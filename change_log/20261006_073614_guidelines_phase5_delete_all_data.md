# Change log — Guidelines Phase 5: Delete all data

Implements Phase 5 of [../plans/20261005_202751_guideline_compliance_audit.md](../plans/20261005_202751_guideline_compliance_audit.md)
(finding F12, engineering standard §15.4).

## What changed

- New `lib/core/storage/app_data_purge_service.dart` — `AppDataPurgeService.deleteAll()`:
  deletes all rows in `recent_files`, `reading_positions`, `annotations` and `trust_store` in one
  transaction (the schema and `meta` table stay), releases every lasting file permission, clears
  SharedPreferences, and empties the temp cache (including the printer spool). A database failure
  throws `StorageException`; the other steps are best-effort and log their own failures. The
  user's own PDF files are never touched.
- New `lib/app/app_restart_scope.dart` — `AppRestartScope` rebuilds the app below it with a new
  key, so the provider container and all screen state start fresh. `lib/main.dart` wraps the
  `ProviderScope` in it.
- New `lib/features/settings/presentation/providers.dart` — `appDataPurgeServiceProvider`.
- `lib/core/platform/open_document_channel.dart` + `android/.../MainActivity.kt` — new
  `releaseAllAccess` method: releases every persisted SAF URI permission.
- `lib/features/settings/presentation/storage_settings_screen.dart` — new "App data" section with
  a red "Delete all data" row. It asks first in an `AlertDialog` whose confirm button is labelled
  "Delete all data" (§6.4). On success the app goes to the home screen and restarts in place; on
  failure a SnackBar shows a safe message with "Try again".
- Same screen: the "Clear temporary cache" button showed the annotation tool label "Eraser". It
  now uses a new `actionClear` key ("Clear").
- New ARB keys (en, ml, sa): `titleAppData`, `actionDeleteAllData`, `descDeleteAllData`,
  `titleDeleteAllDataConfirm`, `bodyDeleteAllDataConfirm`, `errorDeleteAllData`, `actionClear`.
  The Sanskrit text passes the language-pack Hindi-marker gate.
- `docs/security.md` §13 (retention table and purge implementation) and §17 (open risks) updated.

## Tests

- New `test/core/storage/app_data_purge_service_test.dart` — every user table emptied, settings
  cleared, file access released once, `meta` kept, database failure → `StorageException`.
- New `test/app/app_restart_scope_test.dart` — a restart throws away all state below the scope.
- `dart format`: clean. `flutter analyze`: no issues. `flutter test`: 447 passed.
  `flutter build apk --flavor dev --debug`: built.

## Needs native-reader review

- `titleAppData` — ml "ആപ്പ് വിവരങ്ങൾ" · sa "अनुप्रयोगदत्तांशः"
- `actionDeleteAllData` — ml "എല്ലാം ഇല്ലാതാക്കുക" · sa "सर्वं लुप्यताम्"
- `descDeleteAllData`, `bodyDeleteAllDataConfirm`, `errorDeleteAllData` (long text, ml and sa)
- `titleDeleteAllDataConfirm` — ml "എല്ലാം ഇല്ലാതാക്കണോ?" · sa "सर्वं लोप्तव्यं किम्?"
- `actionClear` — ml "മായ്ക്കുക" · sa "मार्ज्यताम्"

## To verify on a device

- Open a few files, add a mark, trust a certificate, change the theme and language, then use
  "Delete all data": the home screen shows no recents, settings are back to default, and the
  system's "app access" list for files is empty.
- Not covered by an automated test: the native permission release (needs a device).
