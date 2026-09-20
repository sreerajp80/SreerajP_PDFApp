# Change Log: Strict Adherence to Project Structure Guidelines

**Date:** 2026-09-20 10:26:00  
**Plan Reference:** `plans/20260920_102000_adhere_project_structure_guidelines.md`

## Summary of Changes

Made the project structure adhere strictly to the guidelines in `docs/guidelines/` (`guideline.md` and `flutter_project_engineering_standard.md §3`), `docs/project_structure.md`, and `AGENTS.md`.

### 1. Test Suite Reorganization (`test/`)
Moved tests to their exact mirrored paths matching `lib/`:
- Moved `test/widget/about_screen_test.dart` to `test/features/about/presentation/about_screen_test.dart` and removed `test/widget/`.
- Moved `test/app/theme_test.dart` to `test/app/theme/theme_test.dart`.
- Moved `test/core/malayalam_transliteration_test.dart` to `test/core/search/malayalam_transliteration_test.dart`.
- Moved `test/features/annotation/annotation_dao_test.dart` to `test/features/annotation/data/annotation_dao_test.dart`.
- Moved `test/features/annotation/annotation_geometry_test.dart` to `test/features/annotation/domain/annotation_geometry_test.dart`.
- Moved `test/features/annotation/annotation_serialization_test.dart` to `test/features/annotation/domain/annotation_serialization_test.dart`.
- Moved `test/features/extraction/extraction_service_test.dart` to `test/features/extraction/data/extraction_service_test.dart`.
- Moved `test/features/page_ops/page_ops_service_test.dart` to `test/features/page_ops/data/page_ops_service_test.dart`.
- Moved `test/features/page_ops/page_ops_service_enhancements_test.dart` to `test/features/page_ops/data/page_ops_service_enhancements_test.dart`.
- Moved `test/features/printer/import_screen_test.dart` to `test/features/printer/presentation/import_screen_test.dart`.
- Moved `test/features/printer/pdf_builder_service_test.dart` to `test/features/printer/data/pdf_builder_service_test.dart`.
- Moved `test/features/printer/print_service_test.dart` to `test/features/printer/data/print_service_test.dart`.
- Moved `test/features/printer/print_sheet_test.dart` to `test/features/printer/presentation/print_sheet_test.dart`.
- Moved `test/features/printer/web_content_cleaner_test.dart` to `test/features/printer/data/web_content_cleaner_test.dart`.
- Moved `test/features/reading/reading_velocity_test.dart` to `test/features/reading/domain/reading_velocity_test.dart`.
- Moved `test/features/signature/signature_badge_test.dart` to `test/features/signature/presentation/signature_badge_test.dart`.
- Moved `test/features/signature/signature_repository_test.dart` to `test/features/signature/data/signature_repository_test.dart`.
- Moved `test/features/signature/signature_trust_evaluator_test.dart` to `test/features/signature/domain/signature_trust_evaluator_test.dart`.
- Moved `test/features/signature/signatures_screen_test.dart` to `test/features/signature/presentation/signatures_screen_test.dart`.
- Moved `test/features/signature/trust_store_dao_test.dart` to `test/features/signature/data/trust_store_dao_test.dart`.
- Moved `test/features/signature/trust_store_export_test.dart` to `test/features/signature/data/trust_store_export_test.dart`.
- Moved `test/features/viewer/page_layouts_test.dart` to `test/features/viewer/presentation/page_layouts_test.dart`.

### 2. Core Widgets (`lib/core/widgets/`)
- Created `lib/core/widgets/made_with_love.dart`:
  - Implemented the `MadeWithLove` widget per `guideline.md §1.7`.
  - Added `test/core/widgets/made_with_love_test.dart` to verify rendering and semantics.

### 3. About Screen Constants & Localization (`lib/core/config/`, `assets/config/`, `lib/l10n/`, `lib/features/about/`)
- Updated `lib/core/config/app_config.dart`:
  - Added `LocalizedText` model with `plain`, `byLocale`, `resolve`, and `fromJson`.
  - Updated `AppConfig` to use `LocalizedText description` and `Map<String, LocalizedText> details` per `guideline.md §1.4`.
- Updated `assets/config/app_config.json`:
  - Detail keys converted to lowercase identifiers (`author`, `email`, `license`, `aiUsed`, `ideUsed`).
  - Added localized descriptions for English and Malayalam per `guideline.md §1.2`.
- Updated `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb`:
  - Added `aboutDetailAuthor`, `aboutDetailEmail`, `aboutDetailLicense`, `aboutDetailAiUsed`, `aboutDetailIdeUsed`.
  - Added `madeWithLove` and `madeWithLoveA11y`.
  - Regenerated localizations with `flutter gen-l10n`.
- Updated `lib/features/about/presentation/about_screen.dart`:
  - Details rendered dynamically with `aboutDetailLabel(l10n, entry.key)` and `entry.value.resolve(lang)`.
  - Added `MadeWithLove` badge at the bottom per `guideline.md §1.7`.
- Updated `test/core/config/app_config_test.dart` and `test/features/about/presentation/about_screen_test.dart`.

### 4. Project Structure Documentation (`docs/project_structure.md`)
- Updated `docs/project_structure.md` to include `lib/core/widgets/` and documented the exact test suite mirroring structure.

## Verification
- Ran `flutter gen-l10n` — successful.
- Ran `dart format .` — clean.
- Ran `flutter analyze` — zero issues found.
- Ran `flutter test` — all 393 tests passed cleanly.
