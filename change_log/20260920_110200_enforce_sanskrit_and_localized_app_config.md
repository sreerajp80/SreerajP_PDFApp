# Change Log: Enforce Sanskrit and Localized App Config

**Date:** 2026-09-20 11:22:00  
**Referenced Plan:** [plans/20260920_110200_enforce_sanskrit_and_localized_app_config.md](plans/20260920_110200_enforce_sanskrit_and_localized_app_config.md)

## Summary of Changes

1. **Config Localization (`assets/config/app_config.json`)**:
   - Updated `appName`, `description`, `author`, `license`, `aiUsed`, and `ideUsed` with trilingual entries (`en`, `ml`, `sa`) and transliterations.
   - Preserved metadata values (`version`, `build`, `email`, `repository`, `device`, `osVersion`, `target`).

2. **Core Config Model (`lib/core/config/app_config.dart`)**:
   - Changed `AppConfig.appName` from `String` to `LocalizedText`.
   - Updated `AppConfig.fromJson` to parse `appName` as either a `LocalizedText` (multilingual map) or plain string fallback.
   - Updated `AppConfig.fallback` with localized fallback text for `appName`.

3. **Presentation & Screen Updates**:
   - Updated `lib/features/about/presentation/about_screen.dart` to resolve `config.appName` dynamically using the current locale (`config.appName.resolve(lang)`).
   - Updated `lib/features/settings/presentation/language_screen.dart` to add Sanskrit (`संस्कृतम्`, `Locale('sa')`).
   - Updated `lib/app/app.dart` to register Sanskrit fallback delegates (`SaMaterialLocalizationsDelegate`, `SaCupertinoLocalizationsDelegate`, `SaWidgetsLocalizationsDelegate`).

4. **Sanskrit Fallback Delegates (`lib/l10n/sa_material_localizations.dart`)**:
   - Created Material, Cupertino, and Widgets localization fallback delegates for `Locale('sa')`.
   - Delegates fall back to Hindi (`Locale('hi')`) for framework-level strings (such as date pickers and standard dialog actions).

5. **Full Sanskrit ARB File (`lib/l10n/app_sa.arb`)**:
   - Generated pure classical Sanskrit translations for all 660 keys matching `app_en.arb` and `app_ml.arb`.
   - Verified zero forbidden Hindi markers across all strings.
   - Verified 100% parity of all 41 ICU placeholder sets.
   - Added `languageSanskrit` key across `app_en.arb`, `app_ml.arb`, and `app_sa.arb`.

6. **Agent Rules & Documentation**:
   - Updated `AGENTS.md`, `.agents/AGENTS.md`, and `CLAUDE.md` to state support for English (`app_en.arb`), Malayalam (`app_ml.arb`), and Sanskrit (`app_sa.arb`).

7. **Automated Tests**:
   - Updated `test/core/config/app_config_test.dart` to test `appName.resolve()` and trilingual map parsing.
   - Updated `test/core/config/config_service_test.dart` for localized `appName`.
   - Updated `test/features/about/presentation/about_screen_test.dart` for `LocalizedText` `appName`.
   - Added `test/l10n/sa_material_localizations_test.dart` to verify Sanskrit delegates and widget rendering in `Locale('sa')`.

## Verification
- `flutter gen-l10n` generated localizations cleanly for `en`, `ml`, and `sa`.
- `dart format .` formatted all files.
- `flutter analyze` passed with 0 issues.
- `flutter test` passed all 398 tests.
