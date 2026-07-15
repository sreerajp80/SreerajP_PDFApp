import 'package:pdfrx/pdfrx.dart';

/// One match, ready to draw.
///
/// Positions are in the *original* page text, so the surrounding words can be
/// quoted back to the reader exactly as the PDF spells them.
class SearchHit {
  const SearchHit({
    required this.pageNumber,
    required this.sourceStart,
    required this.sourceEnd,
    required this.rects,
  });

  final int pageNumber;

  /// Range in the page's original text.
  final int sourceStart;
  final int sourceEnd;

  /// Where to draw, in PDF page coordinates — one box per line the match spans.
  final List<PdfRect> rects;
}

/// What the search is doing right now.
class SearchState {
  const SearchState({
    this.query = '',
    this.hits = const [],
    this.currentIndex = -1,
    this.running = false,
    this.finished = false,
    this.limitReached = false,
  });

  /// What the reader typed, unchanged.
  final String query;

  /// Matches found so far, in page order. Grows while the search runs.
  final List<SearchHit> hits;

  /// Which hit is highlighted as "current", or -1 when there is none.
  final int currentIndex;

  /// True while pages are still being looked at.
  final bool running;

  /// True once every page has been looked at.
  final bool finished;

  /// True when the search stopped early at the match limit.
  final bool limitReached;

  bool get hasQuery => query.trim().isNotEmpty;

  /// True only once the whole document has been searched and nothing was found
  /// — so the UI never says "no matches" while it is still looking.
  bool get isEmptyResult => hasQuery && finished && hits.isEmpty;

  SearchHit? get current => currentIndex >= 0 && currentIndex < hits.length
      ? hits[currentIndex]
      : null;

  SearchState copyWith({
    String? query,
    List<SearchHit>? hits,
    int? currentIndex,
    bool? running,
    bool? finished,
    bool? limitReached,
  }) => SearchState(
    query: query ?? this.query,
    hits: hits ?? this.hits,
    currentIndex: currentIndex ?? this.currentIndex,
    running: running ?? this.running,
    finished: finished ?? this.finished,
    limitReached: limitReached ?? this.limitReached,
  );
}
