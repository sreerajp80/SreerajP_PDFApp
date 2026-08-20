# SreerajP PDF App — Features & App Documentation

## 1. App Overview & Description

**SreerajP PDF App** (`pdfapp` / `in.sreerajp.pdfapp`) is an offline-first, open-source, privacy-focused Android application built with **Flutter** (3.44.8+) and **native Kotlin** (minSdk 26 / Android 8.0+). It serves as a comprehensive tool for viewing, navigating, searching, reading aloud (text-to-speech), selecting/copying text, annotating, reorganizing, watermarking, imposing (N-up and booklet), trimming, extracting data from, encrypting/decrypting, compressing, verifying digital signatures of, and printing PDF documents. Additionally, it functions as a system-wide PDF printer and content conversion hub for Android, allowing other applications to share images, plain text, or web content to be cleaned, saved, or printed as PDFs.

### Key Architectural Principles & Hard Rules

1. **100% Open Source Stack**: Core functionality relies exclusively on open-source libraries:
   - **Rendering**: `pdfrx` (pdfium, BSD license).
   - **Document Processing & Page Operations**: `PdfBox-Android` (Apache 2.0 license).
   - **Cryptography & Signatures**: Bouncy Castle (`org.bouncycastle`) & native `CertPathValidator`.
   - **Text-to-Speech**: `flutter_tts` (MIT license) & native Android TTS engine integration.
   - **Database**: `sqflite` (MIT license) in SQLite WAL mode.
   - **Unicode & Script Normalization**: `unorm_dart` (MIT license) & `characters`.
   - **Navigation**: `go_router` (BSD license).
   - **Settings Storage**: `shared_preferences` (BSD license).
   - **App Version Info**: `package_info_plus` (BSD license), shown on the About screen.
   - **Hashing**: `crypto` (BSD license), used for SHA-256 document fingerprinting.
   - **Logging**: `logger` (MIT license).
   - **State Management**: `flutter_riverpod` (MIT license), used throughout the app's screens and services.
   - **File Paths**: `path_provider` (BSD license), used to locate app-local output and cache folders for generated files.
   - **Locale-Sensitive Formatting**: `intl` (BSD license), used for date and file-size formatting and localizations.
   - **Localization Framework**: `flutter_localizations` (Flutter SDK), backing the dual-language (English/Malayalam) UI.
   - **Bundled Fonts**: Open-source Malayalam and multilingual fonts (`Manjari`, `Anek Malayalam`, `Noto Sans Malayalam`).
   *Commercial or proprietary SDKs (e.g., Syncfusion, PSPDFKit, Apryse) are strictly forbidden.*
2. **Offline-First & Zero Telemetry**: Fully functional without network access. The app requests no internet permission (`android.permission.INTERNET` is absent) and collects zero user data or telemetry. Local cryptographic signature verification is performed entirely offline using bundled and user-imported trust stores.
3. **Scoped Storage & SAF URI Persistence**: Files are accessed strictly via system file pickers (Storage Access Framework — `ACTION_OPEN_DOCUMENT`) and Android share/view intents (`ACTION_VIEW`, `ACTION_SEND`, `ACTION_SEND_MULTIPLE`). No broad storage permissions (`READ_EXTERNAL_STORAGE` / `MANAGE_EXTERNAL_STORAGE`) are requested. Persistable URI permissions (`takePersistableUriPermission`) are maintained so recently opened documents remain accessible across app reboots. Stale or moved file URIs degrade gracefully with clear error prompts.
4. **Copy-on-Write Operations**: Every page modification or document operation (merge, split, reorder, rotate, delete, watermark, N-up, booklet, trim margins, compress, encrypt, decrypt, export annotations, print/save) generates a **new output file**. Original PDF files are **never** overwritten in place.
5. **Never Crash on Bad Input**: Corrupt, truncated, empty, or password-protected files trigger clear, friendly error UI instead of app crashes.
6. **Never a Dead Button**: Shared components (e.g., TTS speech engines, system print services) report their operational state and provide clear setup or fallback paths when unavailable.
7. **OCR Out of Scope & Graceful Degradation**: Scanned (image-only) PDFs without a text layer degrade gracefully by showing a clear notice (`TextQualityNotice`) and safely disabling text-dependent features (search, copy, text extraction, TTS).
8. **Dual-Language UI (i18n / l10n)**: Native UI localization supporting both **English (`en`)** and **Malayalam (`ml`)**.

