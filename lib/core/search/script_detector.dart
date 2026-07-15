/// Scripts this app treats specially when searching and reading aloud.
///
/// Only the complex Indic scripts we support are named. Everything else (Latin,
/// digits, punctuation, other scripts) is [other] — it needs no special fold.
enum PdfScript {
  /// Malayalam (`U+0D00–U+0D7F`). Also carries Sanskrit written in Malayalam
  /// script (Manipravalam / traditional Kerala texts).
  malayalam,

  /// Devanagari, including Devanagari Extended and the Vedic Extensions used by
  /// Sanskrit.
  devanagari,

  /// Anything else — no special handling needed.
  other,
}

/// Tells which script a piece of text is written in.
///
/// Drives two things: which fold [SearchNormalizer] applies, and the
/// garbled-extraction guard (a PDF whose text should be Malayalam but extracts
/// as nonsense).
class ScriptDetector {
  const ScriptDetector._();

  static bool _inRange(int c, int low, int high) => c >= low && c <= high;

  /// True if [rune] is a Malayalam code point.
  static bool isMalayalam(int rune) => _inRange(rune, 0x0D00, 0x0D7F);

  /// True if [rune] is Devanagari, Devanagari Extended, or a Vedic Extension.
  ///
  /// Sanskrit uses all three: the Vedic Extensions (`U+1CD0–U+1CFF`) hold the
  /// chant accents, and Devanagari Extended (`U+A8E0–U+A8FF`) holds more of them.
  static bool isDevanagari(int rune) =>
      _inRange(rune, 0x0900, 0x097F) ||
      _inRange(rune, 0xA8E0, 0xA8FF) ||
      _inRange(rune, 0x1CD0, 0x1CFF);

  /// The script of a single code point.
  static PdfScript of(int rune) {
    if (isMalayalam(rune)) return PdfScript.malayalam;
    if (isDevanagari(rune)) return PdfScript.devanagari;
    return PdfScript.other;
  }

  /// Every special script that appears in [text].
  ///
  /// A document can mix scripts (a Malayalam book quoting Devanagari Sanskrit),
  /// so this returns a set rather than one answer.
  static Set<PdfScript> scriptsIn(String text) {
    final found = <PdfScript>{};
    for (final rune in text.runes) {
      final script = of(rune);
      if (script != PdfScript.other) found.add(script);
      // Both special scripts found — nothing more to learn.
      if (found.length == 2) break;
    }
    return found;
  }

  /// True when [text] holds any Malayalam or Devanagari.
  static bool hasComplexScript(String text) => scriptsIn(text).isNotEmpty;

  /// The special script that appears most in [text], or [PdfScript.other] when
  /// there is none. Used to pick a fold for a query the user typed.
  static PdfScript dominantScript(String text) {
    var malayalam = 0;
    var devanagari = 0;
    for (final rune in text.runes) {
      switch (of(rune)) {
        case PdfScript.malayalam:
          malayalam++;
        case PdfScript.devanagari:
          devanagari++;
        case PdfScript.other:
          break;
      }
    }
    if (malayalam == 0 && devanagari == 0) return PdfScript.other;
    return malayalam >= devanagari ? PdfScript.malayalam : PdfScript.devanagari;
  }
}
