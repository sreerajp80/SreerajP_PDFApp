import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/features/viewer/domain/recent_file.dart';
import 'package:pdfapp/features/viewer/presentation/home_screen.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../helpers/tooltip_checks.dart';

/// A channel that never touches the platform, so Home can be tested off-device.
class _FakeOpenDocumentChannel extends OpenDocumentChannel {
  /// The start-location hint passed to the last picker call, if any.
  String? lastPickInitialUri;
  int pickCount = 0;

  /// What [checkAvailable] answers, by URI. Empty means "unknown" for all.
  Map<String, bool> reachable = {};

  @override
  Future<Map<String, bool>> checkAvailable(List<String> uris) async => {
    for (final u in uris)
      if (reachable.containsKey(u)) u: reachable[u]!,
  };

  @override
  Future<OpenedDocument?> pickPdf({String? initialUri}) async {
    pickCount++;
    lastPickInitialUri = initialUri;
    return null;
  }

  @override
  Future<IncomingContent?> initialIntent() async => null;

  @override
  Stream<IncomingContent> get incoming => const Stream.empty();

  @override
  Future<OpenedDocument> resolveToCache(String uri) async {
    throw const StorageException('This file could not be reopened.');
  }
}

/// A recents notifier backed by an in-memory list, so the widget test does no
/// real database I/O (real ffi async does not mix with testWidgets' fake clock).
class _FakeRecentFilesNotifier extends RecentFilesNotifier {
  _FakeRecentFilesNotifier(this._files);

  final List<RecentFile> _files;

  @override
  Future<List<RecentFile>> build() async => List.of(_files);

  @override
  Future<void> refresh() async => state = AsyncData(List.of(_files));

  @override
  Future<void> remove(String fingerprint) async {
    _files.removeWhere((f) => f.fingerprint == fingerprint);
    state = AsyncData(List.of(_files));
  }
}

