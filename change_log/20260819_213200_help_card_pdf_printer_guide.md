# Change Log: Help Section in Settings and PDF Printer Guide

**Date:** 2026-08-19
**Plan Reference:** `plans/20260819_212900_help_card_pdf_printer_guide.md`

## Summary of Changes

1. **Help Card in Settings**
   - Added a **Help** section card (`Icons.help_outline`) on the Settings screen (`lib/features/settings/presentation/settings_screen.dart`).
   - Tapping the Help card navigates to the Help screen.

2. **Help Hub Screen**
   - Created `lib/features/help/presentation/help_screen.dart` listing available user guides and troubleshooting topics.
   - Added a **PDF Printer** topic card (`Icons.print_outlined`) navigating to the PDF printer setup guide.

3. **PDF Printer Help Topic Screen**
   - Created `lib/features/help/presentation/pdf_printer_help_screen.dart` with full step-by-step instructions on enabling virtual print services on Android:
     - Header: *1. How to Enable the PDF Printer on Android*
     - Intro text explaining system-level virtual print services.
     - 4 numbered step cards:
       1. Open Android Settings.
       2. Navigate to Connected devices → Connection preferences → Printing.
       3. Find SreerajP PDF App under Print services.
       4. Switch the toggle to On.
     - Direct **Open Print Settings** button to launch Android print settings.

4. **Platform Channel & Native Android Integration**
   - Added `openPrintSettings` channel method in `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` and `lib/core/platform/open_document_channel.dart` using `android.provider.Settings.ACTION_PRINT_SETTINGS`.

5. **Routing & Localization**
   - Registered `AppRoute.help` and `AppRoute.helpPdfPrinter` in `lib/app/routing/app_router.dart`.
   - Added localized strings in English (`lib/l10n/app_en.arb`) and Malayalam (`lib/l10n/app_ml.arb`).

6. **Automated Tests**
   - Updated `test/features/settings/presentation/settings_screen_test.dart` to verify the Help card.
   - Added `test/features/help/presentation/help_screen_test.dart` to test the Help hub.
   - Added `test/features/help/presentation/pdf_printer_help_screen_test.dart` to test step rendering and print settings trigger.
   - Verified that all 358 tests pass and `flutter analyze` reports 0 issues.
