import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/annotation/domain/annotation.dart';
import 'package:sqflite/sqflite.dart';

/// Reads and writes the `annotations` table (schema v3).
class AnnotationDao {
  AnnotationDao(this._db);

  final DatabaseExecutor _db;

  /// Every annotation for a file, oldest first (draw order).
  Future<List<Annotation>> byFile(String fingerprint) async {
    final rows = await _db.query(
      AppConstants.tableAnnotations,
      where: 'fingerprint = ?',
      whereArgs: [fingerprint],
      orderBy: 'created_at ASC, id ASC',
    );
    return rows.map(Annotation.fromRow).toList();
  }

  /// Annotations on one page of a file, oldest first.
  Future<List<Annotation>> byPage(String fingerprint, int page) async {
    final rows = await _db.query(
      AppConstants.tableAnnotations,
      where: 'fingerprint = ? AND page = ?',
      whereArgs: [fingerprint, page],
      orderBy: 'created_at ASC, id ASC',
    );
    return rows.map(Annotation.fromRow).toList();
  }

  /// Inserts a new annotation and returns its row id.
  Future<int> insert(Annotation annotation) {
    return _db.insert(AppConstants.tableAnnotations, annotation.toRow());
  }

  /// Updates an existing annotation (must have an id).
  Future<void> update(Annotation annotation) async {
    final id = annotation.id;
    if (id == null) {
      throw ArgumentError('Cannot update an annotation with no id.');
    }
    await _db.update(
      AppConstants.tableAnnotations,
      annotation.toRow(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteById(int id) async {
    await _db.delete(
      AppConstants.tableAnnotations,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Removes every annotation for a file.
  Future<void> deleteAllForFile(String fingerprint) async {
    await _db.delete(
      AppConstants.tableAnnotations,
      where: 'fingerprint = ?',
      whereArgs: [fingerprint],
    );
  }
}
