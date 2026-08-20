# Feature Analysis and Product Roadmap — SreerajP_PDFApp

This document details completed features, upcoming unique features, existing feature enhancements, and ecosystem app integrations for the **SreerajP PDF App**. It focuses on features that are absent from mainstream Android PDF applications (such as Adobe Acrobat, Foxit, PDF Extra, ReadEra, and Xodo), while respecting all project rules: **open-source only**, **offline-first**, **scoped storage only**, **copy-on-write**, and **no OCR**.

---

## 1. Executive Summary & Core App Philosophy

The SreerajP PDF App is an open-source, privacy-focused Android PDF reader and printer built with Flutter and native Kotlin.

### Implementation Status Notice (Phases 0–8, Features 2.1 & 2.7, and Features 3.1, 3.2, 3.4, 3.5 & 3.6 Completed)
Phases 0 through 8, Features 2.1 & 2.7, and Enhancements 3.1, 3.2, 3.4, 3.5 & 3.6 are 100% completed, tested (384 unit/widget tests passing), and release-hardened.
- **Core Engine**: `pdfrx` rendering, outline/toc navigation, pinch-zoom, continuous/two-page views, and last-read position memory.
- **Viewing & Navigation**: OLED pitch-black theme (`#000000`), real-time reading velocity & chapter/document time estimates, and foldable/dual-screen auto-adaptive layout with hinge gap detection.
- **Reading & Indic Search**: Offline text search with full Sandhi compound splitting/joining and Indic phonetic sound-alike matching (Malayalam & Sanskrit in Malayalam/Devanagari scripts), on-screen Malayalam transliteration helper & virtual keypad, plus Malayalam (`ml-IN`) and English TTS with pitch controls, sentence-ending pauses, and persistent background notification player controls.
- **Page Operations & Annotations**: Copy-on-write page merge, split, visual drag-and-drop thumbnail grid reorder with multi-select (bulk rotate/delete), compress, custom watermarks (opacity, rotation, tiling, page ranges), batch operations (encrypt, merge, extract, trim, compress), smart margin trim, 2-Up booklet imposition, and password encrypt/decrypt. Persistent annotation overlay layer (schema v3) supporting highlights, underlines, notes, freehand ink, and bookmarks.
- **Printer & Security**: Android system print framework integration ("Save to PDF" and physical printing), N-Up multi-page grid layouts (2-in-1, 4-in-1, 6-in-1, 9-in-1), offline web content & HTML cleaner (Reader Mode), and offline PKCS#7 digital signature verification with visual stamp inspection and trust certificate PEM manager.

### Hard Constraints
1. **Open-Source Stack Only**: Uses `pdfrx` (pdfium), `PdfBox-Android` (Apache 2.0), Bouncy Castle, and native Android platform APIs. Commercial SDKs (such as Syncfusion, PSPDFKit, or Apryse) are strictly banned.
2. **Offline-First**: All rendering, search, text extraction, TTS, signature verification, and page operations run completely offline on the user device.
3. **Scoped Storage Only**: Files are opened using system file pickers (Storage Access Framework) or share intents. No broad storage permissions are requested.
4. **Copy-on-Write**: Every page modification (merge, split, reorder, rotate, compress, encrypt) writes a new output file. The original PDF file is never overwritten.
5. **No OCR**: Scanned (image-only) PDFs gracefully report missing text layers and safely turn off text-dependent features (search, copy, TTS) without crashing.
6. **Simple English**: All documentation, user guides, and notifications use clear and simple English.

---

## 2. Unique & World-First Features (Advanced Roadmap)

These feature concepts solve real user problems that standard PDF readers neglect.

```
+-------------------------------------------------------------------------------+
|                      UNIQUE / WORLD-FIRST FEATURES                            |
+------------------------------------+------------------------------------------+
| 1. Indic Phonetic & Sandhi Search  | [x] ✅ Implemented (Sandhi & phonetic)   |
| 2. Visual PDF Diff Heatmap         | Offline side-by-side visual comparison   |
| 3. Smart Offline Redactor          | True physical PII removal without cloud  |
| 4. Forensic Revision Inspector     | View incremental update history & certs  |
| 5. Bionic & Karaoke Reader         | Dual-mode TTS sync with Bionic typography|
| 6. Air-Gapped Barcode Decoupler    | Decode & inspect QR/barcodes inside PDFs |
| 7. Smart Margin & Booklet Engine   | [x] ✅ Implemented (Auto crop & 2-Up)     |
+------------------------------------+------------------------------------------+
```

