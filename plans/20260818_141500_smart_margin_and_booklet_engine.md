# Implementation Plan — Smart Margin Trimming & Foldable Booklet Imposition Engine (Feature 2.7)

**Status:** Completed

This plan details the implementation of Feature 2.7: **Smart Margin Trimming & Foldable Booklet Imposition Engine** for SreerajP PDF App.

---

## 1. Overview & Problem Statement

1. **Smart Margin Trimming ("Smart Trim")**:
   - **Problem**: PDF pages created for desktop printing often have wide blank margins (e.g. 54–72 pt borders). When viewed on mobile phone screens, these margins consume up to 30–40% of screen width, forcing tiny text or excessive zoom.
   - **Solution**: Automatic content bounding-box calculation that crops blank page margins to fit mobile displays, writing a new copy-on-write PDF with adjusted `CropBox` and safe padding.
2. **Foldable Booklet Imposition Engine**:
   - **Problem**: Printing multi-page documents as fold-ready physical booklets (saddle-stitch) requires arranging pages in a non-linear 2-Up imposition order (e.g., pages 8 and 1 on sheet 1 front, 2 and 7 on sheet 1 back). Standard Android PDF readers cannot generate booklet print imposition layouts without third-party desktop tools.
   - **Solution**: A 2-Up imposition layout generator that computes the exact saddle-stitch signature order (padded to multiples of 4) and synthesizes a print-ready 2-Up landscape PDF with fold line guides.

---

## 2. Proposed Architectural Design

### 2.1 Pure Dart Domain Layer (`lib/features/page_ops/domain/`)
- **`BookletImpositionPlanner` (`lib/features/page_ops/domain/booklet_imposition_planner.dart`)**:
  - Implements the pure 2-Up booklet signature mathematics.
  - Generates a list of `BookletSheet` and `BookletFace` objects for $N$ pages (padded to nearest multiple of 4: $M = \lceil N/4 \rceil \times 4$).
  - Supports Left-to-Right (LTR) and Right-to-Left (RTL) binding directions.
  - 100% unit-tested with various page counts ($1, 2, 3, 4, 5, 7, 8, 12, 16, 21$ pages).
- **Options Models**:
  - `MarginTrimOptions`: padding points (e.g. 0, 8, 16, 24 pt), symmetric left/right borders.
  - `BookletOptions`: binding (`ltr` / `rtl`), sheet size (`auto`, `a4`, `letter`), fold guide (`bool`), gutter spacing (`double`).

### 2.2 Native Kotlin Engine (`android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`)
- **`trimPdfMargins`**:
  - Loads document via `PDDocument`.
  - Calculates content bounding box for each page by sampling non-background pixels / stream bounds.
  - Applies safe padding and sets `page.cropBox = PDRectangle(x, y, width, height)`.
  - Writes new PDF to cache output path (copy-on-write).
- **`generateBookletPdf`**:
  - Loads document via `PDDocument`.
  - Calculates 2-Up imposition sheet layout using `LayerUtility` (`importPageAsForm`).
  - Creates 2-Up landscape pages and draws paired logical pages side-by-side with optional center fold guide lines.
  - Writes new booklet PDF to cache output path (copy-on-write).

### 2.3 Dart Platform Bridge & Service Layer
- **`PdfBoxChannel` (`lib/core/platform/pdfbox_channel.dart`)**:
  - `trimMargins(String path, {String? password, double padding, bool symmetric})`
  - `generateBooklet(String path, {String? password, String binding, String sheetSize, bool addFoldGuide, double gutter})`
- **`PageOpsService` (`lib/features/page_ops/data/page_ops_service.dart`)**:
  - Adds `trimMargins(...)` and `generateBooklet(...)` helper methods with temporary output cache paths.

### 2.4 User Interface & Presentation Layer
- **`SmartTrimDialog` (`lib/features/page_ops/presentation/widgets/smart_trim_dialog.dart`)**:
  - Allows user to choose padding amount (Tight / Standard / Comfortable) and symmetric margin option.
  - Runs operation behind progress indicator and presents `PageOpsResultDialog` with "View", "Save to device", and "Share".
- **`BookletImpositionDialog` (`lib/features/page_ops/presentation/widgets/booklet_dialog.dart`)**:
  - Displays booklet summary (total source pages, calculated sheets, padded blank pages).
  - Allows selecting binding direction (Left-to-Right vs Right-to-Left), paper size (Auto / A4 / Letter), and fold guidelines toggle.
  - Generates booklet and presents `PageOpsResultDialog` with "View", "Print", "Save to device", and "Share".
- **`PageOpsSheet` (`lib/features/page_ops/presentation/page_ops_sheet.dart`)**:
  - Adds two new action tiles:
    - **Smart Margin Trim**: "Crop blank page margins for mobile reading"
    - **Foldable Booklet (2-Up)**: "Create fold-ready 2-Up booklet for printing"

### 2.5 Localization
- Update `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb` with all user-facing strings in English and Malayalam.
- Run `flutter gen-l10n`.

---

## 3. Files to Create and Modify

### New Files
- `lib/features/page_ops/domain/booklet_imposition_planner.dart`
- `lib/features/page_ops/presentation/widgets/smart_trim_dialog.dart`
- `lib/features/page_ops/presentation/widgets/booklet_dialog.dart`
- `test/features/page_ops/domain/booklet_imposition_planner_test.dart`
- `test/features/page_ops/presentation/smart_trim_dialog_test.dart`
- `test/features/page_ops/presentation/booklet_dialog_test.dart`

### Modified Files
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`
- `lib/core/platform/pdfbox_channel.dart`
- `lib/features/page_ops/data/page_ops_service.dart`
- `lib/features/page_ops/presentation/page_ops_sheet.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ml.arb`
- `docs/feature_analysis_and_roadmap.md`

---

## 4. Verification Plan

### Automated Tests
1. **Unit Tests**:
   - `test/features/page_ops/domain/booklet_imposition_planner_test.dart`: Test 1-page, 2-page, 3-page, 4-page, 6-page, 8-page, and odd-page documents for correct LTR and RTL sheet face mappings.
2. **Widget Tests**:
   - `test/features/page_ops/presentation/smart_trim_dialog_test.dart`: Test dialog options and callback invocation.
   - `test/features/page_ops/presentation/booklet_dialog_test.dart`: Test booklet sheet count calculation and options triggering.
3. **Full Test Suite & Static Analysis**:
   - `flutter test` (all tests passing)
   - `flutter analyze` (0 warnings)

### Manual Verification
1. Open a PDF in the app and open Page Tools.
2. Tap "Smart Margin Trim" -> Adjust padding -> Generate trimmed PDF -> Verify page margins are cropped cleanly.
3. Tap "Foldable Booklet" -> Configure 2-Up booklet -> Generate booklet PDF -> Verify page ordering $(M, 1), (2, M-1), \dots$ and fold guide.
