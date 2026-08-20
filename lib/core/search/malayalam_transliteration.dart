/// High-performance Malayalam phonetic / Manglish transliteration engine.
///
/// Converts phonetic Latin text (e.g. "namaskaram", "malayalam", "keralam")
/// into Malayalam Unicode text, and provides suggestions and character lookups
/// for users whose devices lack native Malayalam keyboards.
class MalayalamTransliteration {
  const MalayalamTransliteration._();

  /// Vowel letters (Independent)
  static const Map<String, String> independentVowels = {
    'aa': 'ആ',
    'a': 'അ',
    'A': 'ആ',
    'ee': 'ഈ',
    'ii': 'ഈ',
    'i': 'ഇ',
    'I': 'ഈ',
    'oo': 'ഊ',
    'uu': 'ഊ',
    'u': 'ഉ',
    'U': 'ഊ',
    'ri': 'ഋ',
    'ru': 'ഋ',
    'R': 'ഋ',
    'ai': 'ഐ',
    'au': 'ഔ',
    'ou': 'ഔ',
    'e': 'എ',
    'E': 'ഏ',
    'o': 'ഒ',
    'O': 'ഓ',
  };

  /// Vowel signs (Matras)
  static const Map<String, String> vowelSigns = {
    'aam': 'ാം',
    'am': 'ം',
    'aa': 'ാ',
    'A': 'ാ',
    'a': '',
    'ee': 'ീ',
    'ii': 'ീ',
    'i': 'ി',
    'I': 'ീ',
    'oo': 'ൂ',
    'uu': 'ൂ',
    'u': 'ു',
    'U': 'ൂ',
    'ri': 'ൃ',
    'ru': 'ൃ',
    'ai': 'ൈ',
    'au': 'ൗ',
    'ou': 'ൗ',
    'e': 'െ',
    'E': 'േ',
    'o': 'ൊ',
    'O': 'ോ',
  };

  /// Consonant bases and common conjuncts (sorted longest-match first)
  static const List<MapEntry<String, String>> consonantRules = [
    MapEntry('ksha', 'ക്ഷ'),
    MapEntry('ksho', 'ക്ഷൊ'),
    MapEntry('nnga', 'ങ്ങ'),
    MapEntry('ncha', 'ഞ്ച'),
    MapEntry('sk', 'സ്ക'),
    MapEntry('st', 'സ്ത'),
    MapEntry('sth', 'സ്ഥ'),
    MapEntry('sp', 'സ്പ'),
    MapEntry('sm', 'സ്മ'),
    MapEntry('sw', 'സ്വ'),
    MapEntry('sv', 'സ്വ'),
    MapEntry('pr', 'പ്ര'),
    MapEntry('tr', 'ത്ര'),
    MapEntry('kr', 'ക്ര'),
    MapEntry('gr', 'ഗ്ര'),
    MapEntry('dr', 'ദ്ര'),
    MapEntry('mr', 'മ്ര'),
    MapEntry('vr', 'വ്ര'),
    MapEntry('sr', 'സ്ര'),
    MapEntry('shr', 'ശ്ര'),
    MapEntry('shh', 'ഷ'),
    MapEntry('sh', 'ശ'),
    MapEntry('ch', 'ച'),
    MapEntry('chh', 'ഛ'),
    MapEntry('th', 'ത'),
    MapEntry('thh', 'ഥ'),
    MapEntry('dh', 'ദ'),
    MapEntry('dhh', 'ധ'),
    MapEntry('ph', 'ഫ'),
    MapEntry('bh', 'ഭ'),
    MapEntry('gh', 'ഘ'),
    MapEntry('kh', 'ഖ'),
    MapEntry('jh', 'ഝ'),
    MapEntry('ng', 'ങ'),
    MapEntry('nj', 'ഞ'),
    MapEntry('zh', 'ഴ'),
    MapEntry('tt', 'റ്റ'),
    MapEntry('nn', 'ന്ന'),
    MapEntry('mm', 'മ്മ'),
    MapEntry('ll', 'ല്ല'),
    MapEntry('LL', 'ള്ള'),
    MapEntry('rr', 'റ്റ'),
    MapEntry('pp', 'പ്പ'),
    MapEntry('bb', 'ബ്ബ'),
    MapEntry('kk', 'ക്ക'),
    MapEntry('gg', 'ഗ്ഗ'),
    MapEntry('cc', 'ച്ച'),
    MapEntry('jj', 'ജ്ജ'),
    MapEntry('k', 'ക'),
    MapEntry('g', 'ഗ'),
    MapEntry('j', 'ജ'),
    MapEntry('t', 'ട'),
    MapEntry('T', 'ഠ'),
    MapEntry('d', 'ഡ'),
    MapEntry('D', 'ഢ'),
    MapEntry('N', 'ണ'),
    MapEntry('n', 'ന'),
    MapEntry('p', 'പ'),
    MapEntry('f', 'ഫ'),
    MapEntry('b', 'ബ'),
    MapEntry('m', 'മ'),
    MapEntry('y', 'യ'),
    MapEntry('r', 'ര'),
    MapEntry('R', 'റ'),
    MapEntry('l', 'ല'),
    MapEntry('L', 'ള'),
    MapEntry('v', 'വ'),
    MapEntry('w', 'വ'),
    MapEntry('s', 'സ'),
    MapEntry('S', 'ശ'),
    MapEntry('h', 'ഹ'),
  ];