void main() {
  setUpAll(sqfliteFfiInit);

  late AppDatabase appDb;

  setUp(() async {
    // Needed only so pdfRepositoryProvider can build its DAOs; never queried.
    appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await appDb.open();
  });

  tearDown(() => appDb.close());

  RecentFile recent({int? pageCount}) => RecentFile(
    fingerprint: 'fp1',
    uri: 'content://fp1',
    displayName: 'report.pdf',
    sizeBytes: 100,
    pageCount: pageCount,
    lastOpenedAt: DateTime.fromMillisecondsSinceEpoch(1000),
  );

  late _FakeOpenDocumentChannel channel;

  Future<void> pumpHome(
    WidgetTester tester,
    List<RecentFile> files, {
    Map<String, bool> reachable = const {},
  }) async {
    channel = _FakeOpenDocumentChannel()..reachable = reachable;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(appDb),
          openDocumentChannelProvider.overrideWithValue(channel),
          recentFilesProvider.overrideWith(
            () => _FakeRecentFilesNotifier(files),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expectAllIconButtonsHaveTooltips(tester);
  }

  testWidgets('shows the empty state when there are no recents', (
    tester,
  ) async {
    await pumpHome(tester, []);
    expect(
      find.text('No recent files yet. Tap "Open PDF" to read one.'),
      findsOneWidget,
    );
    expect(find.text('Open PDF'), findsOneWidget);
  });

  testWidgets('lists a recent file with its page count', (tester) async {
    await pumpHome(tester, [recent(pageCount: 12)]);
    expect(find.text('report.pdf'), findsOneWidget);
    expect(find.text('12 pages'), findsOneWidget);
  });

  testWidgets('remove button clears a recent entry', (tester) async {
    await pumpHome(tester, [recent()]);
    expect(find.text('report.pdf'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('report.pdf'), findsNothing);
  });

  Future<void> tapFailingRecent(WidgetTester tester) async {
    await pumpHome(tester, [recent()]);
    await tester.tap(find.text('report.pdf'));
    await tester.pumpAndSettle();
  }

  testWidgets('a recent file that fails to open shows the recovery dialog', (
    tester,
  ) async {
    await tapFailingRecent(tester);

    expect(find.text("Can't reopen file"), findsOneWidget);
    expect(find.text('Find file'), findsOneWidget);
    // The file name appears in the list and in the dialog.
    expect(find.text('report.pdf'), findsNWidgets(2));
  });

  testWidgets('"Find file" opens the picker near the old file', (tester) async {
    await tapFailingRecent(tester);

    await tester.tap(find.text('Find file'));
    await tester.pumpAndSettle();

    expect(find.text("Can't reopen file"), findsNothing);
    expect(channel.pickCount, 1);
    expect(channel.lastPickInitialUri, 'content://fp1');
  });

  testWidgets('"Remove" in the dialog clears the recent entry', (tester) async {
    await tapFailingRecent(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Remove'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('report.pdf'), findsNothing);
  });

  testWidgets('"Cancel" closes the dialog and keeps the entry', (tester) async {
    await tapFailingRecent(tester);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text("Can't reopen file"), findsNothing);
    expect(find.text('report.pdf'), findsOneWidget);
    expect(channel.pickCount, 0);
  });

  RecentFile second() => RecentFile(
    fingerprint: 'fp2',
    uri: 'content://fp2',
    displayName: 'notes.pdf',
    sizeBytes: 200,
    lastOpenedAt: DateTime.fromMillisecondsSinceEpoch(500),
  );

  testWidgets('long-press starts selection; taps add files; close clears it', (
    tester,
  ) async {
    await pumpHome(tester, [recent(), second()]);
    expect(find.text('Open PDF'), findsOneWidget);

    await tester.longPress(find.text('report.pdf'));
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsOneWidget);
    expect(find.byTooltip('Send to nearby phone'), findsOneWidget);
    // While selecting: no Open button, no remove buttons.
    expect(find.text('Open PDF'), findsNothing);
    expect(find.byTooltip('Remove'), findsNothing);
    expectAllIconButtonsHaveTooltips(tester);

    // A tap now selects instead of opening.
    await tester.tap(find.text('notes.pdf'));
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsOneWidget);
    expect(find.text("Can't reopen file"), findsNothing);

    await tester.tap(find.byTooltip('Cancel selection'));
    await tester.pumpAndSettle();
    expect(find.text('2 selected'), findsNothing);
    expect(find.text('Open PDF'), findsOneWidget);
  });

  testWidgets('tapping the only selected file ends selection', (tester) async {
    await pumpHome(tester, [recent()]);
    await tester.longPress(find.text('report.pdf'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('report.pdf'));
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsNothing);
    expect(find.text('Open PDF'), findsOneWidget);
  });

  testWidgets('an unavailable recent file is marked and can be removed', (
    tester,
  ) async {
    await pumpHome(
      tester,
      [recent(pageCount: 12)],
      reachable: {'content://fp1': false},
    );

    expect(find.text('Not available'), findsOneWidget);
    expect(find.text('12 pages'), findsNothing);
    expect(find.byIcon(Icons.report_outlined), findsOneWidget);

    await tester.tap(find.byTooltip('Remove'));
    await tester.pumpAndSettle();
    expect(find.text('report.pdf'), findsNothing);
  });

  testWidgets('tapping an unavailable file still shows the recovery dialog', (
    tester,
  ) async {
    await pumpHome(tester, [recent()], reachable: {'content://fp1': false});
    await tester.tap(find.text('report.pdf'));
    await tester.pumpAndSettle();
    expect(find.text("Can't reopen file"), findsOneWidget);
  });

  testWidgets('a reachable or unknown file looks normal', (tester) async {
    await pumpHome(
      tester,
      [recent(pageCount: 12)],
      reachable: {'content://fp1': true},
    );
    expect(find.text('Not available'), findsNothing);
    expect(find.text('12 pages'), findsOneWidget);
    expect(find.byIcon(Icons.picture_as_pdf_outlined), findsOneWidget);
  });
}
