# Plan: Help Section in Settings and PDF Printer Setup Guide

**Status:** Proposed

## 1. Overview
This plan introduces a dedicated **Help** section in the Settings screen, structured to host user guides and troubleshooting topics. Under Help, a **PDF Printer** topic card will guide users step-by-step on how to enable the virtual print service in Android system settings.

## 2. Proposed Changes

### A. Navigation & Routing
- **File:** `lib/app/routing/app_router.dart`
  - Add `AppRoute.help` (`/help`) and `AppRoute.helpPdfPrinter` (`/help/pdf-printer`).
  - Register route handlers for `HelpScreen` and `PdfPrinterHelpScreen`.

### B. Platform Bridge (Direct Print Settings Shortcut)
- **File:** `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt`
  - Add `openPrintSettings` channel handler to launch Android's `ACTION_PRINT_SETTINGS` (with fallback to `ACTION_SETTINGS`).
- **File:** `lib/core/platform/open_document_channel.dart`
  - Add `openPrintSettings()` method to invoke native print settings.

### C. Presentation Screens
- **File:** `lib/features/settings/presentation/settings_screen.dart`
  - Add a **Help** card (`Icons.help_outline`) with title, subtitle, and navigation to the Help screen.
- **File:** `lib/features/help/presentation/help_screen.dart` (NEW)
  - Create the Help hub screen with topic cards, featuring the **PDF Printer** card (`Icons.print_outlined`).
- **File:** `lib/features/help/presentation/pdf_printer_help_screen.dart` (NEW)
  - Create the PDF Printer help topic page containing:
    - Topic header: *1. How to Enable the PDF Printer on Android*
    - Intro explanation regarding system-level virtual print services.
    - Numbered step cards (1. Open Settings, 2. Navigate to Printing, 3. Find App, 4. Toggle On).
    - Quick-action button: *Open Print Settings* to launch system printing settings directly.

### D. Localization
- **Files:** `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb`
  - Add localized strings for Help titles, subtitles, PDF printer steps, and action button in both English and Malayalam.

### E. Automated Tests
- **File:** `test/features/settings/presentation/settings_screen_test.dart`
  - Update widget tests to verify Help card presence in Settings.
- **File:** `test/features/help/presentation/help_screen_test.dart` (NEW)
  - Test Help screen rendering and topic list.
- **File:** `test/features/help/presentation/pdf_printer_help_screen_test.dart` (NEW)
  - Test PDF printer guide content, steps rendering, and print settings button action.

## 3. Verification Plan
- Run `flutter gen-l10n`.
- Run `flutter analyze` (must be 0 warnings/errors).
- Run `flutter test` (all unit and widget tests must pass).
