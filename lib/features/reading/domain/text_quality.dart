import 'package:pdfapp/core/constants/app_constants.dart';

/// What we found when we looked for readable text in a PDF.
enum TextQuality {
  /// There is real, readable text. Search, copy, and read-aloud all work.
  good,

  /// There is no text layer at all — the pages are pictures. Almost always a
  /// scanned document. Reading text out of a picture (OCR) is out of scope, so
  /// search, copy, extraction, and read-aloud are honestly unavailable.
  none,

  /// There is a text layer, but it does not decode to real characters.
  ///
  /// The usual cause is a font with no `ToUnicode` map: pdfium hands back the
  /// font's internal glyph numbers, which land in the Private Use Area or as
  /// replacement characters. The text looks fine on the page and is nonsense
  /// underneath. Common with Malayalam and Sanskrit PDFs.
  ///
  /// We say so rather than search nonsense or read it aloud.
  garbled,
}

/// Decides whether a PDF's extracted text is usable.
///
/// Pure and testable: it judges a sample of text, and knows nothing about
/// pdfium or widgets.
class TextQualityCheck {
  const TextQualityCheck._();

  /// True for a code point in a Private Use Area.
  ///
  /// Real text never uses these. A font with no `ToUnicode` map does, because
  /// its glyph numbers get passed through unmapped.
  static bool _isPrivateUse(int rune) =>
      (rune >= 0xE000 && rune <= 0xF8FF) || // Basic Multilingual Plane
      (rune >= 0xF0000 && rune <= 0xFFFFD) || // Supplementary Plane A
      (rune >= 0x100000 && rune <= 0x10FFFD); // Supplementary Plane B

  /// True for a character that means "this could not be decoded".
  static bool _isUndecodable(int rune) =>
      rune == 0xFFFD || // replacement character
      _isPrivateUse(rune);

  /// Judges [sample], which should be text gathered from a few pages.
  ///
  /// Whitespace-only text counts as [TextQuality.none]: a scanned page often
  /// yields a few stray spaces or newlines rather than a truly empty string.
  static TextQuality assess(String sample) {
    final meaningful = sample.trim();
    if (meaningful.isEmpty) return TextQuality.none;

    var total = 0;
    var bad = 0;
    for (final rune in meaningful.runes) {
      // Spaces are not evidence either way.
      if (rune == 0x20 || rune == 0x0A || rune == 0x0D || rune == 0x09) {
        continue;
      }
      total++;
      if (_isUndecodable(rune)) bad++;
    }

    if (total == 0) return TextQuality.none;
    // Too little text to judge fairly — assume it is fine rather than accuse a
    // good PDF of being broken.
    if (total < AppConstants.minCharsForTextQualityCheck) {
      return TextQuality.good;
    }
    final ratio = bad / total;
    return ratio >= AppConstants.garbledTextRatioThreshold
        ? TextQuality.garbled
        : TextQuality.good;
  }
}
