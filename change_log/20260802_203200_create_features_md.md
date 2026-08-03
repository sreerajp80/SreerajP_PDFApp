# Change Log: Create docs/features.md

**Date:** 2026-08-02
**Plan Implemented:** [plans/20260802_203200_create_features_md.md](../plans/20260802_203200_create_features_md.md)

## Summary of Changes
- Analyzed the `SreerajP_PDFApp` codebase, architecture, domain models, DAOs, presentation screens, and native Kotlin handlers (`MainActivity.kt`, `PdfBoxHandler.kt`, `SignatureHandler.kt`, `PrintHandler.kt`, `TtsHandler.kt`).
- Created [docs/features.md](../docs/features.md) containing an exhaustive app description and detailed catalog of all features and architectural principles:
  - App description & tech stack (Flutter 3.44.8+, Dart 3.12.2+, minSdk 26).
  - Core architectural rules (100% open-source stack, offline-first, scoped storage SAF & intent filters, copy-on-write, non-crashing error handling, graceful fallback for scanned PDFs without OCR, no dead buttons).
  - Feature 2.1: PDF Viewing & Navigation Engine (rendering, zoom/pan preservation, TOC drawer, page jump sheet, password unlock, fingerprinting, reading position persistence, recents gallery).
  - Feature 2.2: Search, Indic Phonetic & Sandhi Engine, and TTS (full-text search, ICU NFC normalization, chillu unification, joiner-ignorable matching, grapheme cluster alignment, Sanskrit accent stripping, English & Malayalam TTS, voice install helper).
  - Feature 2.3: Non-Destructive Annotation Overlay (highlights, underlines, strikethroughs with colors, sticky notes, ink drawing, bookmarks, burn/export annotations to new PDF).
  - Feature 2.4: Page Operations & Document Reorganization (visual thumbnail organize grid, drag-and-drop reorder, rotate/delete/duplicate pages, merge, split, compress, encrypt/protect, decrypt/unlock).
  - Feature 2.5: Data Extraction & Document Utilities (text extraction to clipboard/txt, embedded image extraction, form fields reader, page-to-image rendering at custom DPI, document metadata inspector).
  - Feature 2.6: PDF Printer & Content Importer (Android print framework integration, images-to-PDF conversion, text-to-PDF conversion with Latin-1 validation, ACTION_VIEW/SEND/SEND_MULTIPLE intent target).
  - Feature 2.7: Digital Signature Verification & Trust Store (native Bouncy Castle verification, byte integrity/coverage checks, certificate detail inspection, SQLite certificate trust store).
  - Feature 2.8: Themes, Settings & About (Material 3 with light/dark/sepia/system themes, settings screen, trust store manager, About screen).
