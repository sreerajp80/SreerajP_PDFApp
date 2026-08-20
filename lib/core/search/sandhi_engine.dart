/// Sandhi compound joining and splitting rules for Malayalam and Sanskrit
/// (in Malayalam and Devanagari scripts).
///
/// Sandhi (സന്ധി / सन्धि) refers to the phonetic sound changes and mergers that
/// occur at word boundaries or compound junctions.
class SandhiEngine {
  const SandhiEngine();

  // Malayalam characters & signs
  static const int _mlA = 0x0D05; // അ
  static const int _mlAa = 0x0D06; // ആ
  static const int _mlI = 0x0D07; // ഇ
  static const int _mlEe = 0x0D08; // ഈ
  static const int _mlU = 0x0D09; // ഉ
  static const int _mlOo = 0x0D0A; // ഊ
  static const int _mlR = 0x0D0B; // ഋ
  static const int _mlE = 0x0D0E; // എ
  static const int _mlAi = 0x0D10; // ഐ
  static const int _mlO = 0x0D12; // ഒ
  static const int _mlAu = 0x0D14; // ഔ
  static const int _mlVirama = 0x0D4D; // ് (chandrakkala)
  static const int _mlVisarga = 0x0D03; // ഃ
  static const int _mlAnusvara = 0x0D02; // ം
  static const int _mlAvagraha = 0x0D3D; // ഽ

  // Vowel signs (Matras) Malayalam
  static const int _mlSignAa = 0x0D3E; // ാ
  static const int _mlSignI = 0x0D3F; // ി
  static const int _mlSignEe = 0x0D40; // ീ
  static const int _mlSignU = 0x0D41; // ു
  static const int _mlSignOo = 0x0D42; // ൂ
  static const int _mlSignR = 0x0D43; // ൃ
  static const int _mlSignE = 0x0D46; // െ
  static const int _mlSignEeLong = 0x0D47; // േ
  static const int _mlSignAi = 0x0D48; // ൈ
  static const int _mlSignO = 0x0D4A; // ൊ
  static const int _mlSignOoLong = 0x0D4B; // ോ
  static const int _mlSignAu = 0x0D57; // ൗ

  // Devanagari characters & signs
  static const int _devA = 0x0905; // अ
  static const int _devAa = 0x0906; // आ
  static const int _devI = 0x0907; // इ
  static const int _devEe = 0x0908; // ई
  static const int _devU = 0x0909; // उ
  static const int _devOo = 0x090A; // ऊ
  static const int _devR = 0x090B; // ऋ
  static const int _devE = 0x090F; // ए
  static const int _devAi = 0x0910; // ऐ
  static const int _devO = 0x0913; // ओ
  static const int _devAu = 0x0914; // औ
  static const int _devVirama = 0x094D; // ्
  static const int _devVisarga = 0x0903; // ः
  static const int _devAnusvara = 0x0902; // ं
  static const int _devAvagraha = 0x093D; // ऽ

  // Vowel signs (Matras) Devanagari
  static const int _devSignAa = 0x093E; // ा
  static const int _devSignI = 0x093F; // ि
  static const int _devSignEe = 0x0940; // ी
  static const int _devSignU = 0x0941; // ु
  static const int _devSignOo = 0x0942; // ू
  static const int _devSignR = 0x0943; // ृ
  static const int _devSignE = 0x0947; // े
  static const int _devSignAi = 0x0948; // ै
  static const int _devSignO = 0x094B; // ो
  static const int _devSignAu = 0x094C; // ौ

  /// Joins two adjacent words applying all valid Sandhi rules.
  /// Returns a set of candidate compound words.
  Set<String> joinWords(String word1, String word2) {
    final w1 = word1.trim();
    final w2 = word2.trim();
    if (w1.isEmpty) return {w2};
    if (w2.isEmpty) return {w1};

    final results = <String>{};
    // Direct juxtaposition (no Sandhi / as-is)
    results.add('$w1$w2');
    results.add('$w1 $w2');

    // Malayalam Sandhis
    results.addAll(_joinMalayalam(w1, w2));

    // Devanagari / Sanskrit Sandhis
    results.addAll(_joinDevanagari(w1, w2));

    return results;
  }

  /// Generates compound joining combinations for a multi-word phrase.
  Set<String> generateCompoundQueries(List<String> words) {
    if (words.isEmpty) return const {};
    if (words.length == 1) return {words.first};

    var currentCompounds = {words.first};
    for (var i = 1; i < words.length; i++) {
      final nextWord = words[i];
      final newCompounds = <String>{};
      for (final comp in currentCompounds) {
        newCompounds.addAll(joinWords(comp, nextWord));
      }
      currentCompounds = newCompounds;
    }
    return currentCompounds;
  }

