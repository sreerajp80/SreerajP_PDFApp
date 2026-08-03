# Feature Analysis and Product Roadmap — SreerajP_PDFApp

This document details new features and enhancements for the **SreerajP PDF App**. It focuses on features that are absent from mainstream Android PDF applications (such as Adobe Acrobat, Foxit, PDF Extra, ReadEra, and Xodo), while respecting all project rules: **open-source only**, **offline-first**, **scoped storage only**, **copy-on-write**, and **no OCR**.

---

## 1. Executive Summary & Core App Philosophy

The SreerajP PDF App is an open-source, privacy-focused Android PDF reader and printer built with Flutter and native Kotlin.

### Hard Constraints
1. **Open-Source Stack Only**: Uses `pdfrx` (pdfium), `PdfBox-Android` (Apache 2.0), Bouncy Castle, and native Android platform APIs. Commercial SDKs (such as Syncfusion, PSPDFKit, or Apryse) are strictly banned.
2. **Offline-First**: All rendering, search, text extraction, TTS, signature verification, and page operations run completely offline on the user device.
3. **Scoped Storage Only**: Files are opened using system file pickers (Storage Access Framework) or share intents. No broad storage permissions are requested.
4. **Copy-on-Write**: Every page modification (merge, split, reorder, rotate, compress, encrypt) writes a new output file. The original PDF file is never overwritten.
5. **No OCR**: Scanned (image-only) PDFs gracefully report missing text layers and safely turn off text-dependent features (search, copy, TTS) without crashing.
6. **Simple English**: All documentation, user guides, and notifications use clear and simple English.

---

## 2. Unique Features (Not Available in Similar Android PDF Apps)

These feature concepts solve real user problems that standard PDF readers neglect.

```
+-------------------------------------------------------------------------------+
|                      UNIQUE / WORLD-FIRST FEATURES                            |
+------------------------------------+------------------------------------------+
| 1. Indic Phonetic & Sandhi Search  | Sandhi compound & sound-alike matching   |
| 2. Visual PDF Diff Heatmap         | Offline side-by-side visual comparison   |
| 3. Smart Offline Redactor          | True physical PII removal without cloud  |
| 4. Forensic Revision Inspector     | View incremental update history & certs  |
| 5. Bionic & Karaoke Reader         | Dual-mode TTS sync with Bionic typography|
| 6. Air-Gapped Barcode Decoupler    | Decode & inspect QR/barcodes inside PDFs |
| 7. Smart Margin & Booklet Engine   | Trim margins & 2-Up fold print layouts   |
+------------------------------------+------------------------------------------+
```

### 2.1 Phonetic and Sandhi-Aware Indic Search (Malayalam & Sanskrit)
- **Problem**: Standard PDF search engines match exact bytes. In Malayalam and Sanskrit, words combine through complex joining rules (Sandhi), alternate Unicode forms (chillu characters), and spelling variations. Users searching for a split root word miss joined compounds in the text layer.
- **Solution**: A dedicated search engine using ICU Unicode normalization, chillu unification, joiner-ignorable matching, and phonetic sound-alike rules.
- **Key Capability**: Finds matching Malayalam or Sanskrit words even when typed with split Sandhi parts, alternate chillu encodings, or slightly different phonetic spellings.

### 2.2 Offline Visual PDF Diff & Revision Heatmap Engine
- **Problem**: Comparing two PDF document versions on Android requires expensive cloud subscriptions or desktop software. Mobile viewers either lack diff tools or only support basic text diffs.
- **Solution**: A local, side-by-side and overlay visual comparison tool powered by background `pdfrx` bitmap rendering off the UI thread.
- **Key Capability**: Displays page diffs with visual heatmaps — green highlights for added content, red for deleted elements, and blue for layout shifts. Works entirely offline without sending data to servers.

### 2.3 Privacy-Preserving Offline Smart Redactor
- **Problem**: Removing sensitive information (such as credit card numbers, phone numbers, email addresses, or national identity IDs) usually requires manual black boxes. Simple black rectangles drawn over text do not remove the underlying text layer, leaving data vulnerable to extraction.
- **Solution**: An offline scanning tool using local regex rules to detect sensitive information patterns.
- **Key Capability**: Performs true physical content removal using `PdfBox-Android`. Erases text streams from the output PDF copy and draws permanent black redaction boxes over the target coordinates.

### 2.4 Zero-Trust PDF Forensic & Revision History Inspector
- **Problem**: PDF files allow incremental updates where new content or signatures are appended onto older file data. Bad actors can alter documents while hiding original versions. Standard readers only show the latest version.
- **Solution**: A forensic dashboard that parses xref tables and incremental update streams.
- **Key Capability**: Shows a complete timeline of document revisions. Allows users to view earlier historical versions of the document before subsequent edits were appended, and inspect digital signature certificates, digest algorithms, and cryptographic details.

### 2.5 Dual-Mode Bionic Reading & Synchronized Karaoke Reader
- **Problem**: Reading long PDF documents on small mobile screens causes eye strain, and standard text-to-speech (TTS) features only highlight full sentences or plain boxes.
- **Solution**: Combines Bionic Reading typography with word-level synchronized karaoke text highlighting during TTS playback.
- **Key Capability**: Boldens the initial letters of words to guide visual flow (Bionic Reading) while dynamically highlighting active words in sync with English and Malayalam TTS playback.

