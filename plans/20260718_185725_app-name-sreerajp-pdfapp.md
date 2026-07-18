# Change Android app display name to SreerajP_PDFApp

**Status:** approval_pending

## Issue

The user wants the app's display name (the label shown under the launcher icon and in
Android settings) to be **SreerajP_PDFApp**.

Right now the name is set per build flavor in `android/app/build.gradle.kts` using the
`appLabel` manifest placeholder:

- prod flavor: `"PDF App"`
- dev flavor: `"PDF App Dev"`

The manifest (`android/app/src/main/AndroidManifest.xml`) uses `android:label="${appLabel}"`,
so only the gradle values need to change.

## Files to change

- `android/app/build.gradle.kts` — update the two `manifestPlaceholders["appLabel"]` values.

## Plan for the fix

Change the two placeholder values:

- prod: `"PDF App"` → `"SreerajP_PDFApp"`
- dev: `"PDF App Dev"` → `"SreerajP_PDFApp Dev"` (keep the "Dev" suffix so the dev build is
  still easy to tell apart from prod on the same device — the dev build already installs
  as a separate app via the `.dev` applicationId suffix)

No manifest or Dart changes are needed. `pubspec.yaml` `name:` is the Dart package name and
is not the Android display name, so it stays as is.

## Verification

- Run `flutter build apk --flavor prod --release --split-per-abi` (or a dev build) and
  confirm the launcher label reads "SreerajP_PDFApp".
