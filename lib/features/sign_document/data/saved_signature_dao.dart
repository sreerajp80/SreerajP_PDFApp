import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:sqflite/sqflite.dart';

/// Reads and writes the `saved_signatures` table (schema v5).
class SavedSignatureDao {
  SavedSignatureDao(this._db);

  final DatabaseExecutor _db;

  /// Every saved signature, newest first.
  Future<List<SavedSignature>> all() async {
    final rows = await _db.query(
      AppConstants.tableSavedSignatures,
      orderBy: 'created_at DESC, id DESC',
    );
    return rows.map(SavedSignature.fromRow).toList();
  }

  /// Inserts a new signature and returns its row id.
  Future<int> insert(SavedSignature signature) =>
      _db.insert(AppConstants.tableSavedSignatures, signature.toRow());

  Future<void> deleteById(int id) async {
    await _db.delete(
      AppConstants.tableSavedSignatures,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
