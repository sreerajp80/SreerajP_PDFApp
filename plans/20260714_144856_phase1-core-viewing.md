# Phase 1 — Core viewing & navigation (MVP)

**Status:** completed

This plan implements **Phase 1** of `doc/pdf-app-implementation-plan.md`: opening a PDF
and reading it well. It builds on the Phase 0 scaffold. Nothing else in the app matters if
this is weak, so this phase is the real MVP.

---

## 1. What the issue is

After Phase 0 the app only shows an empty Home, Settings, and About. It cannot open or
show a PDF at all. Phase 1 must let a user:

- open a PDF through the **system file picker (SAF)** and through **"Open with" / share**
  intents from other apps,
- **read** it: single page, continuous scroll, and two-page (book) view,
- **zoom**: pinch, buttons, fit-to-width, fit-to-page,
- **navigate**: jump to a page number, use the table of contents (outline), and a
  thumbnail grid,
- **come back** to the last-read page when the same file is reopened,
- read comfortably at night: **dark** and **sepia**, plus a **color-invert** toggle,
- see a **recent files** list on Home and reopen from it,
- handle **large** files and **broken / encrypted** files without crashing.

All of this must obey the hard project rules: open source only, offline, scoped storage
only (SAF + intents, no broad storage permission, no in-app file browser), take
persistable URI permission, never crash on bad input, file identity = content fingerprint
(size + hash).

---

## 2. Key technical decisions (inside the locked stack)

The stack is already locked by the master plan (`pdfrx`, Riverpod, go_router, sqflite).
These are the smaller choices this phase must make, with the reason:

1. **Opening files = native SAF, not `file_picker`.** The phase explicitly requires
   *persistable URI permission* and a recents list that reopens later. `file_picker`
   copies to a cache path and does **not** grant a persistable URI, so recents would break
   after a reboot. We add a small **native method channel** that runs
   `ACTION_OPEN_DOCUMENT` (mime `application/pdf`), calls
   `takePersistableUriPermission`, and returns the `content://` URI + display name + size.
   This keeps us fully inside "scoped storage only".

2. **Rendering source = copy the picked content to a private cache file, then open that
   file with `pdfrx`.** pdfium needs random access; `pdfrx` opens a *file path* or bytes
   cleanly but does **not** open `content://` URIs directly. The native side streams the
   SAF content into the app's private cache (`getCacheDir`) and returns the cache path.
   `pdfrx` opens that path. The original is never touched (copy-on-read; matches
   copy-on-write spirit). Recents store the **persistable URI** (the durable identity),
   not the throwaway cache path, and reopening re-copies from the URI.

3. **"Open with" / share intents** are handled in `MainActivity`: an incoming
   `ACTION_VIEW` or `ACTION_SEND` with a PDF mime is read at launch (and while running)
   and pushed to Dart over the same channel, then copied to cache the same way.

4. **Fingerprint = size + SHA-256 of the file bytes** (streamed, off the UI isolate).
   This is the file identity used to key reading positions and recents, per the master
   plan. A changed file → different hash → treated as a new document.

5. **Password-protected PDFs**: `pdfrx` supports a password callback. Since *reading* an
   encrypted file (with the user typing the password) is still reading, Phase 1 shows a
   friendly password prompt. Wrong password or cancel → a clear, non-crashing error state.
   (Encrypt/decrypt as a *page operation* stays in Phase 4.) The password is held only in
   memory and is **never logged** (security rule).

6. **Dark / sepia / invert for the page**: theme already exists (Phase 0). For the page
   pixels we add a **color-invert toggle** in the viewer using `pdfrx`'s built-in
   `PdfViewerParams` (page-rendering color adjustment) so night reading inverts the page,
   not just the app chrome.

7. **Large-file handling**: if the picked file is larger than
   `AppConstants.largePdfThresholdBytes` (already 50 MB), show a one-time warning and open
   in a **degraded paged view** (single-page mode, thumbnails off by default) instead of
   continuous scroll, to keep memory and jank in budget. The user can still switch view
   modes.

---

## 3. New dependencies (all open source)

Add to `pubspec.yaml`:

- `pdfrx` (BSD) — rendering (locked by the master plan).
- `crypto` (BSD, Dart team) — SHA-256 for the fingerprint.

No `file_picker` (replaced by the native SAF channel). No new native third-party
libraries in this phase — the SAF open + intent handling is plain Android SDK Kotlin.

---

## 4. Database — migration v2

Bump `AppConstants.databaseVersion` from `1` to `2` and add migration `_v2` to the
`migrations` map (append-only; v1 is never touched). New tables:

