# Change log: fix recent files that cannot be reopened

Implements plan: [plans/20261005_192800_fix_recent_files_reopen.md](../plans/20261005_192800_fix_recent_files_reopen.md)

## Why

Most files in the recent list showed "could not be reopened" even though they were still in
Downloads. Those files had been opened with "Open with" from another app. Android gives
that only short access, which ends when the app closes. Also, reopening a picked file with
"Open with" replaced its lasting link with a short one.

## What changed

- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt`
  - For "Open with" / shared PDFs, take lasting access when the sending app allows it
    (`FLAG_GRANT_PERSISTABLE_URI_PERMISSION`).
  - Each PDF payload now says whether the app has lasting access (`persisted`).
  - New method `hasLastingAccess(uri)`.
  - `pickPdf` accepts an `initialUri` hint (`EXTRA_INITIAL_URI`), so the picker can start
    near the old file.
- `lib/core/platform/open_document_channel.dart` — `OpenedDocument.hasLastingAccess`,
  `hasLastingAccess(uri)`, and `pickPdf({initialUri})`.
- `lib/features/viewer/data/pdf_repository.dart`
  - A short link no longer replaces a stored link that still has lasting access.
  - New `relocateRecent(recent)`: picks the file again, starting near the old one. Recents
    are keyed by content, so the same file updates the same entry and keeps its reading
    position.
- `lib/features/viewer/presentation/home_screen.dart` — when a recent file fails to open, a
  dialog explains why and offers **Find file**, **Remove**, or **Cancel**.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ generated files) — clearer
  `reopenFailed`, and new `reopenFailedTitle`, `reopenFailedHelp`, `findFileAgain`.
- `docs/features.md` — describes the new behaviour.

## Tests

- New `test/features/viewer/data/pdf_repository_test.dart` (6 tests): link-keeping rules and
  relocation.
- `test/features/viewer/presentation/home_screen_test.dart`: the old snack-bar test is
  replaced by 4 dialog tests (dialog shown, Find file opens the picker near the old file,
  Remove, Cancel).
- `flutter analyze` is clean, and all 417 tests pass. This was run after the package
  upgrade in `change_log/20261005_195024_upgrade_all_packages.md`; before that, the Home
  screen test could not compile because of `pdfrx`.

## Notes for the user

- Files already in the list that were opened with "Open with" need **Find file** once each.
- Android does not let any app silently reopen most "Open with" files after a restart. Using
  the app's own **Open PDF** button gives lasting access.
- The hands-on check on the phone is still to be done (the phone was locked).
