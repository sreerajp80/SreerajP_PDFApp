# Change log — Consolidate the two architecture.md files into one

Implements [plans/20260714_161524_consolidate-architecture-docs.md](../plans/20260714_161524_consolidate-architecture-docs.md).

## What was changed

The project had two `architecture.md` files with overlapping but non-duplicate content:
`doc/architecture.md` (the full technical design blueprint) and `docs/architecture.md` (the
concise engineering-standard architecture record). They collided in the wider effort to move all
`doc/` files into `docs/`. This change merges them into one file.

- **`docs/architecture.md`** — rewritten as the consolidated document. Base is the full design
  blueprint. Folded in the content that only the engineering record had:
  - Intro now also states this is the engineering-standard architecture record
    (`flutter_project_engineering_standard.md §21`) and lists the **applicability profiles in
    force**. It points to `pdf-app-implementation-progress.md` for phase status.
  - New **§9 Initialization sequence (`main()`)** — the detailed startup order.
  - New **§13 Platform / build** — Android only, minSdk 26, Java 17, AGP 8.x, Gradle 8.14,
    Impeller, dev/prod flavors, no `INTERNET` permission.
  - New **§16 Known risks / follow-ups** — release signing in Phase 8, log rotation not yet
    implemented, 16 KB page-size compliance to verify.
  - **§5 UI** and **§8 Database** enriched with the engineering record's concrete detail
    (root-provider overrides, `AppRoute` enum, `AppThemeMode`; `onConfigure` WAL/FK, migration
    map location, and a "current schema = v1, v2–v4 planned" column).
  - **§10 Errors & logging** merged from the design doc plus the record's logging specifics.
  - Sibling-doc links updated to point within the same `docs/` folder (no more `../doc/`).
- **`doc/architecture.md`** — deleted (content merged into `docs/architecture.md`; removal
  avoids the folder-move collision).

## What was NOT changed

- No source code changes.
- Other `doc/` files were not moved (the user is handling the `doc/`→`docs/` move).
- Link paths in `CLAUDE.md` and `README.md` were left as-is, to be fixed as part of the wider
  move rather than in this change.

## Verify

- `docs/architecture.md` read end to end: every unique fact from both originals is present; no
  internal link points at `../doc/`.
- `doc/architecture.md` confirmed deleted.
