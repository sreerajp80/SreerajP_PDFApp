import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/search/script_detector.dart';

void main() {
  group('of', () {
    test('recognises Malayalam', () {
      expect(ScriptDetector.of(0x0D15), PdfScript.malayalam); // ka
      expect(ScriptDetector.of(0x0D00), PdfScript.malayalam); // block start
      expect(ScriptDetector.of(0x0D7F), PdfScript.malayalam); // block end
    });

    test('recognises Devanagari, including the Sanskrit blocks', () {
      expect(ScriptDetector.of(0x0915), PdfScript.devanagari); // ka
      expect(ScriptDetector.of(0x0951), PdfScript.devanagari); // udatta accent
      expect(
        ScriptDetector.of(0x1CD0),
        PdfScript.devanagari,
      ); // Vedic Extensions
      expect(ScriptDetector.of(0xA8E0), PdfScript.devanagari); // Dev. Extended
    });

    test('everything else is other', () {
      expect(ScriptDetector.of(0x0041), PdfScript.other); // A
      expect(ScriptDetector.of(0x0030), PdfScript.other); // 0
      expect(ScriptDetector.of(0x0020), PdfScript.other); // space
      expect(ScriptDetector.of(0x0B85), PdfScript.other); // Tamil — not ours
    });

    test('does not claim code points just outside its blocks', () {
      expect(
        ScriptDetector.of(0x0CFF),
        PdfScript.other,
      ); // just before Malayalam
      expect(
        ScriptDetector.of(0x0D80),
        PdfScript.other,
      ); // just after Malayalam
      expect(
        ScriptDetector.of(0x08FF),
        PdfScript.other,
      ); // just before Devanagari
      expect(
        ScriptDetector.of(0x0980),
        PdfScript.other,
      ); // just after Devanagari
    });
  });

  group('scriptsIn', () {
    test('finds nothing special in plain English', () {
      expect(ScriptDetector.scriptsIn('Hello world'), isEmpty);
    });

    test('finds Malayalam', () {
      expect(ScriptDetector.scriptsIn(' കേരളം'), {PdfScript.malayalam});
    });

    test('finds both scripts in a mixed document', () {
      // A Malayalam book quoting Devanagari Sanskrit is a real case.
      expect(ScriptDetector.scriptsIn('കേരളം ॐ नमः'), {
        PdfScript.malayalam,
        PdfScript.devanagari,
      });
    });

    test('empty text has no scripts', () {
      expect(ScriptDetector.scriptsIn(''), isEmpty);
    });
  });

  group('hasComplexScript', () {
    test('is false for Latin and true for Malayalam', () {
      expect(ScriptDetector.hasComplexScript('Hello'), isFalse);
      expect(ScriptDetector.hasComplexScript('കേരളം'), isTrue);
    });
  });

  group('dominantScript', () {
    test('picks the script that appears most', () {
      expect(ScriptDetector.dominantScript('കേരളം ॐ'), PdfScript.malayalam);
      expect(ScriptDetector.dominantScript('क नमः ക'), PdfScript.devanagari);
    });

    test('is other when there is no complex script', () {
      expect(ScriptDetector.dominantScript('Hello 123'), PdfScript.other);
    });

    test('ignores surrounding Latin when picking', () {
      expect(
        ScriptDetector.dominantScript('Chapter 1: കേരളം'),
        PdfScript.malayalam,
      );
    });
  });
}