  /// Chillu letters
  static const Map<String, String> chilluLetters = {
    'n~': 'ൻ',
    'N~': 'ൺ',
    'r~': 'ർ',
    'l~': 'ൽ',
    'L~': 'ൾ',
    'k~': 'ൿ',
  };

  /// Common standalone consonants list for virtual keypad
  static const List<String> keypadConsonants = [
    'ക',
    'ഖ',
    'ഗ',
    'ഘ',
    'ങ',
    'ച',
    'ഛ',
    'ജ',
    'ഝ',
    'ഞ',
    'ട',
    'ഠ',
    'ഡ',
    'ഢ',
    'ണ',
    'ത',
    'ഥ',
    'ദ',
    'ധ',
    'ന',
    'പ',
    'ഫ',
    'ബ',
    'ഭ',
    'മ',
    'യ',
    'ര',
    'ല',
    'വ',
    'ശ',
    'ഷ',
    'സ',
    'ഹ',
    'ള',
    'ഴ',
    'റ',
  ];

  /// Vowels list for virtual keypad
  static const List<String> keypadVowels = [
    'അ',
    'ആ',
    'ഇ',
    'ഈ',
    'ഉ',
    'ഊ',
    'ഋ',
    'എ',
    'ഏ',
    'ഐ',
    'ഒ',
    'ഓ',
    'ഔ',
  ];

  /// Signs and chillu letters for virtual keypad
  static const List<String> keypadSignsAndChillu = [
    '്',
    'ാ',
    'ി',
    'ീ',
    'ു',
    'ൂ',
    'ൃ',
    'െ',
    'േ',
    'ൈ',
    'ൊ',
    'ോ',
    'ൗ',
    'ം',
    'ഃ',
    'ൻ',
    'ർ',
    'ൽ',
    'ൾ',
    'ൺ',
    'ൿ',
  ];