### 2.1 Phonetic and Sandhi-Aware Indic Search (Malayalam & Sanskrit) ✅
- **Status**: [x] ✅ Implemented (`SandhiEngine`, `IndicPhoneticEngine`, `SearchNormalizer`, and `PdfSearchEngine`).
- **Problem**: Standard PDF search engines match exact bytes. In Malayalam and Sanskrit, words combine through complex joining rules (Sandhi), alternate Unicode forms (chillu characters), and spelling variations. Users searching for a split root word miss joined compounds in the text layer.
- **Solution**: A dedicated search engine using ICU Unicode normalization, chillu unification, joiner-ignorable matching, and phonetic sound-alike rules.
- **Key Capability**: Finds matching Malayalam or Sanskrit words even when typed with split Sandhi parts, alternate chillu encodings, or slightly different phonetic spellings. Fully integrated into the search options menu.

### 2.2 Offline Visual PDF Diff & Revision Heatmap Engine
- **Status**: Planned (Phase 10).
- **Problem**: Comparing two PDF document versions on Android requires expensive cloud subscriptions or desktop software. Mobile viewers either lack diff tools or only support basic text diffs.
- **Solution**: A local, side-by-side and overlay visual comparison tool powered by background `pdfrx` bitmap rendering off the UI thread.
- **Key Capability**: Displays page diffs with visual heatmaps — green highlights for added content, red for deleted elements, and blue for layout shifts. Works entirely offline without sending data to servers.

### 2.3 Privacy-Preserving Offline Smart Redactor
- **Status**: Planned (Phase 10).
- **Problem**: Removing sensitive information (such as credit card numbers, phone numbers, email addresses, or national identity IDs) usually requires manual black boxes. Simple black rectangles drawn over text do not remove the underlying text layer, leaving data vulnerable to extraction.
- **Solution**: An offline scanning tool using local regex rules to detect sensitive information patterns.
- **Key Capability**: Performs true physical content removal using `PdfBox-Android`. Erases text streams from the output PDF copy and draws permanent black redaction boxes over the target coordinates.

### 2.4 Zero-Trust PDF Forensic & Revision History Inspector
- **Status**: Digital signature verification and visual stamp inspection implemented (Phase 7 & 3.6). Incremental revision timeline inspector planned (Phase 10).
- **Problem**: PDF files allow incremental updates where new content or signatures are appended onto older file data. Bad actors can alter documents while hiding original versions. Standard readers only show the latest version.
- **Solution**: A forensic dashboard that parses xref tables and incremental update streams.
- **Key Capability**: Shows a complete timeline of document revisions. Allows users to view earlier historical versions of the document before subsequent edits were appended, and inspect digital signature certificates, digest algorithms, and cryptographic details.

### 2.5 Dual-Mode Bionic Reading & Synchronized Karaoke Reader
- **Status**: English & Malayalam TTS engine implemented (Phase 2 & Phase 9). Bionic typography & word-level karaoke sync planned (Phase 9).
- **Problem**: Reading long PDF documents on small mobile screens causes eye strain, and standard text-to-speech (TTS) features only highlight full sentences or plain boxes.
- **Solution**: Combines Bionic Reading typography with word-level synchronized karaoke text highlighting during TTS playback.
- **Key Capability**: Boldens the initial letters of words to guide visual flow (Bionic Reading) while dynamically highlighting active words in sync with English and Malayalam TTS playback.

### 2.6 Air-Gapped Barcode & QR Code Payload Decoupler
- **Status**: Planned (Phase 11).
- **Problem**: Tickets, utility bills, invoices, and boarding passes stored as PDFs often contain QR codes or 1D/2D barcodes (such as PDF417). Standard PDF readers treat them as static images.
- **Solution**: An offline barcode scanner that inspects PDF page render streams using open-source image analysis, paired with direct handoff to `sreeraj_qr_reader`.
- **Key Capability**: Automatically locates barcodes and QR codes on PDF pages, decodes their embedded payloads (such as JSON data, plain text, or links), and allows users to copy, share, or inspect payload data offline.

