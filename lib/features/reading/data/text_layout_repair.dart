import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/core/constants/app_constants.dart';

/// Repairs the word spacing in pdfium's raw page text, using where each
/// character sits on the page.
///
/// Some PDF makers (LibreOffice is the common one) draw the spaces of a line
/// separately from its words. pdfium then gets two things wrong, and phrase
/// search fails:
///
/// - **A space inside a word.** pdfium adds its own (generated) space in the
///   right gap, but also keeps the real space glyph at a later, wrong place.
///   That glyph's box still shows where it belongs: its centre is left of the
///   letter just before it.
/// - **A missing space after a virama (്, ्).** The virama's ink reaches into
///   the space glyph, so pdfium drops the space. Inside a word the next letter
///   always touches the virama; at a word end there is a clear gap.
///
/// The order *inside* a line is never re-sorted by x: a Malayalam cluster's
/// vowel signs and virama often share one box, so sorting would break letters.
abstract final class TextLayoutRepair {
  static const PdfRect _noRect = PdfRect(0, 0, 0, 0);

  /// Viramas of the Indic scripts pdfium can drop a following space after.
  static const Set<int> _viramas = {
    0x094D, // Devanagari ्
    0x09CD, // Bengali
    0x0A4D, // Gurmukhi
    0x0ACD, // Gujarati
    0x0B4D, // Odia
    0x0BCD, // Tamil
    0x0C4D, // Telugu
    0x0CCD, // Kannada
    0x0D4D, // Malayalam ്
  };

  /// Repairs [text] using [rects], pdfium's box for each character.
  ///
  /// [rects] holds one box per character as `PdfPageRawText` gives them. The
  /// result is index-aligned: `rects[i]` is the box of the UTF-16 code unit
  /// `text[i]`. Never throws: on input it cannot make sense of, it returns the
  /// text with boxes padded to match.
  static ({String text, List<PdfRect> rects}) repair(
    String text,
    List<PdfRect> rects,
  ) {
    try {
      final chars = _toChars(text, rects);
      if (chars == null) return _unaligned(text, rects);

      _joinLineBreaks(chars);
      _dropVerticalLineBreaks(chars);
      _addSpacesAfterViramas(chars);
      _moveMisplacedSpaces(chars);
      return _build(_tidyBlanks(chars));
    } catch (_) {
      // A repair is a nice-to-have; reading the page must never fail on it.
      return _unaligned(text, rects);
    }
  }

  /// Pairs each character with its box. pdfium gives one box per Unicode
  /// character, so a character outside the BMP (two UTF-16 units) has one box.
  static List<_Char>? _toChars(String text, List<PdfRect> rects) {
    final runes = text.runes.toList();
    if (runes.length == rects.length) {
      return [
        for (var i = 0; i < runes.length; i++)
          _Char(String.fromCharCode(runes[i]), rects[i]),
      ];
    }
    if (text.length == rects.length) {
      return [for (var i = 0; i < text.length; i++) _Char(text[i], rects[i])];
    }
    return null;
  }

  static ({String text, List<PdfRect> rects}) _unaligned(
    String text,
    List<PdfRect> rects,
  ) => (
    text: text,
    rects: List<PdfRect>.generate(
      text.length,
      (i) => i < rects.length ? rects[i] : _noRect,
    ),
  );

  /// `\r\n` and a lone `\r` become one `\n`.
  static void _joinLineBreaks(List<_Char> chars) {
    for (var i = chars.length - 1; i >= 0; i--) {
      if (chars[i].text != '\r') continue;
      if (i + 1 < chars.length && chars[i + 1].text == '\n') {
        chars.removeAt(i + 1);
      }
      chars[i] = _Char('\n', chars[i].rect);
    }
  }

  /// Removes the fake line breaks some Word PDFs put between the characters of
  /// vertical text ("縦\n書\nき"). Same rule as pdfrx's structured text.
  static void _dropVerticalLineBreaks(List<_Char> chars) {
    // Decide on the original lines first, then remove: removing as we go would
    // change what the next check sees.
    final fake = <int>[];
    for (var i = chars.length - 2; i >= 1; i--) {
      if (chars[i].text != '\n') continue;
      final before = chars[i - 1];
      final after = chars[i + 1];
      final singleBefore = i - 2 < 0 || chars[i - 2].text == '\n';
      final singleAfter = i + 2 >= chars.length || chars[i + 2].text == '\n';
      if (!singleBefore || !singleAfter) continue;
      if (_isBlank(before.text) || _isBlank(after.text)) continue;
      final nextCenterX = (after.rect.left + after.rect.right) / 2;
      if (before.rect.left < nextCenterX &&
          nextCenterX < before.rect.right &&
          before.rect.top > after.rect.top) {
        fake.add(i);
      }
    }
    // Indices were collected from the end, so removing in that order is safe.
    fake.forEach(chars.removeAt);
  }

