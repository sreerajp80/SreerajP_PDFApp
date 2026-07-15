import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/features/viewer/data/reading_position_dao.dart';
import 'package:pdfapp/features/viewer/data/recent_files_dao.dart';
import 'package:pdfapp/features/viewer/domain/reading_position.dart';
import 'package:pdfapp/features/viewer/domain/recent_file.dart';
import 'package:pdfapp/features/viewer/domain/view_mode.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  late AppDatabase appDb;
  late ReadingPositionDao dao;
  late RecentFilesDao recents;

  setUp(() async {
    appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await appDb.open();
    dao = ReadingPositionDao(appDb.database);
    recents = RecentFilesDao(appDb.database);
    // A recent_files row must exist first (foreign key).
    await recents.upsert(
      RecentFile(
        fingerprint: 'fp1',
        uri: 'content://fp1',
        displayName: 'a.pdf',
        sizeBytes: 100,
        lastOpenedAt: DateTime.fromMillisecondsSinceEpoch(1),
      ),
    );
  });

  tearDown(() => appDb.close());

  test('returns null when nothing saved', () async {
    expect(await dao.byFingerprint('fp1'), isNull);
  });

  test('saves and restores page + view mode', () async {
    await dao.save(
      ReadingPosition(
        fingerprint: 'fp1',
        lastPage: 7,
        viewMode: PdfViewMode.book,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
      ),
    );
    final got = await dao.byFingerprint('fp1');
    expect(got!.lastPage, 7);
    expect(got.viewMode, PdfViewMode.book);
  });

  test('save overwrites the previous position', () async {
    await dao.save(
      ReadingPosition(
        fingerprint: 'fp1',
        lastPage: 2,
        viewMode: PdfViewMode.continuous,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(1),
      ),
    );
    await dao.save(
      ReadingPosition(
        fingerprint: 'fp1',
        lastPage: 9,
        viewMode: PdfViewMode.single,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(2),
      ),
    );
    final got = await dao.byFingerprint('fp1');
    expect(got!.lastPage, 9);
    expect(got.viewMode, PdfViewMode.single);
  });
}
