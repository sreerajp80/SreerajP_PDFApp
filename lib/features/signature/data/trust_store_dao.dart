import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';
import 'package:sqflite/sqflite.dart';

/// Reads and writes the `trust_store` table (schema v4).
///
/// Every row here is the user saying "I trust this signer". Nothing may write to
/// this table without the user's explicit confirmation — that is the whole
/// integrity story of Phase 7, and it is enforced by the callers (the trust
/// dialog), not by this class.
class TrustStoreDao {
  TrustStoreDao(this._db);

  final DatabaseExecutor _db;

  /// Every trusted certificate, newest first (how the manage screen lists them).
  Future<List<CertificateInfo>> all() async {
    final rows = await _db.query(
      AppConstants.tableTrustStore,
      orderBy: 'added_at DESC',
    );
    return rows.map(CertificateInfo.fromRow).toList();
  }

  /// The base64 DER of every trusted certificate — what the native verifier
  /// wants as its trust anchors.
  Future<List<String>> allDer() async {
    final rows = await _db.query(
      AppConstants.tableTrustStore,
      columns: ['der'],
      orderBy: 'added_at DESC',
    );
    return [for (final row in rows) row['der'] as String];
  }

  Future<bool> contains(String sha256) async {
    final rows = await _db.query(
      AppConstants.tableTrustStore,
      columns: ['sha256'],
      where: 'sha256 = ?',
      whereArgs: [sha256],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  /// Adds [certificate] to the trust store.
  ///
  /// Trusting the same certificate twice replaces the row rather than failing:
  /// the user's intent is the same either way, and an error would be noise.
  Future<void> add(CertificateInfo certificate, {DateTime? addedAt}) async {
    await _db.insert(
      AppConstants.tableTrustStore,
      certificate.toRow(addedAt: addedAt ?? DateTime.now()),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Removes a certificate from the trust store — the user withdrawing trust.
  Future<void> remove(String sha256) async {
    await _db.delete(
      AppConstants.tableTrustStore,
      where: 'sha256 = ?',
      whereArgs: [sha256],
    );
  }
}
