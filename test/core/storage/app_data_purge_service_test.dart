import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/storage/app_data_purge_service.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(sqfliteFfiInit);

  late AppDatabase appDb;
  late SharedPreferences prefs;
  late int releaseCalls;

  setUp(() async {
    appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await appDb.open();
    SharedPreferences.setMockInitialValues({
      'app_language': 'ml',
      'theme': 'dark',
    });
    prefs = await SharedPreferences.getInstance();
    releaseCalls = 0;
  });

  tearDown(() => appDb.close());

  AppDataPurgeService service() => AppDataPurgeService(
    database: appDb,
    prefs: prefs,
    releaseFileAccess: () async => releaseCalls++,
  );

  Future<void> seed() async {
    final db = appDb.database;
    await db.insert('recent_files', {
      'fingerprint': 'f1',
      'uri': 'content://x',
      'display_name': 'a.pdf',
      'size_bytes': 10,
      'last_opened_at': 1,
    });
    await db.insert('reading_positions', {
      'fingerprint': 'f1',
      'last_page': 3,
      'updated_at': 1,
    });
    await db.insert('annotations', {
      'fingerprint': 'f1',
      'page': 1,
      'type': 'highlight',
      'payload': '{}',
      'created_at': 1,
      'updated_at': 1,
    });
    await db.insert('trust_store', {
      'sha256': 'abc',
      'subject': 's',
      'issuer': 'i',
      'serial': '1',
      'not_before': 0,
      'not_after': 1,
      'der': 'x',
      'added_at': 1,
    });
  }

  test('deletes every user table, settings and file access', () async {
    await seed();
    await service().deleteAll();

    for (final table in AppDataPurgeService.userTables) {
      final rows = await appDb.database.query(table);
      expect(rows, isEmpty, reason: '$table still has rows');
    }
    expect(prefs.getKeys(), isEmpty);
    expect(releaseCalls, 1);
  });

  test('keeps the schema bookkeeping so the app starts clean', () async {
    await seed();
    await service().deleteAll();
    final meta = await appDb.database.query('meta');
    expect(meta, isNotEmpty);
  });

  test('a database failure is reported as a StorageException', () async {
    await appDb.close();
    expect(service().deleteAll(), throwsA(isA<StorageException>()));
  });
}
