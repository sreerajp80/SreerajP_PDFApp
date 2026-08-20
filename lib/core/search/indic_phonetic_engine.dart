/// Indic phonetic and orthographic sound-alike normalizer for Malayalam and
/// Sanskrit (Malayalam and Devanagari scripts).
class IndicPhoneticEngine {
  const IndicPhoneticEngine();

  static const int _zwnj = 0x200C;
  static const int _zwj = 0x200D;
  static const int _mlVirama = 0x0D4D;
  static const int _devVirama = 0x094D;

  static final String _zwnjChar = String.fromCharCode(_zwnj);
  static final String _zwjChar = String.fromCharCode(_zwj);

  /// Converts Indic text into a canonical phonetic comparison key.
  String phoneticFold(String text) {
    if (text.isEmpty) return text;

    var s = text;

    // 1. Remove Avagraha (ഽ / ऽ)
    s = s.replaceAll('ഽ', '').replaceAll('ऽ', '');

    // 2. Unify Malayalam NTA ligature variants (ന്റ, ൻറ, ൻറ്റ, ന്റ്റ)
    s = s
        .replaceAll('ൻറ്റ', 'ന്റ')
        .replaceAll('ൻറ', 'ന്റ')
        .replaceAll('ന്റ്റ', 'ന്റ');

    // 3. Normalize Chillu vs Consonant + Virama
    s = _unifyChilluAndVirama(s);

    // After chillu unification, also handle any remaining nta variants
    s = s
        .replaceAll('ന്റ്റ', 'ന്റ')
        .replaceAll('ൻറ', 'ന്റ')
        .replaceAll('ൻറ്റ', 'ന്റ');

    // 4. Unify Anusvara before consonants with class nasals
    s = _unifyAnusvaraMalayalam(s);
    s = _unifyAnusvaraDevanagari(s);

    // 5. Unify Sanskrit Repha gemination (e.g. ർമ്മ -> ർമ, धर्म्म -> धर्म)
    s = _unifyRephaGemination(s);

    // 6. Strip invisible joiners
    s = s.replaceAll(_zwnjChar, '').replaceAll(_zwjChar, '');

    return s;
  }

  /// Unifies chillu characters with their consonant + virama counterparts
  /// so that typing either finds both in phonetic mode.
  static String _unifyChilluAndVirama(String s) {
    return s
        .replaceAll('ൺ', 'ണ്')
        .replaceAll('ൻ', 'ന്')
        .replaceAll('ർ', 'ര്')
        .replaceAll('ൽ', 'ല്')
        .replaceAll('ൾ', 'ള്')
        .replaceAll('ൿ', 'ക്');
  }

  /// Unifies Malayalam Anusvara (ം) with class nasal conjuncts.
  /// E.g. 'സംഗീതം' -> 'സങ്ഗീതം', 'സന്തോഷം' -> 'സന്തോഷം', 'സഞ്ചയം' -> 'സഞ്ചയം', 'സമ്പത്ത്' -> 'സമ്പത്ത്'.
  static String _unifyAnusvaraMalayalam(String s) {
    final runes = s.runes.toList();
    final out = <int>[];
    for (var i = 0; i < runes.length; i++) {
      final r = runes[i];
      if (r == 0x0D02 && i + 1 < runes.length) {
        // ം followed by consonant
        final next = runes[i + 1];
        if (next >= 0x0D15 && next <= 0x0D18) {
          // ക, ഖ, ഗ, ഘ -> ങ്
          out.addAll([0x0D19, _mlVirama]);
          continue;
        } else if (next >= 0x0D1A && next <= 0x0D1D) {
          // ച, ഛ, ജ, ഝ -> ഞ്
          out.addAll([0x0D1E, _mlVirama]);
          continue;
        } else if (next >= 0x0D1F && next <= 0x0D22) {
          // ട, ഠ, ഡ, ഢ -> ണ്
          out.addAll([0x0D23, _mlVirama]);
          continue;
        } else if (next >= 0x0D24 && next <= 0x0D27) {
          // ത, ഥ, ദ, ധ -> ന്
          out.addAll([0x0D28, _mlVirama]);
          continue;
        } else if (next >= 0x0D2A && next <= 0x0D2D) {
          // പ, ഫ, ബ, ഭ -> മ്
          out.addAll([0x0D2E, _mlVirama]);
          continue;
        }
      }
      out.add(r);
    }
    return String.fromCharCodes(out);
  }

  /// Unifies Devanagari Anusvara (ं) with class nasal conjuncts.
  /// E.g. 'गंगा' -> 'गङ्गा', 'संत' -> 'सन्त', 'चंचल' -> 'चञ्चल', 'पंडित' -> 'पण्डित', 'कंप' -> 'कम्प'.
  static String _unifyAnusvaraDevanagari(String s) {
    final runes = s.runes.toList();
    final out = <int>[];
    for (var i = 0; i < runes.length; i++) {
      final r = runes[i];
      if (r == 0x0902 && i + 1 < runes.length) {
        // ं followed by consonant
        final next = runes[i + 1];
        if (next >= 0x0915 && next <= 0x0918) {
          // क, ख, ग, घ -> ङ्
          out.addAll([0x0919, _devVirama]);
          continue;
        } else if (next >= 0x091A && next <= 0x091D) {
          // च, छ, ज, झ -> ञ्
          out.addAll([0x091E, _devVirama]);
          continue;
        } else if (next >= 0x091F && next <= 0x0922) {
          // ट, ठ, ड, ढ -> ण्
          out.addAll([0x0923, _devVirama]);
          continue;
        } else if (next >= 0x0924 && next <= 0x0927) {
          // त, थ, द, ध -> न्
          out.addAll([0x0928, _devVirama]);
          continue;
        } else if (next >= 0x092A && next <= 0x092D) {
          // प, फ, ब, भ -> म्
          out.addAll([0x092E, _devVirama]);
          continue;
        }
      }
      out.add(r);
    }
    return String.fromCharCodes(out);
  }

  /// Unifies Sanskrit Repha gemination in both Malayalam and Devanagari scripts.
  /// (e.g. ർമ്മ -> ർമ / ര്മ്മ -> ര്മ; धर्म्म -> धर्म / कर्म्म -> कर्म / सर्व्व -> सर्व).
  static String _unifyRephaGemination(String s) {
    var res = s;
    // Malayalam repha doubling
    res = res
        .replaceAll('ര്മ്മ', 'ര്മ')
        .replaceAll('ർമ്മ', 'ര്മ')
        .replaceAll('ര്വ്വ', 'ര്വ')
        .replaceAll('ർവ്വ', 'ര്വ')
        .replaceAll('ര്ഗ്ഗ', 'ര്ഗ')
        .replaceAll('ർഗ്ഗ', 'ര്ഗ')
        .replaceAll('ര്ത്ത', 'ര്ത')
        .replaceAll('ർ record', 'ര്ത')
        .replaceAll('ര്യ്യ', 'ര്യ')
        .replaceAll('ർയ്യ', 'ര്യ');

    // Devanagari repha doubling
    res = res
        .replaceAll('र्म्म', 'र्म')
        .replaceAll('र्व्व', 'र्व')
        .replaceAll('र्ग्य', 'र्ग')
        .replaceAll('र्त्त', 'र्त')
        .replaceAll('र्य्य', 'र्य');

    return res;
  }
}
