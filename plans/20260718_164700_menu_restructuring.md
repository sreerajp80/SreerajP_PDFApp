# Restructure Viewer Menu and Move Actions to Popup Menu

**Status:** `completed`

## 1. Issue Description
The user wants to simplify and clean up the PDF viewer UI:
- Group the layout/view modes (Continuous, Single Page, Two Pages) into a single option ("View Mode" / "കാഴ്ച രീതി") that opens a dialog to select the option.
- Group the fit options (Fit Width, Fit Page) into a single option ("Page Fit" / "പേജ് ക്രമീകരണം") that opens a dialog.
- Move three app bar actions (Invert/Night Colors, Thumbnails/Pages, and Contents) into the dotted popup menu.
- Add a "Settings" menu option to the dotted popup menu.

## 2. Proposed Changes

We will modify:
1. `lib/l10n/app_en.arb` [MODIFY]
   - Add `"pageFit": "Page fit"` and descriptive metadata.
2. `lib/l10n/app_ml.arb` [MODIFY]
   - Add `"pageFit": "പേജ് ക്രമീകരണം"`.
3. `lib/features/viewer/presentation/viewer_screen.dart` [MODIFY]
   - Update `_ViewerMenu` enum:
     - Remove `continuous`, `single`, `book`, `fitWidth`, `fitPage`.
     - Add `invertColors`, `viewMode`, `pageFit`, `thumbnails`, `contents`, `settings`.
   - Update `_buildActions`:
     - Remove the `IconButton` widgets for Invert Colors, Thumbnails, and Contents from the `AppBar` actions list.
     - Restructure `PopupMenuButton<_ViewerMenu>` items list, adding leading icons to all options for visual consistency.
     - Add dividers to group items logically (e.g. view preferences, navigation/outline, tools/operations, settings).
   - Implement dialogs:
     - `_showViewModeDialog()`: Displays an `AlertDialog` with radio list tiles for "Continuous", "Single page", and "Two pages".
     - `_showPageFitDialog()`: Displays an `AlertDialog` with options for "Fit width" and "Fit page".
   - Map menu choices in `PopupMenuButton.onSelected`:
     - `invertColors` -> `_toggleInvert()`
     - `viewMode` -> `_showViewModeDialog()`
     - `pageFit` -> `_showPageFitDialog()`
     - `thumbnails` -> `_showThumbnails()`
     - `contents` -> `_scaffoldKey.currentState?.openEndDrawer()`
     - `settings` -> `context.pushNamed(AppRoute.settings.name)`

## 3. Verification Plan
- Verify that the Flutter app builds successfully.
- Open a PDF to access the `ViewerScreen`.
- Verify that only Search, Read Aloud (TTS), and Annotate buttons are shown in the AppBar.
- Open the dotted menu and verify the layout and Malayalam translation.
- Select "Night colors" and verify that it toggles successfully.
- Select "View Mode" and verify that the dialog opens with radio buttons, changes the view mode when clicked, and closes.
- Select "Page Fit" and verify that the dialog opens, allows choosing "Fit width" / "Fit page", and updates the scale correctly.
- Select "Settings" and verify that the settings page opens.
- Verify that other options (Thumbnails, Contents, Bookmarks, Details, Extract, Page tools, Print) continue to work properly from the menu.
