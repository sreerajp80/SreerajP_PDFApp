import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/core/storage/cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// "Delete all data" — engineering standard §15.4.
///
/// Removes everything the app keeps about the user: database rows (recent
/// files, reading positions, annotations and bookmarks, trusted certificates
/// the user added, saved signatures), private files such as saved signature
/// pictures, saved settings, cached files (including the printer
/// spool), and lasting file permissions. The user's own PDF files are never
/// touched. The schema and its `meta` table stay, so the app starts clean.
class AppDataPurgeService {
  AppDataPurgeService({
    required this._database,
    required this._prefs,
    required this._releaseFileAccess,
    this._cache = const CacheService(),
    this._deletePrivateFiles = const [],
  });

  final AppDatabase _database;
  final SharedPreferences _prefs;
  final Future<void> Function() _releaseFileAccess;
  final CacheService _cache;

  /// Clean-ups for files kept outside the cache (for example the saved
  /// signature pictures). Each is best-effort.
  final List<Future<void> Function()> _deletePrivateFiles;

  /// Tables that hold user data. `meta` is app bookkeeping and is kept.
  static const List<String> userTables = [
    'recent_files',
    'reading_positions',
    'annotations',
    'trust_store',
    'saved_signatures',
  ];

  /// Deletes all user data. Throws [StorageException] if the database part
  /// fails; every other step is best-effort and logs its own failure.
  Future<void> deleteAll() async {
    try {
      await _database.database.transaction((txn) async {
        for (final table in userTables) {
          await txn.delete(table);
        }
      });
    } catch (e) {
      throw StorageException('Could not delete the app data.', cause: e);
    }
    for (final cleanUp in _deletePrivateFiles) {
      try {
        await cleanUp();
      } catch (e) {
        AppLogger.warning('A private-file clean-up failed.', error: e);
      }
    }
    await _releaseFileAccess();
    await _prefs.clear();
    await _cache.clearTempCache();
    AppLogger.info('All app data deleted.');
  }
}
