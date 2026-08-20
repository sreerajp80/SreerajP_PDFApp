# Plan: Appearance Settings Cards (Theme, Typography, Accent Color, App Color)

**Status:** Proposed  
**Date:** 2026-08-19  

## Overview
The user requested adding all appearance options to the Appearance screen under Settings to match the requested design:
1. **Theme Mode** (`തീം മോഡ്` / `Theme Mode`)
2. **Typography and Text Size** (`ടൈപോഗ്രാഫിയും ടെക്സ്റ്റ് വലിപ്പവും` / `Typography and Text Size`)
3. **Accent Color** (`ആക്സന്റ് നിറം` / `Accent Color`)
4. **App Color** (`ആപ്പിന്റെ നിറം` / `App Color`)

---

## Files to Modify / Create

### 1. New Screens
- `lib/features/settings/presentation/typography_screen.dart` [NEW]: Font family selection, text scale factor slider/presets, live preview card with English and Malayalam samples, reset to default.
- `lib/features/settings/presentation/app_color_screen.dart` [NEW]: Page background and card surface tone presets and custom controls, live preview, reset to default.

### 2. Update Existing Files
- `lib/features/settings/presentation/appearance_screen.dart`: Update cards to include all 4 sections with their respective icons, titles, subtitles, and navigation routes.
- `lib/app/routing/app_router.dart`: Add `AppRoute.typography` and `AppRoute.appColor` routes.
- `lib/core/constants/app_constants.dart`: Add preference keys for font family, text scale, and app background/card tone.
- `lib/app/config/providers.dart`: Add Riverpod notifiers and providers for font family, text scale factor, and app color preferences.
- `lib/app/theme/app_theme.dart`: Integrate font family and surface tone adjustments into theme generation.
- `lib/app/app.dart`: Apply text scale factor and typography to `MaterialApp.router`.
- `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb`: Add localization entries for Typography and App Color titles, subtitles, descriptions, and preset labels.

### 3. Unit and Widget Tests
- `test/features/settings/presentation/appearance_screen_test.dart`: Test all 4 cards in AppearanceScreen.
- `test/features/settings/presentation/typography_screen_test.dart` [NEW]: Test typography and font scale options.
- `test/features/settings/presentation/app_color_screen_test.dart` [NEW]: Test app background & card color options.

---

## Verification Plan
1. Run `flutter gen-l10n` to regenerate localizations.
2. Run `flutter analyze` to ensure zero warnings.
3. Run `flutter test` to ensure all unit and widget tests pass.
