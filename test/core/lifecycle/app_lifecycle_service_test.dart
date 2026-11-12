import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:pdfapp/core/lifecycle/app_lifecycle_service.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/core/storage/cache_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(sqfliteFfiInit);

  AppDatabase newDb() =>
      AppDatabase(factory: databaseFactoryFfi, path: inMemoryDatabasePath);

  bool isOpen(AppDatabase db) {
    try {
      return db.database.isOpen;
    } on StateError {
      return false;
    }
  }

  // The close and reopen run in the background (fire and forget), so wait for
  // them instead of guessing a delay.
  Future<void> waitUntil(bool Function() done) async {
    for (var i = 0; i < 100 && !done(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }

  test('closes the database on detached and reopens on resume', () async {
    final db = newDb();
    await db.open();
    final service = AppLifecycleService(database: db);

    service.didChangeAppLifecycleState(AppLifecycleState.detached);
    await waitUntil(() => !isOpen(db));
    expect(() => db.database, throwsStateError);

    service.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await waitUntil(() => isOpen(db));
    expect(db.database.isOpen, isTrue);

    await db.close();
  });

  test('a normal resume does not touch an open database', () async {
    final db = newDb();
    final opened = await db.open();
    final service = AppLifecycleService(database: db);

    service.didChangeAppLifecycleState(AppLifecycleState.paused);
    service.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await pumpEventQueue();
    expect(identical(db.database, opened), isTrue);

    await db.close();
  });

  group('CacheService.clearStaleWorkingFiles', () {
    late Directory temp;

    setUp(() => temp = Directory.systemTemp.createTempSync('cache_test'));
    tearDown(() => temp.deleteSync(recursive: true));

    File makeFile(String dir, String name, DateTime modified) {
      final file = File(p.join(temp.path, dir, name))
        ..createSync(recursive: true)
        ..writeAsStringSync('x');
      file.setLastModifiedSync(modified);
      return file;
    }

    test('removes only old files in the app working folders', () async {
      final now = DateTime(2026, 10, 5, 12);
      final old = now.subtract(const Duration(days: 2));
      final fresh = now.subtract(const Duration(hours: 1));

      final oldOpened = makeFile('opened', 'a.pdf', old);
      final oldPageOps = makeFile('page_ops', 'b.pdf', old);
      final freshOpened = makeFile('opened', 'c.pdf', fresh);
      final oldPrinted = makeFile('printer', 'd.pdf', old);
      final oldOther = makeFile('other', 'e.pdf', old);

      final removed = await const CacheService().clearStaleWorkingFiles(
        tempDir: temp,
        now: now,
      );

      expect(removed, 2);
      expect(oldOpened.existsSync(), isFalse);
      expect(oldPageOps.existsSync(), isFalse);
      expect(freshOpened.existsSync(), isTrue);
      // The printer spool holds the user's printed documents — never touched.
      expect(oldPrinted.existsSync(), isTrue);
      expect(oldOther.existsSync(), isTrue);
    });

    test('a missing temp folder is not an error', () async {
      final removed = await const CacheService().clearStaleWorkingFiles(
        tempDir: Directory(p.join(temp.path, 'missing')),
      );
      expect(removed, 0);
    });
  });
}
