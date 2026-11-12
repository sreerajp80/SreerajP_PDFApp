# Change log: Mark unavailable files in the Recent files list

Plan: [plans/20261112_112534_recent_files_unavailable_marker.md](../plans/20261112_112534_recent_files_unavailable_marker.md)

## What changed

Home now marks recent files that were deleted, moved, or can no longer be read. These rows
show a warning icon, a dimmed name, and "Not available" in place of the page count. The
user can remove them with the × button without trying to open them. Tapping such a row
still tries to open the file and, if that fails, shows the same "Can't reopen file" dialog
(Find file / Remove) as before.

## Files

- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` — new `checkAvailable`
  method on the open-document channel. For each stored URI it asks the provider for the
  display name only (no open, no copy, so cloud files are not downloaded). It runs on a
  background thread and replies on the main thread. `file://` URIs use `File.canRead()`.
- `lib/core/platform/open_document_channel.dart` — `checkAvailable(uris)`. Returns an empty
  map ("unknown") on any platform failure.
- `lib/features/viewer/data/pdf_repository.dart` — `availabilityOf(files)` maps the answer
  to fingerprints.
- `lib/features/viewer/presentation/providers.dart` — `recentFileAvailabilityProvider`,
  which re-runs whenever the recent list changes.
- `lib/features/viewer/presentation/home_screen.dart` — marks unavailable rows; re-checks
  when the app comes back to the foreground (`AppLifecycleListener.onResume`). Rows with an
  unknown state look normal. The last answer is kept while a new check runs, so rows do
  not flicker.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ generated files) — new key
  `descFileUnavailable`: "Not available" / "ലഭ്യമല്ല" / "न लभ्यते".
- `test/features/viewer/data/pdf_repository_test.dart` — 2 new tests.
- `test/features/viewer/presentation/home_screen_test.dart` — 3 new tests (marked row and
  remove, tap still shows dialog, reachable row looks normal).
- `docs/features.md` — Recent Files Dashboard entry updated.

Small difference from the plan: the marker icon is `Icons.report_outlined` (a warning
icon) in the error colour.

## Checks

- `flutter analyze`: no issues.
- `flutter test`: all 569 tests pass.
- The Kotlin change has not been compiled or tried on a device yet.

## Translation review

- Malayalam "ലഭ്യമല്ല" and Sanskrit "न लभ्यते" follow wording already used in the app.
  A quick native-reader check is still welcome.

## Security impact

No new permission and no new file access. The check only reads metadata for URIs the app
already stored, using access it already holds. No URI or file name is logged.
