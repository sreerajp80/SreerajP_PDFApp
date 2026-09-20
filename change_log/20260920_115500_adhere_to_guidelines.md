# Change Log: Adhere to Project Guidelines

**Date:** 2026-09-20 11:55:00  
**Referenced Plan:** [plans/20260920_113500_adhere_to_guidelines.md](plans/20260920_113500_adhere_to_guidelines.md)

## Summary of Changes

1. **Localization Completeness & Key Parity**:
   - Added missing keys across all three supported languages (`lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb`):
     - `menuTooltip` (for popup menu buttons)
     - `tooltipShowPassword` & `tooltipHidePassword` (for password visibility toggle buttons)
     - `colorYellow`, `colorGreen`, `colorBlue`, `colorRed`, `colorPurple`, `colorOrange` (for color swatch labels and tooltips)
     - `aboutVersionBuild` (for version and build number formatting without raw strings)
     - `closeAction` (for closing sheets and helper bars)
     - `removeAction` (for removing items from batch lists)
   - Updated Sanskrit `madeWithLove` and `madeWithLoveA11y` in `lib/l10n/app_sa.arb` to use the verbatim standard phrasing (`सस्नेहं निर्मितम् {heart} भारततः` and `सस्नेहं निर्मितम् भारततः`).
   - Regenerated localization bindings with `flutter gen-l10n`.

2. **Hardcoded String and UI Tooltip Cleanups**:
   - `lib/features/about/presentation/about_screen.dart`: Replaced the hardcoded `"build"` string literal with `l10n.aboutVersionBuild(config.version, config.build)`.
   - `lib/core/config/app_config.dart`: Updated the docstring to list the three supported language codes: `'en'`, `'ml'`, `'sa'`.
   - `lib/features/viewer/presentation/viewer_screen.dart`: Added `tooltip: l10n.menuTooltip` to the viewer options `PopupMenuButton`.
   - `lib/features/viewer/presentation/widgets/password_prompt.dart`, `lib/features/page_ops/presentation/widgets/unlock_dialog.dart`, and `lib/features/page_ops/presentation/widgets/protect_dialog.dart`: Added dynamic tooltips (`l10n.tooltipShowPassword` / `l10n.tooltipHidePassword`) to password visibility toggle buttons.
   - `lib/features/signature/presentation/widgets/signature_detail_sheet.dart`: Added `tooltip: l10n.closeAction` to the close button.
   - `lib/features/reading/presentation/widgets/malayalam_input_helper.dart`: Added `tooltip: l10n.closeAction` to the close button.
   - `lib/features/page_ops/presentation/widgets/batch_operations_dialog.dart`: Added `tooltip: l10n.removeAction` to the document remove button.

3. **Accessibility & Touch Target Standards**:
   - `lib/features/settings/presentation/accent_color_screen.dart`: Wrapped the color swatch tap target in a 48x48 box, added an accessible `Tooltip`, and attached a `Semantics` label.
   - `lib/features/annotation/presentation/widgets/annotation_toolbar.dart`: Wrapped color swatches in 48x48 tap targets, added localized tooltips, and attached accessibility semantics.

4. **Theme & Semantic Color System Compliance**:
   - `lib/features/settings/presentation/permissions_screen.dart`: Replaced hardcoded color values with semantic colors from `Theme.of(context).colorScheme` (`primary`, `secondary`, `tertiary`).
   - `lib/features/help/presentation/signatures_help_screen.dart`, `lib/features/help/presentation/privacy_storage_help_screen.dart`, and `lib/features/help/presentation/page_ops_help_screen.dart`: Replaced hardcoded info box colors with `theme.colorScheme.primaryContainer` and `theme.colorScheme.primary`.

5. **Bidirectional & RTL Layout Alignment**:
   - `lib/features/viewer/presentation/widgets/outline_drawer.dart`: Replaced asymmetric `EdgeInsets.only(left: ...)` with `EdgeInsetsDirectional.only(start: ...)`.
   - `lib/features/annotation/presentation/widgets/bookmarks_panel.dart` and `lib/features/annotation/presentation/widgets/annotation_overlay_notice.dart`: Replaced `EdgeInsets.fromLTRB` with `EdgeInsetsDirectional.fromSTEB`.
   - `lib/features/reading/presentation/widgets/malayalam_input_helper.dart`: Replaced `Alignment.centerLeft` with `AlignmentDirectional.centerStart`.

6. **Automated Localization & Quality Assurance Tests**:
   - Added `test/l10n/translation_parity_test.dart` per standard §8.7:
     - Tests ARB key parity across English, Malayalam, and Sanskrit.
     - Tests that translations do not match English (allowing only approved brand names and symbols).
     - Tests that `{heart}` badge placeholder is retained in all languages.
     - Tests multilingual fields in `assets/config/app_config.json` against ARB detail labels.
     - Tests content twin asset parity.
   - Added `test/l10n/label_length_test.dart` per standard §8.6:
     - Tests grapheme cluster count on short-key labels (`action`, `label`, `title`, `tab`, `nav`, `tooltip`) against the standard budgets (20 chars for `en`, 22 for `ml` and `sa`).

## Verification
- `flutter gen-l10n` passed with 0 errors.
- `dart format .` formatted all modified code.
- `flutter analyze` passed with 0 issues.
- `flutter test` passed all 406 automated tests.
