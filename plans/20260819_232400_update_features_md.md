# Plan: Update features.md with Complete and Accurate Implemented Features

**Status:** Pending Approval

## 1. Issue & Objective
The documentation file `docs/features.md` needs to be updated so that:
1. All newly implemented features are documented clearly and comprehensively.
2. Outdated or inaccurate feature descriptions are corrected to match the active codebase.
3. Only features that are actually implemented are listed (no planned or unbuilt features).

## 2. Changes Needed in `docs/features.md`

### 1. Section 1: Architectural Principles & Libraries
- Document bundled Malayalam typography assets (`Manjari`, `Anek Malayalam`, `Noto Sans Malayalam`).
- Ensure all architectural guarantees (100% open source, offline-first, Scoped Storage SAF, Copy-on-Write, Error Resilience, Graceful Degradation without OCR) match current implementation.

### 2. Section 2.1: PDF Viewing & Navigation Engine
- Add **Foldable & Dual-Screen Support**: Adaptive dual-page book view, automatic screen layout mode (`PdfViewMode.auto`), and display hinge gap handling.
- Add **Reading Velocity & Time Estimates**: Real-time reading speed tracking (words per minute, seconds per page), chapter-aware remaining reading time derived from the document outline, and total document remaining time.

### 3. Section 2.2: Search, Indic Phonetic & Sandhi Engine, and Text-to-Speech (TTS)
- Add **Malayalam Input Helper & Virtual Keypad**: In-reader search integration featuring live phonetic transliteration suggestions (Manglish to Malayalam) and an expandable 3-tab virtual Malayalam keypad (Vowels, Consonants, Signs & Chillu).
- Update **TTS Audio Player & Playback Controls**: Clarify manual slider controls for Speech Rate (0.5x to 2.0x), Pitch (0.5x to 2.0x), Sentence Pause durations (0.0s to 2.0s), Auto-Scroll reading toggle, background audio playback with persistent Android system media notification player controls, and Malayalam voice detection with installer helper sheet.

### 4. Section 2.3: Annotation Overlay & Markup System
- Retain all current annotation capabilities (Text markups with 7 colors, Sticky notes, Freehand ink drawing, Bookmarks panel, Eraser, Clear all, and Copy-on-write annotation flattening/export).

### 5. Section 2.4: Page Operations & Document Reorganization (Copy-on-Write)
- Add **Custom Text Watermarks**: Add custom text watermarks with adjustable opacity, diagonal/horizontal rotation angle, font size, color presets, repeated tiling grid option, and page range selection.
- Add **N-Up Multi-Page Layout Imposition**: Combine multiple source pages onto a single sheet (2-in-1, 4-in-1, 6-in-1, 9-in-1) with custom page borders, sheet orientation, and margin sliders.
- Add **Batch Operations**: Run batch jobs across multiple selected PDF documents via SAF (Batch Compress, Batch Watermark, Batch Encrypt/Protect, Batch Decrypt/Unlock, Batch Margin Trim, Batch Text Extraction, Batch Merge).
- Add **Smart Margin Trim / Crop**: Auto-detection of white margins with preview and customizable crop margin trimming.
- Add **Booklet Creator (Imposition)**: Create printable saddle-stitch booklet layouts with 4-page rounding padding.
- Retain **Visual Organize Pages Grid** (drag-and-drop reorder, rotate, delete with undo), **Merge PDFs**, **Split PDF**, **Compress PDF**, **Encrypt PDF (Protect)**, and **Decrypt PDF (Unlock)**.

### 6. Section 2.5: Data Extraction & Document Utilities
- Retain all extraction utilities: Plain text extraction, Embedded image extraction, Interactive form fields inspector (`.json` export/clipboard copy), Page rendering to high-res images (100–300 DPI), and Document metadata modal.

