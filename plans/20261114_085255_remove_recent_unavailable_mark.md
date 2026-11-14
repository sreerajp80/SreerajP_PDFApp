# Remove the "Not available" mark from the recent files list

**Status:** completed

## The issue

Home checks every recent file when it opens and whenever the app comes back to the front.
If Android says the stored file link cannot be reached, the row gets a red warning icon,
a dimmed name, and "Not available".

On a test phone this mark was misleading:

- Files that still exist were marked "Not available". The real cause was lost permission
  (a short-term link, for example one handed over by another file app), not a missing file.
- A file shown as normal was only reachable because the app was still running. After the
  app fully closed, it would turn red too. So the mark is not reliable in either direction.
- The check cannot tell "file deleted" from "permission lost", so the label cannot say
  anything more useful.

Tapping a row already gives a clear answer: the file opens, or the "Can't reopen file"
dialog offers **Find file**, **Remove**, or **Cancel**. The mark adds confusion, not help.

## Decision

Remove the mark and the start-up check. Every recent row looks normal. The user taps to
find out, and can find the file again or remove it right away from the dialog. The "Remove"
(X) button on each row stays.

## Files to change

| File | Change |
|---|---|
| `lib/features/viewer/presentation/home_screen.dart` | Remove the availability watch, the red icon / dimmed name / "Not available" subtitle, and the `AppLifecycleListener` that only re-ran the check. |
| `lib/features/viewer/presentation/providers.dart` | Remove `recentFileAvailabilityProvider`. |
| `lib/features/viewer/data/pdf_repository.dart` | Remove `availabilityOf`. |
| `lib/core/platform/open_document_channel.dart` | Remove `checkAvailable`. |
| `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` | Remove the `checkAvailable` method-channel case, `checkAvailable` and `isReachable`. |
| `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ regenerated `app_localizations*.dart`) | Remove the unused `descFileUnavailable` key. Update `helpReopenFailed` (see below). |
| `test/features/viewer/presentation/home_screen_test.dart` | Remove the fake `checkAvailable` and the three mark tests; add one test that a recent row shows no warning mark and tapping a failing file still shows the dialog. |
| `test/features/viewer/data/pdf_repository_test.dart` | Remove the fake `checkAvailable` and the two `availabilityOf` tests. |
| `docs/features.md` | Update the "Recent Files Dashboard" line. |
| `CHANGELOG.md` | One line under the unreleased section. |

## Dialog text update (`helpReopenFailed`)

Today it says only "Open with" files lose access. The phone check showed a file chosen
through *another app inside the file picker* also gets short access. New English text:

> Files opened through another app (with "Open with", or by choosing another app in the
> file picker) can only be reopened until this app closes. Pick the file once more from
> the file picker's own folders to keep it in the list.

Matching Malayalam and Sanskrit translations will be written and flagged for native-reader
review in the change log.

## What is not changed

- How files are opened, saved, and permissions taken (scoped storage, hard rule 3).
- The "Find file" recovery dialog and the "keep the lasting link" rule.
- No new permission. **Security impact:** none added; one native method that queried other
  apps' file providers at start-up is removed, so the app does less with stored links.

## Downside (honest)

The user can no longer see broken rows at a glance; they find out on tap. Since the mark
was wrong in both directions, this is the better trade.

## Checks after the change

- `flutter gen-l10n`, `dart format .`, `flutter analyze` (0 warnings), `flutter test`.
- On the phone: the recent list shows no red rows; tapping a broken file shows the dialog;
  **Remove** takes it off the list; **Find file** fixes it.