```sql
CREATE TABLE recent_files (
  fingerprint   TEXT PRIMARY KEY NOT NULL,   -- size + ':' + sha256
  uri           TEXT NOT NULL,               -- persistable content:// URI
  display_name  TEXT NOT NULL,
  size_bytes    INTEGER NOT NULL,
  page_count    INTEGER,                     -- filled once opened, may be null
  last_opened_at INTEGER NOT NULL            -- epoch ms
);

CREATE TABLE reading_positions (
  fingerprint   TEXT PRIMARY KEY NOT NULL,   -- FK-like link to recent_files.fingerprint
  last_page     INTEGER NOT NULL,            -- 1-based
  view_mode     TEXT,                        -- 'single' | 'continuous' | 'book'
  updated_at    INTEGER NOT NULL
);
```

New table-name constants in `AppConstants` (`tableRecentFiles`, `tableReadingPositions`).
An upgrade-path test covers v1 → v2.

---

## 5. Files to change / add

### Dart — core

- `pubspec.yaml` — add `pdfrx`, `crypto`; add any needed assets (none expected).
- `lib/core/constants/app_constants.dart` — `databaseVersion = 2`, new table names,
  method-channel already has `channelPdfBox`; add `channelOpenDocument`
  (`in.sreerajp.pdfapp/open`) and an event/method for incoming intents.
- `lib/core/storage/migrations.dart` — add `_v2` (recents + reading positions).
- `lib/core/storage/fingerprint.dart` — **new.** `Fingerprint.ofFile(path)` → size +
  SHA-256, streamed, runs off the UI isolate.
- `lib/core/errors/app_exception.dart` — add viewer subtypes under `PdfException`:
  `PdfOpenException`, `PdfCorruptException`, `PdfPasswordException`,
  `PdfEmptyException` (each maps to a friendly UI state).
- `lib/core/platform/open_document_channel.dart` — **new.** Dart wrapper over the native
  SAF open (`pickPdf()` → uri/name/size/cachePath), `resolveToCache(uri)` for reopening a
  recent, and a stream of incoming "Open with" documents.

### Dart — feature: viewer

- `lib/features/viewer/domain/pdf_document_ref.dart` — **new.** value type: fingerprint,
  uri, displayName, sizeBytes, cachePath, pageCount.
- `lib/features/viewer/domain/recent_file.dart` — **new.** model + mapping.
- `lib/features/viewer/domain/reading_position.dart` — **new.** model + view-mode enum.
- `lib/features/viewer/domain/view_mode.dart` — **new.** `PdfViewMode { single, continuous, book }`.
- `lib/features/viewer/data/recent_files_dao.dart` — **new.** CRUD on `recent_files`.
- `lib/features/viewer/data/reading_position_dao.dart` — **new.** get/upsert position.
- `lib/features/viewer/data/pdf_repository.dart` — **new.** ties channel + DAOs +
  fingerprint: pick/open/reopen, record recents, save/restore position.
- `lib/features/viewer/presentation/providers.dart` — **new.** Riverpod providers:
  DAOs, repository, recents list, current-document controller, view-mode + invert state.
- `lib/features/viewer/presentation/home_screen.dart` — **replace placeholder.** "Open
  PDF" action + **recent files** list (reopen, remove). Keeps Settings/About actions.
- `lib/features/viewer/presentation/viewer_screen.dart` — **new.** the `pdfrx` viewer with
  app bar controls (view mode, zoom fit, invert, TOC, thumbnails, page jump), last-page
  restore, save position on change/leave, large-file degraded mode, all error states.
- `lib/features/viewer/presentation/widgets/outline_drawer.dart` — **new.** TOC tree.
- `lib/features/viewer/presentation/widgets/thumbnail_grid.dart` — **new.** thumbnail grid,
  tap to jump.
- `lib/features/viewer/presentation/widgets/page_jump_sheet.dart` — **new.** jump-to-page.
- `lib/features/viewer/presentation/widgets/password_prompt.dart` — **new.** password
  dialog for encrypted files.
- `lib/features/viewer/presentation/widgets/viewer_error_view.dart` — **new.** friendly
  error / large-file-warning / empty states.

### Dart — routing & l10n

- `lib/app/routing/app_router.dart` — add the real `viewer` route (already an enum member)
  taking the document ref (via a provider / `extra`).
