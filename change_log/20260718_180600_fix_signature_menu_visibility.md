# Change Log - Fix Signature Menu Visibility Bug

## Metadata
- **Date/Time:** 2026-07-18 18:06:00 (Local Time)
- **Plan Reference:** [plans/20260718_180500_fix_signature_menu_visibility.md](file:///l:/Android/SreerajP_PDFApp/plans/20260718_180500_fix_signature_menu_visibility.md)

## Summary of Changes
Fixed the bug where the "Signatures" option would not show up in the PDF viewer dotted menu on the first tap, but would appear on the second.

## Detailed Changes

### lib/features/viewer/presentation/viewer_screen.dart
- Watched the signature status provider (`hasSignaturesProvider`) directly at the top of the main `build` method.
- Passed this value (`hasSignatures`) into the action builder method `_buildActions`.
- Replaced the inline `ref.watch` in `PopupMenuButton.itemBuilder` with the pre-evaluated `hasSignatures` boolean.

## Verification Run
Ran `flutter test` at the workspace root, and all 307 tests passed.
