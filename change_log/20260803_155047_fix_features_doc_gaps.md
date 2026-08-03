# Fix gaps in docs/features.md

Implements: `plans/20260803_155047_fix_features_doc_gaps.md`

## What changed

Checked `docs/features.md` against the real code and fixed three gaps:

1. **Added** the eraser tool to section 2.3 (Annotation Overlay & Markup System) — a
   tap-to-remove tool for deleting markup/ink strokes. It was implemented in code
   (`AnnotationTool.eraser`) but missing from the doc.

2. **Added** the `ACTION_PROCESS_TEXT` "Process Text" entry point to section 2.6 (PDF
   Printer & Content Importer) — lets a user select text in another app and send it
   straight to this app to save as a PDF. This is registered in the Android manifest
   but was missing from the doc.

3. **Removed** the "Export Page Ranges" bullet from section 2.4 (Page Operations),
   since no such feature exists in code — there is no method that exports a page range
   as its own new PDF file. Also fixed the Split bullet, which pointed to this
   non-existent feature; it now points to the real place page ranges are exported
   (Data Extraction & Document Utilities, section 2.5: text, images, or rendered
   pictures).

No code was changed. Section 1 (App Overview & Description) was reviewed and found to
already cover the app's full feature scope, so it was left as-is.
