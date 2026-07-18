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

  Future<List<String>> indexNames(DatabaseExecutor db) async {
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'index'",
    );
    return [for (final r in rows) r['name'] as String];
  }

  Map<String, Object?> certRow({String sha256 = 'abc123'}) => {
    'sha256': sha256,
    'subject': 'CN=Jane Doe',
    'issuer': 'CN=Example CA',
    'serial': '01',
    'not_before': 1000,
    'not_after': 2000,
    'der': 'ZGVy',
    'added_at': 1500,
  };

  test('fresh create builds the v4 trust_store table', () async {
    final appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    final db = await appDb.open();

    expect(await tableNames(db), contains(AppConstants.tableTrustStore));
    expect(await indexNames(db), contains('idx_trust_store_added'));
    expect(await db.getVersion(), 4);

    await appDb.close();
  });

  test('upgrade v3 -> v4 adds trust_store and keeps old data', () async {
    final db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 3,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON;');
        },
        onCreate: (db, version) async {
          await migrations[1]!(db);
          await migrations[2]!(db);
          await migrations[3]!(db);
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
    await db.insert(AppConstants.tableAnnotations, {
      'fingerprint': 'fp1',
      'page': 1,
      'type': 'bookmark',
      'color': null,
      'payload': '{"label":""}',
      'created_at': 1,
      'updated_at': 1,
    });

    expect(await tableNames(db), isNot(contains(AppConstants.tableTrustStore)));

    await migrations[4]!(db);

    expect(await tableNames(db), contains(AppConstants.tableTrustStore));
    expect((await db.query(AppConstants.tableRecentFiles)).length, 1);
    expect((await db.query(AppConstants.tableAnnotations)).length, 1);

    await db.close();
  });

  test('trusting the same certificate twice does not duplicate it', () async {
    // sha256 is the primary key, so the same certificate is the same row. The
    // user's intent is identical either way; a second entry would be noise.
    final appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    final db = await appDb.open();

    await db.insert(AppConstants.tableTrustStore, certRow());
    await db.insert(
      AppConstants.tableTrustStore,
      certRow(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    expect((await db.query(AppConstants.tableTrustStore)).length, 1);

    await appDb.close();
  });

  test('the trust store is independent of recent files', () async {
    // No foreign key here on purpose: a trusted certificate is about a signer,
    // not about a document, so trimming recents must never withdraw trust.
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
    await db.insert(AppConstants.tableTrustStore, certRow());

    await db.delete(
      AppConstants.tableRecentFiles,
      where: 'fingerprint = ?',
      whereArgs: ['fp1'],
    );

    expect((await db.query(AppConstants.tableTrustStore)).length, 1);

    await appDb.close();
  });
}