### 7. Section 2.6: PDF Printer & Content Importer ("Print to PDF" / Share Hub)
- Add **Web Content Cleaner (Reader Mode)**: Offline cleaner for shared web pages/HTML that strips headers, navs, sidebars, cookie notices, scripts, ads, and tracking parameters before saving or printing to PDF.
- Add **N-Up Grid Printing**: Direct printing of multi-page imposition grids to hardware printers or Android Print Spooler.
- Retain Android System Print Spooler integration, Images-to-PDF converter, Text-to-PDF converter with UTF-8/Latin-1 validation, and Intent filters (`ACTION_VIEW`, `ACTION_SEND`, `ACTION_SEND_MULTIPLE`).

### 8. Section 2.7: Digital Signature Verification & Trust Store
- Add **Visual Signature Stamp Inspection**: Tap-to-inspect interactive touch overlay on visual signature stamps in the PDF viewer that opens the full signature detail sheet.
- Add **Trust Store Certificate Export**: Export individual certificates or export all certificates as a standard `.pem` bundle via SAF.
- Retain offline cryptographic verification checks (byte integrity, SHA-1/SHA-256, coverage scope, validity period, signer metadata, X.509 certificate chain, offline revocation check, document-level summary verdict, bundled EU EUTL trust list, and SQLite custom trust store).

### 9. Section 2.8: Themes, Settings & System Integration
- Update **Appearance Customization**:
  - Theme Modes: Light, Dark, OLED Pitch-Black (`#000000`), and System Default.
  - Typography: Dynamic font family switching (`System Default`, `Manjari`, `Anek Malayalam`, `Noto Sans Malayalam`) and text scale presets (`Small`, `Default`, `Large`, `Larger`).
  - Accent Color Picker: Live preview chip, 8 preset color swatches, HSV color wheel with hue/saturation gesture control, value/brightness slider, and reset-to-default controls.
- Update **Comprehensive Settings Architecture**: 10 dedicated sub-screens:
  - Appearance (Themes, Typography, Accent Color)
  - Language (System, English, Malayalam)
  - Reader Settings (Remember last position, Page indicator, Reading time estimates, Invert colors, Default layout, Double-tap zoom)
  - Read Aloud (Malayalam voice toggle, Voice installer helper, Auto-scroll, Speech rate slider, Pitch slider, Sentence pause slider)
  - Virtual PDF Printer (Enable virtual printer toggle, Default paper size, Color mode, Orientation, Printer cache cleaner)
  - Storage & Privacy (Remember recent files toggle, Clear recent files history in bulk, Clear temporary cache)
  - Trust Store (Certificates list, Import, Export, Revocation)
  - App Permissions (Full offline privacy explanation & manifest transparency)
  - Help Center (6 structured user guides)
  - About Screen (Data-driven from `assets/config/app_config.json`)

### 10. Section 2.9: Built-In Help & User Guides
- Add dedicated section detailing the 6 in-app guide topics:
  1. PDF Printer Setup (`/help/pdf-printer`)
  2. Unicode & Malayalam PDF Printing (`/help/unicode-printing`)
  3. Read Aloud (TTS) & Malayalam Voice (`/help/tts`)
  4. Organizing & Modifying Pages (`/help/page-ops`)
  5. Digital Signatures & Trust Store (`/help/signatures`)
  6. Privacy & Scoped Storage (`/help/privacy-storage`)

## 3. Files to Change
- `docs/features.md` (Update catalog to reflect all implemented features accurately and completely)

## 4. Verification Plan
- Verify that every feature listed in `docs/features.md` maps directly to implemented code in `lib/` and `android/`.
- Verify that all newly implemented features (Themes, Typography, Accent Color, Reading Velocity, Foldables, Malayalam Helper, Watermark, N-Up, Batch Ops, Booklet, Smart Trim, Web Content Cleaner, Signature Overlays & Export, Settings sub-screens, Help guides) are included.
- Verify no unbuilt or removed features are claimed.
