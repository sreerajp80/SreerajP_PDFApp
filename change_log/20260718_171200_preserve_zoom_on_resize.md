# Change Log: Preserve Zoom Level on Viewport/Layout Resize

Implemented the fix for preserving PDF document zoom level when layout constraints or viewport sizes change.

## References:
- Implements plan: [20260718_171000_preserve_zoom_on_resize.md](file:///l:/Android/SreerajP_PDFApp/plans/20260718_171000_preserve_zoom_on_resize.md)

## Changes made:
- Modified [viewer_screen.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/viewer/presentation/viewer_screen.dart):
  - Added tracking variables for the last matrix (`_lastMatrix`), its corresponding viewport size (`_lastMatrixViewSize`), and restoration guard (`_restoringMatrix`).
  - Added `_onMatrixChanged` callback to listen for transformation controller updates. When the viewport size changes (e.g., due to search bar toggling or keyboard opening), it cancels pdfrx's internal auto-reset animation by instantly setting the controller's position to `_lastMatrix`.
  - Registered/deregistered the listener in `initState` and `dispose`.
