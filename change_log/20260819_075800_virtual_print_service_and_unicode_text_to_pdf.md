# Change Log: Android Virtual Print Service & Unicode Text-to-PDF Engine

**Date:** 2026-08-19 07:58:00  
**Plan Reference:** `plans/20260819_075600_virtual_print_service_and_unicode_text_to_pdf.md`

## Summary
Added an Android system Virtual Print Service (`PdfPrintService`) and upgraded the Text-to-PDF engine with native Unicode and complex Indic script shaping (Malayalam, Devanagari, Tamil, etc.).

## Changes Made

### Native Android (Kotlin & XML)
- **`android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfPrintService.kt`**:
  - Implemented `android.printservice.PrintService`.
  - Discovers and registers "Save as PDF (SreerajP PDF App)" in the Android print system.
  - Receives spooled print jobs, copies PDF data to the app's cache, and launches `MainActivity` to view and save the document.
- **`android/app/src/main/res/xml/printservice.xml`**:
  - Defined the print service descriptor configuration.
- **`android/app/src/main/res/values/strings.xml`**:
  - Added string resources for the print service name and printer target.
- **`android/app/src/main/AndroidManifest.xml`**:
  - Registered `PdfPrintService` with the required `BIND_PRINT_SERVICE` permission.
- **`android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`**:
  - Upgraded `textToPdf` to use Android's native `android.graphics.pdf.PdfDocument` and `StaticLayout` with `TextPaint`.
  - Added full complex script shaping (HarfBuzz), multi-language font fallback, bidirectional layout, and TrueType subset embedding with valid `/ToUnicode` CMaps.
  - Updated `canWriteTextToPdf` to accept all valid Unicode text.

## Verification
- `flutter analyze` passed with 0 issues.
- `flutter test` passed all 352 unit and widget tests across all features.