---

## 2. Exhaustive Feature Catalog

### 2.1 PDF Viewing & Navigation Engine

- **High-Performance Rendering**: Fast, crisp PDF page rendering powered by native pdfium (`pdfrx`).
- **Flexible Viewing & Fit Modes**:
  - Viewing Modes: Single Page view, Continuous Vertical Scrolling, Book view (two pages side by side), and Auto mode (adapts dynamically between single/continuous and dual-page book view based on screen width and foldable state).
  - Page Fit Modes: Fit-to-Width and Fit-to-Page display options.
- **Foldable & Dual-Screen Support**: Adaptive dual-page book view on wide screens and foldable devices with display hinge gap spacing.
- **Reading Velocity & Time Estimates**: Real-time reading speed tracking (words per minute and seconds per page) calculating remaining reading time for the active chapter (derived from the document outline) and the total document. Configurable via Reader Settings.
- **Thumbnail Grid Navigation**: Tap-to-jump thumbnail grid panel for quickly scanning and jumping to any page, separate from the page-viewing modes.
- **Smooth Pinch-to-Zoom & Scale Preservation**: Interactive gesture transformation with zoom scale preservation across device orientation changes and window resizes. A "Reset Zoom" control returns the page to its default scale.
- **Double-Tap Zoom**: Configurable double-tap action in Reader Settings (toggle between Fit to Width and 200% Zoom).
- **Large File Safeguard**: Very large PDFs automatically open in single-page mode (rather than continuous scroll) with an on-screen warning, to keep rendering smooth.
- **Invert Colors Toggle**: Option to invert page colors for comfortable night reading, separate from reading themes.
- **Document Outline / Table of Contents (TOC)**: Drawer navigation parsing document bookmark hierarchies for direct section jumping.
- **Direct Page Navigation**: Page jump bottom sheet featuring exact page number input and interactive page slider.
- **Password-Protected PDF Support**: On-demand password dialog for opening encrypted documents with full password validation and retry handling.
- **Document Content Fingerprinting**: Unique SHA-256 content fingerprinting (`size:sha256`) ensuring document identity, annotations, bookmarks, and reading positions persist across file renaming or path relocation.
- **Reading Position Persistence**: Automatically saves and restores last-read page number and viewing mode per document in a local SQLite database (`reading_positions` table).
- **Recent Files Dashboard**: Home screen recents gallery detailing display name, page count, thumbnail/icon, and last-opened date. Features one-tap reopening, single-item deletion, bulk history clearing in Storage Settings, and stale URI removal. Keeps the 30 most recently opened files.

### 2.2 Search, Indic Phonetic & Sandhi Engine, and Text-to-Speech (TTS)

- **On-Page Full-Text Search**: Real-time keyword search with match counting, next/previous match navigation, and bright match highlighting on rendered pages.
- **Select & Copy Text**: Native text selection on rendered pages wherever a real text layer exists, allowing users to select and copy passages. Automatically disabled when the page has no usable text layer, and disabled during active annotation drawing.
- **Indic Phonetic & Sandhi-Aware Search (Malayalam & Devanagari/Sanskrit)**:
  - **Sandhi Compound Joining & Splitting Engine**: Rule-based Sandhi compound transformation supporting Vowel Sandhi (Savarna Deergha, Guna, Vriddhi, Yan, Ayadi, Poorvaroopa with Avagraha `ഽ`/`ऽ`), Consonant Sandhi (Jashthva, Anunasika, Schutva, Parasavarna), Visarga Sandhi (Ruthva, Sathva, Uthva, Lopa), and Malayalam Dravidian Sandhi (Agama, Dvitva, Lopa, Adesha). Multi-word queries automatically match joined compounds and vice versa.
  - **Indic Phonetic Sound-Alike Engine**: Unifies Anusvara (`ം`/`ं`) and class nasal conjuncts (e.g. `സംഗീതം` / `സങ്ഗീതം`, `गंगा` / `गङ्गा`, `संत` / `സന്ത`), chillu and virama/halant forms, NTA ligatures (`ന്റ` vs `ൻറ` vs `ൻറ്റ`), Samvruthokaram endings (`്` vs `ു` vs `ു്`), and Sanskrit repha gemination (`धर्म्म` / `धर्म`, `ര്മ്മ` / `ർമ`).
  - **Unicode NFC Normalization**: Standardizes Unicode representations via `unorm_dart`.
  - **Chillu Unification**: Folds traditional multi-character `consonant + virama + ZWJ` sequences into single atomic chillu characters (`ണ`+virama+ZWJ -> `ൺ`, `ന`+virama+ZWJ -> `ൻ`, `ര`+virama+ZWJ -> `ർ`, `ല`+virama+ZWJ -> `ൽ`, `ള`+virama+ZWJ -> `ൾ`, `ക`+virama+ZWJ -> `ൿ`).
  - **Joiner-Ignorable Matching**: Strips zero-width joiners (`ZWJ` `U+200D`) and zero-width non-joiners (`ZWNJ` `U+200C`) from comparison keys by default so users need not type invisible characters.
  - **Strict Joiner Mode Option**: Configurable toggle allowing users to require exact ZWJ/ZWNJ joiner matching when needed.
  - **Grapheme-Cluster Alignment**: Aligns matches strictly along grapheme boundaries using the `characters` package, preventing highlights from slicing letters or vowel signs.
  - **Sanskrit Cantillation Accent Stripping (opt-in)**: Folds Vedic and Devanagari cantillation/tone accents so queries typed without accents match accented Sanskrit text in both Devanagari and Malayalam scripts.
