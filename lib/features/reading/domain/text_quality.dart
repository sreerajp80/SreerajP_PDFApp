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

  /// There is a text layer made of real characters, but it is probably not
  /// proper Unicode for the script on the page.
  ///
  /// Two common causes in Indic PDFs:
  /// - letters stored in the order they are *drawn*, so a vowel sign such as
  ///   Devanagari `ि` or Malayalam `െ` comes before its consonant;
  /// - an old font (Kruti Dev, ML-TT style) whose glyphs are mapped onto Latin
  ///   letters and Latin-1 symbols.
  ///
  /// Some words may still match, so search, copy and read-aloud stay on, but
  /// the reader is warned that results may be missing or wrong.
  unreliable;

  /// True when search, copy and read-aloud are offered at all.
  bool get isUsable => this == good || this == unreliable;
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

  static bool _isSpace(int rune) =>
      rune == 0x20 || rune == 0x0A || rune == 0x0D || rune == 0x09;

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
      if (_isSpace(rune)) continue;
      total++;
      if (_isUndecodable(rune)) bad++;
    }

    if (total == 0) return TextQuality.none;
    // Too little text to judge fairly — assume it is fine rather than accuse a
    // good PDF of being broken.
    if (total < AppConstants.minCharsForTextQualityCheck) {
      return TextQuality.good;
    }
    if (bad / total >= AppConstants.garbledTextRatioThreshold) {
      return TextQuality.garbled;
    }
    if (_IndicOrderCheck.looksVisualOrder(meaningful) ||
        _LegacyFontCheck.looksLegacy(meaningful, total)) {
      return TextQuality.unreliable;
    }
    return TextQuality.good;
  }
}

/// Spots Indic text stored in drawing order instead of reading order.
///
/// All the Indic blocks from Devanagari (U+0900) to Malayalam (U+0D7F) share
/// one layout, inherited from ISCII: the same offset inside each 128-character
/// block has the same job. So one set of offsets covers Devanagari, Bengali,
/// Gurmukhi, Gujarati, Oriya, Tamil, Telugu, Kannada and Malayalam.
class _IndicOrderCheck {
  const _IndicOrderCheck._();

  static const int _first = 0x0900;
  static const int _last = 0x0DFF;

  static bool _isIndic(int rune) => rune >= _first && rune <= _last;
  static int _block(int rune) => rune & ~0x7F;
  static int _offset(int rune) => rune & 0x7F;

  /// Candrabindu, anusvara, visarga: they follow a letter or a vowel.
  static bool _isSign(int o) => o >= 0x01 && o <= 0x03;

  /// Dependent vowel signs (and the AU / length marks).
  static bool _isVowelSign(int o) =>
      (o >= 0x3E && o <= 0x4C) ||
      (o >= 0x55 && o <= 0x57) ||
      o == 0x62 ||
      o == 0x63;

  static bool _isVirama(int o) => o == 0x4D;
  static bool _isNukta(int o) => o == 0x3C;

  /// Independent vowels (अ, ആ …) — they never take a vowel sign or virama.
  static bool _isIndependentVowel(int o) => o >= 0x04 && o <= 0x14;

  /// Digits and the danda punctuation marks.
  static bool _isDigitOrPunct(int o) =>
      o == 0x64 || o == 0x65 || (o >= 0x66 && o <= 0x6F);

  static bool _isMark(int o) =>
      _isSign(o) || _isVowelSign(o) || _isVirama(o) || _isNukta(o);

  /// Two vowel signs in a row are wrong, except the two-part vowels that
  /// Unicode allows in decomposed form (Malayalam `െ` + `ാ` = `ൊ`, Bengali,
  /// Oriya, Tamil, Kannada likewise): the second part is one of these.
  static bool _isSecondHalf(int o) =>
      o == 0x3E || o == 0x42 || o == 0x55 || o == 0x56 || o == 0x57;

  /// True when enough marks sit where proper Unicode never puts them.
  static bool looksVisualOrder(String text) {
    var marks = 0;
    var misplaced = 0;
    int? prev;
    for (final rune in text.runes) {
      if (_isIndic(rune) && _isMark(_offset(rune))) {
        marks++;
        if (_misplaced(prev, rune)) misplaced++;
      }
      prev = rune;
    }
    if (marks < AppConstants.minIndicMarksForOrderCheck) return false;
    return misplaced / marks >= AppConstants.misplacedIndicMarkRatioThreshold;
  }

  static bool _misplaced(int? prev, int mark) {
    // A mark must follow a character of its own script: not the start of the
    // text, a space, punctuation, or another script.
    if (prev == null || !_isIndic(prev) || _block(prev) != _block(mark)) {
      return true;
    }
    final p = _offset(prev);
    final m = _offset(mark);
    if (_isDigitOrPunct(p)) return true;
    // Signs (ം ः …) may follow vowels; everything else may not.
    if (_isSign(m)) return false;
    if (_isIndependentVowel(p)) return true;
    if (_isVowelSign(m) && _isVirama(p)) return true;
    if (_isVowelSign(m) && _isVowelSign(p) && !_isSecondHalf(m)) return true;
    return false;
  }
}

/// Spots an old Indic font whose glyphs are mapped onto Latin-1 symbols.
class _LegacyFontCheck {
  const _LegacyFontCheck._();

  /// Latin-1 symbols that ordinary text in European languages hardly uses,
  /// but old Indic fonts use for brackets, conjuncts and vowel parts.
  ///
  /// Left out on purpose because normal text does use them: no-break space,
  /// soft hyphen, © ® ° · « » § and the accented letters.
  static bool _isRareSymbol(int rune) {
    if (rune < 0xA1 || rune > 0xFF) return false;
    if (rune >= 0xC0 && rune != 0xD7 && rune != 0xF7) return false;
    const common = {0xA7, 0xA9, 0xAB, 0xAD, 0xAE, 0xB0, 0xB7, 0xBB};
    return !common.contains(rune);
  }

  static bool _isIndicLetter(int rune) => rune >= 0x0900 && rune <= 0x0DFF;

  static bool looksLegacy(String text, int nonSpaceCount) {
    var rare = 0;
    var indic = 0;
    for (final rune in text.runes) {
      if (_isRareSymbol(rune)) rare++;
      if (_isIndicLetter(rune)) indic++;
    }
    // A PDF with real Indic text is not using a legacy font for it.
    if (indic * 10 >= nonSpaceCount) return false;
    if (rare < AppConstants.minLegacyFontSymbols) return false;
    return rare / nonSpaceCount >= AppConstants.legacyFontSymbolRatioThreshold;
  }
}
