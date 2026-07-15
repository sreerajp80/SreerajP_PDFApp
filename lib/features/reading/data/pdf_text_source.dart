import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/reading/domain/text_quality.dart';

/// Placeholder for a character pdfium gave no rectangle for. `isEmpty` is true
/// for it, so the highlight code skips it rather than merging it in.
const PdfRect _noRect = PdfRect(0, 0, 0, 0);

/// One page's text, kept together with the rectangle of every character.
///
/// The rectangles are index-aligned with [text]: `charRects[i]` is where
/// `text[i]` sits on the page. That alignment is what lets a match found in a
/// folded comparison key be drawn in the right place.
class PageText {
  const PageText({
    required this.pageNumber,
    required this.text,
    required this.charRects,
  });

  final int pageNumber;

  /// The page's text exactly as pdfium gave it — never folded or rewritten.
  final String text;

  /// One rectangle per character of [text], in PDF page coordinates.
  final List<PdfRect> charRects;

  static const PageText emptyPage = PageText(
    pageNumber: 0,
    text: '',
    charRects: [],
  );

  bool get isEmpty => text.trim().isEmpty;

  /// The rectangles covering `text[start..end)`, merged into one box per line.
  ///
  /// A match that wraps across lines needs a box per line, not one huge box
  /// swallowing everything between — so rectangles are grouped by line and each
  /// group is merged.
  List<PdfRect> rectsForRange(int start, int end) {
    if (start < 0 || end > charRects.length || start >= end) return const [];

    final lines = <PdfRect>[];
    PdfRect? current;
    for (var i = start; i < end; i++) {
      final rect = charRects[i];
      // Characters with no box of their own (a newline, or a character pdfium
      // gave no rectangle for) must be skipped: merging a zero rect at the
      // origin would stretch the highlight to the corner of the page.
      if (rect.isEmpty) continue;

      if (current == null) {
        current = rect;
        continue;
      }
      // Same line if the boxes overlap vertically. PDF y-coordinates go up, so
      // "top" is the larger number.
      final sameLine = rect.bottom < current.top && rect.top > current.bottom;
      current = sameLine ? current.merge(rect) : _push(lines, current, rect);
    }
    if (current != null) lines.add(current);
    return lines;
  }

  static PdfRect _push(List<PdfRect> lines, PdfRect finished, PdfRect next) {
    lines.add(finished);
    return next;
  }
}

/// A document's pages, as text.
///
/// Search, copy, and read-aloud all talk to this rather than to pdfium, so they
/// can be tested against plain text with no native code and no real PDF.
abstract class PageTextSource {
  int get pageCount;

  /// The text of [pageNumber] (1-based). Never throws: an unreadable page comes
  /// back empty.
  Future<PageText> page(int pageNumber);
}

/// Judges whether [source] has usable text, from a sample of its pages.
///
/// Samples the first page and then spreads across the rest: a scanned book often
/// has a text-bearing title page, and a text book often has a picture cover, so
/// looking only at the front lies both ways.
Future<TextQuality> assessTextQuality(PageTextSource source) async {
  final count = source.pageCount;
  if (count <= 0) return TextQuality.none;

  const wanted = AppConstants.textQualitySamplePages;
  final pages = count <= wanted
      ? List.generate(count, (i) => i + 1)
      : List.generate(wanted, (i) => (i * (count ~/ wanted)) + 1);

  final sample = StringBuffer();
  for (final pageNumber in pages) {
    sample.writeln((await source.page(pageNumber)).text);
  }
  return TextQualityCheck.assess(sample.toString());
}

/// Reads text out of an open PDF, one page at a time.
///
/// Text comes from pdfrx/pdfium — not PdfBox — because only pdfium reports the
/// rectangle of each character, which highlighting needs.
///
/// Pages are loaded lazily and cached: search, copy, and read-aloud all ask for
/// the same pages, and pulling text out of a page is not free.
class PdfTextSource implements PageTextSource {
  PdfTextSource(this.document);

  final PdfDocument document;

  final Map<int, PageText> _cache = {};
  TextQuality? _quality;

  @override
  int get pageCount => document.pages.length;

  /// The text of [pageNumber] (1-based), or an empty page if it cannot be read.
  ///
  /// A page that fails to give up its text must not break search or reading, so
  /// the failure is logged and treated as an empty page.
  @override
  Future<PageText> page(int pageNumber) async {
    final cached = _cache[pageNumber];
    if (cached != null) return cached;

    if (pageNumber < 1 || pageNumber > pageCount) return PageText.emptyPage;

    try {
      final pageText = await document.pages[pageNumber - 1].loadText();
      final loaded = PageText(
        pageNumber: pageNumber,
        text: pageText.fullText,
        charRects: _charRectsOf(pageText),
      );
      _cache[pageNumber] = loaded;
      return loaded;
    } catch (e) {
      AppLogger.warning('Could not read text on page $pageNumber.', error: e);
      // One unreadable page must not break search or reading of the rest.
      final blank = PageText(
        pageNumber: pageNumber,
        text: '',
        charRects: const [],
      );
      _cache[pageNumber] = blank;
      return blank;
    }
  }

  /// Flattens pdfium's fragments into one rectangle per character of `fullText`.
  ///
  /// Every character of `fullText` belongs to exactly one fragment, and a
  /// fragment's `charRects` line up with its own slice of the text. Any gap is
  /// padded with an empty rect so the list stays index-aligned with the text —
  /// that alignment is the whole point.
  static List<PdfRect> _charRectsOf(PdfPageText pageText) {
    final rects = List<PdfRect>.filled(pageText.fullText.length, _noRect);
    for (final fragment in pageText.fragments) {
      final charRects = fragment.charRects;
      for (var i = 0; i < fragment.length && i < charRects.length; i++) {
        final at = fragment.index + i;
        if (at >= 0 && at < rects.length) rects[at] = charRects[i];
      }
    }
    return rects;
  }

  /// Whether this PDF has usable text, judged from a sample of its pages.
  ///
  /// Answered once and remembered: it decides whether search, copy, and
  /// read-aloud are offered at all, so every reader screen asks for it.
  Future<TextQuality> quality() async =>
      _quality ??= await assessTextQuality(this);
}