- **Search Options Menu**: In-search settings menu with direct checkboxes for "Sandhi search", "Phonetic matching", "Strict spelling", and "Ignore Accents".
- **Malayalam Input Helper & Virtual Keypad**:
  - Live Manglish-to-Malayalam phonetic transliteration suggestions displayed directly above the search bar.
  - Expandable 3-tab virtual Malayalam keypad (Vowels, Consonants, Signs & Chillu) providing complete Malayalam input even without a native Indic system keyboard.
- **Text Quality Inspector & Notice**: Automatically inspects extracted page text for missing or garbled `ToUnicode` maps, displaying a friendly info banner (`TextQualityNotice`) and disabling text operations safely when text layer is absent or corrupted.
- **Text-to-Speech (TTS) & Playback Controls**:
  - Reads PDF text aloud in English (`en-US`) and Malayalam (`ml-IN`) via `flutter_tts` and native Android TTS.
  - Fine-grained playback controls in TTS Settings: Speech Rate slider (0.5x to 2.0x), Pitch slider (0.5x to 2.0x), Sentence Pause slider (0.0s to 2.0s), and Auto-Scroll toggle.
  - Persistent Android media playback notification with play/pause and stop controls for background listening.
- **TTS Voice Installer Helper**: Automatically detects missing voice data (`LANG_MISSING_DATA` or `LANG_NOT_SUPPORTED`) and offers native Android intent options to install voices (engine voice installer, system TTS settings, or Google TTS store link).

### 2.3 Annotation Overlay & Markup System

- **Non-Destructive Storage**: Stores annotations locally in an SQLite database (`annotations` table) keyed by content fingerprint without altering original PDF files.
- **Text Markups**: Highlight, Underline, and Strikethrough with 7 customizable color presets (Yellow, Green, Blue, Red, Purple, Orange, Black).
- **Sticky Notes**: Coordinate-anchored note pins with an editable text body.
- **Freehand Drawing (Ink)**: Freehand drawing tool with customizable stroke color and smooth rendering.
- **Bookmarks Panel**: Page-level bookmarking with an interactive jump list and one-tap page bookmarking.
- **Eraser Tool**: Tap-to-remove tool for deleting individual markup or ink strokes from the overlay.
- **Clear All**: Single action (with confirmation dialog) that removes all overlay annotations on the current document.
- **Export / Flatten Annotations**: Flattens and burns all overlay annotations and bookmarks into real PDF annotation objects and document outline in a permanent new copy of the PDF using `PdfBox-Android`.

### 2.4 Page Operations & Document Reorganization (Copy-on-Write)

