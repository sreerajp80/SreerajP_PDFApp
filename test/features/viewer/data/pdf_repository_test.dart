import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/core/storage/fingerprint.dart';
import 'package:pdfapp/features/viewer/data/pdf_repository.dart';
import 'package:pdfapp/features/viewer/data/reading_position_dao.dart';
import 'package:pdfapp/features/viewer/data/recent_files_dao.dart';
import 'package:pdfapp/features/viewer/domain/recent_file.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// A channel with no platform behind it. [lastingUris] are the links that
/// still have access after a restart; [nextPick] is what the picker returns.
class _FakeChannel extends OpenDocumentChannel {
  final Set<String> lastingUris = {};
  OpenedDocument? nextPick;
  String? lastPickInitialUri;

  @override
  Future<bool> hasLastingAccess(String uri) async => lastingUris.contains(uri);

  @override
  Future<OpenedDocument?> pickPdf({String? initialUri}) async {
    lastPickInitialUri = initialUri;
    return nextPick;
  }
}

void main() {
  setUpAll(sqfliteFfiInit);

  late AppDatabase appDb;
  late RecentFilesDao recentDao;
  late _FakeChannel channel;
  late PdfRepository repo;
  late Directory tempDir;
  late String pdfPath;
  late String fingerprint;

  setUp(() async {
    appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await appDb.open();
    recentDao = RecentFilesDao(appDb.database);
    channel = _FakeChannel();
    repo = PdfRepository(
      channel: channel,
      recentFilesDao: recentDao,
      readingPositionDao: ReadingPositionDao(appDb.database),
    );
    tempDir = await Directory.systemTemp.createTemp('pdf_repo_test');
    pdfPath = '${tempDir.path}/doc.pdf';
    await File(pdfPath).writeAsString('%PDF-1.4 test bytes');
    fingerprint = await Fingerprint.ofFile(pdfPath);
  });

  tearDown(() async {
    await appDb.close();
    await tempDir.delete(recursive: true);
  });

  OpenedDocument opened(String uri, {bool lasting = false}) => OpenedDocument(
    uri: uri,
    displayName: 'doc.pdf',
    sizeBytes: 19,
    cachePath: pdfPath,
    hasLastingAccess: lasting,
  );

  Future<void> seedRecent(String uri) => recentDao.upsert(
    RecentFile(
      fingerprint: fingerprint,
      uri: uri,
      displayName: 'doc.pdf',
      sizeBytes: 19,
      lastOpenedAt: DateTime.fromMillisecondsSinceEpoch(1000),
    ),
  );

  test('a new file is stored with its own link', () async {
    await repo.openFromIntent(opened('content://short'));
    final got = await recentDao.byFingerprint(fingerprint);
    expect(got!.uri, 'content://short');
  });

  test('a short link does not replace a link that still works', () async {
    await seedRecent('content://picked');
    channel.lastingUris.add('content://picked');

    await repo.openFromIntent(opened('content://short'));

    final got = await recentDao.byFingerprint(fingerprint);
    expect(got!.uri, 'content://picked');
  });

  test('a short link replaces an old link that no longer works', () async {
    await seedRecent('content://old');

    await repo.openFromIntent(opened('content://short'));

    final got = await recentDao.byFingerprint(fingerprint);
    expect(got!.uri, 'content://short');
  });

  test('a lasting link always replaces the stored link', () async {
    await seedRecent('content://picked');
    channel.lastingUris.add('content://picked');

    await repo.openFromIntent(opened('content://new', lasting: true));

    final got = await recentDao.byFingerprint(fingerprint);
    expect(got!.uri, 'content://new');
  });

  test(
    'relocateRecent starts near the old file and updates the entry',
    () async {
      await seedRecent('content://old');
      final recent = (await recentDao.byFingerprint(fingerprint))!;
      channel.nextPick = opened('content://picked', lasting: true);

      final ref = await repo.relocateRecent(recent);

      expect(channel.lastPickInitialUri, 'content://old');
      expect(ref, isNotNull);
      final list = await recentDao.list();
      expect(list, hasLength(1));
      expect(list.single.uri, 'content://picked');
    },
  );

  test('relocateRecent returns null when the user cancels', () async {
    await seedRecent('content://old');
    final recent = (await recentDao.byFingerprint(fingerprint))!;

    expect(await repo.relocateRecent(recent), isNull);
    final got = await recentDao.byFingerprint(fingerprint);
    expect(got!.uri, 'content://old');
  });
}
