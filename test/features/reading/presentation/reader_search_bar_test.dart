import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/search/search_normalizer.dart';
import 'package:pdfapp/features/reading/domain/search_hit.dart';
import 'package:pdfapp/features/reading/presentation/widgets/reader_search_bar.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

SearchHit hit(int page) =>
    SearchHit(pageNumber: page, sourceStart: 0, sourceEnd: 1, rects: const []);

void main() {
  Future<void> pumpBar(
    WidgetTester tester,
    SearchState state, {
    SearchOptions options = SearchOptions.normal,
    ValueChanged<String>? onQueryChanged,
    VoidCallback? onNext,
    VoidCallback? onPrevious,
    VoidCallback? onClose,
    ValueChanged<SearchOptions>? onOptionsChanged,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          appBar: AppBar(
            title: ReaderSearchBar(
              state: state,
              options: options,
              onQueryChanged: onQueryChanged ?? (_) {},
              onNext: onNext ?? () {},
              onPrevious: onPrevious ?? () {},
              onClose: onClose ?? () {},
              onOptionsChanged: onOptionsChanged ?? (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('match counter', () {
    testWidgets('shows which match of how many', (tester) async {
      await pumpBar(
        tester,
        SearchState(
          query: 'cat',
          hits: [hit(1), hit(2), hit(3)],
          currentIndex: 1,
          finished: true,
        ),
      );

      expect(find.text('2 of 3'), findsOneWidget);
    });

    testWidgets('says it is searching while results are still coming', (
      tester,
    ) async {
      await pumpBar(tester, const SearchState(query: 'cat', running: true));

      expect(find.text('Searching…'), findsOneWidget);
      expect(find.text('No matches'), findsNothing);
    });

    testWidgets('only says "no matches" once the search has finished', (
      tester,
    ) async {
      // Saying it while the search is still running would be a lie that flashes
      // up on every long document.
      await pumpBar(tester, const SearchState(query: 'cat', finished: true));

      expect(find.text('No matches'), findsOneWidget);
    });

    testWidgets('shows no counter before anything is typed', (tester) async {
      await pumpBar(tester, const SearchState());

      expect(find.text('No matches'), findsNothing);
      expect(find.text('Searching…'), findsNothing);
    });
  });

  group('stepping between matches', () {
    testWidgets('next and previous are disabled when there are no results', (
      tester,
    ) async {
      await pumpBar(tester, const SearchState(query: 'cat', finished: true));

      final next = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.keyboard_arrow_down),
      );
      final previous = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.keyboard_arrow_up),
      );

      expect(next.onPressed, isNull);
      expect(previous.onPressed, isNull);
    });

    testWidgets('next and previous work when there are results', (
      tester,
    ) async {
      var nexts = 0;
      var previouses = 0;
      await pumpBar(
        tester,
        SearchState(query: 'cat', hits: [hit(1), hit(2)], currentIndex: 0),
        onNext: () => nexts++,
        onPrevious: () => previouses++,
      );

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.tap(find.byIcon(Icons.keyboard_arrow_up));

      expect(nexts, 1);
      expect(previouses, 1);
    });
  });

  group('typing', () {
    testWidgets('waits for a pause before searching', (tester) async {
      final queries = <String>[];
      await pumpBar(tester, const SearchState(), onQueryChanged: queries.add);

      await tester.enterText(find.byType(TextField), 'ca');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextField), 'cat');

      // Still typing — a long document must not be searched per keystroke.
      expect(queries, isEmpty);

      await tester.pump(const Duration(milliseconds: 350));
      expect(queries, ['cat']);
    });

    testWidgets('searches at once when the reader presses enter', (
      tester,
    ) async {
      final queries = <String>[];
      await pumpBar(tester, const SearchState(), onQueryChanged: queries.add);

      await tester.enterText(find.byType(TextField), 'cat');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(queries, ['cat']);
    });
  });

  group('closing', () {
    testWidgets('the back button closes search', (tester) async {
      var closed = 0;
      await pumpBar(tester, const SearchState(), onClose: () => closed++);

      await tester.tap(find.byIcon(Icons.arrow_back));

      expect(closed, 1);
    });
  });

  group('search options', () {
    testWidgets('turning on exact spelling reports the new options', (
      tester,
    ) async {
      SearchOptions? chosen;
      await pumpBar(
        tester,
        const SearchState(),
        onOptionsChanged: (o) => chosen = o,
      );

      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Exact spelling'));
      await tester.pumpAndSettle();

      expect(chosen?.strict, isTrue);
      expect(chosen?.ignoreAccents, isFalse);
    });

    testWidgets('toggling sandhi compound option reports the new options', (
      tester,
    ) async {
      SearchOptions? chosen;
      await pumpBar(
        tester,
        const SearchState(),
        onOptionsChanged: (o) => chosen = o,
      );

      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('Sandhi compound search'),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(chosen?.sandhi, isFalse);
    });

    testWidgets('toggling phonetic option reports the new options', (
      tester,
    ) async {
      SearchOptions? chosen;
      await pumpBar(
        tester,
        const SearchState(),
        onOptionsChanged: (o) => chosen = o,
      );

      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Phonetic matching'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(chosen?.phonetic, isFalse);
    });
  });
}
