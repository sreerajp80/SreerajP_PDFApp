import 'package:sqflite/sqflite.dart';

/// Append-only, versioned migrations — engineering standard §13.1.
///
/// Never modify a migration that has already shipped. Each entry is atomic
/// (the runner wraps the whole upgrade in a transaction). Feature tables are
/// added in later phases (v2 recents/positions, v3 annotations, v4 trust store).
typedef Migration = Future<void> Function(DatabaseExecutor db);

/// Map of schema version -> migration that brings the DB *to* that version.
const Map<int, Migration> migrations = {1: _v1BaseTables, 2: _v2ViewerTables};

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
