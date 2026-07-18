# Fix Signature Menu Visibility Bug

**Status:** completed

## Issue
When opening a PDF document, the "Signatures" option is missing from the dotted menu (three-dot menu) on the first click. However, it appears on the second click.

## Cause
In `lib/features/viewer/presentation/viewer_screen.dart`, the signature presence checking provider `hasSignaturesProvider` is watched inside the `itemBuilder` of the `PopupMenuButton`:
```dart
if (ref.watch(hasSignaturesProvider(widget.docRef.cachePath)).valueOrNull ?? false)
```
Since `itemBuilder` only executes when the menu button is tapped, the provider starts loading the value at that moment. The future resolves asynchronously, which initially yields `AsyncLoading` (resolving `valueOrNull` to `null` and defaulting to `false`). Therefore, the "Signatures" menu item is omitted. By the time the user closes and opens the menu again, the future has resolved and its value is cached, causing it to show up on the second click.

## Fix
1. Watch `hasSignaturesProvider` at the top of the main `build` method of `ViewerScreen` (`lib/features/viewer/presentation/viewer_screen.dart`). This ensures that signature checking begins as soon as the screen is loaded.
2. Store the resulting boolean in a local variable `hasSignatures`.
3. Pass `hasSignatures` as a parameter to the actions builder method `_buildActions`.
4. Use `hasSignatures` directly in the `PopupMenuButton` item list.

## Files to be changed
- [viewer_screen.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/viewer/presentation/viewer_screen.dart)

## Verification Plan
- Launch the application and open a PDF containing digital signatures.
- Tap the dotted menu on the top right for the first time.
- Verify that the "Signatures" option is present in the menu on the very first click.
