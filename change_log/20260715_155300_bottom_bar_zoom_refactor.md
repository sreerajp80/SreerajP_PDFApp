# Change Log: Refactored Bottom Bar Height and Zoom Controls

This change implements the plan [20260715_154900_bottom_bar_zoom_refactor.md](../plans/20260715_154900_bottom_bar_zoom_refactor.md) to make the bottom navigation bar more compact and replace the redundant Zoom In and Zoom Out buttons with a single "Reset Zoom" button.

## Changes:
- **Localization (`lib/l10n/`)**:
  - Added `"resetZoom": "Reset zoom"` in [app_en.arb](../lib/l10n/app_en.arb).
  - Added `"resetZoom": "സൂം പുനഃക്രമീകരിക്കുക"` in [app_ml.arb](../lib/l10n/app_ml.arb).
- **PDF Viewer UI (`lib/features/viewer/presentation/viewer_screen.dart`)**:
  - Added `_resetZoom()` method to set the zoom scale to `1.0`.
  - Updated `_buildBottomBar` to use `height: 56.0` and `padding: const EdgeInsets.symmetric(horizontal: 16.0)` to match Material 3 compact guidelines.
  - Removed redundant zoom in/out button icons.
  - Added a "Reset Zoom" icon button using `Icons.zoom_out_map` mapped to `_resetZoom()`.
  - Centered the page indicator button in the remaining space.
  - Updated `_buildTtsBottomBar` to use `height: 56.0` and `padding: const EdgeInsets.symmetric(horizontal: 16.0)` for consistency.

## Verification:
- Regenerated localizations using `flutter gen-l10n`.
- Ran `flutter analyze` which completed successfully with no errors or warnings.
