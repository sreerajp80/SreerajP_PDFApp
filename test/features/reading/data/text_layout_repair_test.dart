import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/features/reading/data/text_layout_repair.dart';

/// A box from left/top/right/bottom (PDF y grows upwards, so top > bottom).
PdfRect box(double l, double t, double r, double b) => PdfRect(l, t, r, b);

/// pdfium's generated characters (its own spaces and line breaks) have an
/// empty point box.
PdfRect point(double x, double y) => PdfRect(x, y, x, y);

/// Runs the repair on characters given as (text, box) pairs, one pair per
/// Unicode character, the way pdfium's raw text gives them.
({String text, List<PdfRect> rects}) repairChars(
  List<(String, PdfRect)> chars,
) => TextLayoutRepair.repair(
  chars.map((c) => c.$1).join(),
  chars.map((c) => c.$2).toList(),
);

/// A simple left-to-right line: one 10-point box per character, starting at
/// x = 0, with spaces in their right place.
List<(String, PdfRect)> line(
  String text, {
  double top = 20,
  double bottom = 10,
}) => [
  for (var i = 0; i < text.length; i++)
    (text[i], box(i * 10.0, top, i * 10.0 + 9, bottom)),
];

void main() {
  group('fault A: a misplaced real space inside a word', () {
    test('drops the space pdfium put inside അർത്ഥം (real boxes)', () {
      // From a LibreOffice PDF: pdfium's generated space sits before അ, and the
      // real space glyph (drawn in that same gap, x 210.2–214.0) comes after ർ.
      final result = repairChars([
        ('ക', box(186.25, 470.49, 199.83, 463.45)),
        ('ൾ', box(198.34, 472.91, 212.98, 463.41)),
        (' ', point(213.98, 463.54)),
        ('അ', box(214.41, 470.51, 233.09, 463.40)),
        ('ർ', box(231.58, 472.80, 242.89, 463.36)),
        (' ', box(210.20, 463.55, 214.00, 463.54)),
        ('ത', box(240.64, 470.56, 246.85, 463.41)),
        ('്', box(246.85, 470.56, 253.06, 463.41)),
        ('ഥ', box(253.06, 470.56, 259.27, 463.41)),
        ('ം', box(259.27, 470.56, 265.48, 463.41)),
        (' ', point(240.20, 463.54)),
        ('ക', box(267.83, 472.89, 276.12, 463.40)),
      ]);

      expect(result.text, 'കൾ അർത്ഥം ക');
    });

    test('drops the space pdfium put inside ഉവാച (real boxes)', () {
      final result = repairChars([
        ('ര', box(93.84, 646.45, 103.97, 636.14)),
        (' ', point(108.29, 640.44)),
        ('ഉ', box(108.87, 646.45, 115.49, 638.43)),
        (' ', box(104.55, 640.45, 108.29, 640.44)),
        ('വ', box(116.69, 646.44, 124.08, 640.33)),
        ('ാ', box(124.08, 646.44, 131.47, 640.33)),
        ('ച', box(132.29, 646.44, 140.34, 640.42)),
      ]);

      expect(result.text, 'ര ഉവാച');
    });

    test('moves a misplaced space into a gap that has none', () {
      // "ab cd" drawn as "abcd" then the space, which belongs between b and c.
      final result = repairChars([
        ('a', box(0, 20, 9, 10)),
        ('b', box(10, 20, 19, 10)),
        ('c', box(25, 20, 34, 10)),
        ('d', box(35, 20, 44, 10)),
        (' ', box(20, 12, 24, 11)),
      ]);

      expect(result.text, 'ab cd');
      expect(result.rects[2], box(20, 12, 24, 11));
      expect(result.rects[3], box(25, 20, 34, 10));
    });
  });

  group('fault B: a space pdfium dropped after a virama', () {
    test('adds the space in എന്ന് വിളി (real boxes)', () {
      final result = repairChars([
        ('എ', box(57.39, 376.96, 69.44, 368.42)),
        ('ന', box(70.59, 379.32, 75.00, 370.81)),
        ('്', box(75.00, 379.32, 79.41, 370.81)),
        ('ന', box(79.41, 379.32, 83.82, 370.81)),
        ('്', box(83.82, 379.32, 88.23, 370.81)),
        ('വ', box(90.69, 379.21, 96.15, 370.81)),
        ('ി', box(96.15, 379.21, 101.61, 370.81)),
      ]);

      expect(result.text, 'എന്ന് വി');
      // The added space covers the gap between the virama and the next letter.
      final space = result.text.indexOf(' ');
      expect(result.rects[space].left, 88.23);
      expect(result.rects[space].right, 90.69);
    });

    test('adds no space for a virama inside a word', () {
      // ന്ന: the letter after the virama touches it.
      final result = repairChars([
        ('ന', box(70.59, 379.32, 75.00, 370.81)),
        ('്', box(75.00, 379.32, 79.41, 370.81)),
        ('ന', box(79.41, 379.32, 83.82, 370.81)),
      ]);

      expect(result.text, 'ന്ന');
    });

    test('adds no space when a conjunct shares one box', () {
      // ഷ്ട്ര drawn as one glyph: every character has the same box.
      final shared = box(197.09, 565.35, 207.22, 555.04);
      final result = repairChars([
        ('ഷ', shared),
        ('്', shared),
        ('ട', shared),
        ('്', shared),
        ('ര', shared),
      ]);

      expect(result.text, 'ഷ്ട്ര');
    });

    test('adds no space between a virama and the next line', () {
      final result = repairChars([
        ('ന', box(70, 400, 75, 390)),
        ('്', box(75, 400, 80, 390)),
        ('വ', box(10, 380, 15, 370)),
      ]);

      expect(result.text, 'ന്വ');
    });

    test('also works for the Devanagari virama', () {
      final result = repairChars([
        ('त', box(0, 20, 5, 10)),
        ('्', box(5, 20, 8, 10)),
        ('क', box(11, 20, 16, 10)),
      ]);

      expect(result.text, 'त् क');
    });
  });

  group('blanks', () {
    test('turns \\r\\n into one \\n', () {
      final result = repairChars([
        ...line('ab'),
        ('\r', point(19, 10)),
        ('\n', point(19, 10)),
        ...line('cd', top: 8, bottom: 0),
      ]);

      expect(result.text, 'ab\ncd');
    });

    test('merges a space before a line break into the line break', () {
      final result = repairChars([
        ...line('ab'),
        (' ', point(19, 10)),
        ('\r', point(19, 10)),
        ('\n', point(19, 10)),
        ...line('cd', top: 8, bottom: 0),
      ]);

      expect(result.text, 'ab\ncd');
    });

    test('merges a run of spaces into one, keeping a real box', () {
      final result = repairChars([
        ('a', box(0, 20, 9, 10)),
        (' ', point(9, 10)),
        (' ', box(10, 12, 14, 11)),
        ('b', box(15, 20, 24, 10)),
      ]);

      expect(result.text, 'a b');
      expect(result.rects[1], box(10, 12, 14, 11));
    });
  });

  group('text that is already right', () {
    test('comes back unchanged', () {
      final chars = line('Hello world, this is fine.');
      final result = repairChars(chars);

      expect(result.text, 'Hello world, this is fine.');
      expect(result.rects, chars.map((c) => c.$2).toList());
    });

    test('keeps a real line break between two lines', () {
      final result = repairChars([
        ...line('ab'),
        ('\n', point(19, 10)),
        ...line('cd', top: 8, bottom: 0),
      ]);

      expect(result.text, 'ab\ncd');
    });
  });

  test('drops the fake line breaks between vertical characters', () {
    final result = repairChars([
      ('縦', box(100, 200, 110, 190)),
      ('\r', point(110, 190)),
      ('\n', point(110, 190)),
      ('書', box(100, 189, 110, 179)),
      ('\r', point(110, 179)),
      ('\n', point(110, 179)),
      ('き', box(100, 178, 110, 168)),
    ]);

    expect(result.text, '縦書き');
  });

  group('safety', () {
    test('keeps boxes index-aligned with the text', () {
      final result = repairChars([
        ('ക', box(186.25, 470.49, 199.83, 463.45)),
        ('ൾ', box(198.34, 472.91, 212.98, 463.41)),
        (' ', point(213.98, 463.54)),
        ('അ', box(214.41, 470.51, 233.09, 463.40)),
        ('ർ', box(231.58, 472.80, 242.89, 463.36)),
        (' ', box(210.20, 463.55, 214.00, 463.54)),
        ('ത', box(240.64, 470.56, 246.85, 463.41)),
        ('്', box(246.85, 470.56, 253.06, 463.41)),
        ('വ', box(256, 470.56, 260, 463.41)),
      ]);

      expect(result.rects, hasLength(result.text.length));
    });

    test('gives a character outside the BMP one box per UTF-16 unit', () {
      // pdfium gives one box for "😀" (two UTF-16 units).
      final result = TextLayoutRepair.repair('a😀', [
        box(0, 20, 9, 10),
        box(10, 20, 19, 10),
      ]);

      expect(result.text, 'a😀');
      expect(result.rects, hasLength(3));
      expect(result.rects[1], box(10, 20, 19, 10));
      expect(result.rects[2], box(10, 20, 19, 10));
    });

    test('does not throw when text and boxes do not match', () {
      final result = TextLayoutRepair.repair('abc', [box(0, 20, 9, 10)]);

      expect(result.text, 'abc');
      expect(result.rects, hasLength(3));
    });

    test('handles an empty page', () {
      final result = TextLayoutRepair.repair('', const []);

      expect(result.text, '');
      expect(result.rects, isEmpty);
    });
  });
}
