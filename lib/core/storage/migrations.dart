import 'package:sqflite/sqflite.dart';

/// Append-only, versioned migrations — engineering standard §13.1.
///
/// Never modify a migration that has already shipped. Each entry is atomic
/// (the runner wraps the whole upgrade in a transaction). Feature tables are
/// added in later phases (v2 recents/positions, v3 annotations, v4 trust store).
typedef Migration = Future<void> Function(DatabaseExecutor db);

/// Map of schema version -> migration that brings the DB *to* that version.
const Map<int, Migration> migrations = {
  1: _v1BaseTables,
  2: _v2ViewerTables,
  3: _v3AnnotationsTable,
  4: _v4TrustStoreTable,
};

/// v1 — schema baseline. A tiny `meta` table so the DB is never empty and the
/// migration framework is exercised from the first version.
Future<void> _v1BaseTables(DatabaseExecutor db) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS meta (
      key TEXT PRIMARY KEY NOT NULL,
      value TEXT NOT NULL
    );
  ''');
  await db.insert('meta', {
    'key': 'schema_created_version',
    'value': '1',
  }, conflictAlgorithm: ConflictAlgorithm.ignore);
}

/// v2 (Phase 1) — recent files + reading positions.
///
/// A document's identity is its content fingerprint (`size:sha256`), so both
/// tables are keyed to it. `reading_positions` links to `recent_files` and is
/// removed with it (FKs are ON — see `AppDatabase._onConfigure`).
Future<void> _v2ViewerTables(DatabaseExecutor db) async {
  await db.execute('''
    CREATE TABLE recent_files (
      fingerprint    TEXT    PRIMARY KEY NOT NULL,
      uri            TEXT    NOT NULL,
      display_name   TEXT    NOT NULL,
      size_bytes     INTEGER NOT NULL,
      page_count     INTEGER,
      last_opened_at INTEGER NOT NULL
    );
  ''');
  await db.execute('''
    CREATE TABLE reading_positions (
      fingerprint TEXT    PRIMARY KEY NOT NULL,
      last_page   INTEGER NOT NULL,
      view_mode   TEXT,
      updated_at  INTEGER NOT NULL,
      FOREIGN KEY (fingerprint) REFERENCES recent_files (fingerprint)
        ON DELETE CASCADE
    );
  ''');
  // Newest-first listing on Home is the common query.
  await db.execute(
    'CREATE INDEX idx_recent_files_last_opened '
    'ON recent_files (last_opened_at DESC);',
  );
}

/// v3 (Phase 5) — overlay annotations.
///
/// One table holds every mark type (highlight, underline, strikethrough, note,
/// ink, bookmark). The shape-specific data lives in the JSON `payload` column.
/// Positions are stored normalized (0.0–1.0 of page width/height, top-left
/// origin) so they redraw correctly at any zoom.
///
/// Unlike `reading_positions`, this table has **no** foreign key to
/// `recent_files`: annotations must survive even when a file is trimmed from the
/// recents list. They are re-attached by fingerprint the next time the file
/// opens.
Future<void> _v3AnnotationsTable(DatabaseExecutor db) async {
  await db.execute('''
    CREATE TABLE annotations (
      id          INTEGER PRIMARY KEY AUTOINCREMENT,
      fingerprint TEXT    NOT NULL,
      page        INTEGER NOT NULL,
      type        TEXT    NOT NULL,
      color       INTEGER,
      payload     TEXT    NOT NULL,
      created_at  INTEGER NOT NULL,
      updated_at  INTEGER NOT NULL
    );
  ''');
  // Redrawing a page loads its marks by (file, page).
  await db.execute(
    'CREATE INDEX idx_annotations_file_page '
    'ON annotations (fingerprint, page);',
  );
}

/// v4 (Phase 7) — the signature trust store.
///
/// Holds the signing certificates the **user** chose to trust. Certificates are
/// public material, not secrets, so plain sqflite is the right home for them
/// (`flutter_secure_storage` is for secret material — see plan §11).
///
/// What matters here is *integrity*, not confidentiality: a row in this table is
/// a statement that the user trusts this certificate, so nothing may add one
/// without the user's explicit confirmation.
///
/// `sha256` (of the DER bytes) is the primary key, so trusting the same
/// certificate twice is a no-op rather than a duplicate. `der` keeps the full
/// certificate, since the native verifier needs the real bytes, not a summary.
Future<void> _v4TrustStoreTable(DatabaseExecutor db) async {
  await db.execute('''
    CREATE TABLE trust_store (
      sha256     TEXT    PRIMARY KEY NOT NULL,
      subject    TEXT    NOT NULL,
      issuer     TEXT    NOT NULL,
      serial     TEXT    NOT NULL,
      not_before INTEGER NOT NULL,
      not_after  INTEGER NOT NULL,
      der        TEXT    NOT NULL,
      added_at   INTEGER NOT NULL
    );
  ''');
  // The manage-certificates screen lists newest first.
  await db.execute(
    'CREATE INDEX idx_trust_store_added ON trust_store (added_at DESC);',
  );
}
