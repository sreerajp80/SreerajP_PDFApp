import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pdfapp/core/search/search_normalizer.dart';
import 'package:pdfapp/features/reading/data/pdf_search_engine.dart';
import 'package:pdfapp/features/reading/data/pdf_text_source.dart';
import 'package:pdfapp/features/reading/domain/search_hit.dart';

/// Drives find-in-document for one open PDF.
///
/// Owned by the reader screen and thrown away with it. It is deliberately not a
/// global provider: it is bound to one open document handle, and a leftover
/// controller pointing at a closed document would be a bug waiting to happen.
/// (Riverpod still owns the app-wide state — settings, TTS, recents.)
///
/// Results arrive page by page, so [state] changes many times during one
/// search and the reader can jump to an early match while the rest is still
/// being looked at.
class PdfSearchController extends ChangeNotifier {
  PdfSearchController({required this.source});

  final PageTextSource source;

  SearchState _state = const SearchState();
  SearchState get state => _state;

  SearchOptions _options = SearchOptions.normal;
  SearchOptions get options => _options;

  // Cancelled by _stop(), which both search() and dispose() go through.
  // ignore: cancel_subscriptions
  StreamSubscription<SearchHit>? _run;

  /// Starts a search for [query], replacing any search already running.
  ///
  /// [startPage] is the page the reader is on, so the first match found is
  /// usually the one nearest them.
  Future<void> search(String query, {int startPage = 1}) async {
    await _stop();

    if (query.trim().isEmpty) {
      _set(const SearchState());
      return;
    }

    // A fresh state, so the old results and any "no matches" answer are gone
    // while the new search runs.
    _set(SearchState(query: query, running: true));

    final engine = PdfSearchEngine(source: source, options: _options);
    final hits = <SearchHit>[];

    _run = engine
        .search(query, startPage: startPage)
        .listen(
          (hit) {
            hits.add(hit);
            _set(
              _state.copyWith(
                hits: List.unmodifiable(hits),
                // Select the first match as soon as it turns up.
                currentIndex: _state.currentIndex < 0 ? 0 : _state.currentIndex,
              ),
            );
          },
          onDone: () => _set(_state.copyWith(running: false, finished: true)),
          onError: (Object _) {
            // A page that will not give up its text must not break the search.
            _set(_state.copyWith(running: false, finished: true));
          },
          cancelOnError: false,
        );
  }

  /// Moves to the next match, wrapping around at the end.
  void next() => _moveBy(1);

  /// Moves to the previous match, wrapping around at the start.
  void previous() => _moveBy(-1);

  void _moveBy(int step) {
    final count = _state.hits.length;
    if (count == 0) return;
    final at = (_state.currentIndex + step) % count;
    _set(_state.copyWith(currentIndex: at < 0 ? at + count : at));
  }

  /// Changes how text is compared (strict / accent-insensitive) and runs the
  /// current query again, because the old results were found under the old rules.
  Future<void> setOptions(SearchOptions options, {int startPage = 1}) async {
    if (options == _options) {
      return;
    }
    _options = options;
    if (_state.hasQuery) {
      await search(_state.query, startPage: startPage);
    }
  }

  /// Clears the query and every result.
  Future<void> clear() async {
    await _stop();
    _set(const SearchState());
  }

  Future<void> _stop() async {
    final run = _run;
    _run = null;
    await run?.cancel();
  }

  void _set(SearchState state) {
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    // Cancel first: a search still running would call back into a dead object.
    unawaited(_stop());
    super.dispose();
  }
}
