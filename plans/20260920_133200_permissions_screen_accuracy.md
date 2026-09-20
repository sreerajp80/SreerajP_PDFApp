# Implementation Plan: Permissions Screen Accuracy

**Status:** Proposed
**Date:** 2026-09-20 13:32:00

## 1. Overview
The settings screen includes a "Permissions" page that explains the app's security posture, capabilities, and system declarations. To make this screen completely accurate and comprehensive, we need to show all explicit permissions, implicit permissions, and privacy guarantees used or enforced by the application.

## 2. Issues Found & Enhancements Needed
1. **Explicit Permissions:**
   - The app uses the explicit service-level permission `android.permission.BIND_PRINT_SERVICE` to guard `PdfPrintService`. Currently, the screen lists "Virtual Print Service" generically without highlighting the exact permission.
   - The app uses explicit Scoped Storage persistable URI permissions (`FLAG_GRANT_PERSISTABLE_URI_PERMISSION`, `FLAG_GRANT_READ_URI_PERMISSION`) via the Storage Access Framework (SAF) and `FileProvider` URI grants. These should be clearly documented as explicit grants.
2. **Implicit Permissions & System Queries:**
   - The manifest declares `<queries>` for Text-to-Speech (`TTS_SERVICE`), Voice Data Installer (`INSTALL_TTS_DATA`), and Process Text (`PROCESS_TEXT`).
   - The manifest also declares `<queries>` for App Store / Browser links (`market://` and `https://` schemes) to help users download missing speech engines (like Speech Services by Google). This query was missing from the screen.
   - The manifest declares intent filters for viewing PDFs (`ACTION_VIEW`), receiving shares (`ACTION_SEND`, `ACTION_SEND_MULTIPLE`), and virtual printing (`android.printservice.PrintService`).
   - The app integrates with Android's system Print Manager framework (`PrintDocumentAdapter` & `PrintManager`) to print PDFs to physical and virtual printers.
3. **Privacy & Zero-Permission Guarantees:**
   - The screen currently highlights the Zero Internet guarantee (`android.permission.INTERNET` absent).
   - We should also prominently highlight the Zero Broad Storage guarantee (`READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`, `MANAGE_EXTERNAL_STORAGE` absent), explaining how Scoped Storage keeps the rest of the user's files completely private.

## 3. Files to Change
- `lib/features/settings/presentation/permissions_screen.dart`:
  - Organize items into three clear groups:
    1. **Explicit Permissions & Grants** (`android.permission.BIND_PRINT_SERVICE`, Scoped Storage persistable URI permissions, FileProvider URI grants).
    2. **Implicit Permissions & System Queries** (TTS engine query, Voice installer query, App store & browser query, Process text query, Document viewing handler, Share receiving handler, Android Print Manager integration).
    3. **Privacy & Zero-Permission Guarantees** (Zero Internet permission guarantee, Zero broad storage permission guarantee).
- `lib/l10n/app_en.arb`:
  - Add localized strings for the new permission items, titles, reasons, what they achieve, and updated section headers.
- `lib/l10n/app_ml.arb`:
  - Add Malayalam translations for all new permission strings and updated section headers.
- `lib/l10n/app_sa.arb`:
  - Add Sanskrit translations for all new permission strings and updated section headers.
- `test/features/settings/presentation/permissions_screen_test.dart`:
  - Update and expand widget tests to verify that all explicit, implicit, and privacy items render properly.

## 4. Verification Plan
1. **Localization generation**:
   - Run `flutter gen-l10n` to compile localizations across English, Malayalam, and Sanskrit.
2. **Static Analysis**:
   - Run `flutter analyze` to ensure 0 errors and 0 warnings.
3. **Automated Testing**:
   - Run `flutter test test/features/settings/presentation/permissions_screen_test.dart` to verify the permissions screen renders all items.
   - Run all tests via `flutter test`.
