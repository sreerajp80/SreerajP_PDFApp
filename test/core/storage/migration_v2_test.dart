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

  test('fresh create builds v2 tables', () async {
    final appDb = AppDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    final db = await appDb.open();

    final names = await tableNames(db);
    expect(names, contains(AppConstants.tableRecentFiles));
    expect(names, contains(AppConstants.tableReadingPositions));
    // A fresh database is created at the current schema version, which the v2
    // tables are part of.
    expect(await db.getVersion(), AppConstants.databaseVersion);

    await appDb.close();
  });

  test('upgrade path v1 -> v2 adds the new tables', () async {
    // Open at v1 only, using just the v1 migration.
    final db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON;');
        },
        onCreate: (db, version) => migrations[1]!(db),
      ),
    );
    var names = await tableNames(db);
    expect(names, isNot(contains(AppConstants.tableRecentFiles)));

    // Apply the v2 migration by hand (what _onUpgrade would run).
    await migrations[2]!(db);

    names = await tableNames(db);
    expect(names, contains(AppConstants.tableRecentFiles));
    expect(names, contains(AppConstants.tableReadingPositions));

    await db.close();
  });

  test('reading_positions cascades when its recent_file is removed', () async {
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
    await db.insert(AppConstants.tableReadingPositions, {
      'fingerprint': 'fp1',
      'last_page': 3,
      'view_mode': 'single',
      'updated_at': 1,
    });

    await db.delete(
      AppConstants.tableRecentFiles,
      where: 'fingerprint = ?',
      whereArgs: ['fp1'],
    );

    final positions = await db.query(AppConstants.tableReadingPositions);
    expect(positions, isEmpty);

    await appDb.close();
  });
}
