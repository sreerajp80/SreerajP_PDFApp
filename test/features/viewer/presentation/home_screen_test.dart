import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/features/viewer/domain/recent_file.dart';
import 'package:pdfapp/features/viewer/presentation/home_screen.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A channel that never touches the platform, so Home can be tested off-device.
class _FakeOpenDocumentChannel extends OpenDocumentChannel {
  @override
  Future<OpenedDocument?> pickPdf() async => null;

  @override
  Future<OpenedDocument?> initialIntent() async => null;

  @override
  Stream<OpenedDocument> get incoming => const Stream.empty();
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

  Future<void> pumpHome(WidgetTester tester, List<RecentFile> files) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(appDb),
          openDocumentChannelProvider.overrideWithValue(
            _FakeOpenDocumentChannel(),
          ),
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
}
