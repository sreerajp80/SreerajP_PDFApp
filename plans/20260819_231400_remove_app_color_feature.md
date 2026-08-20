# Plan: Remove App Color Feature

**Status:** Proposed  
**Date:** 2026-08-19  

## Overview
Completely remove the "App Color" (custom page background / card color) feature as requested, keeping only Theme Mode, Typography & Text Size, and Accent Color under Appearance.

---

## Files to Modify / Delete

### 1. Routes & Presentation
- **`lib/features/settings/presentation/appearance_screen.dart`**: Remove the `SettingsNavCard` for App Color.
- **`lib/app/routing/app_router.dart`**: Remove `AppRoute.appColor` and its GoRoute `/settings/app-color`.
- **`lib/features/settings/presentation/app_color_screen.dart`** [DELETE]: Remove the screen.
- **`test/features/settings/presentation/app_color_screen_test.dart`** [DELETE]: Remove the test file.

### 2. State & Core
- **`lib/app/config/providers.dart`**: Remove `lightBaseProvider` and `darkBaseProvider`.
- **`lib/core/constants/app_constants.dart`**: Remove `prefBaseLight` and `prefBaseDark`.
- **`lib/app/theme/app_theme.dart`**: Remove base color customizations (`normalizeBase`, `presetLightBases`, `presetDarkBases`, etc.).
- **`lib/app/app.dart`**: Remove base color references from `ResolvedTheme.of`.

### 3. Localization
- **`lib/l10n/app_en.arb`** & **`lib/l10n/app_ml.arb`**: Clean up unused `appColor*` keys and run `flutter gen-l10n`.

### 4. Tests
- Update `test/features/settings/presentation/appearance_screen_test.dart` to expect the 3 remaining cards (Theme Mode, Typography, Accent Color).

---

## Verification Plan
1. `flutter gen-l10n`
2. `flutter analyze`
3. `flutter test`
