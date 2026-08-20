import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/viewer/domain/recent_file.dart';
import 'package:sqflite/sqflite.dart';

/// Reads and writes the `recent_files` table (schema v2).
class RecentFilesDao {
  RecentFilesDao(this._db);

  final DatabaseExecutor _db;

  /// Recent files, newest first, capped at [AppConstants.recentFilesLimit].
  Future<List<RecentFile>> list() async {
    final rows = await _db.query(
      AppConstants.tableRecentFiles,
      orderBy: 'last_opened_at DESC',
      limit: AppConstants.recentFilesLimit,
    );
    return rows.map(RecentFile.fromRow).toList();
  }

  Future<RecentFile?> byFingerprint(String fingerprint) async {
    final rows = await _db.query(
      AppConstants.tableRecentFiles,
      where: 'fingerprint = ?',
      whereArgs: [fingerprint],
      limit: 1,
    );
    return rows.isEmpty ? null : RecentFile.fromRow(rows.first);
  }

  /// Inserts or refreshes a recent entry (updates uri, name, size, timestamp).
  Future<void> upsert(RecentFile file) async {
    await _db.insert(
      AppConstants.tableRecentFiles,
      file.toRow(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _trim();
  }

  /// Stores the page count once the document is opened.
  Future<void> setPageCount(String fingerprint, int pageCount) async {
    await _db.update(
      AppConstants.tableRecentFiles,
      {'page_count': pageCount},
      where: 'fingerprint = ?',
      whereArgs: [fingerprint],
    );
  }

  /// Removes an entry. Its reading position is removed too (FK cascade).
  Future<void> remove(String fingerprint) async {
    await _db.delete(
      AppConstants.tableRecentFiles,
      where: 'fingerprint = ?',
      whereArgs: [fingerprint],
    );
  }

  /// Clears all recent files.
  Future<void> clearAll() async {
    await _db.delete(AppConstants.tableRecentFiles);
  }

  // Keeps the table bounded: delete everything past the newest N.
  Future<void> _trim() async {
    await _db.rawDelete(
      '''
      DELETE FROM ${AppConstants.tableRecentFiles}
      WHERE fingerprint NOT IN (
        SELECT fingerprint FROM ${AppConstants.tableRecentFiles}
        ORDER BY last_opened_at DESC
        LIMIT ?
      )
      ''',
      [AppConstants.recentFilesLimit],
    );
  }
}
