# Refactor Bottom Bar Height and Zoom Controls

**Status:** completed

This plan describes changes to make the viewer's bottom bars more compact and replace the separate Zoom In and Zoom Out controls with a single "Reset Zoom" action since pinch-to-zoom is natively supported.

## Files to be changed:
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ml.arb`
- `lib/features/viewer/presentation/viewer_screen.dart`

## Issue:
- The default Material 3 `BottomAppBar` height is 80 logical pixels, which is unnecessarily tall on mobile devices.
- Zoom In and Zoom Out buttons are redundant because pinch-to-zoom works natively.
- Only a "Reset Zoom" function is needed to revert zoom level back to `1.0`.

## Plan for the fix:
- Reduce height of both standard and TTS bottom bars in `BottomAppBar` to 56.0.
- Remove Zoom In and Zoom Out buttons.
- Add a "Reset Zoom" button (using `Icons.zoom_out_map` icon) mapped to a function that resets scale to `1.0`.
- Center-align the page indicator inside the remaining space.