- **Visual Organize Pages Grid**: Interactive thumbnail grid screen allowing users to reorder pages via drag-and-drop, rotate pages (0°, 90°, 180°, 270°), or delete specific pages with an immediate "Undo" action. Supports multi-selection mode (select all, invert selection, bulk rotate, and bulk delete).
- **Custom Text Watermarks**: Add custom text watermarks to single pages or page ranges with configurable opacity, diagonal/horizontal rotation angle, font size, color presets, and optional repeating grid tiling.
- **N-Up Multi-Page Imposition**: Combine multiple pages onto a single sheet (2-in-1, 4-in-1, 6-in-1, 9-in-1 layouts) on A4 or US Letter sheets with customizable page borders, sheet orientation, and margin sliders.
- **Batch PDF Operations**: Execute batch operations across multiple SAF-picked PDF files (Batch Compress, Batch Watermark, Batch Encrypt/Protect, Batch Decrypt/Unlock, Batch Margin Trim, Batch Text Extraction, Batch Merge) with real-time step progress reporting.
- **Smart Margin Trim / Crop**: Auto-detects white space margins with live preview and trims unnecessary margins for improved reading on mobile screens.
- **Booklet Creator (Imposition)**: Formats document pages into printable saddle-stitch booklet order (e.g., 4-1, 2-3) with automatic 4-page rounding padding.
- **Merge PDFs**: Combine multiple selected PDF documents into a single unified PDF file.
- **Split PDF**: Split a multi-page PDF into separate single-page PDF files (one output file per page).
- **Compress PDF**: Best-effort size reduction that strips optional document metadata, unused objects, and XMP metadata without re-encoding media.
- **Encrypt PDF (Protect)**: Secure PDF files with user and owner passwords using standard AES-256 security.
- **Decrypt PDF (Unlock)**: Remove password protection by producing an unencrypted PDF copy.
- **Save or Share the Result**: Every operation produces a new file that can be saved directly to a user-selected folder via SAF or shared via the Android system share sheet.

> **Note:** Merge, Split, Organize Pages, Booklet, Trim, and Compress expect an unencrypted source file. For password-protected PDFs, run Decrypt (Unlock) first.

### 2.5 Data Extraction & Document Utilities

- **Text Extraction**: Extract plain text from page ranges or full document; copy to clipboard, share via Android share sheet, or save as a `.txt` file.
- **Image Extraction**: Extract all embedded PNG and JPEG images from selected page ranges into a target folder.
- **Interactive Form Fields Reader**: Parse and display interactive PDF form fields (text inputs, checkboxes, radio buttons, dropdown choice lists); copy field details to clipboard or share as a `.json` file.
- **Render Pages to Images**: Export page ranges as high-resolution PNG/JPEG images with a customizable DPI slider (100–300 DPI).
- **Document Metadata Inspector**: Detailed metadata modal displaying Title, Author, Subject, Keywords, Creator, Producer, Creation Date, Modification Date, Page Count, File Size, PDF Version, and Encryption state.

### 2.6 PDF Printer & Content Importer ("Print to PDF" / Share Hub)

- **Android System Printer Integration**: Streams PDF documents, specific page ranges, or extracted plain text to the native Android print spooler (`PrintManager`) for printing to hardware printers or saving as PDF.
- **N-Up Grid Printing**: Print 2, 4, 6, or 9 pages per sheet directly to hardware printers or Android Print Spooler.
- **Web Content Cleaner (Reader Mode)**: Offline cleaner for shared web pages and HTML text that strips headers, footers, navigation, sidebars, cookie notices, scripts, ads, and tracking parameters before printing or converting to PDF.
- **Images-to-PDF Converter**: Import single or multiple images (JPEG, PNG, up to 100 images per import) from file picker or share intents and convert them into a single formatted PDF document.
- **Text-to-PDF Converter**: Import shared or typed plain text and convert it into a multi-page PDF document with automatic line-wrapping, pagination, font metrics, and UTF-8 / Latin-1 validation.
- **Direct PDF Intent Viewer**: Opens PDF files shared directly from other apps (`ACTION_VIEW` and `ACTION_SEND` for `application/pdf`).
- **System Share & View Intent Filters**: Registered target for `ACTION_VIEW`, `ACTION_SEND` (PDFs, images, plain text), and `ACTION_SEND_MULTIPLE` (images).

### 2.7 Digital Signature Verification & Trust Store

- **Native Cryptographic Engine**: Kotlin platform-channel engine leveraging `PdfBox-Android`, Bouncy Castle (`org.bouncycastle`), and Java `CertPathValidator`.
- **Fact-Based Verification Checks**:
  - Cryptographic byte integrity validation (supporting SHA-1 for legacy `adbe.pkcs7.sha1` signatures, SHA-256 for fingerprints, and dynamic algorithm discovery).
  - Byte coverage scope evaluation (`coversWholeFile` vs incremental updates appended after signing).
  - Validity period verification (`notBefore` and `notAfter` timestamp checks).
  - Signer details extraction: Signer Name, Location, Contact Info, Signing Reason, and Signing Time.
  - Full X.509 Certificate Chain Details: Subject DN, Issuer DN, Serial Number, SHA-256 Fingerprint, Public Key Algorithm.
  - Offline certificate revocation checking from embedded signature data.
