import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/search/search_normalizer.dart';
import 'package:pdfapp/features/reading/data/pdf_text_source.dart';
import 'package:pdfapp/features/reading/domain/search_hit.dart';

/// Searches a document page by page and reports matches as they are found.
///
/// Results stream out rather than arriving all at once, so a reader can jump to
/// the first match on page 2 without waiting for page 200.
///
/// **Why this is not on a background isolate.** The rule is to keep heavy work
/// off the UI isolate, and the matching itself is pure Dart that could move.
/// But the page text has to come from pdfium through the document handle, which
/// cannot be sent to an isolate, and `compute` starts a fresh isolate per call —
/// hundreds of them for a long document. pdfium already does its own work off
/// the UI thread, and folding one page's text is small next to that, so the
/// search yields between pages instead. If a very long document ever janks,
/// batch several pages into one `compute` call rather than one call per page.
class PdfSearchEngine {
  PdfSearchEngine({required this.source, SearchOptions? options})
    : _normalizer = SearchNormalizer(options ?? SearchOptions.normal);

  final PageTextSource source;
  final SearchNormalizer _normalizer;

  /// Finds [query] through the whole document, from [startPage] onwards and
  /// then wrapping around to the pages before it.
  ///
  /// Starting at the page the reader is on means the first result is usually
  /// the one in front of them. Matches for a blank query are never reported.
  ///
  /// Stops at [AppConstants.searchMatchLimit] so a one-letter query on a huge
  /// document cannot fill memory.
  Stream<SearchHit> search(String query, {int startPage = 1}) async* {
    final key = _normalizer.queryKey(query);
    // A query of only joiners or spaces folds away to nothing — that is not a
    // search, and it would otherwise match every position on every page.
    if (key.trim().isEmpty) return;

    var found = 0;
    for (final pageNumber in _pageOrder(startPage)) {
      final page = await source.page(pageNumber);
      if (page.isEmpty) continue;

      final matches = _normalizer.normalize(page.text).findAll(key);
      for (final match in matches) {
        yield SearchHit(
          pageNumber: pageNumber,
          sourceStart: match.sourceStart,
          sourceEnd: match.sourceEnd,
          rects: page.rectsForRange(match.sourceStart, match.sourceEnd),
        );
        if (++found >= AppConstants.searchMatchLimit) return;
      }
    }
  }

  /// Every page once, starting at [startPage] and wrapping around.
  Iterable<int> _pageOrder(int startPage) sync* {
    final count = source.pageCount;
    if (count <= 0) return;

    final first = startPage.clamp(1, count);
    for (var i = 0; i < count; i++) {
      yield ((first - 1 + i) % count) + 1;
    }
  }
}
