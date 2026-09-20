# Change Log: Unicode Searchable PDF Printer Engine

**Date:** 2026-09-20  
**Plan Reference:** `plans/20260920_123100_unicode_searchable_pdf_printer.md`

## Problem
In some PDF generators and exports (such as LibreOffice PDF export), complex scripts like Malayalam, Sanskrit, or Devanagari and ligatures can suffer from character mapping issues:
- Complex glyphs or ligatures may be mapped to Private Use Area (PUA) codes or unmapped glyph IDs without a `/ToUnicode` CMap table.
- Decomposed character sequences (e.g. split vowels or legacy chillu sequences) can cause character mismatches.
- The resulting PDF displays readable text visually, but text search, copying, and text-to-speech fail because the text layer is non-searchable or garbled.

## Fix
1. **Unicode NFC Normalization & Chillu Conversion**:
   - In `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`, normalized incoming text to Canonical Composition (NFC) via `Normalizer.normalize(..., Normalizer.Form.NFC)`.
   - Converted legacy chillu sequences (consonant + virama + ZWJ) to atomic Unicode chillu characters (U+0D7A..U+0D7F) to ensure standard 1-to-1 Unicode character mapping.
2. **Bundled OpenType Font Loading**:
   - Loaded the bundled `NotoSansMalayalam-Regular.ttf` font from app assets when rendering Malayalam text. This guarantees complete OpenType GSUB/GPOS tables and standard `/ToUnicode` CMap generation.
3. **Clean Per-Page Text Slicing**:
   - Sliced text per page using `StaticLayout` line indices so each PDF page's content stream contains only the text visible on that page.
4. **Post-Generation Searchability Verification**:
   - Verified the generated PDF immediately with `PDFTextStripper` to ensure 0% Private Use Area (PUA) codepoints or replacement characters exist in the text layer.
5. **Print Spool Inspection in `PdfPrintService`**:
   - Added automated text quality inspection to `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfPrintService.kt` to detect when external applications send PDFs with missing or garbled `/ToUnicode` maps.
6. **Tests & Documentation**:
   - Updated `lib/features/printer/data/pdf_builder_service.dart` with Unicode searchability guarantees.
   - Added unit test in `test/features/printer/data/pdf_builder_service_test.dart` for complex Indic Unicode text.

## Files Changed
- `[MODIFY]` `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`
- `[MODIFY]` `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfPrintService.kt`
- `[MODIFY]` `lib/features/printer/data/pdf_builder_service.dart`
- `[MODIFY]` `test/features/printer/data/pdf_builder_service_test.dart`
- `[MODIFY]` `plans/20260920_123100_unicode_searchable_pdf_printer.md`
