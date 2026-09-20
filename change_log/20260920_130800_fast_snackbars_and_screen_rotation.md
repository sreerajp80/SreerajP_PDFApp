# Change Log: Fast SnackBar Updates and Screen Orientation Rotation

**Reference Plan:** `plans/20260920_130000_fast_snackbars_and_screen_rotation.md`
**Date:** 2026-09-20

---

## Summary

1. **Immediate SnackBar Feedback on Home Screen**:
   - Fixed an issue where rapidly tapping recent files that failed to reopen (e.g. moved or deleted files) queued up error messages sequentially with long delays.
   - Cleared existing SnackBars immediately before showing a new error, and set display duration to 2 seconds for quick and responsive feedback.

2. **Screen Orientation Rotation in PDF Viewer**:
   - Added the ability to rotate and switch screen orientation (Landscape / Portrait / Auto) in the PDF viewer.
   - Replaced the bottom bar blank spacer with a screen rotation button.
   - Added a "Screen Orientation" option to the viewer's top-right overflow menu with a choice between Auto (System Sensor), Portrait, and Landscape.
   - Restored system default orientation when exiting the viewer.

3. **Localization**:
   - Added translations for `rotateScreenTooltip` and `screenOrientationTitle` in English (`app_en.arb`), Malayalam (`app_ml.arb`), and Sanskrit (`app_sa.arb`).

---

## Files Changed

- `lib/l10n/app_en.arb`: Added `rotateScreenTooltip` and `screenOrientationTitle`.
- `lib/l10n/app_ml.arb`: Added Malayalam translations for orientation strings.
- `lib/l10n/app_sa.arb`: Added Sanskrit translations for orientation strings.
- `lib/features/viewer/presentation/home_screen.dart`: Updated `_showError` to call `clearSnackBars()` and use a 2-second duration.
- `lib/features/viewer/presentation/viewer_screen.dart`: Added `ScreenOrientationMode`, orientation toggle button in bottom bar, orientation dialog in menu, and orientation reset on dispose.
- `test/features/viewer/presentation/home_screen_test.dart`: Added test case for reopen error SnackBar display.
- `plans/20260920_130000_fast_snackbars_and_screen_rotation.md`: Updated status to completed.

---

## Verification

- Ran `flutter gen-l10n` to regenerate localizations.
- Ran `flutter analyze` with 0 warnings/errors.
- Ran `flutter test test/features/viewer/presentation/home_screen_test.dart` (passed).
- Ran full test suite `flutter test` (all 408 tests passed).