- **Visual Signature Badges & Stamp Overlay**:
  - On-page status overlay drawn directly over the PDF viewer's signature widgets.
  - Interactive touch overlay on signature stamps allowing one-tap opening of full signature details.
  - Dedicated Signatures Dashboard summarizing document signatures with overall verdict (weakest signature decides document status).
- **Bundled & Custom Trust Stores**:
  - **Bundled Trust Lists**: Bundled European Union Trusted Lists (EU EUTL) root certificates for offline validation.
  - **Custom Trust Store**: SQLite-backed certificate manager (`trust_store` table) supporting import of custom X.509 root/CA certificates (`.pem`, `.cer`, `.crt`, `.der`, up to 512 KB per file). Expired certificates remain visible with an expiration warning.
  - **Certificate Export**: Export individual certificates or export the full trust store as standard `.pem` bundles via SAF.

### 2.8 Themes, Settings & System Integration

- **Appearance Customization**:
  - **Theme Modes**: Light, Dark, OLED Pitch-Black (`#000000` background for battery savings), and System Default.
  - **Custom Typography**: Dynamic app-wide font switching (`System Default`, `Manjari`, `Anek Malayalam`, `Noto Sans Malayalam`).
  - **Text Scaling**: App text scale presets (`Small`, `Default`, `Large`, `Larger`).
  - **Accent Color Picker**: Live preview chip, 8 preset swatches, interactive HSV color wheel with hue/saturation gesture control, brightness slider, and reset-to-default controls.
- **Comprehensive Settings Architecture (10 Dedicated Hubs)**:
  1. **Appearance**: Theme Mode, Typography, and Accent Color configuration.
  2. **Language**: System Default, English, and Malayalam selection.
  3. **Reader Preferences**: Remember last-read position, page number indicator, reading time estimates, inverted colors, default layout (Auto, Continuous, Single Page), and double-tap zoom behavior.
  4. **Read Aloud (TTS)**: Malayalam voice toggle, voice installer helper, auto-scroll toggle, speech rate slider, pitch slider, and sentence pause slider.
  5. **Virtual PDF Printer**: Virtual printer enable/disable toggle, default paper size (A4, Letter, Legal), color mode (Color, Grayscale, Monochrome), default orientation (Auto, Portrait, Landscape), and printer cache cleaner.
  6. **Storage & Privacy**: Remember recent files toggle, bulk "Clear Recent Files History" action, and temporary cache cleaner.
  7. **Trust Store**: Certificate list, import custom certificates, export individual/all certificates, and delete certificates.
  8. **App Permissions**: Transparent breakdown explaining Scoped Storage, zero internet access, no broad storage permissions, and no audio recording.
  9. **Help Center**: Centralized access to 6 detailed user guides.
  10. **About Screen**: Data-driven from `assets/config/app_config.json`, displaying app name, description, version/build number, author, email, license statement, and AI/IDE development tools.

### 2.9 Built-In Help & User Guides

- **PDF Printer Setup Guide (`/help/pdf-printer`)**: Instructions for enabling and configuring Android's system virtual print service.
- **Unicode & Malayalam Printing Guide (`/help/unicode-printing`)**: Step-by-step guide for capturing print jobs from other apps, font embedding, and preserving complex Indic/Malayalam glyph shaping without broken ligatures.
- **Read Aloud & Malayalam Voice Guide (`/help/tts`)**: Guide to setting up TTS, downloading offline Malayalam voice engines, and configuring speech speeds and sentence pauses.
- **Organizing & Modifying Pages Guide (`/help/page-ops`)**: Overview of page operations (reorder, rotate, delete), booklets, N-up grids, and the strict copy-on-write safety guarantee.
- **Digital Signatures & Trust Store Guide (`/help/signatures`)**: Explanation of cryptographic signature validation, certificate chains, and trust store management.
- **Privacy & Scoped Storage Guide (`/help/privacy-storage`)**: Details on the zero-internet privacy guarantee, Scoped Storage (SAF) boundaries, and cache cleanup.
