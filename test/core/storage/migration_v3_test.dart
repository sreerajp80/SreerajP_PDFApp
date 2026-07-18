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

  test('fresh create builds the v3 annotations table', () async {
    final appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    final db = await appDb.open();

    final names = await tableNames(db);
    expect(names, contains(AppConstants.tableAnnotations));
    expect(await indexNames(db), contains('idx_annotations_file_page'));
    expect(await db.getVersion(), AppConstants.databaseVersion);

    await appDb.close();
  });

  test('upgrade v2 -> v3 adds annotations and keeps old data', () async {
    // Open at v2, apply v1 + v2 migrations by hand.
    final db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON;');
        },
        onCreate: (db, version) async {
          await migrations[1]!(db);
          await migrations[2]!(db);
        },
      ),
    );

    // Seed a recent file that must survive the upgrade.
    await db.insert(AppConstants.tableRecentFiles, {
      'fingerprint': 'fp1',
      'uri': 'content://x',
      'display_name': 'a.pdf',
      'size_bytes': 10,
      'last_opened_at': 1,
    });

    var names = await tableNames(db);
    expect(names, isNot(contains(AppConstants.tableAnnotations)));

    // Apply the v3 migration (what _onUpgrade would run).
    await migrations[3]!(db);

    names = await tableNames(db);
    expect(names, contains(AppConstants.tableAnnotations));

    // Old data is untouched (append-only migration).
    final recents = await db.query(AppConstants.tableRecentFiles);
    expect(recents.length, 1);

    await db.close();
  });

  test('annotations survive deleting the recent_files row (no FK)', () async {
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
    await db.insert(AppConstants.tableAnnotations, {
      'fingerprint': 'fp1',
      'page': 1,
      'type': 'bookmark',
      'color': null,
      'payload': '{"label":""}',
      'created_at': 1,
      'updated_at': 1,
    });

    // Trimming the recents list must not remove the marks.
    await db.delete(
      AppConstants.tableRecentFiles,
      where: 'fingerprint = ?',
      whereArgs: ['fp1'],
    );

    final marks = await db.query(
      AppConstants.tableAnnotations,
      where: 'fingerprint = ?',
      whereArgs: ['fp1'],
    );
    expect(marks.length, 1);

    await appDb.close();
  });
}