- `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb` — new strings: open PDF, recents, no
  recents, remove from recents, view modes, fit width/page, zoom in/out, invert colors,
  contents, thumbnails, go to page, page X of Y, password prompt + hint, wrong password,
  and every error/large-file message. (Malayalam values added; if any need a native
  speaker's polish that is noted, never left as a dead/English-only key.)

### Android — native

- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` — method channel for
  `pickPdf` (launch `ACTION_OPEN_DOCUMENT`, `takePersistableUriPermission`, copy to
  cache, return uri/name/size/path), `resolveToCache`, and delivery of incoming
  `ACTION_VIEW` / `ACTION_SEND` PDF intents (initial + `onNewIntent`).
- `android/app/src/main/AndroidManifest.xml` — add intent-filters on `MainActivity` for
  `ACTION_VIEW` (`application/pdf`, file/content schemes) and `ACTION_SEND`
  (`application/pdf`). No new permissions (SAF needs none; still no `INTERNET`).

### Tests — `test/` mirrors `lib/`

- `test/core/storage/fingerprint_test.dart` — size+hash stable, changes when bytes change.
- `test/core/storage/migration_v2_test.dart` — v1 → v2 upgrade path; tables exist; FKs/WAL on.
- `test/features/viewer/data/recent_files_dao_test.dart` — insert/list-ordered/remove/limit.
- `test/features/viewer/data/reading_position_dao_test.dart` — upsert + restore.
- `test/features/viewer/presentation/home_screen_test.dart` — recents render; empty state.
- `test/features/viewer/presentation/viewer_error_view_test.dart` — each error/large state renders.

Native Kotlin is not unit-tested here (no device in CI); it is verified by running the app
(exit check). Widget tests use a fake repository/channel so they run without a device.

---

## 6. How the fix works, end to end

1. User taps **Open PDF** on Home → `open_document_channel.pickPdf()` → native SAF picker →
   returns uri + name + size + cache path (persistable permission taken).
2. `PdfRepository` computes the **fingerprint** from the cache file, upserts
   `recent_files`, and creates a `PdfDocumentRef`.
3. Router pushes **ViewerScreen**; `pdfrx` opens the cache file. On open we read the
   page count, restore the saved `reading_position` (last page + view mode), and jump there.
4. As the user reads, page/view-mode changes are **debounced and saved** to
   `reading_positions`; leaving the screen also saves.
5. **TOC / thumbnails / page-jump** drive the `pdfrx` controller to change pages.
6. **Invert / dark / sepia**: app theme is the existing setting; the viewer's invert
   toggle flips page pixels via `PdfViewerParams`.
7. **Large file**: size over threshold → warning + degraded single-page mode.
8. **Broken / empty / encrypted**: the open call's typed exception maps to a friendly
   `ViewerErrorView` (or the password prompt for encrypted); the app never crashes.
9. **"Open with"** from another app → intent delivered on launch → same copy-to-cache →
   straight into ViewerScreen.
10. **Recents**: Home lists `recent_files` newest-first; tapping one calls
    `resolveToCache(uri)` and reopens at the last page. If the URI permission is gone
    (file moved/deleted), show a friendly "can't reopen" and offer to remove it.

---

## 7. Rules respected (checklist)

- **Open source only** — `pdfrx` (BSD), `crypto` (BSD); native SAF is plain Android SDK.
- **Offline** — no network; manifest still has no `INTERNET`.
- **Scoped storage only** — SAF `ACTION_OPEN_DOCUMENT` + intents; persistable permission
  taken; no broad storage permission; no in-app file browser.
- **Never crash** — every open path has a typed failure → friendly UI state.
- **File identity = size + hash** — `Fingerprint`, keys recents + positions.
- **Copy-on-write spirit** — we only ever read the original; cache copy is separate.
- **No secrets in logs** — PDF passwords never logged.
- **Heavy work off UI isolate** — hashing (and any copy work we do in Dart) uses `compute`.
- **Definition of Done** — `flutter analyze` clean, `flutter test` passing, `dart format`
  clean, tests added, dev APK builds.

---

## 8. Out of scope for Phase 1 (kept for later phases)

- Text search, copy, metadata panel, TTS → **Phase 2**.
- Extraction / conversion / share → **Phase 3**.
- Encrypt/decrypt as a page operation, merge/split/etc. → **Phase 4**.
- Real (in-PDF) annotations and overlay layer → **Phase 5**.

---

## 9. Exit check (Definition of Done for this phase)

A user can open a PDF (picker **and** "Open with"), read it in single / continuous / book
view, zoom and fit, jump by page / TOC / thumbnail, invert for night reading, close and
**reopen at the last page** from recents; large files open in degraded mode with a warning;
corrupt / truncated / empty / password-protected files show friendly messages and never
crash. `flutter analyze` / `flutter test` / `dart format` are clean and the dev APK builds.

---

## 10. Approval

Per the workflow rules, no `lib/`, `android/`, or `pubspec` code will change until this is
approved.

**Do you approve this plan?**
