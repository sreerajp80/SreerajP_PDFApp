# Mark unavailable files in the Recent files list

**Status:** completed

## The issue

Home shows every recent file the same way. Some of them can no longer be opened:

- the file was deleted or moved, or
- the app lost access to it (most "Open with" files only give short access, which ends when
  the app closes; the user may also have cleared access in system settings).

Today the user only finds out after tapping the row: the app tries to copy the file, fails,
and then shows the "could not reopen" dialog. The user wants to see these files marked in
the list, so they can remove them straight away without trying to open them.

## Files to change

| File | Change |
|---|---|
| `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` | New method `checkAvailable(uris)` |
| `lib/core/platform/open_document_channel.dart` | Dart wrapper `checkAvailable(List<String>)` |
| `lib/features/viewer/data/pdf_repository.dart` | `availabilityOf(List<RecentFile>)` that calls the channel |
| `lib/features/viewer/presentation/providers.dart` | New `recentFileAvailabilityProvider` |
| `lib/features/viewer/presentation/home_screen.dart` | Show unavailable rows differently |
| `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` | New text `descFileUnavailable` |
| `test/features/viewer/data/pdf_repository_test.dart` | Test the new repository call |
| `test/features/viewer/presentation/home_screen_test.dart` | Test the unavailable row |
| `docs/features.md` | Mention the new marker |

## Plan for the fix

1. **Native check (Kotlin).** Add `checkAvailable` to the existing open-document method
   channel. For each stored URI it does a cheap metadata look-up only
   (`contentResolver.query` for the display name). It does **not** open or copy the file,
   so a cloud file (for example Google Drive) is not downloaded just to check it.
   - row found → `true` (available)
   - no row, `FileNotFoundException`, or `SecurityException` → `false` (unavailable)
   - The check runs on a background thread (up to 30 URIs) and replies on the main thread,
     so the UI never freezes.
2. **Dart channel.** `OpenDocumentChannel.checkAvailable(uris)` returns a
   `Map<String, bool>`. On any platform failure it returns an empty map, which means
   "unknown" — never a crash and never a wrong "unavailable" mark.
3. **Repository + provider.** `PdfRepository.availabilityOf(files)` passes the URIs through.
   A `FutureProvider` (`recentFileAvailabilityProvider`) watches the recent list and runs the
   check. It re-runs whenever the list refreshes (open, remove) and when the app comes back
   to the foreground (the user may have deleted a file in another app).
4. **UI (Home).** The list shows at once, as today. When the check finishes, each
   unavailable row:
   - shows a "file off" style icon instead of the PDF icon, in the error colour,
   - dims the title,
   - shows the subtitle "Not available" (instead of the page count).
   The **Remove (×)** button stays as it is. Tapping the row still tries to open the file
   and, if that fails, shows the existing
   "could not reopen" dialog (Find again / Remove), so the row is never a dead button.
   Rows whose state is unknown look normal.
5. **Text.** One new key `descFileUnavailable` in all three languages
   (en "Not available", ml "ലഭ്യമല്ല", sa "न उपलभ्यते"), with an `@` description in
   `app_en.arb`. Run `flutter gen-l10n`.
6. **Tests.** Repository test with a fake channel; widget test that an unavailable row shows
   the new text and still has the Remove button; a channel failure shows normal rows.
7. Run `flutter analyze`, `flutter test`, `dart format .`. Write the change log.

## Not in this plan (could be a follow-up)

- A "Remove all unavailable" button. Easy to add later if the list often has many dead rows.

## Limits

- Some document providers keep answering a query for a short time after a file is deleted.
  Then the row looks available until the provider catches up; tapping it still falls back to
  the existing dialog.

## Security impact

Touches the Android platform folder and storage access. The new check only reads metadata
for URIs the app already stored, using access the app already holds. No new permission, no
new file access, no network. No file name or URI is logged.
