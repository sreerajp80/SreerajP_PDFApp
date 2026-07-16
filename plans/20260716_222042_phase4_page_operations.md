# Plan — Phase 4: Page Operations (always copy-on-write)

**Status:** completed

This plan describes how we will implement **Phase 4: Page operations** from
`docs/pdf-app-implementation-plan.md`. Every operation writes a **new file**; the original PDF
is never changed in place.

---

## 1. What we are building

Six page operations, each producing a brand-new PDF (copy-on-write):

1. **Merge** — pick several PDFs and join them into one new PDF.
2. **Split** — break one PDF into one file per page.
3. **Organize** — reorder, rotate, and delete pages in one screen; save as a new PDF.
4. **Compress** — best-effort size reduction, clearly labelled as best-effort.
5. **Protect (encrypt)** — add a password to a new copy.
6. **Unlock (decrypt)** — remove the password from a copy (needs the current password).

All heavy work runs on the native background thread (PdfBox-Android), same as Phase 3. Output
files are written first to the app cache, then the user saves them to a location of their choice
through the Android system "create document" dialog (scoped storage — no broad file access), or
shares them through the share sheet.

---

## 2. Key decisions (please review)

> [!IMPORTANT]
> - **Saving to a user-chosen location.** We add a native `saveToDevice` method that opens the
>   Android **`ACTION_CREATE_DOCUMENT`** dialog. This is the correct scoped-storage way to let the
>   user pick where a new file goes. The op writes to app cache first, then copies the bytes into
>   the URI the user picks. Nothing is written to storage without the user choosing the spot.
> - **Merge input.** We add a native `pickPdfs` method (system picker with "allow multiple") so the
>   user can select the extra PDFs to merge. Each is copied to cache the same way single-open does.
> - **Split output (many files).** A split makes many files at once. Saving each through the
>   create-document dialog one by one is clumsy, so split offers **Share** (multi-file share sheet)
>   as its output path. Single-file ops (merge/organize/compress/protect/unlock) offer both
>   **Save** (create-document) and **Share**.
> - **Passwords (§11).** Passwords for protect/unlock are typed in the dialog, held only in memory
>   for the one call, passed to native, and **never logged, never stored, never put in
>   SharedPreferences**. The Dart channel and native code already avoid logging the `password`
>   argument; we keep that.
> - **No new database table and no new method channel.** Page ops reuse the existing `pdfbox`
>   channel (native ops) and the existing `open` channel (pick/save/share). No schema migration.
> - **Compression is weak by design.** PdfBox re-saves with object-stream compression and we strip
>   optional metadata; it will not shrink already-optimized files much. The UI says "best-effort".

---

## 3. Files to change

### Android native layer

**[MODIFY]** `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`
Add background-thread methods (all catch `InvalidPasswordException` → `password_required`, other
errors → typed failure, `OutOfMemoryError` guarded; nothing throws into Flutter):
- `mergePdfs(paths: List<String>, outputPath)` — `PDFMergerUtility`, returns output path.
- `splitPdf(path, password, outputDir)` — `Splitter` (one page each), returns list of paths.
- `organizePages(path, password, outputPath, pages)` — `pages` is an ordered list of
  `{page: Int (1-based original), rotation: Int (0/90/180/270)}`. Build a new `PDDocument`,
  import each listed source page in order, apply rotation. Pages not listed are dropped. This one
  method covers **reorder + rotate + delete**.
- `compressPdf(path, password, outputPath)` — load, remove document-info + XMP metadata, save
  (PdfBox writes compressed object streams). Best-effort.
- `encryptPdf(path, password, outputPath, userPassword, ownerPassword)` —
  `StandardProtectionPolicy` (AES-256, `setPreferAES(true)`), save the new copy.
- `decryptPdf(path, password, outputPath)` — load with `password`, `setAllSecurityToBeRemoved(true)`,
  save.
- Add the matching `when(call.method)` cases with argument validation, mirroring the existing ones.

**[MODIFY]** `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt`
- Add `pickPdfs` (method): `ACTION_OPEN_DOCUMENT` with `EXTRA_ALLOW_MULTIPLE`, persistable read
  permission, copy each picked item to cache, return a list of `{uri, name, size, path}`. Handle
  the multi-select result in `onActivityResult` (new request code).
- Add `saveToDevice` (method): `ACTION_CREATE_DOCUMENT` with a suggested name + MIME type; on
  result, copy the cache source file into the chosen URI via `contentResolver.openOutputStream`.
  Return the saved display name, or `null` if the user cancelled. Uses its own pending-result slot
  and request code (mirrors `pendingPick`).

### Core platform layer

**[MODIFY]** `lib/core/platform/pdfbox_channel.dart`
Add typed wrappers returning the new-file path(s), reusing the existing `_mapException`:
- `Future<String> mergePdfs(List<String> paths, String outputPath)`
- `Future<List<String>> splitPdf(String path, String outputDir, {String? password})`
- `Future<String> organizePages(String path, String outputPath, List<Map<String,int>> pages, {String? password})`
- `Future<String> compressPdf(String path, String outputPath, {String? password})`
- `Future<String> encryptPdf(String path, String outputPath, {String? password, required String userPassword, String? ownerPassword})`
- `Future<String> decryptPdf(String path, String outputPath, {required String password})`

