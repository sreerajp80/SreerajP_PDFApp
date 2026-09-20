# Plan: Enforce Sanskrit and Localized App Config

**Status:** Pending Approval

## 1. Overview and Problem Statement

The user requested:
1. Update `AGENTS.md` and `CLAUDE.md` to state:
   "The app supports English (`app_en.arb`), Malayalam (`app_ml.arb`), and Sanskrit (`app_sa.arb`)."
2. Update `assets/config/app_config.json` with Sanskrit (`sa`) and transliterations for `appName`, `author`, `aiUsed`, and `ideUsed`.
3. Update `lib/core/config/app_config.dart` so `appName` is a `LocalizedText`.
4. Add `lib/l10n/app_sa.arb` with full Sanskrit key parity (660 keys).

In addition, per `docs/guidelines/flutter_project_engineering_standard.md §8.3.1` and `§8.4`:
- Sanskrit lacks built-in Flutter Material/Cupertino localizations, requiring fallback delegates (`SaMaterialLocalizationsDelegate`, `SaCupertinoLocalizationsDelegate`, `SaWidgetsLocalizationsDelegate`).
- `LanguageScreen` must include Sanskrit (`Locale('sa')`, `संस्कृतम्`) in its language picker.
- Translation parity tests should be added to guarantee that `app_en.arb`, `app_ml.arb`, and `app_sa.arb` stay synchronized.

---

## 2. Proposed Changes

### Component 1: Root AI Instruction Files
- Update `AGENTS.md`, `.agents/AGENTS.md`, and `CLAUDE.md`:
  - Update the localization section to state that the app supports English (`app_en.arb`), Malayalam (`app_ml.arb`), and Sanskrit (`app_sa.arb`).

### Component 2: About Config Model, JSON Asset, and Presentation
- Update `assets/config/app_config.json`:
  - Provide `{"en": ..., "ml": ..., "sa": ...}` maps for `appName`, `description`, `author`, `license`, `aiUsed`, and `ideUsed`.
  - Keep `email`, `version`, and `build` as non-translatable fields.
- Update `lib/core/config/app_config.dart`:
  - Change `appName` from `final String appName` to `final LocalizedText appName`.
  - Parse `appName` using `LocalizedText.fromJson`.
  - Update `AppConfig.fallback`.
- Update `lib/features/about/presentation/about_screen.dart`:
  - Resolve `config.appName` using `config.appName.resolve(lang)`.
- Update `test/core/config/app_config_test.dart` and `test/features/about/presentation/about_screen_test.dart`.

### Component 3: Sanskrit Localization Infrastructure & ARB Files
- Create `lib/l10n/sa_material_localizations.dart`:
  - Implement `SaMaterialLocalizationsDelegate`, `SaCupertinoLocalizationsDelegate`, `SaWidgetsLocalizationsDelegate` providing English Material/Cupertino string fallbacks for `sa` per standard §8.3.1.
- Update `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb`:
  - Add `languageSanskrit` key.
- Create `lib/l10n/app_sa.arb`:
  - Complete Sanskrit translations for all 660 keys with 100% key parity with `app_en.arb` and `app_ml.arb`.
  - Adhere strictly to the Sanskrit quality rules, vocabulary, and grammar in `docs/guidelines/flutter_project_engineering_standard.md §8.5`.
- Run `flutter gen-l10n` to regenerate localizations.
- Update `lib/app/app.dart`:
  - Register the Sanskrit fallback delegates before global delegates.
- Update `lib/features/settings/presentation/language_screen.dart`:
  - Add a Sanskrit tile (`Locale('sa')`, `संस्कृतम्`) to the language picker.
- Add `test/features/settings/presentation/language_screen_test.dart` or update existing test to test Sanskrit selection.
- Add `test/core/widgets/sanskrit_delegates_test.dart` to verify Sanskrit Material/Cupertino fallbacks work without throwing.

---

## 3. Files to Change

- `AGENTS.md` (modify)
- `.agents/AGENTS.md` (modify)
- `CLAUDE.md` (modify)
- `assets/config/app_config.json` (modify)
- `lib/core/config/app_config.dart` (modify)
- `lib/features/about/presentation/about_screen.dart` (modify)
- `lib/l10n/sa_material_localizations.dart` (new)
- `lib/l10n/app_en.arb` (modify)
- `lib/l10n/app_ml.arb` (modify)
- `lib/l10n/app_sa.arb` (new)
- `lib/app/app.dart` (modify)
- `lib/features/settings/presentation/language_screen.dart` (modify)
- `test/core/config/app_config_test.dart` (modify)
- `test/features/about/presentation/about_screen_test.dart` (modify)
- `test/core/widgets/sanskrit_delegates_test.dart` (new)

---

## 4. Verification Plan

1. Run `flutter gen-l10n` to verify all three ARB files generate cleanly without errors.
2. Run `dart format .` to format all code.
3. Run `flutter analyze` to ensure zero warnings and zero errors.
4. Run `flutter test` to ensure all tests pass, including Sanskrit fallback and about screen tests.
