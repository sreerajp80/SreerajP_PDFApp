import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/reading/domain/text_quality.dart';

/// Builds a string of [count] characters starting at [start] — used to make
/// samples long enough to be judged.
String repeat(String s, int count) => List.filled(count, s).join();

void main() {
  group('no text layer (scanned)', () {
    test('empty text', () {
      expect(TextQualityCheck.assess(''), TextQuality.none);
    });

    test('whitespace only — a scanned page often yields stray spaces', () {
      expect(TextQualityCheck.assess('   \n\n \t '), TextQuality.none);
    });
  });

  group('good text', () {
    test('ordinary English', () {
      expect(
        TextQualityCheck.assess('The quick brown fox jumps over the lazy dog.'),
        TextQuality.good,
      );
    });

    test('Malayalam that decoded properly', () {
      expect(TextQualityCheck.assess(repeat('കേരളം ', 10)), TextQuality.good);
    });

    test('a few odd glyphs among real text are tolerated', () {
      // Real PDFs do contain the occasional private-use glyph (a logo, a
      // ligature). That alone must not condemn the document.
      final sample = '${repeat('a', 50)}${String.fromCharCode(0xE000)}';
      expect(TextQualityCheck.assess(sample), TextQuality.good);
    });
  });

  group('garbled text (font with no ToUnicode map)', () {
    test('mostly private-use characters', () {
      final sample = repeat(String.fromCharCode(0xE001), 30);
      expect(TextQualityCheck.assess(sample), TextQuality.garbled);
    });

    test('mostly replacement characters', () {
      final sample = repeat(String.fromCharCode(0xFFFD), 30);
      expect(TextQualityCheck.assess(sample), TextQuality.garbled);
    });

    test('private-use characters in the supplementary planes', () {
      final sample = repeat(String.fromCharCode(0xF0001), 30);
      expect(TextQualityCheck.assess(sample), TextQuality.garbled);
    });

    test('past the threshold in a mixed sample', () {
      // 30 bad out of 60 = half, well over the one-fifth threshold.
      final sample = repeat('a', 30) + repeat(String.fromCharCode(0xE000), 30);
      expect(TextQualityCheck.assess(sample), TextQuality.garbled);
    });
  });

  group('Indic text stored in drawing order (unreliable)', () {
    test('proper Devanagari is good', () {
      expect(
        TextQualityCheck.assess(
          repeat(
            'कामेश्वरमुखालोककल्पितश्रीगणेश्वरा महागणेशनिर्भिन्नविघ्नयन्त्रप्रहर्षिता ',
            3,
          ),
        ),
        TextQuality.good,
      );
    });

    test('proper Malayalam with decomposed two-part vowels is good', () {
      // കൊ written as ക + െ + ാ is valid Unicode and must not be flagged.
      const decomposedKo = 'കൊ';
      expect(
        TextQualityCheck.assess(repeat('$decomposedKoണ്ട് കേരളം പൈതൃകം ', 6)),
        TextQuality.good,
      );
    });

    test('Devanagari with the i-sign before its consonant', () {
      // "विशुद्धि शक्ति" as a drawing-order PDF gives it: ि comes first.
      expect(
        TextQualityCheck.assess(repeat('िवशुद्ध िशक्त िकामेश्वरी ', 6)),
        TextQuality.unreliable,
      );
    });

    test('Malayalam with the e-sign before its consonant', () {
      // "കേരളം" in drawing order: േ before ക.
      expect(
        TextQualityCheck.assess(repeat('േകരളം ൈപതൃകം ', 6)),
        TextQuality.unreliable,
      );
    });

    test('a vowel sign after an independent vowel', () {
      // "अति" in drawing order: अ ि त.
      expect(
        TextQualityCheck.assess(repeat('अित अिप इित ', 8)),
        TextQuality.unreliable,
      );
    });

    test('too few marks to judge their order', () {
      expect(
        TextQualityCheck.assess('ि abcdefghijklmnopqrstuvwxyz'),
        TextQuality.good,
      );
    });
  });

  group('old Indic font mapped onto Latin-1 symbols (unreliable)', () {
    test('Kruti Dev style text', () {
      // How an old Hindi font's text layer reads: Latin letters plus rare
      // Latin-1 symbols standing in for brackets and conjuncts.
      expect(
        TextQualityCheck.assess(repeat("Hkkjr ,d foLr`r ¼ns'k½ gS¡ ", 6)),
        TextQuality.unreliable,
      );
    });

    test('ordinary French and German text is good', () {
      expect(
        TextQualityCheck.assess(
          repeat('Déjà vu à l’école, schöne Grüße aus München. ', 4),
        ),
        TextQuality.good,
      );
    });

    test('a Spanish question with ¿ and ¡ is good', () {
      expect(
        TextQualityCheck.assess(
          repeat('¿Dónde está la biblioteca? ¡Aquí mismo, señor! ', 2) +
              repeat('Una frase normal sin signos raros. ', 6),
        ),
        TextQuality.good,
      );
    });

    test('Devanagari text with a few symbols is good', () {
      expect(
        TextQualityCheck.assess(
          repeat('कामेश्वरमुखालोककल्पितश्रीगणेश्वरा ¼७७½ ', 6),
        ),
        TextQuality.good,
      );
    });
  });

  group('usable levels', () {
    test('good and unreliable offer search; none and garbled do not', () {
      expect(TextQuality.good.isUsable, isTrue);
      expect(TextQuality.unreliable.isUsable, isTrue);
      expect(TextQuality.none.isUsable, isFalse);
      expect(TextQuality.garbled.isUsable, isFalse);
    });
  });

  group('too little text to judge', () {
    test('a short sample is given the benefit of the doubt', () {
      // Below the minimum, a couple of odd characters must not brand a good
      // PDF as broken.
      expect(
        TextQualityCheck.assess(String.fromCharCode(0xE000)),
        TextQuality.good,
      );
    });
  });

  group('whitespace is not evidence', () {
    test('spaces around good text do not tip the judgement', () {
      expect(
        TextQualityCheck.assess('  ${repeat('word ', 10)}  '),
        TextQuality.good,
      );
    });
  });
}
