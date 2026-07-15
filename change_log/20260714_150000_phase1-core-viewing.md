# Change log — Phase 1: Core viewing & navigation (MVP)

**Date:** 2026-07-14
**Implements:** `plans/20260714_144856_phase1-core-viewing.md`
**Phase:** 1 of the build plan (`doc/pdf-app-implementation-plan.md`)

---

## What was built

The app can now open and read PDFs. A user can open a file from the system picker or
from another app's "Open with" / share, read it, navigate it, zoom, invert for night
reading, and reopen it later at the last-read page from a recent-files list. Broken,
empty, and password-protected files show friendly messages and never crash.

### Opening (scoped storage only)
- New **native SAF bridge** in `MainActivity.kt`: `ACTION_OPEN_DOCUMENT` for the picker,
  with a **persistable URI permission** taken so recents can reopen later. The picked
  content is copied into the app's private cache (pdfium needs random access; the original
  is only ever read).
- **"Open with" / share** intent filters (`ACTION_VIEW`, `ACTION_SEND`, `application/pdf`)
  added to the manifest; the launch intent and while-running shares are delivered to Dart.
- No new permissions; still no `INTERNET` (offline-first).

### Reading & navigation (pdfrx)
- Single-page, continuous, and two-page (book) view modes (custom page layouts).
- Zoom in/out, pinch, **fit-width**, **fit-page**.
- **Table of contents** drawer, **thumbnail grid**, and **jump-to-page**.
- **Night colors** toggle (page-pixel invert) on top of the existing dark/sepia themes.

### Memory
- **Content fingerprint** (`size:sha256`, hashed off the UI isolate) is the file identity.
- **DB migration v2**: `recent_files` + `reading_positions` tables, keyed to the
  fingerprint. Reopening a file restores the last page and view mode.
- Recent-files list on Home (newest first, capped at 30, removable).

### Robustness
- Friendly, no-crash states for **corrupt / truncated / empty / password-protected** files
  (with a password prompt for encrypted PDFs; the password is never logged).
- **Large files** (> 50 MB) open in single-page mode with a one-time warning.

---

## Files added

- `lib/core/storage/fingerprint.dart` — size + SHA-256 identity (isolate-hashed).
- `lib/core/platform/open_document_channel.dart` — Dart side of the SAF/intent bridge.
- `lib/features/viewer/domain/` — `pdf_document_ref.dart`, `recent_file.dart`,
  `reading_position.dart`, `view_mode.dart`.
- `lib/features/viewer/data/` — `recent_files_dao.dart`, `reading_position_dao.dart`,
  `pdf_repository.dart`.
- `lib/features/viewer/presentation/` — `providers.dart`, `viewer_screen.dart`, and
  `widgets/` (`page_layouts.dart`, `viewer_error_view.dart`, `password_prompt.dart`,
  `page_jump_sheet.dart`, `outline_drawer.dart`, `thumbnail_grid.dart`).
- Tests: `test/core/storage/fingerprint_test.dart`,
  `test/core/storage/migration_v2_test.dart`,
  `test/features/viewer/data/recent_files_dao_test.dart`,
  `test/features/viewer/data/reading_position_dao_test.dart`,
  `test/features/viewer/presentation/viewer_error_view_test.dart`,
  `test/features/viewer/presentation/home_screen_test.dart`.

## Files changed

- `pubspec.yaml` — added `pdfrx` (BSD) and `crypto` (BSD).
- `lib/core/constants/app_constants.dart` — `databaseVersion = 2`, new table names,
  open-document channel ids, recents limit.
- `lib/core/storage/migrations.dart` — added the v2 migration.
- `lib/core/errors/app_exception.dart` — `PdfException` is now `base`; added
  `PdfOpenException`, `PdfCorruptException`, `PdfPasswordRequiredException`,
  `PdfEmptyException`.
- `lib/core/storage/app_database.dart` — `_onConfigure` now runs the WAL pragma via
  `rawQuery` (Android sqflite rejects row-returning pragmas through `execute`); found during
  on-device verification.
- `lib/features/viewer/presentation/home_screen.dart` — real Home (open + recents +
  intents), replacing the Phase 0 placeholder.
- `lib/app/routing/app_router.dart` — wired the real `viewer` route.
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb` — all Phase 1 strings (English + Malayalam).
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` — SAF + intent bridge.
- `android/app/src/main/AndroidManifest.xml` — VIEW/SEND intent filters.
- `test/core/storage/app_database_test.dart` — version assertion now uses
  `AppConstants.databaseVersion`.

---

## Verification

- `flutter analyze` — clean (no issues).
- `flutter test` — 38 tests pass (fingerprint, migration v1→v2 + cascade, both DAOs, the
  error view, and the Home screen).
- `dart format` — clean.
- `flutter build apk --flavor dev --debug` — builds (`app-dev-debug.apk`); native
  SAF/intent Kotlin and pdfrx's PDFium download/link step both succeed.

  Note: pdfrx's native build creates a *symbolic link* (`.lib/latest`) during CMake
  configure. On Windows this needs **Developer Mode on** (or an elevated shell); with it
  off the build fails with "A required privilege is not held by the client." Developer Mode
  was enabled and the build then completed. No code change was involved.

- **On-device run (moto g54 5G, Android 15):** installed and launched; the app opens to
  Home. Opening a PDF was verified end to end from logcat — the SAF system picker
  (`documentsui/PickActivity`) launched, the chosen file was copied to
  `cache/opened/…`, and **pdfrx/PDFium loaded and rendered it**
  (`PdfDocument initial load: …/cache/opened/…pdf (234 ms)`), with the viewer drawing and
  responding to touch (~90 fps) and no `StorageException` / `PdfException` / `FATAL`.

### Bug found and fixed on-device (DB open)

The app initially launched to a blank screen on the device: the database failed to open
with `DatabaseException … 'PRAGMA journal_mode = WAL;'`, so `main()` threw before `runApp`.
Cause: on Android's native sqflite, `PRAGMA journal_mode = WAL` **returns a result row** and
must be run with `rawQuery`, not `execute` (desktop FFI — used by the unit tests — is
lenient, which is why every test still passed). Fixed `AppDatabase._onConfigure` in
`lib/core/storage/app_database.dart` to use `rawQuery` for the WAL pragma; `foreign_keys`
stays on `execute` (it returns no rows). Rebuilt and re-verified: DB opens, Home renders,
PDF opens and renders.

## Notes / decisions

- Widget tests avoid real `sqflite_common_ffi` I/O (it does not mix with `testWidgets`'
  fake clock) by overriding `recentFilesProvider` with an in-memory fake notifier and the
  open channel with a fake. Real DB behavior is covered by the plain `test()` DAO and
  migration tests.
- pdfrx also exports a `PdfDocumentRef`; the viewer hides it to keep this app's own
  domain type of that name.
- Not yet run on a physical device/emulator — first on-device pass is part of ongoing
  Phase 1 manual verification.

## Not in this phase (later)

- Text search, copy, metadata, TTS → Phase 2.
- Extraction / conversion / share → Phase 3.
- Encrypt/decrypt and merge/split page ops → Phase 4.
- Real in-PDF annotations / overlay layer → Phase 5.
