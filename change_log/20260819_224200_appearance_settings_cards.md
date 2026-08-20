# Change Log: Appearance Settings Cards (Theme, Typography, Accent Color, App Color)

**Date:** 2026-08-19
**Plan:** `plans/20260819_223600_appearance_settings_cards.md`

---

## Summary of Changes

Implemented the 4 Appearance cards under **Settings → Appearance** matching the requested UI:

1. **Theme Mode** (`തീം മോഡ്` / `Theme Mode`):
   - Card displays icon, title, and quick selection subtitle.
   - Navigates to `/theme` (`ThemeScreen`).

2. **Typography & Text Size** (`ടൈപോഗ്രാഫിയും ടെക്സ്റ്റ് വലിപ്പവും` / `Typography & Text Size`):
   - Created `TypographyScreen` (`/settings/typography`).
   - Supports font family configuration (System Default, Sans-serif, Serif, Monospace).
   - Supports text scaling (Small 0.85x, Default 1.0x, Large 1.15x, Extra Large 1.3x, and slider 0.80x–1.40x).
   - Includes a live bilingual preview card (English & Malayalam) and reset option.

3. **Accent Color** (`ആക്സന്റ് നിറം` / `Accent Color`):
   - Presets, color wheel, live preview, and live accent indicator.
   - Navigates to `/accent-color` (`AccentColorScreen`).

4. **App Color** (`ആപ്പിന്റെ നിറം` / `App Color`):
   - Created `AppColorScreen` (`/settings/app-color`).
   - Supports page background and card surface tone presets (Material Default, Clean Paper, Warm Parchment, Cool Slate, Soft Forest, Deep Midnight).
   - Includes a live card preview on background tone and reset option.

---

## Files Modified / Added

- `lib/core/constants/app_constants.dart`: Added preference keys `prefFontFamily`, `prefTextScaleFactor`, and `prefAppSurfacePreset`.
- `lib/app/config/providers.dart`: Added `fontFamilyProvider`, `textScaleFactorProvider`, and `appSurfacePresetProvider`.
- `lib/app/theme/app_theme.dart`: Updated `AppTheme` and `ResolvedTheme` to support custom font families and background/card surface presets.
- `lib/app/app.dart`: Configured `MaterialApp` to apply typography, surface tone, and dynamic `MediaQuery` text scaling.
- `lib/app/routing/app_router.dart`: Added `AppRoute.typography` and `AppRoute.appColor` routes.
- `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb`: Added English and Malayalam localization strings.
- `lib/features/settings/presentation/appearance_screen.dart`: Updated to show all 4 cards in sequence.
- `lib/features/settings/presentation/typography_screen.dart`: New typography and text scaling screen.
- `lib/features/settings/presentation/app_color_screen.dart`: New app surface tone screen.
- `test/features/settings/presentation/appearance_screen_test.dart`: Updated widget tests.
- `test/features/settings/presentation/typography_screen_test.dart`: New widget tests for typography settings.
- `test/features/settings/presentation/app_color_screen_test.dart`: New widget tests for app color settings.

---

## Verification

- `flutter gen-l10n`: Completed with 0 errors.
- `flutter analyze`: Completed with 0 warnings.
- `flutter test`: 376 unit and widget tests passed.