### 2.7 Smart Margin Trimming & Foldable Booklet Imposition Engine ✅
- **Status**: [x] ✅ Implemented (`BookletImpositionPlanner`, `SmartTrimDialog`, `BookletDialog`, and `PdfBoxHandler`).
- **Problem**: PDF pages often have wide blank margins that waste screen space on mobile phones. Printing multi-page documents as fold-ready booklets on Android is complex.
- **Solution**: Automatic content bounding-box calculation and print layout generator.
- **Key Capability**: Automatically crops blank page margins for mobile reading ("Smart Trim"). Generates 2-Up booklet imposition page orders (arranging pages 1, N, 2, N-1) for printing fold-ready physical booklets.

---

## 3. Existing Feature Improvements & Ecosystem Integrations

In addition to core features, the app connects directly with existing Flutter applications from `L:\Android\MyFlutterApps\myapps.md`.

```
+-------------------------------------------------------------------------------+
|                  FEATURE IMPROVEMENTS & ECOSYSTEM INTEGRATIONS                |
+------------------------------------+------------------------------------------+
| Viewing & Navigation (3.1)         | [x] ✅ Implemented (OLED, WPM, Foldables)|
| Indic Search & Speech (3.2)        | [x] ✅ Implemented (ML helper, TTS pause)|
| Annotations Overlay (3.3)          | Audio notes, shape auto-smoothing, FDF   |
| Page Operations (3.4)              | [x] ✅ Implemented (Grid, Watermark, Bat)|
| PDF Printer (3.5)                  | [x] ✅ Implemented (N-Up, Web Cleaner)   |
| Digital Signatures (3.6)           | [x] ✅ Implemented (Stamp tap, PEM exp)  |
| Ecosystem App Interoperability (3.7| Links with QR, Vault, Text, & Code apps |
+------------------------------------+------------------------------------------+
```

### 3.1 Viewing & Navigation Enhancements ✅
- **OLED Pitch-Black Theme**: [x] ✅ Implemented (`AppThemeMode.oled`, `#000000` surface, canvas, and scaffold background for maximum battery savings on OLED screens).
- **Reading Velocity & Time Estimates**: [x] ✅ Implemented (`ReadingVelocity`, `ReadingVelocityService`, tracking page dwell times and calculating estimated remaining reading time per chapter and document).
- **Foldable & Dual-Screen Support**: [x] ✅ Implemented (`PdfViewMode.auto`, dynamic book spreads on wide/foldable screens with hinge gap detection).

### 3.2 Reading, Search & Speech Enhancements ✅
- **Malayalam Keyboard Helper**: [x] ✅ Implemented (`MalayalamTransliteration` phonetic engine, `MalayalamInputHelper` suggestion bar, and 3-tab virtual keypad for vowels, consonants, and chillu signs).
- **TTS Controls & Notification Player**: [x] ✅ Implemented (Pitch slider, sentence-ending pause adjustment for natural prosody, and persistent background playback notification player controls on Android).

### 3.3 Annotation Overlay Enhancements
- **Audio Sticky Notes**: Record short voice notes (AAC/m4a) attached to page coordinates, stored in the local overlay database and exported into PDF copies.
- **Shape Auto-Smoothing**: Smooth rough hand-drawn freehand ink drawings into clean lines, circles, rectangles, and arrows.
- **FDF / XFDF Import & Export**: Support standard annotation exchange formats to import and export markup to other open-source PDF tools.

### 3.4 Page Operations Enhancements ✅
- **Visual Drag-and-Drop Reorder Grid**: [x] ✅ Implemented (Interactive thumbnail grid view in `OrganizePagesScreen` with multi-select mode, bulk rotate, bulk delete, and drag-and-drop reordering).
- **Custom Watermarks**: [x] ✅ Implemented (`WatermarkDialog`, text/image watermarks, opacity slider, rotation slider, font size, color chips, page range filtering, and repeated tiling).
- **Batch Operations**: [x] ✅ Implemented (`BatchOperationsDialog` & `PageOpsService.runBatchOperation`, multi-PDF batch encryption, merge, text extraction, margin trim, and compression with progress updates).

