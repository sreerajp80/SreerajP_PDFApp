# Fix gaps in docs/features.md

**Status:** completed

## What files will change

- `docs/features.md`

## What is the issue

I checked `docs/features.md` against the real app code (in `lib/` and the Android
manifest) to see if the document is complete and correct. I found three problems:

1. **Missing feature — Eraser tool.** The annotation code has an eraser tool
   (`AnnotationTool.eraser` in `lib/features/annotation/presentation/annotation_controller.dart`,
   used in `page_annotation_layer.dart`) that lets a user tap to delete a markup or ink
   stroke. Section 2.3 of the doc lists Highlight, Underline, Strikethrough, Sticky
   Notes, Ink, and Bookmarks, but not the eraser.

2. **Missing feature — "Process text" intent.** `android/app/src/main/AndroidManifest.xml`
   (lines 135-137) registers the app for Android's `ACTION_PROCESS_TEXT` intent. This
   means a user can select text in *any other app*, and from the text-selection menu
   choose to send that text to this app (to convert it to a PDF). This is a separate
   entry point from the "share a PDF to this app" and "share plain text to this app"
   paths that are already documented in section 2.6.

3. **Wrong feature — "Export Page Ranges" does not exist as a separate feature.**
   Section 2.4 says the app can "select and export specific page ranges into a newly
   created PDF document." I checked `lib/features/page_ops/data/page_ops_service.dart`
   and the only page operations that exist are: merge, split, organize (reorder /
   rotate / delete), compress, protect (encrypt), and unlock (decrypt). There is no
   method that takes a page range and writes it out as its own new PDF file. Page
   ranges are only used in two other, already-documented places: (a) extraction
   (turning a page range into text, images, or rendered PNG/JPEG — not a new PDF), and
   (b) printing a page range. The doc's own cross-reference in the Split bullet
   ("For a specific page range instead, use Export Page Ranges") points at a feature
   that is not implemented, which is misleading.

Everything else in the document (viewing modes, search, TTS, annotation types, page
operations, extraction, printer/share paths, signature verification, settings,
database tables, dependencies) was checked against the code and matches — no other
gaps found.

## Plan for the fix

1. In section 2.3 (Annotation Overlay & Markup System), add one line for the eraser
   tool, describing it as a tap-to-remove tool for markups/ink strokes.

2. In section 2.6 (PDF Printer & Content Importer), add one line documenting the
   `ACTION_PROCESS_TEXT` entry point — selecting text in another app and sending it to
   this app to save as a PDF.

3. In section 2.4 (Page Operations & Document Reorganization):
   - Remove the "Export Page Ranges" bullet, since it does not exist as a page
     operation.
   - Fix the Split bullet's cross-reference, which currently points to the now-removed
     "Export Page Ranges" feature. Change it to point at the real place page ranges are
     exported as separate files: the Extraction section's "Render Pages to Images"
     and the Extraction/text-extraction range options (section 2.5).

4. Section 1 (App Overview & Description) is already broad enough ("viewing,
   navigating, searching, listening to ... selecting/copying text from, annotating,
   reorganizing, extracting from, verifying digital signatures of, and printing") — no
   change needed there. No other description gaps were found.

No code changes, no behavior changes — this is a documentation-only fix.
