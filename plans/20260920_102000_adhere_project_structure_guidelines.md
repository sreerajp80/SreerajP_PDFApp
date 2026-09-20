# Plan: Strict Adherence to Project Structure Guidelines

**Status:** Pending Approval

## 1. Overview and Problem Statement

The project structure guidelines are defined in `docs/guidelines/` (`guideline.md` and `flutter_project_engineering_standard.md §3`), as well as `docs/project_structure.md` and `AGENTS.md`.

An audit of the codebase reveals several areas where project structure deviates from these guidelines:

1. **Test Directory Mirroring (`test/`)**:
   - The testing standard (`flutter_project_engineering_standard.md §3.2`, `§18.2` and `AGENTS.md`) requires that `test/` mirrors `lib/` directory structure closely.
   - Currently, several test files are placed directly in parent folders or non-mirroring folders:
     - `test/widget/about_screen_test.dart` is in `test/widget/` instead of mirroring `lib/features/about/presentation/about_screen.dart`.
     - `test/app/theme_test.dart` is in `test/app/` instead of `test/app/theme/`.
     - `test/core/malayalam_transliteration_test.dart` is directly in `test/core/` instead of `test/core/search/`.
     - Multiple feature tests under `test/features/` (`annotation`, `extraction`, `page_ops`, `printer`, `reading`, `signature`, `viewer`) sit at the feature root rather than their corresponding `data/`, `domain/`, or `presentation/` folders.

2. **Core Widgets Layout (`lib/core/widgets/`)**:
   - `flutter_project_engineering_standard.md §3.1` (Tier 2: Feature-First) explicitly defines `lib/core/widgets/` for shared core widgets across features.
   - `guideline.md §1.7` requires the standard "Made with ❤️ from India" badge widget (`MadeWithLove`) for the About screen. Currently, `lib/core/widgets/` is missing and `MadeWithLove` is not implemented.

3. **About Screen Constants & Localization Structure (`guideline.md §1`)**:
   - `guideline.md §1.2` requires detail keys in `assets/config/app_config.json` to be identifiers (`lowerCamelCase`), with prose text using locale maps (`{"en": ..., "ml": ...}`).
   - `guideline.md §1.4` requires `AppConfig` to support `LocalizedText` for `description` and `details`.
   - `guideline.md §1.6` requires `AboutScreen` to dynamically render details with localized labels (`aboutDetail<Key>`) and values resolved against the active language.
   - `guideline.md §1.7` requires `AboutScreen` to end with `MadeWithLove`.

4. **Project Structure Documentation (`docs/project_structure.md`)**:
   - `docs/project_structure.md` needs to reflect `lib/core/widgets/` and the complete test mirroring structure.

---

## 2. Proposed Changes

### Component 1: Test Suite Reorganization (`test/`)
Move tests to their exact mirrored paths matching `lib/`:
- Move `test/widget/about_screen_test.dart` -> `test/features/about/presentation/about_screen_test.dart`
- Remove empty `test/widget/` directory
- Move `test/app/theme_test.dart` -> `test/app/theme/theme_test.dart`
- Move `test/core/malayalam_transliteration_test.dart` -> `test/core/search/malayalam_transliteration_test.dart`
- Move `test/features/annotation/annotation_dao_test.dart` -> `test/features/annotation/data/annotation_dao_test.dart`
- Move `test/features/annotation/annotation_geometry_test.dart` -> `test/features/annotation/domain/annotation_geometry_test.dart`
- Move `test/features/annotation/annotation_serialization_test.dart` -> `test/features/annotation/domain/annotation_serialization_test.dart`
- Move `test/features/extraction/extraction_service_test.dart` -> `test/features/extraction/data/extraction_service_test.dart`
- Move `test/features/page_ops/page_ops_service_test.dart` -> `test/features/page_ops/data/page_ops_service_test.dart`
- Move `test/features/page_ops/page_ops_service_enhancements_test.dart` -> `test/features/page_ops/data/page_ops_service_enhancements_test.dart`
- Move `test/features/printer/import_screen_test.dart` -> `test/features/printer/presentation/import_screen_test.dart`
- Move `test/features/printer/pdf_builder_service_test.dart` -> `test/features/printer/data/pdf_builder_service_test.dart`
- Move `test/features/printer/print_service_test.dart` -> `test/features/printer/data/print_service_test.dart`
- Move `test/features/printer/print_sheet_test.dart` -> `test/features/printer/presentation/print_sheet_test.dart`
- Move `test/features/printer/web_content_cleaner_test.dart` -> `test/features/printer/data/web_content_cleaner_test.dart`
- Move `test/features/reading/reading_velocity_test.dart` -> `test/features/reading/domain/reading_velocity_test.dart`
- Move `test/features/signature/signature_badge_test.dart` -> `test/features/signature/presentation/signature_badge_test.dart`
- Move `test/features/signature/signature_repository_test.dart` -> `test/features/signature/data/signature_repository_test.dart`
- Move `test/features/signature/signature_trust_evaluator_test.dart` -> `test/features/signature/domain/signature_trust_evaluator_test.dart`
- Move `test/features/signature/signatures_screen_test.dart` -> `test/features/signature/presentation/signatures_screen_test.dart`
- Move `test/features/signature/trust_store_dao_test.dart` -> `test/features/signature/data/trust_store_dao_test.dart`
- Move `test/features/signature/trust_store_export_test.dart` -> `test/features/signature/data/trust_store_export_test.dart`
- Move `test/features/viewer/page_layouts_test.dart` -> `test/features/viewer/presentation/page_layouts_test.dart`

