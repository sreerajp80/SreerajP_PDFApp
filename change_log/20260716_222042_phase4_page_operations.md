# Change Log — Phase 4: Page Operations (copy-on-write)

**Date:** 2026-07-16
**Implements:** `plans/20260716_222042_phase4_page_operations.md`

This change adds Phase 4: page operations. Every operation writes a **new file**; the
original PDF is only ever read (copy-on-write). Nothing was changed in the app database and no
new method channel was added — the work reuses the existing `pdfbox` and `open` channels.

---

## What was added

Six operations, reachable from the viewer menu → **Page tools**:

1. **Merge** — pick several PDFs (multi-select system picker) and join them into one new PDF.
2. **Split** — break one PDF into one file per page.
3. **Organize** — a full-screen editor to reorder (drag), rotate, and delete pages, then save
   a new PDF. One native call (`organizePages`) covers all three.
4. **Compress** — best-effort size reduction (drops optional metadata, re-saves with compressed
   object streams). Clearly labelled as best-effort in the UI.
5. **Protect (encrypt)** — write a password-protected copy (AES-256).
6. **Unlock (decrypt)** — write an unprotected copy using the current password.

Single-file outputs offer **Save** (Android `ACTION_CREATE_DOCUMENT`, user picks the location)
and **Share**. Split (many files) offers **Share**.

---

## Files changed

### Android native
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt` — new background-thread ops:
  `mergePdfs`, `splitPdf`, `organizePages`, `compressPdf`, `encryptPdf`, `decryptPdf`, plus their
  `when` cases. All catch `InvalidPasswordException` → `password_required`, other errors → typed
  failure, and guard `OutOfMemoryError` (never crash on bad input).
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` — added `pickPdfs`
  (multi-select picker for merge) and `saveToDevice` (`ACTION_CREATE_DOCUMENT`), each with its own
  pending-result slot and request code, handled in `onActivityResult`.

### Core platform (Dart)
- `lib/core/platform/pdfbox_channel.dart` — typed wrappers for the six ops, reusing `_mapException`.
- `lib/core/platform/open_document_channel.dart` — `pickPdfs` and `saveToDevice`.

### Feature `lib/features/page_ops/`
- `data/page_ops_service.dart` — service + `pageOpsServiceProvider`; manages the `page_ops/`
  cache output dir and builds output filenames.
- `presentation/page_ops_sheet.dart` — the Page tools bottom sheet + merge/split/compress flows.
- `presentation/widgets/organize_pages_screen.dart` — reorder/rotate/delete editor.
- `presentation/widgets/protect_dialog.dart` — user + optional owner password.
- `presentation/widgets/unlock_dialog.dart` — current password.
- `presentation/widgets/page_ops_result_dialog.dart` — shared Save/Share result dialog.

### Viewer + l10n
- `lib/features/viewer/presentation/viewer_screen.dart` — new `_ViewerMenu.pageOps` entry opening
  the Page tools sheet.
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb` — new strings (regenerated localizations).

### Tests
- `test/features/page_ops/page_ops_service_test.dart` — new (9 tests).
- `test/core/platform/pdfbox_channel_test.dart` — added the Phase 4 channel cases.

---

## Safety / rules

- **Copy-on-write:** every op reads the source and writes a separate output file.
- **Passwords (§11):** held in memory for the single call only; never logged, never stored, never
  in SharedPreferences.
- **Never crash:** corrupt / locked / empty inputs return typed errors mapped to friendly UI.
- **Scoped storage:** merge input via the system picker; output saved only where the user points
  the create-document/share dialog. No broad storage permission.

---

## Verification

- `flutter analyze` — clean (no issues).
- `dart format` — clean.
- `flutter test` — all 186 tests pass (27 in the page-ops + channel suites).
- `flutter build apk --flavor dev --debug` — builds (Kotlin compiles).
- Manual on-device verification of the six flows and copy-on-write integrity is still to be done
  on a physical device.

---

## Follow-ups (out of scope)

- Custom-range split (only per-page split now).
- Saving many split files each to a chosen folder via `ACTION_OPEN_DOCUMENT_TREE` (split uses Share).
- Stronger compression via image down-sampling (best-effort re-save only).
