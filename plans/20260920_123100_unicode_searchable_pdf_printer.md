# Plan: Unicode Searchable PDF Printer Engine

**Status:** completed

## Overview

When exporting PDFs containing complex scripts (such as Malayalam, Sanskrit, or Devanagari) or ligatures, tools like LibreOffice PDF Export can sometimes treat glyphs incorrectly:
1. Ligatures and conjuncts may be assigned Private Use Area (PUA) codepoints (U+E000–U+F8FF) or unmapped font glyph IDs without a `/ToUnicode` CMap table.
2. Non-canonical Unicode sequences (such as decomposed split vowels or non-standard chillu sequences) can cause character mismatches.
3. The resulting PDF looks visually correct on screen, but searching for words, copying text, or reading aloud with TTS fails because the text layer is garbled or non-searchable.

This plan ensures that the PDF printer in SreerajP PDF App creates fully standard-compliant, searchable Unicode PDFs by:
1. Applying Unicode NFC normalization to canonicalize all vowels, conjuncts, and chillu letters.
2. Loading high-quality bundled OpenType fonts (`NotoSansMalayalam-Regular.ttf`) for complex scripts to guarantee proper glyph shaping and `/ToUnicode` CMap generation.
3. Slicing text cleanly per page so each page's PDF content stream contains only the text visible on that page.
4. Performing post-generation text layer verification using `PDFTextStripper` to confirm that extracted text has 0% PUA or replacement characters and is completely searchable.
5. In `PdfPrintService`, inspecting incoming spooled PDFs to detect missing or garbled `/ToUnicode` maps from external applications.

---

## Files to Change

### Native Android (Kotlin)
- `[MODIFY]` `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt`:
  - Add Unicode NFC normalization (`Normalizer.normalize`) before text measurement and layout.
  - Load and set bundled `NotoSansMalayalam-Regular.ttf` Typeface when text contains Malayalam Unicode points, preserving full OpenType tables and standard Unicode mapping.
  - Paginate text cleanly per page (using substring ranges from `StaticLayout` line indices) so page content streams contain only their own text.
  - Add `verifyUnicodeSearchability(outputPath, expectedText)` using `PDFTextStripper` to verify that the generated PDF contains a valid, searchable text layer with zero PUA codepoints.
- `[MODIFY]` `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfPrintService.kt`:
  - Add inspection of incoming spooled print jobs using `PDFTextStripper` to detect if an external application sent a PDF with missing or garbled `/ToUnicode` mappings.

### Flutter / Dart Layer
- `[MODIFY]` `lib/features/printer/data/pdf_builder_service.dart`:
  - Add text validation and searchability checks before and after PDF creation.
- `[MODIFY]` `test/features/printer/data/pdf_builder_service_test.dart`:
  - Add unit tests verifying Unicode text handling and searchability assertions.

---

## Implementation Details

### 1. Unicode Normalization (NFC)
In `PdfBoxHandler.kt`:
- Run `Normalizer.normalize(cleaned, Normalizer.Form.NFC)` to convert decomposed character sequences (such as split vowels `െ` + `ാ` -> `ൊ`) into precomposed canonical Unicode forms.
- Normalize legacy Malayalam chillu sequences (consonant + virama + ZWJ) where appropriate so they render using canonical atomic chillu characters (U+0D7A..U+0D7F) with direct Unicode mappings.

### 2. High-Quality Font Embedding
- Check if text contains Malayalam characters (`\u0D00..\u0D7F`).
- If so, load `Typeface.createFromAsset(appContext.assets, "flutter_assets/assets/fonts/NotoSansMalayalam-Regular.ttf")`.
- `Noto Sans Malayalam` (developed by SMC / Google) has complete OpenType GSUB/GPOS tables and standard Unicode cmap entries.
- If the text is Latin or other scripts, use `Typeface.create("sans-serif", Typeface.NORMAL)`.

### 3. Clean Per-Page Text Slicing
- Rather than drawing the entire multi-page layout with a canvas clip on each page, slice the text into per-page segments using `layout.getLineStart(startLine)` and `layout.getLineEnd(endLine - 1)`.
- Build a single-page `StaticLayout` for that slice and draw it to the page canvas.
- This guarantees that each PDF page contains only the exact text of that page in its content stream, preventing text leakage across pages and ensuring accurate text selection.

### 4. Post-Generation Searchability Verification
- After `pdfDoc.writeTo(out)`, open the written PDF with `PDDocument.load(File(outputPath))`.
- Extract text with `PDFTextStripper()`.
- Check extracted text against `TextQualityCheck` rules:
  - Verify that no Private Use Area (PUA) runes (`0xE000..0xF8FF`, `0xF0000..0xFFFFD`, `0x100000..0x10FFFD`) or replacement characters (`\uFFFD`) are present.
  - Verify that key words from the input text match the extracted text.
- If verification passes, return the output path.

### 5. Spooled Print Job Inspection in `PdfPrintService`
- In `PdfPrintService.kt`, after saving the spooled PDF from the external app, run a quick check with `PDFTextStripper`.
- If the document contains text with a high ratio of PUA/replacement characters (indicative of a LibreOffice export without `/ToUnicode`), log a descriptive warning so `ViewerScreen`'s `TextQualityNotice` can alert the user.

---

## Verification Plan

### Automated Tests
- `flutter test test/features/printer/data/pdf_builder_service_test.dart`
- `flutter test test/features/reading/domain/text_quality_test.dart`
- `flutter test` (all unit and widget tests)
- `flutter analyze` (ensure 0 warnings)

### Manual Verification
- Share Malayalam text into the app and generate a PDF.
- Open the generated PDF in the viewer:
  - Search for Malayalam words with conjuncts (e.g., `മലയാളം`, `അക്ഷരങ്ങൾ`, `പ്രത്യേക`).
  - Verify all search matches highlight accurately.
  - Select and copy text to the clipboard and paste into another app; verify characters are intact.
  - Verify read aloud (TTS) reads the words smoothly without skipping.
