# Plan: Fast SnackBar Updates and Screen Orientation Rotation

**Status:** completed

## Overview

This change addresses two usability requirements:
1. **Rapid SnackBar Updates on Home Screen**: When browsing or tapping through the recent files list quickly, if an operation fails (e.g. attempting to open moved or deleted files), error SnackBars currently queue up sequentially with long delays (~4 seconds each). We will clear existing SnackBars immediately before displaying a new one and reduce the duration to 2 seconds so the notification updates rapidly without waiting.
2. **Screen Orientation Rotation in PDF Viewer**: Large and wide PDF files (e.g. multi-column layouts, diagrams, art books) are often difficult to read in portrait mode. When users have system auto-rotate locked or prefer a specific reading orientation, they should be able to switch or rotate the screen orientation (Landscape / Portrait / Auto) directly within the PDF viewer.

---

## Files to Change

### Localization
- `[MODIFY]` `lib/l10n/app_en.arb`:
  - Add `rotateScreenTooltip` ("Rotate screen") and `screenOrientationTitle` ("Screen Orientation").
- `[MODIFY]` `lib/l10n/app_ml.arb`:
  - Add Malayalam translations for `rotateScreenTooltip` ("സ്ക്രീൻ തിരിക്കുക") and `screenOrientationTitle` ("സ്ക്രീൻ ഓറിയന്റേഷൻ").
- `[MODIFY]` `lib/l10n/app_sa.arb`:
  - Add Sanskrit translations for `rotateScreenTooltip` ("पटं भ्रामयतु") and `screenOrientationTitle` ("पटदिक्").

### Home Screen
- `[MODIFY]` `lib/features/viewer/presentation/home_screen.dart`:
  - In `_showError`, call `ScaffoldMessenger.of(context).clearSnackBars()` before `showSnackBar` and set `duration: const Duration(seconds: 2)` so notifications update immediately upon successive taps.

### Viewer Screen
- `[MODIFY]` `lib/features/viewer/presentation/viewer_screen.dart`:
  - Add screen orientation state tracking and switching (`SystemChrome.setPreferredOrientations`).
  - Add a rotate screen `IconButton` on the right side of the bottom bar (replacing the empty 48px spacer).
  - Add a "Screen Orientation" option in the top-right overflow popup menu (`_ViewerMenu`) opening a dialog with options: Auto / System, Portrait, Landscape.
  - In `dispose()`, restore orientations to `DeviceOrientation.values` so the rest of the application is unaffected.

### Tests
- `[MODIFY]` `test/features/viewer/presentation/home_screen_test.dart`:
  - Add test verifying SnackBar display behavior when opening fails.

---

## Implementation Details

### 1. Rapid SnackBar Updates in `HomeScreen`
In `_showError(String message)`:
```dart
void _showError(String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}
```
This guarantees that tapping another file that fails immediately dismisses the previous error and shows the new one without queueing.

### 2. Screen Orientation Controls in `ViewerScreen`
- Track active orientation state:
  ```dart
  ScreenOrientationMode _screenOrientation = ScreenOrientationMode.auto;
  ```
  where:
  ```dart
  enum ScreenOrientationMode { auto, portrait, landscape }
  ```
- Orientation methods:
  - `_setScreenOrientation(ScreenOrientationMode mode)`:
    - `auto`: `SystemChrome.setPreferredOrientations(DeviceOrientation.values)`
    - `portrait`: `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])`
    - `landscape`: `SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])`
  - `_toggleScreenOrientation()`:
    - Uses current `MediaQuery.of(context).orientation`.
    - If portrait -> sets to landscape.
    - If landscape -> sets to portrait.
- Bottom bar button:
  - Replaces `const SizedBox(width: 48)` with:
    ```dart
    IconButton(
      icon: const Icon(Icons.screen_rotation_outlined),
      tooltip: l10n.rotateScreenTooltip,
      onPressed: _toggleScreenOrientation,
    )
    ```
- Popup menu:
  - Add `_ViewerMenu.screenOrientation` item.
  - Selecting it opens `_showScreenOrientationDialog()` offering `orientationAuto`, `orientationPortrait`, and `orientationLandscape` with radio selection.
- Cleanup:
  - In `dispose()`, call `SystemChrome.setPreferredOrientations(DeviceOrientation.values)` to ensure the rest of the app retains standard responsive orientation behavior.

---

## Verification Plan

### Automated Tests
- Run `flutter gen-l10n` to regenerate localization classes.
- Run `flutter test test/features/viewer/presentation/home_screen_test.dart`.
- Run `flutter analyze` to ensure zero warnings/errors.
- Run full test suite `flutter test`.

### Manual Verification
- In Home screen, rapidly tap items that cannot be reopened to verify error messages replace each other immediately without waiting or queuing.
- In Viewer screen, tap the rotate screen button on the bottom bar and select orientation modes from the menu to verify screen rotates between Portrait and Landscape cleanly.
- Exit Viewer screen and verify Home screen returns to normal orientation behavior.
