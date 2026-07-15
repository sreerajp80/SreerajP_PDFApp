# Change Log — Phase 0: Scaffolding & Foundation

**Date:** 2026-07-14
**Implements plan:** `plans/20260714_140932_phase0-scaffolding.md`
**Phase:** 0 of `doc/pdf-app-implementation-plan.md`

## What was done

Created the Flutter Android project skeleton and all cross-cutting foundation code, so later
phases have a base to build on. The app compiles, all checks are clean, and the dev-flavor APK
builds.

### Project & build
- `flutter create` (org `in.sreerajp`, project `pdfapp`, Android only).
- `android/app/build.gradle.kts`: application id `in.sreerajp.pdfapp`, **minSdk 26**, Java 17
  target, `dev`/`prod` product flavors (dev → `.dev` suffix, label "PDF App Dev").
- `AndroidManifest.xml`: flavor-driven app label; **no `INTERNET` permission** (offline-first).
- `pubspec.yaml`: added flutter_riverpod, go_router, sqflite, path, path_provider,
  shared_preferences, logger, package_info_plus, intl, flutter_localizations; dev:
  sqflite_common_ffi. `generate: true`, assets registered.
- `analysis_options.yaml` from engineering standard §16.1. `l10n.yaml`. `.gitignore` extended
  with keystore + artifact + symbol rules (guideline §2.3, standard §20.4).

### Config, constants, flavor
- `assets/config/app_config.json` + `lib/core/config/app_config.dart` (`AppConfig`) +
  `lib/core/config/config_service.dart` (`ConfigService`) — the fixed About pattern (guideline §1).
- `lib/core/constants/app_constants.dart` (`AppConstants`).
- `lib/app/config/app_flavor_config.dart` (`AppFlavor`, `AppFlavorConfig`, two-variable pattern).

### Core services
- `AppLogger` (logger package, level taxonomy, dev-gated verbose).
- Sealed `AppException` (`StorageException`, `ValidationException`, `PdfException`) +
  `SafeErrorFallback` widget.
- `AppLifecycleService` (`WidgetsBindingObserver`).
- `AppDatabase` (WAL + FKs in `onConfigure`, transactional migration runner) + `migrations.dart`
  (schema **v1** = `meta` base table).

### App shell
- Theme: `tokens.dart` + `app_theme.dart` (Material 3 light/dark/sepia, `AppThemeMode`).
- Routing: `app_router.dart` (go_router, `AppRoute` enum, centralized).
- Localization: `app_en.arb` + `app_ml.arb` (English + Malayalam) with generated accessors.
- `app.dart` (`MaterialApp.router`) and thin `main.dart` init sequence.
- Riverpod root providers (`sharedPreferencesProvider`, `appConfigProvider`,
  `appDatabaseProvider`, `themeModeProvider`), overridden in `main()`.

### Screens
- Home (empty placeholder), Settings (theme choice via `RadioGroup`), About (data-driven from
  `ConfigService`, loops `details`).

### Tests (mirror `lib/`)
- `AppConfig.fromJson`, `ConfigService.load` (degrade paths), `AppFlavorConfig`, `AppException`,
  `AppDatabase` (open/WAL/FK/migrate/idempotent), About widget (dynamic details). **15 tests pass.**

### Docs
- `README.md` (setup, flavors, tests, migrations, build) and `docs/architecture.md` (engineering
  architecture record, schema version = 1).

## Verification
- `dart format .` — clean.
- `flutter analyze` — no issues.
- `flutter test` — 15 passed.
- `flutter build apk --flavor dev --debug` — built `app-dev-debug.apk`.

## Decisions & deviations
- Global error handlers installed **before** logging/db in `main()` (small reorder of standard
  §4.5) so early failures are captured.
- Desktop FFI DB init omitted from `main()` (Android-only app); tests init FFI themselves.
- `synthetic-package` removed from `l10n.yaml` (deprecated/no effect in Flutter 3.41).
- Settings uses the new `RadioGroup` API (old `RadioListTile.groupValue/onChanged` deprecated
  after 3.32).

## Known issues / follow-ups
- App not yet launched on a device/emulator — visual confirmation of screens deferred to Phase 1.
- Kotlin incremental-compile warnings due to project (L:) and pub cache (H:) on different drives;
  non-fatal, APK builds. Monitor.
- Real release signing config deferred to Phase 8.
