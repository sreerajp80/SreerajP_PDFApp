import 'package:path/path.dart' as p;
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/storage/migrations.dart';
import 'package:sqflite/sqflite.dart';

/// Opens the app's SQLite database with WAL on and foreign keys on, and runs the
/// versioned migrations — engineering standard §13.
///
/// The connection is opened once and kept for the app lifetime (§9.3).
class AppDatabase {
  AppDatabase({this.factory, String? path})
    : _pathOverride = path;

  final DatabaseFactory? factory;
  final String? _pathOverride;

  Database? _db;

  Database get database {
    final db = _db;
    if (db == null) {
      throw StateError('AppDatabase.open() must be called before use.');
    }
    return db;
  }

  Future<Database> open() async {
    if (_db != null) return _db!;
    try {
      final dbFactory = factory ?? databaseFactory;
      final path =
          _pathOverride ??
          p.join(await dbFactory.getDatabasesPath(), AppConstants.databaseName);

      _db = await dbFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: AppConstants.databaseVersion,
          onConfigure: _onConfigure,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
        ),
      );
      return _db!;
    } catch (e) {
      throw StorageException('Could not open the app database.', cause: e);
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  // Runs on every connection sqflite opens — the only reliable place for these
  // per-connection PRAGMAs (§13.2, §13.4).
  static Future<void> _onConfigure(Database db) async {
    // `foreign_keys = ON` returns no rows, so execute() is fine.
    await db.execute('PRAGMA foreign_keys = ON;');
    // `journal_mode = WAL` returns a result row (the new mode). Android's native
    // sqflite rejects that through execute(); it must go via rawQuery. Desktop
    // FFI is lenient, which is why this only shows up on a real device.
    await db.rawQuery('PRAGMA journal_mode = WAL;');
  }

  static Future<void> _onCreate(Database db, int version) =>
      _runMigrations(db, fromVersion: 0, toVersion: version);

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) =>
      _runMigrations(db, fromVersion: oldVersion, toVersion: newVersion);

  static Future<void> _runMigrations(
    Database db, {
    required int fromVersion,
    required int toVersion,
  }) async {
    await db.transaction((txn) async {
      for (var v = fromVersion + 1; v <= toVersion; v++) {
        final migration = migrations[v];
        if (migration == null) {
          throw StorageException('Missing migration for schema version $v.');
        }
        await migration(txn);
      }
    });
  }
}
