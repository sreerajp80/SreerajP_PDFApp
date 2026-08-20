# Plan: Full Freedom (0% to 100%) Range for App Color Sliders with Dynamic Contrast

**Status:** Proposed  
**Date:** 2026-08-19  

## Overview
Remove the artificial clamping on the App Color sliders so users can adjust Hue (0–360°), Tint/Saturation (0%–100%), and Shade/Lightness (0%–100%) completely freely. Ensure the text, card panels, borders, and UI elements dynamically calculate optimal contrast from the background's luminance.

---

## Files to Modify

1. **`lib/app/theme/app_theme.dart`**:
   - Update `normalizeBase` (or remove restrictive clamping) so it returns the exact color picked by the user.
   - Update `_buildTheme` to dynamically calculate `onSurface`, `onSurfaceVariant`, `cardColor`, and `outlineVariant` based on `background.computeLuminance()`, ensuring text is always crisp and readable (white on dark backgrounds, black/dark on light backgrounds) regardless of brightness mode or custom color picked.

2. **`lib/features/settings/presentation/app_color_screen.dart`**:
   - Update the Shade (Lightness) slider gradient in `AppColorScreen` to render the full 0.0 to 1.0 spectrum:
     `HSLColor.fromAHSL(1, hsl.hue, hsl.saturation, 0.0).toColor()` to `HSLColor.fromAHSL(1, hsl.hue, hsl.saturation, 1.0).toColor()`.
   - Update `_apply` and state handling to support full 0.0–1.0 saturation and lightness.

3. **Tests**:
   - Verify with `flutter analyze` and `flutter test`.

---

## Verification Plan
1. `flutter analyze` to ensure 0 warnings.
2. `flutter test` to ensure all tests pass.