**[MODIFY]** `lib/core/platform/open_document_channel.dart`
- `Future<List<OpenedDocument>> pickPdfs()` — wraps native `pickPdfs`; empty list on cancel.
- `Future<String?> saveToDevice(String sourcePath, String suggestedName, {String mimeType = 'application/pdf'})`
  — wraps native `saveToDevice`; `null` on cancel.

### Feature: `lib/features/page_ops/`

**[NEW]** `data/page_ops_service.dart` — provider-managed service that:
- makes/clears the `page_ops/` cache output dir (same pattern as `ExtractionService`),
- builds output filenames (e.g. `merged_<ts>.pdf`, `organized_<ts>.pdf`),
- calls the channel methods,
- exposes `pickPdfs` / `saveToDevice` (via `openDocumentChannelProvider`) and share (via
  `shareServiceProvider`).
- `pageOpsServiceProvider`.

**[NEW]** `presentation/page_ops_sheet.dart` — a Material 3 bottom sheet listing the six
operations (icon + title + one-line description). Each row opens the matching dialog/screen.

**[NEW]** `presentation/widgets/organize_pages_screen.dart` — full-screen page organizer:
- a `ReorderableListView` of page rows (page thumbnail via `pdfrx`, page label, **rotate** button
  cycling 0→90→180→270, **delete** toggle),
- drag handle to reorder, an "undo delete" affordance, a Save action in the app bar,
- on Save: build the `pages` list (skip deleted, keep order, include rotation) → `organizePages`
  → result dialog (Save/Share).

**[NEW]** `presentation/widgets/protect_dialog.dart` — user password field + optional owner
password field + show/hide toggle; validates non-empty; passwords never logged.

**[NEW]** `presentation/widgets/unlock_dialog.dart` — single password field to decrypt.

**[NEW]** `presentation/widgets/page_ops_result_dialog.dart` — shows success + output filename(s)
with **Save** (single file, create-document) and **Share** buttons; reused by every op.

**[NEW]** `presentation/widgets/split_confirm_dialog.dart` (small) and merge flow live inside
`page_ops_sheet.dart` handlers (pick extra PDFs → confirm order → run → result).

Progress/loading and error states follow the `ExtractionDialog` pattern (spinner while running,
inline error text on failure, friendly messages — never crash).

### Viewer integration

**[MODIFY]** `lib/features/viewer/presentation/viewer_screen.dart`
- Add `_ViewerMenu.pageOps` to the enum and the `onSelected` switch.
- Add a `PopupMenuItem` "Page tools" that opens `PageOpsSheet` (passes `cachePath`, current page,
  page count).

### Localization

**[MODIFY]** `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb`
Add strings for: page-tools menu, each operation name + description, organize screen (rotate,
delete, restore, reorder hint, save), protect/unlock dialog labels + validation, best-effort
compress notice, result dialog (saved/shared/save/share), success and error messages. Regenerate
`app_localizations*.dart` with `flutter gen-l10n`.

### Tests

**[NEW]** `test/features/page_ops/page_ops_service_test.dart` — mock the `MethodChannel`; verify
each op passes the right arguments and that errors map to typed exceptions (mirrors
`test/features/extraction/extraction_service_test.dart` and `pdfbox_channel_test.dart`).
**[MODIFY]** `test/core/platform/pdfbox_channel_test.dart` — add cases for the new channel methods
(argument shape + `password_required`/failure mapping).

### Docs

**[NEW]** `change_log/<ts>_phase4_page_operations.md` after implementation.
**[MODIFY]** `docs/pdf-app-implementation-progress.md` — tick Phase 4 items, update the table and
"Last updated" line, add the change-log link.

---

## 4. Copy-on-write & safety checks

- Every native op opens the source read-only and writes a **separate** output file. The source
  cache file (a copy of the user's original already) is never written to.
- The user's real file is never touched: input comes from the read-only cache copy; output goes
  only where the user points the create-document/share dialog.
- Passwords: not logged, not persisted, in memory for the single call only (§11).
- Bad input: corrupt/locked/empty files return typed errors → friendly UI, never a crash.

---

## 5. Verification plan

**Automated:** `flutter analyze` clean, `dart format` clean, `flutter test` green (new page-ops
service + channel tests plus the existing suite).

**Manual (on device):** open a PDF → "Page tools":
1. **Merge** two PDFs → save → open result, page count = sum, original files unchanged.
2. **Split** a multi-page PDF → share → each file is one page.
3. **Organize** — reorder, rotate one page 90°, delete one → save → order/rotation/deletion correct.
4. **Compress** → save → opens fine (note it is best-effort).
5. **Protect** with a password → saved file asks for that password on open.
6. **Unlock** that protected file with the password → new copy opens with no password.
7. Confirm the source PDF is byte-for-byte unchanged after each op.
8. Confirm no password appears in logcat.

---

## 6. Out of scope / follow-ups

- Fine-grained split by custom ranges (only per-page split now).
- Saving many split files each to a chosen folder via `ACTION_OPEN_DOCUMENT_TREE` (split uses Share).
- Real image down-sampling for stronger compression (best-effort re-save only).

---

## 7. Approval

Per the workflow rules, no `lib/`, `android/`, `pubspec`, or test code will be written until you
approve. **Do you approve this plan?**
