# Plan: Create docs/features.md

**Status:** completed

## Issue
The repository currently lacks a comprehensive `docs/features.md` file summarizing the app's overall description and all of its implemented features. The user wants a complete, accurate, single-source document detailing the app description and all capabilities so it can be shared with an LLM for cross-app feature verification.

## Files to be changed
- `docs/features.md` (NEW)

## Proposed Plan
1. Create `docs/features.md` containing:
   - **App Overview & Description**: SreerajP PDF App (`pdfapp` / `in.sreerajp.pdfapp`), an offline-first, open-source Android PDF reader, editor, annotator, text extractor, signature verifier, and PDF printer built with Flutter and native Kotlin.
   - **Core Architectural Rules**: 100% open-source stack (`pdfrx`, `PdfBox-Android`, Bouncy Castle, `flutter_tts`, `sqflite`), offline-first, scoped storage SAF & intent filters, copy-on-write page modifications, non-crashing error handling, graceful fallback for scanned PDFs without OCR, and no dead buttons.
   - **Exhaustive Feature Breakdown**:
     - PDF Viewing & Navigation (rendering, continuous scroll, pinch-to-zoom, page jump, TOC outline, password unlock, fingerprinting, reading position restore, recents list).
     - Search, Indic Phonetic/Sandhi Engine & TTS (full-text search with highlighting, Malayalam & Sanskrit Sandhi/chillu/accent normalization, TTS reading in English & Malayalam, voice install helper).
     - Non-Destructive Annotation Overlay (highlights, underlines, strikethroughs with colors, sticky notes, ink drawing, bookmarks, burn/export annotations to new PDF).
     - Page Operations & Document Reorganization (visual thumbnail organize grid, reorder/rotate/delete/duplicate pages, merge PDFs, split PDF, compress PDF, encrypt/protect PDF, decrypt/unlock PDF).
     - Data Extraction & Document Tools (extract text to txt/clipboard, extract embedded images, read form fields, render pages to PNG/JPG at custom DPI, document metadata inspector).
     - PDF Printer & Content Importer (Android system print framework integration, images-to-PDF conversion, text-to-PDF conversion with Latin-1 validation, ACTION_VIEW/SEND/SEND_MULTIPLE intent filters).
     - Digital Signature Verification & Trust Store (native Bouncy Castle verification, byte integrity & coverage checks, X.509 certificate detail inspection, custom trust store certificate manager).
     - Themes, Settings & About (Material 3 with light, dark, sepia, system themes, app settings, trust store screen, About screen).
2. After creating `docs/features.md`, create a change log entry in `change_log/20260802_203200_create_features_md.md`.