  /// Puts back the space pdfium dropped after a word-final virama.
  static void _addSpacesAfterViramas(List<_Char> chars) {
    for (var i = 1; i < chars.length; i++) {
      final a = chars[i - 1];
      final b = chars[i];
      if (!_viramas.contains(a.text.runes.first)) continue;
      if (!_isVisible(a) || !_isVisible(b) || !_sameLine(a.rect, b.rect)) {
        continue;
      }
      final gap = b.rect.left - a.rect.right;
      if (gap <= AppConstants.textRepairViramaGapRatio * a.rect.height) {
        continue;
      }
      chars.insert(
        i,
        _Char(
          ' ',
          PdfRect(a.rect.right, a.rect.top, b.rect.left, a.rect.bottom),
        ),
      );
      i++;
    }
  }

  /// Moves each real space that sits left of the letter before it back into
  /// the gap it was drawn in, or drops it if that gap already has a space.
  static void _moveMisplacedSpaces(List<_Char> chars) {
    var lineStart = 0;
    while (lineStart < chars.length) {
      var lineEnd = lineStart;
      while (lineEnd < chars.length && chars[lineEnd].text != '\n') {
        lineEnd++;
      }
      lineEnd = _repairLine(chars, lineStart, lineEnd);
      lineStart = lineEnd + 1;
    }
  }

  /// Repairs `chars[start..end)` and returns the line's new end.
  static int _repairLine(List<_Char> chars, int start, int end) {
    var i = start;
    while (i < end) {
      final space = chars[i];
      if (!_isRealSpace(space)) {
        i++;
        continue;
      }
      final previous = _previousVisible(chars, start, i);
      final centerX = (space.rect.left + space.rect.right) / 2;
      if (previous == null || centerX >= previous.rect.left) {
        i++;
        continue;
      }

      chars.removeAt(i);
      end--;
      final target = _gapFor(chars, start, end, centerX);
      if (target == null) {
        // Nowhere better to put it: leave it where it was.
        chars.insert(i, space);
        end++;
        i++;
        continue;
      }
      if (!target.hasBlank) {
        chars.insert(target.insertAt, space);
        end++;
        // The space went back to an earlier spot, so the one now at i is new.
        if (target.insertAt <= i) i++;
      }
    }
    return end;
  }

  /// The gap between two neighbouring visible letters that [centerX] falls in.
  static ({int insertAt, bool hasBlank})? _gapFor(
    List<_Char> chars,
    int start,
    int end,
    double centerX,
  ) {
    const tolerance = AppConstants.textRepairGapTolerance;
    int? previous;
    for (var k = start; k < end; k++) {
      if (!_isVisible(chars[k])) continue;
      if (previous != null) {
        final a = chars[previous].rect;
        final b = chars[k].rect;
        if (b.left >= a.right - tolerance &&
            a.right - tolerance <= centerX &&
            centerX <= b.left + tolerance) {
          var hasBlank = false;
          for (var m = previous + 1; m < k; m++) {
            if (_isBlank(chars[m].text)) hasBlank = true;
          }
          return (insertAt: k, hasBlank: hasBlank);
        }
      }
      previous = k;
    }
    return null;
  }

  static _Char? _previousVisible(List<_Char> chars, int start, int before) {
    for (var k = before - 1; k >= start; k--) {
      if (_isVisible(chars[k])) return chars[k];
    }
    return null;
  }

  /// Turns each run of blanks into one character: `\n` if the run holds a line
  /// break, else a space. Search folds each blank to one space and does not
  /// merge runs, so a run left as it is would break phrase search.
  static List<_Char> _tidyBlanks(List<_Char> chars) {
    final out = <_Char>[];
    var i = 0;
    while (i < chars.length) {
      if (!_isBlank(chars[i].text)) {
        out.add(chars[i]);
        i++;
        continue;
      }
      var hasNewLine = false;
      PdfRect? rect;
      while (i < chars.length && _isBlank(chars[i].text)) {
        if (chars[i].text == '\n') hasNewLine = true;
        if (rect == null && chars[i].rect.isNotEmpty) rect = chars[i].rect;
        i++;
      }
      out.add(_Char(hasNewLine ? '\n' : ' ', rect ?? _noRect));
    }
    return out;
  }

  static ({String text, List<PdfRect> rects}) _build(List<_Char> chars) {
    final buffer = StringBuffer();
    final rects = <PdfRect>[];
    for (final c in chars) {
      buffer.write(c.text);
      for (var u = 0; u < c.text.length; u++) {
        rects.add(c.rect);
      }
    }
    return (text: buffer.toString(), rects: rects);
  }

  static bool _isBlank(String s) => s.trim().isEmpty;

  static bool _isVisible(_Char c) =>
      !_isBlank(c.text) && c.rect.right > c.rect.left;

  /// A space glyph that was really drawn (pdfium's generated spaces have an
  /// empty point box).
  static bool _isRealSpace(_Char c) =>
      c.text != '\n' && _isBlank(c.text) && c.rect.right > c.rect.left;

  /// Whether two boxes overlap vertically. PDF y grows upwards.
  static bool _sameLine(PdfRect a, PdfRect b) =>
      a.bottom < b.top && b.bottom < a.top;
}

/// One character (one Unicode code point) and its box.
class _Char {
  const _Char(this.text, this.rect);

  final String text;
  final PdfRect rect;
}
