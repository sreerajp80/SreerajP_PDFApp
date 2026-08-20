# Change Log: Page Operations, PDF Printer, and Digital Signature Enhancements

**Date:** 2026-08-19
**Related Plan:** `plans/20260819_232700_page_ops_printer_signature_enhancements.md`

---

## 1. Overview
This change implements 7 advanced feature enhancements across Page Operations, PDF Printing, and Digital Signature Verification:
1. **Visual Drag-and-Drop Reorder Grid** (Feature 3.4)
2. **Custom Watermarks** (Feature 3.4)
3. **Batch Operations** (Feature 3.4)
4. **N-Up Multi-Page Layouts** (Feature 3.5)
5. **Web Content Cleaner** (Feature 3.5)
6. **Visual Stamp Inspection** (Feature 3.6)
7. **Trust Certificate Manager (Export)** (Feature 3.6)

---

## 2. Summary of Changes

### Native Kotlin & Platform Bridge Layer
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`:
  - Added `applyWatermark` supporting custom text, opacity, rotation angle, colors, repeated tiling grids, and page range filtering.
  - Added `generateNUpPdf` supporting 2-in-1, 4-in-1, 6-in-1, and 9-in-1 layout imposition grids on A4/US Letter sheets with margins, rotation/orientation handling, and subtle border lines using `LayerUtility.importPageAsForm`.
- `lib/core/platform/pdfbox_channel.dart`:
  - Added `applyWatermark` and `generateNUpPdf` platform bridge methods.

### Page Operations Layer
- `lib/features/page_ops/data/page_ops_service.dart`:
  - Added `applyWatermark`, `generateNUp`, and `runBatchOperation` supporting batch encryption, batch merge, batch text extraction, batch margin trim, and batch compression with live progress reporting.
- `lib/features/page_ops/presentation/widgets/watermark_dialog.dart`:
  - Created interactive dialog for configuring text watermarks, opacity, rotation, font sizes, color chips, tiling toggle, and page range selection.
- `lib/features/page_ops/presentation/widgets/batch_operations_dialog.dart`:
  - Created modal dialog for picking multiple PDF documents via SAF, selecting operations, configuring parameters, and running background batch processing with step progress.
- `lib/features/page_ops/presentation/widgets/organize_pages_screen.dart`:
  - Added visual multi-column thumbnail grid view toggle, drag-and-drop reordering, rotation badges, and multi-selection mode with select all, invert, bulk rotate, and bulk delete.
- `lib/features/page_ops/presentation/page_ops_sheet.dart`:
  - Added tiles for Custom Watermark, N-Up Layout, and Batch Operations.

### Printer Layer
- `lib/features/printer/data/web_content_cleaner.dart`:
  - Implemented offline web content and HTML cleaner that strips headers, footers, navs, sidebars, cookie banners, scripts, ads, and tracking parameters before saving/printing shared web pages.
- `lib/features/printer/data/print_service.dart`:
  - Added `printNUp` method to print multi-page grid sheets directly.
- `lib/features/printer/presentation/import_screen.dart`:
  - Added automatic web content detection and "Clean Web Content (Reader Mode)" toggle switch.
- `lib/features/printer/presentation/widgets/n_up_dialog.dart`:
  - Created N-Up configuration dialog with 2-in-1, 4-in-1, 6-in-1, and 9-in-1 grid choices, sheet size, orientation, page borders, and margin slider.
- `lib/features/printer/presentation/widgets/print_sheet.dart`:
  - Added "Print N-Up multi-page grid" action tile.

### Signature & Trust Store Layer
- `lib/features/signature/data/signature_repository.dart`:
  - Added `exportCertificate` and `exportAllCertificates` to serialize certificates to standard PEM format and save them via SAF.
- `lib/features/signature/presentation/widgets/signature_detail_sheet.dart`:
  - Created signature detail inspection sheet showing status badges, signing times (claims vs verified), integrity, coverage, certificate details, trust actions, and certificate export.
- `lib/features/viewer/presentation/viewer_screen.dart`:
  - Added interactive touch overlays on visual signature stamps that immediately open `SignatureDetailSheet` on tap.
- `lib/features/signature/presentation/trust_store_screen.dart`:
  - Added export action on individual certificate items and "Export All Certificates" in the AppBar.

### Localization & Quality Assurance
- `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb`:
  - Added English and Malayalam localization strings for all new dialogs, actions, and status messages.
- `test/features/printer/web_content_cleaner_test.dart`:
  - Added unit tests for HTML cleaning, boilerplate stripping, and entity decoding.
- `test/features/signature/trust_store_export_test.dart`:
  - Added unit tests for PEM certificate export and trust store bundle generation.
- `test/features/page_ops/page_ops_service_enhancements_test.dart`:
  - Added unit tests for watermark, N-Up, and batch operation service methods.

---

## 3. Verification
- `flutter gen-l10n`: Completed with 0 errors.
- `dart format .`: Formatted all source and test files.
- `flutter analyze`: 0 warnings, 0 errors, 0 hints.
- `flutter test`: All 384 tests passed successfully.
