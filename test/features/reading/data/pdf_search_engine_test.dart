import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/search/search_normalizer.dart';
import 'package:pdfapp/features/reading/data/pdf_search_engine.dart';
import 'package:pdfapp/features/reading/data/pdf_text_source.dart';
import 'package:pdfapp/features/reading/domain/text_quality.dart';

/// A document made of plain strings — no PDF, no pdfium, no device.
///
/// Every character gets a 10-wide box on one line, which is enough for the
/// engine's purposes and keeps the expected rectangles easy to reason about.
class FakeTextSource implements PageTextSource {
  FakeTextSource(this.pages);

  final List<String> pages;
  final List<int> loaded = [];

  @override
  int get pageCount => pages.length;

  @override
  Future<PageText> page(int pageNumber) async {
    loaded.add(pageNumber);
    final text = pages[pageNumber - 1];
    return PageText(
      pageNumber: pageNumber,
      text: text,
      charRects: [
        for (var i = 0; i < text.length; i++)
          PdfRect(i * 10, 20, (i * 10) + 10, 10),
      ],
    );
  }
}

void main() {
  group('finding matches', () {
    test('finds a match and reports the page it is on', () async {
      final engine = PdfSearchEngine(
        source: FakeTextSource(['nothing here', 'the cat sat']),
      );

      final hits = await engine.search('cat').toList();

      expect(hits, hasLength(1));
      expect(hits.single.pageNumber, 2);
      expect(hits.single.sourceStart, 4);
      expect(hits.single.sourceEnd, 7);
    });

    test('finds every match across pages', () async {
      final engine = PdfSearchEngine(
        source: FakeTextSource(['cat', 'cat cat']),
      );

      final hits = await engine.search('cat').toList();

      expect(hits, hasLength(3));
      expect(hits.map((h) => h.pageNumber), [1, 2, 2]);
    });

    test('gives a rectangle to draw for each match', () async {
      final engine = PdfSearchEngine(source: FakeTextSource(['ab cat']));

      final hits = await engine.search('cat').toList();

      // 'cat' is characters 3..5, so the box spans x=30 to x=60.
      expect(hits.single.rects, hasLength(1));
      expect(hits.single.rects.single.left, 30);
      expect(hits.single.rects.single.right, 60);
    });

    test('search ignores case', () async {
      final engine = PdfSearchEngine(source: FakeTextSource(['The Cat']));
      expect(await engine.search('cat').toList(), hasLength(1));
    });

    test(
      'a Malayalam word spelled the old way is found by the modern query',
      () async {
        // The chillu fold is proven in the normalizer's own tests; this checks the
        // engine really uses it.
        final zwj = String.fromCharCode(0x200D);
        final virama = String.fromCharCode(0x0D4D);
        final chilluN = String.fromCharCode(0x0D7B);
        final engine = PdfSearchEngine(
          source: FakeTextSource(['ന$virama$zwj']),
        );

        expect(await engine.search(chilluN).toList(), hasLength(1));
      },
    );
  });

  group('nothing to find', () {
    test('a blank query finds nothing', () async {
      final engine = PdfSearchEngine(source: FakeTextSource(['cat']));
      expect(await engine.search('   ').toList(), isEmpty);
    });

    test('a query of only invisible joiners finds nothing', () async {
      // These fold away to an empty key, which would otherwise match at every
      // position on every page.
      final engine = PdfSearchEngine(source: FakeTextSource(['cat']));
      final zwj = String.fromCharCode(0x200D);

      expect(await engine.search(zwj).toList(), isEmpty);
    });

    test('a word that is not there finds nothing', () async {
      final engine = PdfSearchEngine(source: FakeTextSource(['cat']));
      expect(await engine.search('dog').toList(), isEmpty);
    });

    test('an empty document finds nothing', () async {
      final engine = PdfSearchEngine(source: FakeTextSource([]));
      expect(await engine.search('cat').toList(), isEmpty);
    });

    test('blank pages are skipped', () async {
      final source = FakeTextSource(['', '   ', 'cat']);
      final engine = PdfSearchEngine(source: source);

      expect(await engine.search('cat').toList(), hasLength(1));
    });
  });

  group('page order', () {
    test('starts at the reader\'s page and wraps around', () async {
      final engine = PdfSearchEngine(
        source: FakeTextSource(['cat', 'cat', 'cat']),
      );

      final hits = await engine.search('cat', startPage: 2).toList();

      // The match in front of the reader comes first; page 1 comes last.
      expect(hits.map((h) => h.pageNumber), [2, 3, 1]);
    });

    test('looks at every page exactly once', () async {
      final source = FakeTextSource(['a', 'b', 'c', 'd']);
      await PdfSearchEngine(
        source: source,
      ).search('zzz', startPage: 3).toList();

      expect(source.loaded, [3, 4, 1, 2]);
    });

    test('a start page out of range is clamped rather than throwing', () async {
      final engine = PdfSearchEngine(source: FakeTextSource(['cat', 'cat']));

      expect(await engine.search('cat', startPage: 99).toList(), hasLength(2));
      expect(await engine.search('cat', startPage: 0).toList(), hasLength(2));
    });
  });

  group('limits', () {
    test('stops at the match limit', () async {
      // A one-letter query on a big document must not fill memory.
      final page = 'a' * 100;
      final source = FakeTextSource(List.filled(20, page));

      final hits = await PdfSearchEngine(source: source).search('a').toList();

      expect(hits, hasLength(AppConstants.searchMatchLimit));
    });

    test('stops loading pages once the limit is hit', () async {
      final source = FakeTextSource(List.filled(20, 'a' * 100));
      await PdfSearchEngine(source: source).search('a').toList();

      // 500 matches at 100 per page = 5 pages; it must not read all 20.
      expect(source.loaded.length, lessThan(20));
    });
  });

  group('search options', () {
    test('strict mode keeps joiner spellings apart', () async {
      final zwj = String.fromCharCode(0x200D);
      final virama = String.fromCharCode(0x0D4D);
      final chilluN = String.fromCharCode(0x0D7B);
      final engine = PdfSearchEngine(
        source: FakeTextSource(['ന$virama$zwj']),
        options: const SearchOptions(strict: true),
      );

      expect(await engine.search(chilluN).toList(), isEmpty);
    });

    test('accent-insensitive mode finds accented Sanskrit', () async {
      final udatta = String.fromCharCode(0x0951);
      final engine = PdfSearchEngine(
        source: FakeTextSource(['क$udatta']),
        options: const SearchOptions(ignoreAccents: true),
      );

      expect(await engine.search('क').toList(), hasLength(1));
    });
  });

  group('assessTextQuality', () {
    test('a text document is good', () async {
      final source = FakeTextSource(['The quick brown fox jumps over it.']);
      expect(await assessTextQuality(source), TextQuality.good);
    });

    test('a scanned document has no text', () async {
      expect(
        await assessTextQuality(FakeTextSource(['', '', ''])),
        TextQuality.none,
      );
    });

    test('a document with no pages has no text', () async {
      expect(await assessTextQuality(FakeTextSource([])), TextQuality.none);
    });

    test('samples across a long document, not just the front', () async {
      // A scanned book with a text title page must still be called scanned.
      final pages = [
        'Title page with real words on it',
        ...List.filled(99, ''),
      ];
      final source = FakeTextSource(pages);

      await assessTextQuality(source);

      expect(source.loaded, hasLength(AppConstants.textQualitySamplePages));
      expect(source.loaded.any((p) => p > 50), isTrue);
    });

    test('a short document samples every page', () async {
      final source = FakeTextSource(['a', 'b']);
      await assessTextQuality(source);

      expect(source.loaded, [1, 2]);
    });
  });
}
