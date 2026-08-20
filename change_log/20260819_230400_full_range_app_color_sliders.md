# Change Log: Full Range (0%–100%) App Color Sliders with Dynamic Contrast

**Date:** 2026-08-19
**Related Plan:** `plans/20260819_225900_full_range_app_color_sliders.md`

## Summary of Changes
1. **Unrestricted HSL Freedom**:
   - Removed artificial lightness and saturation clamping in `AppTheme.normalizeBase` and `AppColorScreen`.
   - Users can now freely drag the Hue (0–360°), Tint/Saturation (0%–100%), and Shade/Lightness (0%–100%) sliders to create any background tone from pitch black to pure white or vibrant pastels.

2. **Dynamic Contrast & Legibility**:
   - Updated `AppTheme._buildTheme` to dynamically calculate `isBgDark = usesCustomBase ? (bgLuminance < 0.5) : isDark`.
   - Dynamically adjust `onSurface`, `onSurfaceVariant`, card panel lift, and border outline colors according to the true background luminance so text and icons always maintain optimal contrast and readability.

3. **Slider Visuals**:
   - Updated the Shade slider gradient in `AppColorScreen` to display the full 0.0 (black) to 1.0 (white) gradient corresponding to the selected hue and tint.

4. **Testing**:
   - Verified with `flutter analyze` (0 warnings).
   - Verified with `flutter test` (all 376 tests passing).
