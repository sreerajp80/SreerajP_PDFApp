import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/features/reading/data/pdf_text_source.dart';

/// A page that is either loaded (with [text]) or still a placeholder.
class _FakePage extends Fake implements PdfPage {
  _FakePage(this.pageNumber, {required this.isLoaded, this.text = ''});

  @override
  final int pageNumber;

  @override
  final bool isLoaded;

  final String text;

  @override
  Future<PdfPageRawText?> loadText() async {
    // Mirrors pdfrx: a page that is not loaded gives no text.
    if (!isLoaded) return null;
    return PdfPageRawText(
      text,
      List.generate(
        text.length,
        (i) => PdfRect(i * 10.0, 20, (i * 10.0) + 10, 10),
      ),
    );
  }
}

class _FakeDocument extends Fake implements PdfDocument {
  _FakeDocument(this.pages);

  @override
  final List<PdfPage> pages;
}

void main() {
  group('PdfTextSource with pages that load later', () {
    test('waits for an unloaded page and reads the loaded one', () async {
      final placeholder = _FakePage(1, isLoaded: false);
      final loaded = _FakePage(1, isLoaded: true, text: 'Rest your eyes');
      final source = PdfTextSource(
        _FakeDocument([placeholder]),
        waitForPage: (page, timeout) async => loaded,
      );

      final page = await source.page(1);

      expect(page.text, 'Rest your eyes');
    });

    test('a page that does not load in time is empty but not cached', () async {
      final placeholder = _FakePage(1, isLoaded: false);
      final loaded = _FakePage(1, isLoaded: true, text: 'original');
      var calls = 0;
      final source = PdfTextSource(
        _FakeDocument([placeholder]),
        // First request: the page has not loaded in time. Second: it has.
        waitForPage: (page, timeout) async => ++calls == 1 ? null : loaded,
      );

      final first = await source.page(1);
      final second = await source.page(1);

      expect(first.isEmpty, isTrue);
      expect(second.text, 'original');
      expect(calls, 2);
    });

    test('a loaded page is read once and then cached', () async {
      final loaded = _FakePage(1, isLoaded: true, text: 'reading');
      var calls = 0;
      final source = PdfTextSource(
        _FakeDocument([loaded]),
        waitForPage: (page, timeout) async {
          calls++;
          return page;
        },
      );

      await source.page(1);
      final again = await source.page(1);

      expect(again.text, 'reading');
      expect(calls, 1);
    });

    test('a page number out of range is empty', () async {
      final source = PdfTextSource(
        _FakeDocument([_FakePage(1, isLoaded: true, text: 'x')]),
        waitForPage: (page, timeout) async => page,
      );

      expect((await source.page(0)).isEmpty, isTrue);
      expect((await source.page(2)).isEmpty, isTrue);
    });
  });
}
