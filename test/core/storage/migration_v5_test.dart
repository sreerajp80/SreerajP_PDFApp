import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/core/storage/migrations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  Future<List<String>> tableNames(DatabaseExecutor db) async {
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table'",
    );
    return [for (final r in rows) r['name'] as String];
  }

  Map<String, Object?> sigRow({String fileName = 'sig_1.png'}) => {
    'file_name': fileName,
    'width_px': 300,
    'height_px': 100,
    'source': 'drawn',
    'created_at': 1,
  };

  test('fresh create builds the v5 saved_signatures table', () async {
    final appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    final db = await appDb.open();

    expect(await tableNames(db), contains(AppConstants.tableSavedSignatures));
    expect(await db.getVersion(), 5);
    expect(AppConstants.databaseVersion, 5);

    await appDb.close();
  });

  test('upgrade v4 -> v5 adds saved_signatures and keeps old data', () async {
    final db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 4,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON;');
        },
        onCreate: (db, version) async {
          for (var v = 1; v <= 4; v++) {
            await migrations[v]!(db);
          }
        },
      ),
    );

    // Seed data that must survive the upgrade (migrations are append-only).
    await db.insert(AppConstants.tableRecentFiles, {
      'fingerprint': 'fp1',
      'uri': 'content://x',
      'display_name': 'a.pdf',
      'size_bytes': 10,
      'last_opened_at': 1,
    });
    await db.insert(AppConstants.tableTrustStore, {
      'sha256': 'abc',
      'subject': 's',
      'issuer': 'i',
      'serial': '1',
      'not_before': 0,
      'not_after': 1,
      'der': 'x',
      'added_at': 1,
    });

    expect(
      await tableNames(db),
      isNot(contains(AppConstants.tableSavedSignatures)),
    );

    await migrations[5]!(db);

    expect(await tableNames(db), contains(AppConstants.tableSavedSignatures));
    expect((await db.query(AppConstants.tableRecentFiles)).length, 1);
    expect((await db.query(AppConstants.tableTrustStore)).length, 1);

    await db.close();
  });

  test('two rows cannot point to the same picture file', () async {
    final appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    final db = await appDb.open();

    await db.insert(AppConstants.tableSavedSignatures, sigRow());
    expect(
      () => db.insert(AppConstants.tableSavedSignatures, sigRow()),
      throwsA(isA<DatabaseException>()),
    );

    await appDb.close();
  });

  test('saved signatures do not depend on recent files', () async {
    // A signature belongs to the user, not to a document: trimming recents
    // must never remove it.
    final appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    final db = await appDb.open();

    await db.insert(AppConstants.tableRecentFiles, {
      'fingerprint': 'fp1',
      'uri': 'content://x',
      'display_name': 'a.pdf',
      'size_bytes': 10,
      'last_opened_at': 1,
    });
    await db.insert(AppConstants.tableSavedSignatures, sigRow());
    await db.delete(AppConstants.tableRecentFiles);

    expect((await db.query(AppConstants.tableSavedSignatures)).length, 1);

    await appDb.close();
  });
}
