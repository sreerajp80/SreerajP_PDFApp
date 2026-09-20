# Plan: Adhere Source Code to Engineering and Design Guidelines Strictly

**Status:** Proposed
**Date:** 2026-09-20 11:35:00
**Target Files:**
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ml.arb`
- `lib/l10n/app_sa.arb`
- `lib/features/viewer/presentation/viewer_screen.dart`
- `lib/features/viewer/presentation/widgets/password_prompt.dart`
- `lib/features/viewer/presentation/widgets/outline_drawer.dart`
- `lib/features/page_ops/presentation/widgets/unlock_dialog.dart`
- `lib/features/page_ops/presentation/widgets/protect_dialog.dart`
- `lib/features/page_ops/presentation/widgets/batch_operations_dialog.dart`
- `lib/features/page_ops/presentation/widgets/page_ops_help_screen.dart`
- `lib/features/signature/presentation/widgets/signature_detail_sheet.dart`
- `lib/features/reading/presentation/widgets/malayalam_input_helper.dart`
- `lib/features/settings/presentation/permissions_screen.dart`
- `lib/features/settings/presentation/accent_color_screen.dart`
- `lib/features/annotation/presentation/widgets/annotation_toolbar.dart`
- `lib/features/annotation/presentation/widgets/bookmarks_panel.dart`
- `lib/features/annotation/presentation/widgets/annotation_overlay_notice.dart`
- `lib/features/help/presentation/signatures_help_screen.dart`
- `lib/features/help/presentation/privacy_storage_help_screen.dart`
- `lib/features/help/presentation/page_ops_help_screen.dart`
- `lib/features/about/presentation/about_screen.dart`
- `lib/core/config/app_config.dart`
- `test/l10n/translation_parity_test.dart`
- `test/l10n/label_length_test.dart`

---

## 1. Issue Description

A comprehensive audit of the project against the shared Flutter engineering guidelines (`docs/guidelines/`) identified several areas that need strict compliance:

1. **Tooltips on Icon-Only Controls (Standard §7.8)**:
   - `PopupMenuButton` in `viewer_screen.dart` lacks a localized `tooltip:`.
   - Password visibility toggle `IconButton`s in `password_prompt.dart`, `unlock_dialog.dart`, and `protect_dialog.dart` lack `tooltip:`.
   - Close `IconButton` in `signature_detail_sheet.dart` and `malayalam_input_helper.dart` lacks `tooltip:`.
   - Remove document `IconButton` in `batch_operations_dialog.dart` lacks `tooltip:`.
   - Color swatches in `accent_color_screen.dart` and `annotation_toolbar.dart` are icon/interactive swatches without tooltips.

2. **Touch Target Sizing (Standard §7.1)**:
   - Color swatches in `accent_color_screen.dart` (44x44) and `annotation_toolbar.dart` (30x30) are smaller than the mandatory 48x48 dp minimum interactive hit area.

3. **String Externalization & Hardcoded String Literals (Standard §8.2)**:
   - `annotation_toolbar.dart` contains hardcoded English color names (`'Yellow'`, `'Green'`, `'Blue'`, `'Red'`, `'Purple'`, `'Orange'`).
   - `about_screen.dart` contains hardcoded English text in `'${config.version} (build ${config.build})'`.

4. **Hardcoded Color Literals in Widget Build Methods (Standard §6.1)**:
   - `permissions_screen.dart` hardcodes `Color(0xFF10B981)`, `Color(0xFF3B82F6)`, `Color(0xFF8B5CF6)`.
   - `signatures_help_screen.dart`, `privacy_storage_help_screen.dart`, and `page_ops_help_screen.dart` hardcode `Color(0xFF1565C0)`, `Color(0xFF6A1B9A)`, `Color(0xFF2E7D32)`.

5. **RTL Directional Padding and Alignment (Standard §8.8)**:
   - `outline_drawer.dart` uses `EdgeInsets.only(left: ...)` instead of `EdgeInsetsDirectional.only(start: ...)`.
   - `malayalam_input_helper.dart` uses `Alignment.centerLeft` instead of `AlignmentDirectional.centerStart`.
   - `bookmarks_panel.dart` and `annotation_overlay_notice.dart` use asymmetric `EdgeInsets.fromLTRB` instead of `EdgeInsetsDirectional.fromSTEB`.

6. **Documentation and Verification Gaps (Standard §8.6, §8.7)**:
   - `test/l10n/translation_parity_test.dart` (required by §8.7) is missing.
   - `test/l10n/label_length_test.dart` (required by §8.6) is missing.
   - `AppConfig` docstring in `app_config.dart` omits `'sa'`.

---

## 2. Proposed Changes

### A. Localization & ARB Parity (`lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb`)
- Add new keys across all three languages with authentic translations:
  - `menuTooltip`: "Menu" / "മെനു" / "सूची"
  - `tooltipShowPassword`: "Show password" / "പാസ്‌വേഡ് കാണിക്കുക" / "कूटशब्दः दृश्यताम्"
  - `tooltipHidePassword`: "Hide password" / "പാസ്‌വേഡ് മറയ്ക്കുക" / "कूटशब्दः गोप्यताम्"
  - `colorYellow`: "Yellow" / "മഞ്ഞ" / "पीतः"
  - `colorGreen`: "Green" / "പച്ച" / "हरितः"
  - `colorBlue`: "Blue" / "നീല" / "नीलः"
  - `colorRed`: "Red" / "ചുവപ്പ്" / "रक्तः"
  - `colorPurple`: "Purple" / "വയലറ്റ്" / "धूम्रः"
  - `colorOrange`: "Orange" / "ഓറഞ്ച്" / "काषायः"
  - `aboutVersionBuild`: "{version} (build {build})" / "{version} (നിർമ്മിതി {build})" / "{version} (निर्मितिसङ्ख्या {build})"
- Run `flutter gen-l10n` to regenerate typed localization accessors.

### B. Tooltips & Accessibility Hit Areas
- Add `tooltip: l10n.menuTooltip` to `PopupMenuButton<_ViewerMenu>` in `viewer_screen.dart`.
- Add `tooltip: _obscure ? l10n.tooltipShowPassword : l10n.tooltipHidePassword` to password suffix `IconButton`s in `password_prompt.dart`, `unlock_dialog.dart`, `protect_dialog.dart`.
- Add `tooltip: l10n.dismissAction` to close button in `signature_detail_sheet.dart`.
- Add `tooltip: l10n.cancelAction` to close button in `malayalam_input_helper.dart`.
- Add `tooltip: l10n.removeAction` to remove button in `batch_operations_dialog.dart`.
- In `accent_color_screen.dart`, wrap swatches in 48x48 hit targets and add `Tooltip` + `Semantics`.
- In `annotation_toolbar.dart`, wrap color swatches in 48x48 hit targets, add `Tooltip`, and use localized color names.

### C. Eliminate Hardcoded Color Literals
- In `permissions_screen.dart`, replace raw color constants with theme semantic colors.
- In `signatures_help_screen.dart`, `privacy_storage_help_screen.dart`, and `page_ops_help_screen.dart`, replace hardcoded colors with `Theme.of(context).colorScheme` containers.

### D. RTL Directional Adaptations
- In `outline_drawer.dart`, change `EdgeInsets.only(left: ...)` to `EdgeInsetsDirectional.only(start: ...)`.
- In `malayalam_input_helper.dart`, change `Alignment.centerLeft` to `AlignmentDirectional.centerStart`.
- In `bookmarks_panel.dart` and `annotation_overlay_notice.dart`, change asymmetric `EdgeInsets.fromLTRB` to `EdgeInsetsDirectional.fromSTEB`.

### E. About Screen & Config Fixes
- In `about_screen.dart`, use `l10n.aboutVersionBuild(config.version, config.build)`.
- In `app_config.dart`, update docstring to mention `'sa'`.

### F. Automated Verification Tests
- Create `test/l10n/translation_parity_test.dart` to continuously verify ARB key parity and `app_config.json` parity.
- Create `test/l10n/label_length_test.dart` to verify short-label length budget.

---

## 3. Verification Plan

1. Run `flutter gen-l10n` to ensure all ARB updates generate cleanly.
2. Run `flutter analyze` to ensure zero warnings.
3. Run `flutter test` to ensure all tests (including new parity and label length tests) pass.
4. Verify all icon buttons and interactive controls have tooltips and minimum 48x48 dp hit targets.
