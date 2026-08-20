import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/search/search_normalizer.dart';
import 'package:pdfapp/features/reading/data/pdf_text_source.dart';
import 'package:pdfapp/features/reading/domain/search_hit.dart';

/// Searches a document page by page and reports matches as they are found.
///
/// Results stream out rather than arriving all at once, so a reader can jump to
/// the first match on page 2 without waiting for page 200.
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
    final candidateKeys = _normalizer.candidateQueryKeys(query);
    // A query of only joiners or spaces folds away to nothing — that is not a
    // search, and it would otherwise match every position on every page.
    if (candidateKeys.isEmpty || candidateKeys.every((k) => k.trim().isEmpty)) {
      return;
    }

    var found = 0;
    for (final pageNumber in _pageOrder(startPage)) {
      final page = await source.page(pageNumber);
      if (page.isEmpty) continue;

      final normalizedPage = _normalizer.normalize(page.text);
      final matches = normalizedPage.findAllKeys(candidateKeys);
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