  // ---------------------------------------------------------------------------
  // Malayalam Sandhi implementation
  // ---------------------------------------------------------------------------

  Set<String> _joinMalayalam(String w1, String w2) {
    final results = <String>{};
    final runes1 = w1.runes.toList();
    final runes2 = w2.runes.toList();
    if (runes1.isEmpty || runes2.isEmpty) return results;

    final lastRune = runes1.last;
    final firstRune = runes2.first;

    // Check if w1 ends with virama / chandrakkala (e.g. ് or samvruthokaram)
    final endsWithVirama = lastRune == _mlVirama;
    final endsWithVisarga = lastRune == _mlVisarga;
    final endsWithAnusvara = lastRune == _mlAnusvara;

    final w1NoVisarga = endsWithVisarga
        ? String.fromCharCodes(runes1.sublist(0, runes1.length - 1))
        : w1;

    // Check terminal vowel of w1
    final (w1Stem, termVowel1) = _getMalayalamTerminalVowel(runes1);
    final w2Suffix = w2.substring(1);

    // 1. Vowel Sandhi (സ്വരസന്ധി) & Consonant + Vowel Sandhi
    if (_isMalayalamIndependentVowel(firstRune)) {
      // 1.1 Savarna Deergha Sandhi
      if ((termVowel1 == 'a' || termVowel1 == 'aa') &&
          (firstRune == _mlA || firstRune == _mlAa)) {
        results.add('$w1Stem${String.fromCharCode(_mlSignAa)}$w2Suffix');
      } else if ((termVowel1 == 'i' || termVowel1 == 'ee') &&
          (firstRune == _mlI || firstRune == _mlEe)) {
        results.add('$w1Stem${String.fromCharCode(_mlSignEe)}$w2Suffix');
      } else if ((termVowel1 == 'u' || termVowel1 == 'oo') &&
          (firstRune == _mlU || firstRune == _mlOo)) {
        results.add('$w1Stem${String.fromCharCode(_mlSignOo)}$w2Suffix');
      } else if (termVowel1 == 'r' && firstRune == _mlR) {
        results.add('$w1Stem${String.fromCharCode(_mlSignR)}$w2Suffix');
      }

      // 1.2 Guna Sandhi
      if (termVowel1 == 'a' || termVowel1 == 'aa') {
        if (firstRune == _mlI || firstRune == _mlEe) {
          results.add('$w1Stem${String.fromCharCode(_mlSignEeLong)}$w2Suffix');
        } else if (firstRune == _mlU || firstRune == _mlOo) {
          results.add('$w1Stem${String.fromCharCode(_mlSignOoLong)}$w2Suffix');
        } else if (firstRune == _mlR) {
          results.add('$w1Stemർ$w2Suffix');
        }
      }

      // 1.3 Vriddhi Sandhi
      if (termVowel1 == 'a' || termVowel1 == 'aa') {
        if (firstRune == _mlE || firstRune == _mlAi || firstRune == 0x0D0F) {
          results.add('$w1Stem${String.fromCharCode(_mlSignAi)}$w2Suffix');
        } else if (firstRune == _mlO ||
            firstRune == _mlAu ||
            firstRune == 0x0D13) {
          results.add('$w1Stem${String.fromCharCode(_mlSignAu)}$w2Suffix');
        }
      }

      // 1.4 Yan Sandhi
      if (termVowel1 == 'i' || termVowel1 == 'ee') {
        final sign = _mlVowelToSign(firstRune);
        results.add('$w1Stem്യ$sign$w2Suffix');
      } else if (termVowel1 == 'u' || termVowel1 == 'oo') {
        final sign = _mlVowelToSign(firstRune);
        results.add('$w1Stem്വ$sign$w2Suffix');
      }

      // 1.5 Dravidian Agama Sandhi
      if (termVowel1 == 'i' ||
          termVowel1 == 'ee' ||
          termVowel1 == 'e' ||
          termVowel1 == 'ai') {
        final sign = _mlVowelToSign(firstRune);
        results.add('$w1യ$sign$w2Suffix');
        results.add('$w1യ്യ$sign$w2Suffix');
      } else if (termVowel1 == 'u' ||
          termVowel1 == 'oo' ||
          termVowel1 == 'o' ||
          termVowel1 == 'au') {
        final sign = _mlVowelToSign(firstRune);
        results.add('$w1വ$sign$w2Suffix');
        results.add('$w1വ്വ$sign$w2Suffix');
      }

      // 1.6 Dravidian Lopa Sandhi
      if (endsWithVirama ||
          termVowel1 == 'u' ||
          termVowel1 == 'i' ||
          termVowel1 == 'a') {
        final sign = _mlVowelToSign(firstRune);
        results.add('$w1Stem$sign$w2Suffix');
      }

      // 1.7 Consonant + Vowel Jashthva Sandhi (e.g. വാക് + ഈശ -> വാഗീശ, സത് + ആനന്ദ -> സദാനന്ദ)
      if (endsWithVirama && runes1.length >= 2) {
        final prevCons = runes1[runes1.length - 2];
        final prefix = String.fromCharCodes(
          runes1.sublist(0, runes1.length - 2),
        );
        final sign = _mlVowelToSign(firstRune);
        if (prevCons == 0x0D15) {
          // ക് -> ഗ്
          results.add('$prefixഗ$sign$w2Suffix');
        } else if (prevCons == 0x0D1A) {
          // ച് -> ജ്
          results.add('$prefixജ$sign$w2Suffix');
        } else if (prevCons == 0x0D1F) {
          // ട് -> ഡ്
          results.add('$prefixഡ$sign$w2Suffix');
        } else if (prevCons == 0x0D24) {
          // ത് -> ദ്
          results.add('$prefixദ$sign$w2Suffix');
        } else if (prevCons == 0x0D2A) {
          // പ് -> ബ്
          results.add('$prefixബ$sign$w2Suffix');
        }
      }

      // 1.8 Poorvaroopa Sandhi / Avagraha
      if (firstRune == _mlA &&
          (termVowel1 == 'e_long' || termVowel1 == 'o_long')) {
        results.add('$w1${String.fromCharCode(_mlAvagraha)}$w2Suffix');
        results.add('$w1$w2Suffix');
      }
    }

    // 2. Consonant Sandhi & Consonant Doubling (Dvitva)
    if (_isMalayalamConsonant(firstRune)) {
      // 2.1 Malayalam Consonant doubling
      if (firstRune == 0x0D15) {
        results.add('$w1ക്ക$w2Suffix');
      } else if (firstRune == 0x0D1A) {
        results.add('$w1ച്ച$w2Suffix');
      } else if (firstRune == 0x0D24) {
        results.add('$w1ത്ത$w2Suffix');
      } else if (firstRune == 0x0D2A) {
        results.add('$w1പ്പ$w2Suffix');
      }

      // 2.2 Sanskrit Consonant Sandhi: Jashthva, Anunasika, Schutva
      if (endsWithVirama && runes1.length >= 2) {
        final prevCons = runes1[runes1.length - 2];
        // ത/ത്
        if (prevCons == 0x0D24) {
          final prefix = String.fromCharCodes(
            runes1.sublist(0, runes1.length - 2),
          );
          if (firstRune == 0x0D2E) {
            results.add('$prefixന്മ$w2Suffix');
            results.add('$prefixൻമ$w2Suffix');
          }
          if (firstRune == 0x0D28) {
            results.add('$prefixന്ന$w2Suffix');
          }
          if (firstRune == 0x0D1A) {
            results.add('$prefixച്ച$w2Suffix');
          }
          if (firstRune == 0x0D1C) {
            results.add('$prefixജ്ജ$w2Suffix');
          }
          results.add('$prefixദ്$w2');
        }
        // ക്
        if (prevCons == 0x0D15) {
          final prefix = String.fromCharCodes(
            runes1.sublist(0, runes1.length - 2),
          );
          if (firstRune == 0x0D2E) {
            results.add('$prefixങ്മ$w2Suffix');
          }
          results.add('$prefixഗ്$w2');
        }
      }

      // 2.3 Anusvara Parasavarna
      if (endsWithAnusvara) {
        final prefix = String.fromCharCodes(
          runes1.sublist(0, runes1.length - 1),
        );
        if (firstRune >= 0x0D15 && firstRune <= 0x0D18) {
          results.add('$prefixങ്ക$w2Suffix');
          results.add('$prefixങ്$w2');
        } else if (firstRune >= 0x0D1A && firstRune <= 0x0D1D) {
          results.add('$prefixഞ്ച$w2Suffix');
          results.add('$prefixഞ്$w2');
        } else if (firstRune >= 0x0D24 && firstRune <= 0x0D27) {
          results.add('$prefixന്ത$w2Suffix');
          results.add('$prefixൻ$w2');
        } else if (firstRune >= 0x0D2A && firstRune <= 0x0D2D) {
          results.add('$prefixമ്പ$w2Suffix');
          results.add('$prefixമ്$w2');
        }
      }
    }

    // 3. Visarga Sandhi
    if (endsWithVisarga) {
      if (firstRune == 0x0D24) {
        results.add('$w1NoVisargaസ്ത$w2Suffix');
      } else if (firstRune == 0x0D1A) {
        results.add('$w1NoVisargaശ്ച$w2Suffix');
      } else if (firstRune == 0x0D1F) {
        results.add('$w1NoVisargaഷ്ട$w2Suffix');
      } else if (firstRune == 0x0D15 || firstRune == 0x0D2A) {
        results.add('$w1NoVisargaസ്$w2');
      }

      results.add('$w1NoVisargaർ$w2');
      results.add('$w1NoVisargaര്$w2');

      final (visBase, vType) = _getMalayalamTerminalVowel(
        w1NoVisarga.runes.toList(),
      );
      if (vType == 'a') {
        results.add('$visBase${String.fromCharCode(_mlSignOoLong)}$w2');
      }
    }

    return results;
  }