### Component 2: Core Widgets (`lib/core/widgets/`)
- Create `lib/core/widgets/made_with_love.dart`:
  - Implement `MadeWithLove` widget using `l10n.madeWithLove`, `WidgetSpan` with red `Icons.favorite`, and `Semantics(label: l10n.madeWithLoveA11y)`.
- Create `test/core/widgets/made_with_love_test.dart` to verify rendering and accessibility semantics.

### Component 3: About Screen & Config Guidelines (`lib/core/config/`, `assets/config/`, `lib/features/about/`, `lib/l10n/`)
- Update `lib/core/config/app_config.dart`:
  - Implement `LocalizedText` with `plain`, `byLocale`, `resolve(languageCode)`, and `fromJson`.
  - Update `AppConfig` to use `LocalizedText description` and `Map<String, LocalizedText> details`.
- Update `assets/config/app_config.json`:
  - Detail keys as `author`, `email`, `license`, `aiUsed`, `ideUsed`.
  - Localized prose for `description` and `license`.
- Update `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb`:
  - Add `aboutDetailAuthor`, `aboutDetailEmail`, `aboutDetailLicense`, `aboutDetailAiUsed`, `aboutDetailIdeUsed`.
  - Add `madeWithLove` and `madeWithLoveA11y`.
- Regenerate localizations with `flutter gen-l10n`.
- Update `lib/features/about/presentation/about_screen.dart`:
  - Dynamic detail rendering with `aboutDetailLabel` and `entry.value.resolve(lang)`.
  - Render `MadeWithLove` at the bottom.
- Update `test/core/config/app_config_test.dart` and `test/features/about/presentation/about_screen_test.dart`.

### Component 4: Documentation Alignment (`docs/project_structure.md`)
- Update `docs/project_structure.md`:
  - Include `lib/core/widgets/` in Section 2.
  - Clarify the test suite mirroring structure in Section 1.

---

## 3. Files to Change

- `lib/core/widgets/made_with_love.dart` (new)
- `lib/core/config/app_config.dart` (modify)
- `assets/config/app_config.json` (modify)
- `lib/l10n/app_en.arb` (modify)
- `lib/l10n/app_ml.arb` (modify)
- `lib/features/about/presentation/about_screen.dart` (modify)
- `docs/project_structure.md` (modify)
- `test/widget/about_screen_test.dart` (delete / move to `test/features/about/presentation/about_screen_test.dart`)
- `test/app/theme_test.dart` (delete / move to `test/app/theme/theme_test.dart`)
- `test/core/malayalam_transliteration_test.dart` (delete / move to `test/core/search/malayalam_transliteration_test.dart`)
- `test/core/widgets/made_with_love_test.dart` (new)
- `test/core/config/app_config_test.dart` (modify)
- `test/features/annotation/annotation_dao_test.dart` (delete / move to `test/features/annotation/data/annotation_dao_test.dart`)
- `test/features/annotation/annotation_geometry_test.dart` (delete / move to `test/features/annotation/domain/annotation_geometry_test.dart`)
- `test/features/annotation/annotation_serialization_test.dart` (delete / move to `test/features/annotation/domain/annotation_serialization_test.dart`)
- `test/features/extraction/extraction_service_test.dart` (delete / move to `test/features/extraction/data/extraction_service_test.dart`)
- `test/features/page_ops/page_ops_service_test.dart` (delete / move to `test/features/page_ops/data/page_ops_service_test.dart`)
- `test/features/page_ops/page_ops_service_enhancements_test.dart` (delete / move to `test/features/page_ops/data/page_ops_service_enhancements_test.dart`)
- `test/features/printer/import_screen_test.dart` (delete / move to `test/features/printer/presentation/import_screen_test.dart`)
- `test/features/printer/pdf_builder_service_test.dart` (delete / move to `test/features/printer/data/pdf_builder_service_test.dart`)
- `test/features/printer/print_service_test.dart` (delete / move to `test/features/printer/data/print_service_test.dart`)
- `test/features/printer/print_sheet_test.dart` (delete / move to `test/features/printer/presentation/print_sheet_test.dart`)
- `test/features/printer/web_content_cleaner_test.dart` (delete / move to `test/features/printer/data/web_content_cleaner_test.dart`)
- `test/features/reading/reading_velocity_test.dart` (delete / move to `test/features/reading/domain/reading_velocity_test.dart`)
- `test/features/signature/signature_badge_test.dart` (delete / move to `test/features/signature/presentation/signature_badge_test.dart`)
- `test/features/signature/signature_repository_test.dart` (delete / move to `test/features/signature/data/signature_repository_test.dart`)
- `test/features/signature/signature_trust_evaluator_test.dart` (delete / move to `test/features/signature/domain/signature_trust_evaluator_test.dart`)
- `test/features/signature/signatures_screen_test.dart` (delete / move to `test/features/signature/presentation/signatures_screen_test.dart`)
- `test/features/signature/trust_store_dao_test.dart` (delete / move to `test/features/signature/data/trust_store_dao_test.dart`)
- `test/features/signature/trust_store_export_test.dart` (delete / move to `test/features/signature/data/trust_store_export_test.dart`)
- `test/features/viewer/page_layouts_test.dart` (delete / move to `test/features/viewer/presentation/page_layouts_test.dart`)

---

## 4. Verification Plan

1. Run `flutter gen-l10n` to regenerate localization classes.
2. Run `dart format .` to verify formatting across all files.
3. Run `flutter analyze` to ensure zero errors and zero warnings.
4. Run `flutter test` to ensure all unit and widget tests pass cleanly in their new mirrored locations.
