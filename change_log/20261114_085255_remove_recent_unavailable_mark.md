# Change log: remove the "Not available" mark from the recent files list

Implements plan: `plans/20261114_085255_remove_recent_unavailable_mark.md`

## Why

The start-up check marked recent files "Not available" when Android said the stored link
could not be reached. On a test phone it was wrong both ways: files that still exist were
shown as missing (lost permission, not a missing file), and a file reached through a
short-term link from another app looked fine only until the app closed. Tapping a file
already gives a true answer through the "Can't reopen file" dialog.

## What changed

- `lib/features/viewer/presentation/home_screen.dart` — rows no longer show a warning icon,
  dimmed name, or "Not available". Removed the app-resume listener that only re-ran the check.
- `lib/features/viewer/presentation/providers.dart` — removed `recentFileAvailabilityProvider`.
- `lib/features/viewer/data/pdf_repository.dart` — removed `availabilityOf`.
- `lib/core/platform/open_document_channel.dart` — removed `checkAvailable`.
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` — removed the
  `checkAvailable` channel case and the `checkAvailable` / `isReachable` functions.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ regenerated `app_localizations*.dart`)
  — removed the unused `descFileUnavailable` key; `helpReopenFailed` now also mentions files
  chosen through another app inside the file picker, and says to pick the file from the
  picker's own folders.
- `test/features/viewer/presentation/home_screen_test.dart` — removed the fake check and the
  three mark tests; added a test that a row shows its details and no warning mark. The
  existing test that a failed reopen shows the dialog stays.
- `test/features/viewer/data/pdf_repository_test.dart` — removed the fake check and the two
  `availabilityOf` tests.
- `docs/features.md` — "Recent Files Dashboard" now says rows are not pre-checked.
- `CHANGELOG.md` — one "Changed" line under Unreleased.

**Security impact:** none added. One native method that queried other apps' file providers
at start-up is gone, so the app does less with stored links. No permission changes.

## Checks

- `flutter gen-l10n`, `dart format lib test`, `flutter analyze` — no issues.
- `flutter test` — all 596 tests pass.
- Not yet done: an Android build (to compile the Kotlin change) and a check on the phone.

## Translations to review (native reader)

- `helpReopenFailed` in Malayalam and Sanskrit. Sanskrit uses सञ्चिकाचायक (file picker, as in
  existing texts) and संपुटम् (folder, from the language pack glossary).
