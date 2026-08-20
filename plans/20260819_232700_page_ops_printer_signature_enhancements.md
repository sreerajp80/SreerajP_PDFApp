# Plan: Page Operations, PDF Printer, and Digital Signature Enhancements

**Status:** Proposed

## Overview
This plan implements the 7 roadmap enhancement features across Page Operations (3.4), PDF Printer (3.5), and Digital Signature Verification (3.6) as defined in `docs/feature_analysis_and_roadmap.md`:
1. **Visual Drag-and-Drop Reorder Grid**: Interactive thumbnail grid view with multi-selection, bulk rotation/deletion, and drag-and-drop reordering.
2. **Custom Watermarks**: Apply text or image watermarks with adjustable opacity, rotation, tile spacing, and positioning onto a copy-on-write PDF.
3. **Batch Operations**: Select multiple PDF files via SAF to perform batch encryption, batch merge, batch text extraction, batch margin trim, or batch compression with isolate/background processing.
4. **N-Up Multi-Page Layouts**: Print or save multiple PDF pages onto a single sheet (2-in-1, 4-in-1, 6-in-1, 9-in-1 grid layouts) with sheet sizes, margins, and borders.
5. **Web Content Cleaner**: Remove headers, footers, sidebars, ads, scripts, and navigation when saving shared web content to PDF.
6. **Visual Stamp Inspection**: Interactive touch targets on rendered PDF pages to tap directly on visual signature stamps and open detailed verification sheets.
7. **Trust Certificate Manager**: Import and export self-signed enterprise certificates (.crt / .pem) and full trusted certificate bundles.

---

## Files to Change and Create

### 1. Page Operations Enhancements (3.4)
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`:
  - Implement `applyWatermark(...)` using `PDPageContentStream`, `PDExtendedGraphicsState`, and matrix transforms.
- `lib/core/platform/pdfbox_channel.dart`:
  - Add `applyWatermark(...)` method.
- `lib/features/page_ops/data/page_ops_service.dart`:
  - Add `applyWatermark(...)` and `runBatchOperation(...)`.
- `lib/features/page_ops/presentation/widgets/organize_pages_screen.dart`:
  - Add multi-column Reorderable Grid view alongside List view with view toggle.
  - Add selection mode with multi-select, Select All, Invert Selection, Bulk Rotate, and Bulk Delete.
- `lib/features/page_ops/presentation/widgets/watermark_dialog.dart` (NEW):
  - Dialog to configure text/image watermark, opacity, rotation angle, tiled pattern vs single center, and page range.
- `lib/features/page_ops/presentation/widgets/batch_operations_dialog.dart` (NEW):
  - Dialog for selecting multiple PDFs via SAF, picking an operation (encrypt, merge, extract text, trim margins, compress), and viewing live progress.
- `lib/features/page_ops/presentation/page_ops_sheet.dart`:
  - Add menu tiles for Watermark, N-Up Layout, and Batch Operations.

### 2. PDF Printer Enhancements (3.5)
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`:
  - Implement `generateNUpPdf(...)` supporting 2-in-1, 4-in-1, 6-in-1, and 9-in-1 sheet grid imposition with `LayerUtility.importPageAsForm`.
- `lib/core/platform/pdfbox_channel.dart`:
  - Add `generateNUpPdf(...)` method.
- `lib/features/printer/data/pdf_builder_service.dart`:
  - Expose N-Up PDF generation.
- `lib/features/printer/presentation/widgets/n_up_dialog.dart` (NEW):
  - Dialog to configure N-Up layout (2-in-1, 4-in-1, 6-in-1, 9-in-1), sheet size, margins, border lines, with direct print and save options.
- `lib/features/printer/presentation/widgets/print_sheet.dart`:
  - Add N-Up multi-page print option.
- `lib/features/printer/data/web_content_cleaner.dart` (NEW):
  - Offline parser and cleaner that strips headers, footers, sidebars, script/style tags, and ads from shared HTML/web text while preserving readable article content.
- `lib/features/printer/presentation/import_screen.dart`:
  - Add "Clean web content / Reader mode" toggle for shared text and web content.

### 3. Digital Signature Verification Enhancements (3.6)
- `lib/features/viewer/presentation/viewer_screen.dart`:
  - Add interactive signature stamp tap targets in `pageOverlaysBuilder` matching signature positions (`verdict.signature.position`).
- `lib/features/signature/presentation/widgets/signature_detail_sheet.dart` (NEW):
  - Bottom sheet showing signature validity, integrity, signer details, certificate info, and actions to trust or export certificate.
- `lib/features/signature/data/signature_repository.dart`:
  - Add `exportCertificate(CertificateInfo cert)` and `exportAllCertificates()`.
- `lib/features/signature/presentation/trust_store_screen.dart`:
  - Add Export Certificate action for individual certificates and Export All bundle action in AppBar.

### 4. Localization and Tests
- `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb`:
  - Add all user-facing strings in simple English and Malayalam.
- `test/features/page_ops/page_ops_service_test.dart`:
  - Unit tests for watermark, organize, and batch operations.
- `test/features/printer/web_content_cleaner_test.dart`:
  - Unit tests for web content cleaner.
- `test/features/signature/trust_store_export_test.dart`:
  - Unit tests for certificate export.

---

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure zero warnings.
- Run `flutter test` to ensure all existing and new tests pass.

### Manual Verification
- Test Drag-and-Drop Reorder Grid with list/grid toggle and multi-selection bulk rotate/delete.
- Test Custom Watermarks with text and image modes, opacity slider, rotation, and tile spacing.
- Test Batch Operations with multi-file SAF picker.
- Test N-Up layouts (2-in-1, 4-in-1, 9-in-1) and verify generated PDF imposition.
- Test Web Content Cleaner with sample HTML text.
- Test tapping on signature stamp overlays in the PDF reader to inspect signatures.
- Test exporting certificates from the Trust Store.
