# Change log — Guidelines Phase 11: turn off Android backup

Implements Phase 11 of [../plans/20261005_202751_guideline_compliance_audit.md](../plans/20261005_202751_guideline_compliance_audit.md)
(added during Phase 5 and approved by the user; engineering standard §15.2,
`docs/security.md` §17 "required before the first Google Play release").

## What changed

- `android/app/src/main/AndroidManifest.xml` — `<application>` now sets
  `android:allowBackup="false"`, `android:fullBackupContent="false"` and
  `android:dataExtractionRules="@xml/data_extraction_rules"`.
- New `android/app/src/main/res/xml/data_extraction_rules.xml` — for Android 12+ every domain
  (`root`, `file`, `database`, `sharedpref`, `external`) is excluded from cloud backup **and**
  device-to-device transfer. `allowBackup="false"` alone does not stop device transfer on
  Android 12+, which is why the rules file is needed too.
- `docs/security.md` §10, §12 (M6/M8 note), §13 (purge on uninstall), §17 — the open item is
  closed. `docs/architecture.md` §21 — risk removed. `docs/release_process.md` §6.4 and the
  first-release checklist — updated / ticked.

## Tests

- `flutter build apk --flavor dev --debug`: built. The merged dev manifest contains
  `allowBackup="false"`, `fullBackupContent="false"` and the `dataExtractionRules` reference.
- No Dart code changed.

## To verify on a device

- Android 12+: `adb shell bmgr backupnow in.sreerajp.pdfapp.dev` backs up nothing, and a phone
  transfer to a new device does not carry the app's recent files or settings.
