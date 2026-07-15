/// One row of the recent-files list on Home.
///
/// Keyed to the content [fingerprint]. [uri] is the persistable identity used to
/// reopen; [pageCount] is null until the file has been opened at least once.
class RecentFile {
  const RecentFile({
    required this.fingerprint,
    required this.uri,
    required this.displayName,
    required this.sizeBytes,
    required this.lastOpenedAt,
    this.pageCount,
  });

  final String fingerprint;
  final String uri;
  final String displayName;
  final int sizeBytes;
  final int? pageCount;
  final DateTime lastOpenedAt;

  factory RecentFile.fromRow(Map<String, Object?> row) => RecentFile(
    fingerprint: row['fingerprint']! as String,
    uri: row['uri']! as String,
    displayName: row['display_name']! as String,
    sizeBytes: (row['size_bytes']! as num).toInt(),
    pageCount: (row['page_count'] as num?)?.toInt(),
    lastOpenedAt: DateTime.fromMillisecondsSinceEpoch(
      (row['last_opened_at']! as num).toInt(),
    ),
  );

  Map<String, Object?> toRow() => {
    'fingerprint': fingerprint,
    'uri': uri,
    'display_name': displayName,
    'size_bytes': sizeBytes,
    'page_count': pageCount,
    'last_opened_at': lastOpenedAt.millisecondsSinceEpoch,
  };
}
