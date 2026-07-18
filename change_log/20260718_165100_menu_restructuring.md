# Restructure Viewer Menu and Move Actions to Popup Menu

This change restructuring the viewer's layout, fit, settings options, and moves action buttons to the popup menu.

- **Implements Plan:** [plans/20260718_164700_menu_restructuring.md](file:///l:/Android/SreerajP_PDFApp/plans/20260718_164700_menu_restructuring.md)
- **Walkthrough:** [walkthrough.md](file:///D:/Users/sreerajp/.gemini/antigravity-ide/brain/7701f471-b730-455c-b547-c49a5b6d78ab/walkthrough.md)

## Summary of Changes

### Localization
- Added `"pageFit": "Page fit"` to `lib/l10n/app_en.arb`.
- Added `"pageFit": "പേജ് ക്രമീകരണം"` to `lib/l10n/app_ml.arb`.

### Viewer Screen
- Modified `lib/features/viewer/presentation/viewer_screen.dart`:
  - Removed "Invert Colors", "Thumbnails", and "Contents" from the main `AppBar` action buttons list.
  - Grouped view modes ("Continuous", "Single page", "Two pages") into a single "View Mode" menu item, launching a selection dialog built with `RadioGroup`.
  - Grouped page fit modes ("Fit width", "Fit page") into a "Page Fit" menu item launching a selection dialog.
  - Moved Invert Colors, Thumbnails, and Contents options into the dotted popup menu.
  - Added Settings option that opens the settings screen.
  - Added leading icons to all menu items for visual consistency.
  - Cleaned up the unused helper `_checked` method.