### 2.6 Air-Gapped Barcode & QR Code Payload Decoupler
- **Problem**: Tickets, utility bills, invoices, and boarding passes stored as PDFs often contain QR codes or 1D/2D barcodes (such as PDF417). Standard PDF readers treat them as static images.
- **Solution**: An offline barcode scanner that inspects PDF page render streams using open-source image analysis.
- **Key Capability**: Automatically locates barcodes and QR codes on PDF pages, decodes their embedded payloads (such as JSON data, plain text, or links), and allows users to copy, share, or verify payload data offline.

### 2.7 Smart Margin Trimming & Foldable Booklet Imposition Engine
- **Problem**: PDF pages often have wide blank margins that waste screen space on mobile phones. Printing multi-page documents as fold-ready booklets on Android is complex.
- **Solution**: Automatic content bounding-box calculation and print layout generator.
- **Key Capability**: Automatically crops blank page margins for mobile reading ("Smart Trim"). Generates 2-Up booklet imposition page orders (arranging pages 1, N, 2, N-1) for printing fold-ready physical booklets.

---

## 3. Enhancements for Existing Core Features

In addition to new features, existing modules can be improved for better performance and user experience.

```
+-------------------------------------------------------------------------------+
|                       EXISTING FEATURE IMPROVEMENTS                           |
+------------------------------------+------------------------------------------+
| Viewing & Navigation               | OLED pitch black, reading stats, foldables|
| Indic Search & Speech              | On-screen Malayalam keyboard helper      |
| Annotations Overlay                | Audio notes, shape auto-smoothing, FDF   |
| Page Operations                    | Drag-and-drop reorder, watermarks, batch |
| PDF Printer                        | N-Up slide layouts (2-in-1, 4-in-1 grid)  |
| Digital Signatures                 | Direct tap stamp inspection, trust import|
+------------------------------------+------------------------------------------+
```

### 3.1 Viewing & Navigation Enhancements
- **OLED Pitch-Black Theme**: Add a pure black dark mode tint (`#000000`) alongside dark and sepia modes to save battery on OLED screens.
- **Reading Velocity & Time Estimates**: Estimate remaining reading time per chapter based on calculated user reading speed.
- **Foldable & Dual-Screen Support**: Automatically adjust screen layout between single-page view on phones and dual-page book view on foldable devices or wide tablets.

### 3.2 Reading, Search & Speech Enhancements
- **Malayalam Keyboard Helper**: Provide an optional on-screen Malayalam transliteration helper for users whose device keyboards lack Indic input support.
- **TTS Controls**: Add pitch controls, sentence-ending pause adjustments, and persistent notification player controls for background playback.

### 3.3 Annotation Overlay Enhancements
- **Audio Sticky Notes**: Record short voice notes (AAC/m4a) attached to page coordinates, stored in the local overlay database and exported into PDF copies.
- **Shape Auto-Smoothing**: Smooth rough hand-drawn freehand ink drawings into clean lines, circles, rectangles, and arrows.
- **FDF / XFDF Import & Export**: Support standard annotation exchange formats to import and export markup to other open-source PDF tools.

### 3.4 Page Operations Enhancements
- **Visual Drag-and-Drop Reorder Grid**: Provide an interactive thumbnail grid view to reorder, select, delete, or rotate multiple pages visually.
- **Custom Watermarks**: Apply text or image watermarks with adjustable opacity, rotation, and tile spacing onto a new copy of the PDF.
- **Batch Operations**: Allow selecting multiple PDF files via SAF to perform batch encryption, batch merge, or batch text extraction in background isolates.

### 3.5 PDF Printer Enhancements
- **N-Up Multi-Page Layouts**: Support printing or saving multiple pages onto a single sheet (2-in-1, 4-in-1, or 9-in-1 layout grids).
- **Web Content Cleaner**: Remove unnecessary headers, footers, and sidebars when saving shared web content to PDF.

### 3.6 Digital Signature Verification Enhancements
- **Visual Stamp Inspection**: Allow users to tap directly on visual signature stamps on rendered pages to open signature detail sheets immediately.
- **Trust Certificate Manager**: Provide options to import and export self-signed enterprise certificates to the app trust store.

---

## 4. Implementation Roadmap & Priority Matrix

Features are organized into three phases based on technical dependency, effort, and user value.

| Phase | Milestone Name | Features Included | Primary Technical Stack |
|---|---|---|---|
| **Phase A** | Core UX & Precision Improvements | OLED Pitch-Black theme, Drag-and-Drop page grid, Audio sticky notes, Visual stamp inspection | Flutter UI, `sqflite`, `pdfrx` |
| **Phase B** | Advanced Document Tools | Smart Redactor, Visual PDF Diff Heatmap, Air-Gapped Barcode Decoupler | `PdfBox-Android`, `pdfrx`, open-source image tools |
| **Phase C** | Script & Printing Innovations | Sandhi-Aware Indic Search, Bionic Karaoke reader, Booklet Imposition engine | ICU `Normalizer2`, `flutter_tts`, `PdfBox-Android` |

---

## 5. Architectural & Technical Guidelines

When implementing any feature from this roadmap, developers must strictly adhere to the following rules:

1. **Verify Open-Source Licenses**: Check licenses before introducing any third-party Dart package or native library. No proprietary or commercial SDKs are permitted.
2. **Off-Main-Thread Processing**: Run heavy operations (such as PDF diff comparisons, redaction parsing, and image extraction) inside background Dart isolates (`compute`) or native Kotlin threads to keep the UI smooth.
3. **Strict Copy-on-Write Handling**: Always create new output files for modified documents. Never modify original files in place.
4. **Graceful Error Recovery**: Ensure all parsers return clear error messages on corrupted, password-protected, or malformed input without crashing the app.
5. **Simple English Standard**: Keep code comments, error messages, user documentation, and UI text in clear and simple English.
