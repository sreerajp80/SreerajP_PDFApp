import 'package:pdfapp/features/viewer/domain/view_mode.dart';

/// The last place a file was read: page number (1-based) and view mode.
///
/// Keyed to the content fingerprint, so reopening the same file returns here.
class ReadingPosition {
  const ReadingPosition({
    required this.fingerprint,
    required this.lastPage,
    required this.viewMode,
    required this.updatedAt,
  });

  final String fingerprint;
  final int lastPage;
  final PdfViewMode viewMode;
  final DateTime updatedAt;

  factory ReadingPosition.fromRow(Map<String, Object?> row) => ReadingPosition(
    fingerprint: row['fingerprint']! as String,
    lastPage: (row['last_page']! as num).toInt(),
    viewMode: PdfViewMode.fromStorage(row['view_mode'] as String?),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(
      (row['updated_at']! as num).toInt(),
    ),
  );

  Map<String, Object?> toRow() => {
    'fingerprint': fingerprint,
    'last_page': lastPage,
    'view_mode': viewMode.storageValue,
    'updated_at': updatedAt.millisecondsSinceEpoch,
  };
}