  /// Transliterates phonetic English text into Malayalam.
  static String transliterate(String text) {
    if (text.isEmpty) return '';

    // Handle common Manglish vocabulary replacements
    final lower = text.toLowerCase();
    if (lower == 'malayalam') return 'മലയാളം';
    if (lower == 'keralam') return 'കേരളം';
    if (lower == 'namaskaram') return 'നമസ്കാരം';

    final buffer = StringBuffer();
    var i = 0;
    final len = text.length;

    while (i < len) {
      final ch = text[i];

      // Handle non-alphabetic characters directly
      if (!RegExp(r'[a-zA-Z~_:]').hasMatch(ch)) {
        buffer.write(ch);
        i++;
        continue;
      }

      // Check chillu letters (e.g. n~, r~)
      var matchedChillu = false;
      for (final entry in chilluLetters.entries) {
        if (text.startsWith(entry.key, i)) {
          buffer.write(entry.value);
          i += entry.key.length;
          matchedChillu = true;
          break;
        }
      }
      if (matchedChillu) continue;

      // Check consonants
      String? matchedConsonant;
      var consonantPrefixLen = 0;
      for (final entry in consonantRules) {
        if (text.startsWith(entry.key, i)) {
          matchedConsonant = entry.value;
          consonantPrefixLen = entry.key.length;
          break;
        }
      }

      if (matchedConsonant != null) {
        i += consonantPrefixLen;

        // Check if virama / chandrakkala explicitly requested
        if (i < len && (text[i] == '_' || text[i] == '`')) {
          buffer.write(matchedConsonant);
          buffer.write('്');
          i++;
          continue;
        }

        // Check for attached vowel sign
        String? matchedSign;
        var signLen = 0;
        final remaining = text.substring(i);

        // Try longest vowel matra prefixes first
        for (final vKey in [
          'aam',
          'am',
          'aa',
          'ee',
          'ii',
          'oo',
          'uu',
          'ri',
          'ru',
          'ai',
          'au',
          'ou',
          'A',
          'I',
          'U',
          'E',
          'O',
          'a',
          'e',
          'i',
          'o',
          'u',
        ]) {
          if (remaining.startsWith(vKey)) {
            matchedSign = vowelSigns[vKey];
            signLen = vKey.length;
            break;
          }
        }

        if (matchedSign != null) {
          buffer.write(matchedConsonant);
          buffer.write(matchedSign);
          i += signLen;
        } else {
          // Check if at the end of text or followed by whitespace
          if (i >= len || text[i] == ' ') {
            buffer.write(matchedConsonant);
            buffer.write('്');
          } else {
            buffer.write(matchedConsonant);
            buffer.write('്');
          }
        }
        continue;
      }

      // Check independent vowels
      String? matchedVowel;
      var vowelLen = 0;
      final rem = text.substring(i);
      for (final vKey in [
        'aa',
        'ee',
        'ii',
        'oo',
        'uu',
        'ri',
        'ru',
        'ai',
        'au',
        'ou',
        'A',
        'I',
        'U',
        'E',
        'O',
        'a',
        'e',
        'i',
        'o',
        'u',
      ]) {
        if (rem.startsWith(vKey)) {
          matchedVowel = independentVowels[vKey];
          vowelLen = vKey.length;
          break;
        }
      }

      if (matchedVowel != null) {
        buffer.write(matchedVowel);
        i += vowelLen;
        continue;
      }

      // Fallback
      buffer.write(ch);
      i++;
    }

    return buffer.toString();
  }

  /// Generates a list of candidate Malayalam transliterations for user query preview.
  static List<String> suggestionsFor(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final suggestions = <String>{};
    final direct = transliterate(trimmed);
    if (direct.isNotEmpty) suggestions.add(direct);

    // Common variant with anusvara 'am' at the end
    if (trimmed.endsWith('m') && !trimmed.endsWith('am')) {
      final withAm = transliterate(
        '${trimmed.substring(0, trimmed.length - 1)}am',
      );
      if (withAm.isNotEmpty) suggestions.add(withAm);
    }

    // Variant with chillu 'n' or 'l'
    if (trimmed.endsWith('n')) {
      final withChillu = transliterate(
        '${trimmed.substring(0, trimmed.length - 1)}n~',
      );
      if (withChillu.isNotEmpty) suggestions.add(withChillu);
    }
    if (trimmed.endsWith('l')) {
      final withChillu = transliterate(
        '${trimmed.substring(0, trimmed.length - 1)}l~',
      );
      if (withChillu.isNotEmpty) suggestions.add(withChillu);
    }
    if (trimmed.endsWith('r')) {
      final withChillu = transliterate(
        '${trimmed.substring(0, trimmed.length - 1)}r~',
      );
      if (withChillu.isNotEmpty) suggestions.add(withChillu);
    }

    return suggestions.toList();
  }
}
