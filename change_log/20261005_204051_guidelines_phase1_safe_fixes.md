# Change log — Guidelines Phase 1: small safe fixes

Implements Phase 1 of [../plans/20261005_202751_guideline_compliance_audit.md](../plans/20261005_202751_guideline_compliance_audit.md)
(findings F4, F5, F6, F8, F9, F13, S5).

## What changed

- `lib/core/logging/app_logger.dart` — `AppLogger` now starts with a console-only logger, so a
  log call made before `init()` never throws (engineering standard §14.2). `init()` swaps in the
  full logger as before.
- `lib/main.dart` — start-up order now matches §4.5: binding → `AppLogger.init()` → global error
  handlers → database → preferences + config → PDF engine → lifecycle → `runApp`. The
  `_safeLog` helper and its `debugPrint` call are gone (§14.3); the handlers log through
  `AppLogger` directly.
- `lib/core/errors/safe_error_fallback.dart` — the release-build fallback now shows a localized
  message (new ARB key `errorScreenFallback`). If it renders outside the app's localizations it
  uses English. Its colors moved to design tokens.
- `lib/app/theme/tokens.dart` — new tokens `heartRed`, `errorFallbackBackground`,
  `errorFallbackForeground`. `lib/core/widgets/made_with_love.dart` uses `AppTokens.heartRed`.
- `lib/core/lifecycle/app_lifecycle_service.dart` — closes the database on `detached` and reopens
  it if the same engine comes back (§9.3). New `cleanUpPreviousSession()` runs once at start-up.
- `lib/core/storage/cache_service.dart` — new `clearStaleWorkingFiles()`: deletes files older than
  24 hours in the app's own temp folders `opened/`, `page_ops/`, `extracted/`, `annotations/`.
  The `printer/` spool folder (the user's printed documents) is never touched automatically.
- `android/app/build.gradle.kts` — `kotlinOptions { jvmTarget }` replaced by
  `kotlin { compilerOptions { jvmTarget.set(JvmTarget.JVM_17) } }` (§5.3); App Bundle language
  splitting turned off with `bundle { language { enableSplit = false } }` (§8.1).
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` — new key `errorScreenFallback`; generated
  localizations regenerated.
- `docs/architecture.md` §5 and §6 — start-up order and lifecycle tables updated.

## Tests

- New: `test/core/logging/app_logger_test.dart`, `test/core/errors/safe_error_fallback_test.dart`
  (en, ml, sa, and outside the app), `test/core/lifecycle/app_lifecycle_service_test.dart`
  (close/reopen and the stale-file cleanup rules).
- `dart format`: no changes. `flutter analyze`: no issues. `flutter test`: 427 passed.
- `flutter build apk --flavor dev --debug`: built.
- Note: `test/features/printer/presentation/import_screen_test.dart` ("one picture is described in
  the singular") failed once in a full run and passed when run alone and in the next full run. It
  looks timing-sensitive; it was not changed here.

## Needs native-reader review

- `errorScreenFallback` (ml): "ഈ സ്ക്രീനിൽ ഒരു പിശക് സംഭവിച്ചു. ദയവായി പിന്നോട്ട് പോയി വീണ്ടും ശ്രമിക്കുക."
- `errorScreenFallback` (sa): "अस्मिन् पटले दोषः सञ्जातः। प्रत्यागत्य पुनः प्रयत्यताम्।"

## To verify on a device

- Exit the app with Back, reopen it, and use a recent file — the database must work normally.
