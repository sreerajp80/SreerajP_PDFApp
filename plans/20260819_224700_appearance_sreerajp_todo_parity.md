# Plan: Align Appearance Settings with sreerajp_todo Architecture

**Status:** Proposed  
**Date:** 2026-08-19  

## Overview
Align the Appearance module in `SreerajP_PDFApp` with the exact implementation from `sreerajp_todo`:
1. **Fonts & Assets**: Bundle the 3 open-source Malayalam/Latin fonts (`Manjari`, `Anek Malayalam`, `Noto Sans Malayalam`) in `assets/fonts/` and register them in `pubspec.yaml`.
2. **Typography Screen**: Font tiles (`_FontTile`) displaying live multi-script previews (`The quick brown fox 0123` and `മലയാളം സുന്ദരമാണ്`) in each selected font, and `SegmentedButton<AppTextScale>` (Small 0.85x, Default 1.0x, Large 1.15x, Larger 1.30x).
3. **App Color Screen**: Live themed mock preview, preset base swatches (`presetLightBases` / `presetDarkBases`), and continuous HSL sliders (Hue, Tint, Shade) with brightness normalization.
4. **Accent Color Screen**: Live preview chip, preset accent swatches, custom hue & saturation wheel, brightness slider, and reset button.
5. **Appearance Hub & SettingsNavCard**: Reusable `SettingsNavCard` and `AppSectionCard` styling.

---

## Files to Modify / Create

### 1. Assets & Fonts
- Copy `assets/fonts/*.ttf` and license files from `sreerajp_todo` to `assets/fonts/`.
- Update `pubspec.yaml` to declare the font families `Manjari`, `Anek Malayalam`, `Noto Sans Malayalam` and asset directory.

### 2. Core & Theming
- `lib/core/constants/app_constants.dart`: Add preferences for `prefAppFont`, `prefTextScale`, `prefBaseLight`, `prefBaseDark`.
- `lib/app/config/providers.dart`: Add `AppFont`, `AppTextScale`, and Riverpod notifiers for font, text scale, accent colors, and base colors.
- `lib/app/theme/app_theme.dart`: Add `normalizeBase`, `presetLightBases`, `presetDarkBases`, custom base color lift/panel generation matching `sreerajp_todo`.
- `lib/app/app.dart`: Wire `AppFont`, `AppTextScale`, base colors, and accents into `ResolvedTheme` and `MaterialApp`.

### 3. Presentation Screens & Widgets
- `lib/features/settings/presentation/widgets/settings_nav_card.dart` [NEW]: Reusable navigation card with icon container, title, subtitle, and chevron.
- `lib/features/settings/presentation/widgets/app_section_card.dart` [NEW]: Reusable section card with gradient surface and elevation.
- `lib/features/settings/presentation/appearance_screen.dart`: Update to use `SettingsNavCard`.
- `lib/features/settings/presentation/typography_screen.dart`: Update with font tiles and segmented text size selector.
- `lib/features/settings/presentation/app_color_screen.dart`: Update with HSL sliders, presets, and live preview.
- `lib/features/settings/presentation/accent_color_screen.dart`: Ensure alignment with preset swatches and color wheel.

### 4. Localization
- `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb`: Update localization strings for typography, fonts, app color, and appearance to match `sreerajp_todo`.

### 5. Tests
- Update `appearance_screen_test.dart`, `typography_screen_test.dart`, `app_color_screen_test.dart`, and `settings_screen_test.dart`.

---

## Verification Plan
1. `flutter gen-l10n` to regenerate localizations.
2. `flutter analyze` to ensure zero warnings.
3. `flutter test` to ensure all tests pass.