### 3.5 PDF Printer Enhancements ✅
- **N-Up Multi-Page Layouts**: [x] ✅ Implemented (`NUpDialog`, `PrintService.printNUp`, and `PageOpsService.generateNUp`, 2-in-1, 4-in-1, 6-in-1, and 9-in-1 layout imposition grids with orientation, margin, and border styling).
- **Web Content Cleaner**: [x] ✅ Implemented (`WebContentCleaner` & `ImportScreen`, automatic detection of shared HTML/web content and offline reader mode stripping headers, footers, navs, sidebars, cookie banners, scripts, ads, and tracking parameters).

### 3.6 Digital Signature Verification Enhancements ✅
- **Visual Stamp Inspection**: [x] ✅ Implemented (`SignatureDetailSheet` & `ViewerScreen._buildPageOverlays`, direct tap inspection on visual signature stamps on rendered pages).
- **Trust Certificate Manager**: [x] ✅ Implemented (`TrustStoreScreen` & `SignatureRepository.exportCertificate` / `exportAllCertificates`, importing and exporting self-signed certificates as standard PEM files via SAF).

### 3.7 Interoperability with Ready Ecosystem Apps (`myapps.md`)
- **`sreeraj_qr_reader` Integration**: Share decoded QR codes and barcodes directly to the user's dedicated QR reader app for advanced history and action handling.
- **`vault-files` Integration**: Send sensitive PDF output copies directly into the user's offline secure file vault app.
- **`SreerajP_Journal_Vault` Integration**: Attach PDF quotes, text excerpts, or audio notes directly into journal entries.
- **`SreerajP_TextApp` & `SreerajP_CodeApp` Integration**: Handoff extracted plain text, tabular data, or embedded scripts to specialized text and code editing tools.

---

## 4. Revised Implementation Roadmap & Priority Matrix

Completed phases are marked below, followed by upcoming milestone phases.

| Phase | Milestone Name | Status | Primary Technical Stack |
|---|---|---|---|
| **Phase 0–8** | Baseline PDF Reader, Printer & Security | **Completed (100%)** | Flutter, `pdfrx`, `PdfBox-Android`, Bouncy Castle, `sqflite` |
| **Feature 2.1** | Indic Phonetic & Sandhi Search Engine | **Completed (100%)** | `SandhiEngine`, `IndicPhoneticEngine`, `SearchNormalizer` |
| **Feature 2.7** | Smart Margin Trimming & Booklet Engine | **Completed (100%)** | `BookletImpositionPlanner`, `PdfBox-Android`, `LayerUtility` |
| **Features 3.1 & 3.2** | OLED Theme, Reading Velocity, Foldable Support, ML Input Helper & TTS Controls | **Completed (100%)** | `AppTheme.oled`, `ReadingVelocityService`, `MalayalamTransliteration`, Android `TtsHandler` Player |
| **Features 3.4, 3.5 & 3.6** | Page Operations (Grid, Watermarks, Batch), N-Up & Web Cleaner, Signature Stamp Inspection & Trust Store PEM Export | **Completed (100%)** | `PdfBoxHandler.kt`, `PageOpsService`, `WebContentCleaner`, `SignatureDetailSheet`, `TrustStoreScreen` |
| **Phase 9** | Advanced Reading & Visual Tools | Planned | Audio Notes, Shape Smoothing |
| **Phase 10** | Redaction, Diff & Forensic Security | Planned | `PdfBox-Android`, `pdfrx` bitmap diff engine, Incremental Xref Parser |
| **Phase 11** | Script Innovations & Ecosystem Interoperability | Planned | QR Decoupler, `myapps.md` Intent Integrations |

---

## 5. Architectural & Technical Guidelines

When implementing any feature from this roadmap, developers must strictly adhere to the following rules:

1. **Verify Open-Source Licenses**: Check licenses before introducing any third-party Dart package or native library. No proprietary or commercial SDKs are permitted.
2. **Off-Main-Thread Processing**: Run heavy operations (such as PDF diff comparisons, redaction parsing, and image extraction) inside background Dart isolates (`compute`) or native Kotlin threads to keep the UI smooth.
3. **Strict Copy-on-Write Handling**: Always create new output files for modified documents. Never modify original files in place.
4. **Graceful Error Recovery**: Ensure all parsers return clear error messages on corrupted, password-protected, or malformed input without crashing the app.
5. **Simple English Standard**: Keep code comments, error messages, user documentation, and UI text in clear and simple English.
