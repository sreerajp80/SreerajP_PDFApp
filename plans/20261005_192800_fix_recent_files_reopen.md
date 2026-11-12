# Fix: files in the recent list cannot be reopened

**Status:** completed

## The issue

Tapping most files in the recent list shows "This file could not be reopened. It may have
been moved or deleted." The files still exist in the Downloads folder.

### Root cause (checked on the test phone)

Android lets an app read a file only while it holds a *permission* for that file's link
(its `content://` URI). There are two kinds:

- **Lasting permission** — survives app restarts and phone reboots. The app gets this only
  when the user picks the file with the app's own "Open PDF" button (the system picker).
- **Short permission** — given when another app (Files, Downloads, WhatsApp, Telegram,
  Chrome, ...) opens a PDF in our app with "Open with". It ends when our app closes.

The phone's permission list shows the app holds lasting permission for only **3** files
(`EliteHub_Invoice.pdf`, `LalithaSaahasranaamam_Sanskrit.pdf`, and the Kashmir Saivism
book). All the other recent files were opened with "Open with", so after the app restarted
their permission was gone and reopening fails. The files were not moved or deleted — the
message is misleading.

A second, smaller bug makes this worse: when a file that was first picked with "Open PDF"
(lasting permission) is later opened again with "Open with", the recent entry's link is
overwritten with the new short-permission link. That file then also stops reopening later.

Android does not let us get lasting permission for an "Open with" file unless the sending
app allows it (most do not). So we cannot make every "Open with" file reopen silently. We
can (a) keep lasting permission whenever it is possible, and (b) give the user a one-tap
way to fix a broken entry instead of a dead end.

## Files to change

| File | Change |
|---|---|
| `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` | Try to take lasting permission for "Open with" PDFs; report whether a link has lasting permission; picker can start in a given folder. |
| `lib/core/platform/open_document_channel.dart` | `OpenedDocument` gets a `hasLastingAccess` flag; new `hasLastingAccess(uri)` call; `pickPdf` takes an optional start location. |
| `lib/features/viewer/data/pdf_repository.dart` | Do not overwrite a working lasting link with a short one; new `relocateRecent` (pick the file again, starting near the old one). |
| `lib/features/viewer/presentation/home_screen.dart` | When reopen fails, show a dialog: "Find the file again" (opens the picker) or "Remove from list". |
| `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ regenerated `app_localizations*.dart`) | New / corrected texts. |
| `test/features/viewer/data/pdf_repository_test.dart` (new) | Tests for the "keep the lasting link" rule and relocation. |
| `test/features/viewer/presentation/home_screen_test.dart` | Test the new reopen-failed dialog. |
| `docs/features.md` | Short note on how recents work with "Open with" files. |

## The fix

1. **Take lasting permission when allowed (native).** For an "Open with" / share PDF, if the
   incoming intent carries `FLAG_GRANT_PERSISTABLE_URI_PERMISSION`, call
   `takePersistableUriPermission` (wrapped in try/catch, as the picker path already does).
2. **Report access (native).** Every PDF payload gets `persisted: true/false`, worked out from
   `contentResolver.persistedUriPermissions`. Add a method `hasLastingAccess(uri)` that
   answers the same question for a stored link.
3. **Keep the good link (Dart).** In `PdfRepository._prepare`, if the new link has no
   lasting access but the existing recent entry (same content fingerprint) has a different
   link that still has lasting access, keep the old link.
4. **One-tap recovery (Dart + native).** When reopening fails, show a dialog instead of a
   snack bar:
   - Text: "This app no longer has permission to open this file. Files opened from another
     app with 'Open with' can only be reopened until the app closes. Pick the file once more
     to keep it in the list."
   - **Find file** — opens the system picker, starting in the old file's folder where
     Android allows it (`EXTRA_INITIAL_URI`; works on our minSdk 26). The picked file gets
     lasting permission. Because recents are keyed by content fingerprint, picking the same
     file updates the existing entry (same reading position, same row). A different file
     simply opens as a new entry.
   - **Remove** — removes the entry from the list.
   - **Cancel**.
5. **Better wording.** Change `reopenFailed` so it no longer claims the file was moved or
   deleted when the real cause is a lost permission.
6. Existing broken entries are fixed by the user with "Find file" once each; no data is lost.

## What is not changed

- No broad storage permission is added (project hard rule 3).
- The original PDF is only read, never written (copy-on-write rule unchanged).

## Checks after the change

- `flutter gen-l10n`, `dart format .`, `flutter analyze` (0 warnings), `flutter test`.
- On the phone: open a PDF from the Files app with "Open with", close the app fully, reopen
  from recents → dialog appears → "Find file" → picker opens → pick → PDF opens, and after
  another app restart it reopens directly.
