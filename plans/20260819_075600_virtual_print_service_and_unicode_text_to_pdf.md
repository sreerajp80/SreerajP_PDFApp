# Plan: Android Virtual Print Service & Unicode Text-to-PDF Engine

**Status:** Proposed

## Overview
Currently, the app lacks a system-level Android Virtual Print Service (it cannot be chosen as a destination printer when printing from other apps like LibreOffice, Chrome, or Notes). Additionally, its text-to-PDF engine uses PdfBox's built-in Type 1 Helvetica font, which only supports Latin-1 and rejects Malayalam, Hindi, and other Unicode scripts.

This plan implements three core capabilities:
1. **Android Virtual Print Service (`PdfPrintService`)**: Registers the app with Android's Print Spooler so users can select "Save as PDF (SreerajP PDF App)" from any app's print menu.
2. **True Unicode Text-to-PDF Engine**: Replaces the Latin-1 font generator with Android's native `android.graphics.pdf.PdfDocument` and `StaticLayout` engine. This provides complex script shaping (HarfBuzz), font fallback (Noto Sans Malayalam / Devanagari), and proper `/ToUnicode` font mapping so text remains searchable and copyable without corrupted glyphs.
3. **Enhanced Share-to-PDF**: Ensures text shared from other apps (`ACTION_SEND`) is instantly converted to a clean Unicode PDF.

---

## Files to Change

### Native Android (Kotlin & Resources)
- `[NEW]` `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfPrintService.kt`: The `android.printservice.PrintService` implementation that registers the virtual printer, receives spooled PDFs from other apps, saves them to app cache, and opens them in the viewer.
- `[NEW]` `android/app/src/main/res/xml/printservice.xml`: Print service configuration XML.
- `[MODIFY]` `android/app/src/main/res/values/strings.xml`: User-facing strings for the print service and printer target.
- `[MODIFY]` `android/app/src/main/AndroidManifest.xml`: Declare `PdfPrintService` with `BIND_PRINT_SERVICE` permission and `ACTION_SEND` intent filter for text/plain and documents.
- `[MODIFY]` `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`: Replace Latin-1 `textToPdf` with `NativeTextToPdfRenderer` using `android.graphics.pdf.PdfDocument` and `StaticLayout`. Update `isLatin1Writable` / `canWriteTextToPdf` to support full Unicode text.

### Flutter / Dart Layer
- `[MODIFY]` `lib/features/printer/data/pdf_builder_service.dart`: Support full Unicode text generation.
- `[MODIFY]` `lib/features/printer/presentation/import_screen.dart`: Update UI to seamlessly build and display Unicode PDFs for Malayalam and other languages.
- `[MODIFY]` `test/features/printer/pdf_builder_service_test.dart`: Update unit tests for Malayalam/Unicode text conversion.
- `[MODIFY]` `test/features/printer/import_screen_test.dart`: Update widget tests to verify Unicode text conversion flow.

---

## Detailed Implementation Steps

### 1. Implement Native Unicode Text-to-PDF Engine
- In Kotlin, create a text rendering helper using:
  - `android.graphics.pdf.PdfDocument`
  - `android.text.TextPaint`
  - `android.text.StaticLayout` (or `StaticLayout.Builder` on Android 26+)
- Layout features:
  - Standard A4 page dimensions (595 x 842 points).
  - 36pt margins, page header/footer.
  - Multi-page pagination using `StaticLayout` line breaks and heights.
  - Native font fallback: Renders Malayalam (Noto Sans Malayalam), Hindi/Devanagari, Tamil, English, and Emoji with correct HarfBuzz OpenType shaping.
  - Emits vector PDF with embedded subset TrueType fonts and valid `/ToUnicode` CMaps.

### 2. Implement System Virtual Print Service (`PdfPrintService`)
- Create `PdfPrintService` extending `android.printservice.PrintService`:
  - `onCreatePrinterDiscoverySession()`: Discovers and registers a local virtual printer named "Save as PDF (SreerajP PDF App)".
  - `onPrintJobQueued(printJob)`: Reads the `ParcelFileDescriptor` input stream containing the spooled PDF from the calling application.
  - Writes the bytes to a unique file in the app cache (`printer/spool_<timestamp>.pdf`).
  - Calls `printJob.complete()`.
  - Sends a notification and/or starts `MainActivity` with `ACTION_VIEW` pointing to the newly saved PDF so the user can immediately view, annotate, reorganize, or save it to device storage.

### 3. Share-to-PDF Integration
- Verify `MainActivity` receives incoming text intents (`ACTION_SEND` with `text/plain`), forwards to Flutter's `OpenDocumentHandler`, and opens `ImportScreen`.
- `ImportScreen` automatically creates the Unicode PDF and presents "Save to Device" and "Share" options.

---

## Verification Plan

### Automated Tests
- Run `flutter test test/features/printer/` to verify `PdfBuilderService`, `PrintService`, and `ImportScreen`.
- Run all unit and widget tests: `flutter test`.
- Run static analysis: `flutter analyze`.

### Manual Verification
- Share Malayalam / Unicode text into the app and verify the generated PDF has readable, selectable, and searchable text.
- Verify print service registration and printing from external apps to "Save as PDF (SreerajP PDF App)".
