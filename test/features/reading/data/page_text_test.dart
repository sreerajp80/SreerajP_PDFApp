import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/features/reading/data/pdf_text_source.dart';

/// A box on the first line (y 20..10) for character slot [i].
PdfRect lineOne(int i) => PdfRect(i * 10, 20, (i * 10) + 10, 10);

/// A box on the second line (y 8..0), lower down the page. PDF y-coordinates
/// grow upwards, so "lower on the page" means smaller numbers.
PdfRect lineTwo(int i) => PdfRect(i * 10, 8, (i * 10) + 10, 0);

const noRect = PdfRect(0, 0, 0, 0);

PageText pageOf(String text, List<PdfRect> rects) =>
    PageText(pageNumber: 1, text: text, charRects: rects);

void main() {
  group('rectsForRange', () {
    test('merges characters on one line into a single box', () {
      final page = pageOf('abc', [lineOne(0), lineOne(1), lineOne(2)]);

      final rects = page.rectsForRange(0, 3);

      expect(rects, hasLength(1));
      expect(rects.single.left, 0);
      expect(rects.single.right, 30);
    });

    test('covers only the asked-for range', () {
      final page = pageOf('abc', [lineOne(0), lineOne(1), lineOne(2)]);

      final rects = page.rectsForRange(1, 2);

      expect(rects.single.left, 10);
      expect(rects.single.right, 20);
    });

    test('gives one box per line when a match wraps', () {
      // A single box would swallow the whole block between the two lines.
      final page = pageOf('abcd', [
        lineOne(0),
        lineOne(1),
        lineTwo(0),
        lineTwo(1),
      ]);

      final rects = page.rectsForRange(0, 4);

      expect(rects, hasLength(2));
      expect(rects.first.top, 20);
      expect(rects.last.top, 8);
    });

    test('skips characters that have no box of their own', () {
      // A newline gets no rectangle; merging it would drag the highlight to the
      // corner of the page.
      final page = pageOf('a\nb', [lineOne(0), noRect, lineOne(2)]);

      final rects = page.rectsForRange(0, 3);

      expect(rects, hasLength(1));
      expect(rects.single.left, 0);
      expect(rects.single.right, 30);
    });

    test('an empty range gives nothing', () {
      final page = pageOf('abc', [lineOne(0), lineOne(1), lineOne(2)]);

      expect(page.rectsForRange(1, 1), isEmpty);
    });

    test('a range outside the page gives nothing rather than throwing', () {
      final page = pageOf('abc', [lineOne(0), lineOne(1), lineOne(2)]);

      expect(page.rectsForRange(-1, 2), isEmpty);
      expect(page.rectsForRange(0, 99), isEmpty);
      expect(page.rectsForRange(2, 1), isEmpty);
    });

    test('text with no boxes at all gives nothing', () {
      final page = pageOf('abc', [noRect, noRect, noRect]);

      expect(page.rectsForRange(0, 3), isEmpty);
    });
  });

  group('isEmpty', () {
    test('is true for blank text', () {
      expect(pageOf('', const []).isEmpty, isTrue);
      expect(pageOf('  \n ', const []).isEmpty, isTrue);
    });

    test('is false when there are real words', () {
      expect(pageOf('a', [lineOne(0)]).isEmpty, isFalse);
    });
  });
}
