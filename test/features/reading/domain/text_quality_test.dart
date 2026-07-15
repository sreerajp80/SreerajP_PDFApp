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
