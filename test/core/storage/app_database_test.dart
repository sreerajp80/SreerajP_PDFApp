import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  AppDatabase newDb() =>
      AppDatabase(factory: databaseFactoryFfi, path: inMemoryDatabasePath);

  test('opens, applies WAL + foreign keys, and migrates to current', () async {
    final appDb = newDb();
    final db = await appDb.open();

    final fk = await db.rawQuery('PRAGMA foreign_keys;');
    expect(fk.first.values.first, 1);

    // v1 base table exists and is seeded.
    final rows = await db.query(
      'meta',
      where: 'key = ?',
      whereArgs: ['schema_created_version'],
    );
    expect(rows, hasLength(1));
    expect(rows.first['value'], '1');

    expect(await db.getVersion(), AppConstants.databaseVersion);

    await appDb.close();
  });

  test('database getter throws before open', () {
    final appDb = newDb();
    expect(() => appDb.database, throwsStateError);
  });

  test('open is idempotent', () async {
    final appDb = newDb();
    final a = await appDb.open();
    final b = await appDb.open();
    expect(identical(a, b), isTrue);
    await appDb.close();
  });
}