  // ---------------------------------------------------------------------------
  // Devanagari Sandhi implementation
  // ---------------------------------------------------------------------------

  Set<String> _joinDevanagari(String w1, String w2) {
    final results = <String>{};
    final runes1 = w1.runes.toList();
    final runes2 = w2.runes.toList();
    if (runes1.isEmpty || runes2.isEmpty) return results;

    final lastRune = runes1.last;
    final firstRune = runes2.first;

    final endsWithVirama = lastRune == _devVirama;
    final endsWithVisarga = lastRune == _devVisarga;
    final endsWithAnusvara = lastRune == _devAnusvara;

    final w1NoVisarga = endsWithVisarga
        ? String.fromCharCodes(runes1.sublist(0, runes1.length - 1))
        : w1;

    final (w1Stem, termVowel1) = _getDevanagariTerminalVowel(runes1);
    final w2Suffix = w2.substring(1);

    // 1. Vowel Sandhi (स्वरसन्धि) & Consonant + Vowel Sandhi
    if (_isDevanagariIndependentVowel(firstRune)) {
      // 1.1 Savarna Deergha Sandhi
      if ((termVowel1 == 'a' || termVowel1 == 'aa') &&
          (firstRune == _devA || firstRune == _devAa)) {
        results.add('$w1Stem${String.fromCharCode(_devSignAa)}$w2Suffix');
      } else if ((termVowel1 == 'i' || termVowel1 == 'ee') &&
          (firstRune == _devI || firstRune == _devEe)) {
        results.add('$w1Stem${String.fromCharCode(_devSignEe)}$w2Suffix');
      } else if ((termVowel1 == 'u' || termVowel1 == 'oo') &&
          (firstRune == _devU || firstRune == _devOo)) {
        results.add('$w1Stem${String.fromCharCode(_devSignOo)}$w2Suffix');
      } else if (termVowel1 == 'r' && firstRune == _devR) {
        results.add('$w1Stem${String.fromCharCode(_devSignR)}$w2Suffix');
      }

      // 1.2 Guna Sandhi
      if (termVowel1 == 'a' || termVowel1 == 'aa') {
        if (firstRune == _devI || firstRune == _devEe) {
          results.add('$w1Stem${String.fromCharCode(_devSignE)}$w2Suffix');
        } else if (firstRune == _devU || firstRune == _devOo) {
          results.add('$w1Stem${String.fromCharCode(_devSignO)}$w2Suffix');
        } else if (firstRune == _devR) {
          results.add('$w1Stemर्$w2Suffix');
        }
      }

      // 1.3 Vriddhi Sandhi
      if (termVowel1 == 'a' || termVowel1 == 'aa') {
        if (firstRune == _devE || firstRune == _devAi) {
          results.add('$w1Stem${String.fromCharCode(_devSignAi)}$w2Suffix');
        } else if (firstRune == _devO || firstRune == _devAu) {
          results.add('$w1Stem${String.fromCharCode(_devSignAu)}$w2Suffix');
        }
      }

      // 1.4 Yan Sandhi
      if (termVowel1 == 'i' || termVowel1 == 'ee') {
        final sign = _devVowelToSign(firstRune);
        results.add('$w1Stem्य$sign$w2Suffix');
      } else if (termVowel1 == 'u' || termVowel1 == 'oo') {
        final sign = _devVowelToSign(firstRune);
        results.add('$w1Stem्व$sign$w2Suffix');
      } else if (termVowel1 == 'r') {
        final sign = _devVowelToSign(firstRune);
        results.add('$w1Stem्र$sign$w2Suffix');
      }

      // 1.5 Consonant + Vowel Jashthva Sandhi
      if (endsWithVirama && runes1.length >= 2) {
        final prevCons = runes1[runes1.length - 2];
        final prefix = String.fromCharCodes(
          runes1.sublist(0, runes1.length - 2),
        );
        final sign = _devVowelToSign(firstRune);
        if (prevCons == 0x0915) {
          // क् -> ग्
          results.add('$prefixग$sign$w2Suffix');
        } else if (prevCons == 0x091A) {
          // च् -> ज्
          results.add('$prefixज$sign$w2Suffix');
        } else if (prevCons == 0x091F) {
          // ट् -> ड्
          results.add('$prefixड$sign$w2Suffix');
        } else if (prevCons == 0x0924) {
          // त् -> द्
          results.add('$prefixद$sign$w2Suffix');
        } else if (prevCons == 0x092A) {
          // प् -> ब्
          results.add('$prefixब$sign$w2Suffix');
        }
      }

      // 1.6 Poorvaroopa Sandhi / Avagraha
      if (firstRune == _devA && (termVowel1 == 'e' || termVowel1 == 'o')) {
        results.add('$w1${String.fromCharCode(_devAvagraha)}$w2Suffix');
        results.add('$w1$w2Suffix');
      }
    }

    // 2. Consonant Sandhi (व्यंजनसन्धि)
    if (_isDevanagariConsonant(firstRune)) {
      if (endsWithVirama && runes1.length >= 2) {
        final prevCons = runes1[runes1.length - 2];
        final prefix = String.fromCharCodes(
          runes1.sublist(0, runes1.length - 2),
        );

        // त्
        if (prevCons == 0x0924) {
          if (firstRune == 0x092E) {
            results.add('$prefixन्म$w2Suffix');
          }
          if (firstRune == 0x0928) {
            results.add('$prefixन्न$w2Suffix');
          }
          if (firstRune == 0x091A) {
            results.add('$prefixच्च$w2Suffix');
          }
          if (firstRune == 0x091C) {
            results.add('$prefixज्ज$w2Suffix');
          }
          results.add('$prefixद्$w2');
        }
        // क्
        if (prevCons == 0x0915) {
          if (firstRune == 0x092E) {
            results.add('$prefixङ्क$w2Suffix');
          }
          results.add('$prefixग्$w2');
        }
      }

      // Parasavarna
      if (endsWithAnusvara) {
        final prefix = String.fromCharCodes(
          runes1.sublist(0, runes1.length - 1),
        );
        if (firstRune >= 0x0915 && firstRune <= 0x0918) {
          results.add('$prefixङ्क$w2Suffix');
        } else if (firstRune >= 0x091A && firstRune <= 0x091D) {
          results.add('$prefixञ्च$w2Suffix');
        } else if (firstRune >= 0x0924 && firstRune <= 0x0927) {
          results.add('$prefixन्त$w2Suffix');
        } else if (firstRune >= 0x092A && firstRune <= 0x092D) {
          results.add('$prefixम्प$w2Suffix');
        }
      }
    }

    // 3. Visarga Sandhi (विसर्गसन्धि)
    if (endsWithVisarga) {
      if (firstRune == 0x0924) {
        results.add('$w1NoVisargaस्त$w2Suffix');
      } else if (firstRune == 0x091A) {
        results.add('$w1NoVisargaश्च$w2Suffix');
      } else if (firstRune == 0x091F) {
        results.add('$w1NoVisargaष्ट$w2Suffix');
      }
      results.add('$w1NoVisargaर्$w2');

      final (visBase, vType) = _getDevanagariTerminalVowel(
        w1NoVisarga.runes.toList(),
      );
      if (vType == 'a') {
        results.add('$visBase${String.fromCharCode(_devSignO)}$w2');
      }
    }

    return results;
  }

