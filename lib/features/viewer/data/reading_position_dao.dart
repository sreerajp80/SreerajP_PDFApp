import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/viewer/domain/reading_position.dart';
import 'package:sqflite/sqflite.dart';

/// Reads and writes the `reading_positions` table (schema v2).
class ReadingPositionDao {
  ReadingPositionDao(this._db);

  final DatabaseExecutor _db;

  /// The saved position for a file, or null if it was never opened before.
  Future<ReadingPosition?> byFingerprint(String fingerprint) async {
    final rows = await _db.query(
      AppConstants.tableReadingPositions,
      where: 'fingerprint = ?',
      whereArgs: [fingerprint],
      limit: 1,
    );
    return rows.isEmpty ? null : ReadingPosition.fromRow(rows.first);
  }

  /// Inserts or updates the last-read page and view mode for a file.
  ///
  /// Requires the matching `recent_files` row to exist first (FK).
  Future<void> save(ReadingPosition position) async {
    await _db.insert(
      AppConstants.tableReadingPositions,
      position.toRow(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