  // ---------------------------------------------------------------------------
  // Helper methods
  // ---------------------------------------------------------------------------

  static (String stem, String vowel) _getMalayalamTerminalVowel(
    List<int> runes,
  ) {
    if (runes.isEmpty) return ('', 'none');
    final last = runes.last;
    if (last == _mlSignAa) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'aa');
    }
    if (last == _mlSignI) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'i');
    }
    if (last == _mlSignEe) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'ee');
    }
    if (last == _mlSignU) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'u');
    }
    if (last == _mlSignOo) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'oo');
    }
    if (last == _mlSignR) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'r');
    }
    if (last == _mlSignE) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'e');
    }
    if (last == _mlSignEeLong) {
      return (
        String.fromCharCodes(runes.sublist(0, runes.length - 1)),
        'e_long',
      );
    }
    if (last == _mlSignAi) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'ai');
    }
    if (last == _mlSignO) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'o');
    }
    if (last == _mlSignOoLong) {
      return (
        String.fromCharCodes(runes.sublist(0, runes.length - 1)),
        'o_long',
      );
    }
    if (last == _mlSignAu) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'au');
    }
    if (last == _mlVirama) {
      final base = runes.length >= 2
          ? String.fromCharCodes(runes.sublist(0, runes.length - 2))
          : '';
      return (base, 'virama');
    }
    if (_isMalayalamConsonant(last)) {
      // Inherent 'a'
      return (String.fromCharCodes(runes), 'a');
    }
    return (String.fromCharCodes(runes), 'other');
  }

  static (String stem, String vowel) _getDevanagariTerminalVowel(
    List<int> runes,
  ) {
    if (runes.isEmpty) return ('', 'none');
    final last = runes.last;
    if (last == _devSignAa) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'aa');
    }
    if (last == _devSignI) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'i');
    }
    if (last == _devSignEe) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'ee');
    }
    if (last == _devSignU) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'u');
    }
    if (last == _devSignOo) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'oo');
    }
    if (last == _devSignR) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'r');
    }
    if (last == _devSignE) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'e');
    }
    if (last == _devSignAi) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'ai');
    }
    if (last == _devSignO) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'o');
    }
    if (last == _devSignAu) {
      return (String.fromCharCodes(runes.sublist(0, runes.length - 1)), 'au');
    }
    if (last == _devVirama) {
      final base = runes.length >= 2
          ? String.fromCharCodes(runes.sublist(0, runes.length - 2))
          : '';
      return (base, 'virama');
    }
    if (_isDevanagariConsonant(last)) {
      return (String.fromCharCodes(runes), 'a');
    }
    return (String.fromCharCodes(runes), 'other');
  }

  static bool _isMalayalamIndependentVowel(int r) => r >= 0x0D05 && r <= 0x0D14;
  static bool _isMalayalamConsonant(int r) =>
      (r >= 0x0D15 && r <= 0x0D3A) || (r >= 0x0D7A && r <= 0x0D7F);

  static bool _isDevanagariIndependentVowel(int r) =>
      r >= 0x0904 && r <= 0x0914;
  static bool _isDevanagariConsonant(int r) => r >= 0x0915 && r <= 0x0939;

  static String _mlVowelToSign(int vowelRune) {
    return switch (vowelRune) {
      _mlA => '',
      _mlAa => String.fromCharCode(_mlSignAa),
      _mlI => String.fromCharCode(_mlSignI),
      _mlEe => String.fromCharCode(_mlSignEe),
      _mlU => String.fromCharCode(_mlSignU),
      _mlOo => String.fromCharCode(_mlSignOo),
      _mlR => String.fromCharCode(_mlSignR),
      _mlE => String.fromCharCode(_mlSignE),
      0x0D0F => String.fromCharCode(_mlSignEeLong),
      _mlAi => String.fromCharCode(_mlSignAi),
      _mlO => String.fromCharCode(_mlSignO),
      0x0D13 => String.fromCharCode(_mlSignOoLong),
      _mlAu => String.fromCharCode(_mlSignAu),
      _ => '',
    };
  }

  static String _devVowelToSign(int vowelRune) {
    return switch (vowelRune) {
      _devA => '',
      _devAa => String.fromCharCode(_devSignAa),
      _devI => String.fromCharCode(_devSignI),
      _devEe => String.fromCharCode(_devSignEe),
      _devU => String.fromCharCode(_devSignU),
      _devOo => String.fromCharCode(_devSignOo),
      _devR => String.fromCharCode(_devSignR),
      _devE => String.fromCharCode(_devSignE),
      _devAi => String.fromCharCode(_devSignAi),
      _devO => String.fromCharCode(_devSignO),
      _devAu => String.fromCharCode(_devSignAu),
      _ => '',
    };
  }
}
