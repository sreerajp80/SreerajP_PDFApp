# SreerajP PDF App — Features & App Documentation

## 1. App Overview & Description

**SreerajP PDF App** (`pdfapp` / `in.sreerajp.pdfapp`) is an offline-first, open-source, privacy-focused Android application built with **Flutter** (3.44.8+) and **native Kotlin** (minSdk 26 / Android 8.0+). It serves as a comprehensive tool for viewing, navigating, searching, listening to (text-to-speech), selecting/copying text from, annotating, reorganizing, extracting from, encrypting/decrypting, compressing, verifying digital signatures of, and printing PDF documents. Additionally, it functions as a system-wide PDF printer and content conversion hub for Android, allowing other applications to share images, plain text, or documents to be saved or printed as PDFs.

### Key Architectural Principles & Hard Rules

1. **100% Open Source Stack**: Core functionality relies exclusively on open-source libraries:
   - **Rendering**: `pdfrx` (pdfium, BSD license).
   - **Document Processing & Data**: `PdfBox-Android` (Apache 2.0 license).
   - **Cryptography & Signatures**: Bouncy Castle (`org.bouncycastle`) & native `CertPathValidator`.
   - **Text-to-Speech**: `flutter_tts` (MIT license).
   - **Database**: `sqflite` (MIT license).
   - **Unicode & Script Normalization**: `unorm_dart` (MIT license) & `characters`.
   - **Navigation**: `go_router` (BSD license).
   - **Settings Storage**: `shared_preferences` (BSD license).
   - **App Version Info**: `package_info_plus` (BSD license), shown on the About screen.
   - **Hashing**: `crypto` (BSD license), used for SHA-256 document fingerprinting.
   - **Logging**: `logger` (MIT license).
   - **State Management**: `flutter_riverpod` (MIT license), used throughout the app's
     screens and services.
   - **File Paths**: `path_provider` (BSD license), used to locate app-local output and
     cache folders for generated files.
   - **Locale-Sensitive Formatting**: `intl` (BSD license), used for date and file-size
     formatting and to back the generated localizations.
   - **Localization Framework**: `flutter_localizations` (Flutter SDK), backing the
     dual-language (English/Malayalam) UI.
   *Commercial or proprietary SDKs (e.g., Syncfusion, PSPDFKit, Apryse) are strictly forbidden.*
2. **Offline-First & Zero Telemetry**: Fully functional without network access. The app requests no internet permission (`android.permission.INTERNET` is absent) and collects zero user data or telemetry. Local cryptographic signature verification is performed entirely offline using bundled and user-imported trust stores.
3. **Scoped Storage & SAF URI Persistence**: Files are accessed strictly via system file pickers (Storage Access Framework — `ACTION_OPEN_DOCUMENT`) and Android share/view intents (`ACTION_VIEW`, `ACTION_SEND`, `ACTION_SEND_MULTIPLE`). No broad storage permissions (`READ_EXTERNAL_STORAGE` / `MANAGE_EXTERNAL_STORAGE`) are requested. Persistable URI permissions (`takePersistableUriPermission`) are maintained so recently opened documents remain accessible across app reboots. Stale or moved file URIs degrade gracefully with clear error prompts.
4. **Copy-on-Write Operations**: Every page modification or document operation (merge, split, reorder, rotate, delete, compress, encrypt, decrypt, export annotations, print/save, export page range) generates a **new output file**. Original PDF files are **never** overwritten in place.
5. **Never Crash on Bad Input**: Corrupt, truncated, empty, or password-protected files trigger clear, friendly error UI instead of app crashes.
6. **Never a Dead Button**: Shared components (e.g., TTS speech engines, system print services) report their operational state and provide clear setup or fallback paths when unavailable.
7. **OCR Out of Scope & Graceful Degradation**: Scanned (image-only) PDFs without a text layer degrade gracefully by showing a clear notice (`TextQualityNotice`) and safely disabling text-dependent features (search, copy, text extraction, TTS).
8. **Dual-Language UI (i18n / l10n)**: Native UI localization supporting both **English (`en`)** and **Malayalam (`ml`)**.

---

## 2. Exhaustive Feature Catalog

### 2.1 PDF Viewing & Navigation Engine

- **High-Performance Rendering**: Fast, crisp PDF page rendering powered by native pdfium (`pdfrx`).
- **Flexible Viewing & Fit Modes**:
  - Viewing Modes: Single Page view, Continuous Vertical Scrolling, and Book view (two pages
    side by side).
  - Page Fit Modes: Fit-to-Width and Fit-to-Page display options.
- **Thumbnail Grid Navigation**: Tap-to-jump thumbnail grid panel for quickly scanning and
  jumping to any page, separate from the page-viewing modes above.
- **Smooth Pinch-to-Zoom & Scale Preservation**: Interactive gesture transformation with zoom scale preservation across device orientation changes and window resizes. A "Reset Zoom" control returns the page to its default scale.
- **Large File Safeguard**: Very large PDFs automatically open in single-page mode (rather than continuous scroll) with an on-screen warning, to keep rendering smooth.
- **Invert Colors Toggle**: Menu option to invert page colors for comfortable reading, separate from the Sepia and Dark reading themes.
- **Document Outline / Table of Contents (TOC)**: Drawer navigation parsing document bookmark hierarchies for direct section jumping.
- **Direct Page Navigation**: Page jump bottom sheet featuring exact page number input and interactive page slider.
- **Password-Protected PDF Support**: On-demand password dialog for opening encrypted documents with full password validation and retry handling.
- **Document Content Fingerprinting**: Unique SHA-256 content fingerprinting (`size:sha256`) ensuring document identity, annotations, bookmarks, and reading positions persist across file renaming or path relocation.
- **Reading Position Persistence**: Automatically saves and restores last-read page number and viewing mode per document in a local SQLite database (`reading_positions` table).
- **Recent Files Dashboard**: Home screen recents gallery detailing display name, page count, thumbnail/icon, and last-opened date. Features one-tap reopening, manual history clearing, and stale URI removal. Keeps the 30 most recently opened files; older entries drop off the list automatically.

### 2.2 Search, Indic Phonetic & Sandhi Engine, and Text-to-Speech (TTS)

- **On-Page Full-Text Search**: Real-time keyword search with match counting, next/previous match navigation, and bright yellow/orange match highlighting on rendered pages.
- **Select & Copy Text**: Native text selection on rendered pages wherever a real text layer exists, so users can select and copy words or passages. Automatically disabled when the page has no usable text layer, and turned off while an annotation drawing gesture is in progress (so a markup stroke is not eaten by text selection).
- **Indic Phonetic & Sandhi-Aware Search (Malayalam & Devanagari/Sanskrit)**:
  - **Unicode NFC Normalization**: Standardizes Unicode representations via `unorm_dart`.
  - **Chillu Unification**: Folds traditional multi-character `consonant + virama + ZWJ` sequences into single atomic chillu characters (`ണ`+virama+ZWJ -> `ൺ`, `ന`+virama+ZWJ -> `ൻ`, `ര`+virama+ZWJ -> `ർ`, `ല`+virama+ZWJ -> `ൽ`, `ള`+virama+ZWJ -> `ൾ`, `ക`+virama+ZWJ -> `ൿ`).
  - **Joiner-Ignorable Matching**: Strips zero-width joiners (`ZWJ` `U+200D`) and zero-width non-joiners (`ZWNJ` `U+200C`) from comparison keys by default so users need not type invisible characters.
  - **Strict Joiner Mode Option**: Configurable toggle allowing users to require exact ZWJ/ZWNJ joiner matching when needed.
  - **Grapheme-Cluster Alignment**: Aligns matches strictly along grapheme boundaries using the `characters` package, preventing highlights from slicing letters or vowel signs.
  - **Sanskrit Cantillation Accent Stripping (opt-in)**: When the user turns on the "Ignore Accents" option below, the app folds Vedic and Devanagari cantillation/tone accents so queries typed without accents match accented Sanskrit text (handles Sanskrit in both Devanagari and Malayalam scripts). Off by default, same as Strict Joiner Mode above.
- **Search Options Menu**: A settings icon in the search bar opens two checkboxes — "Strict" (exact joiner matching) and "Ignore Accents" (Sanskrit cantillation stripping) — so the user can see and control both toggles directly from the search bar.
- **Text Quality Inspector & Notice**: Automatically inspects extracted page text for missing or garbled `ToUnicode` maps, displaying a friendly info banner (`TextQualityNotice`) and disabling text operations safely when text layer is absent or corrupted.
- **Text-to-Speech (TTS)**: Reads PDF text aloud in English (`en-US`) and Malayalam (`ml-IN`) via `flutter_tts` with play, pause, and stop controls. Language is chosen automatically from the content and the Settings Malayalam-voice toggle (no manual speed, pitch, or language-picker controls).
- **TTS Voice Installer Helper**: Automatically detects missing voice data (`LANG_MISSING_DATA` or `LANG_NOT_SUPPORTED`) and offers native Android intent options to install voices (engine voice installer, system TTS settings, or Play Store link for Google TTS `com.google.android.tts`). Auto-disables Malayalam TTS toggle with a notice if voice data is removed.

### 2.3 Annotation Overlay & Markup System

- **Non-Destructive Storage**: Stores annotations locally in an SQLite database (`annotations` table) keyed by content fingerprint without altering original PDF files.
- **Text Markups**: Highlight, Underline, and Strikethrough with 7 customizable color presets (Yellow, Green, Blue, Red, Purple, Orange, Black).
- **Sticky Notes**: Coordinate-anchored note pins with an editable text body.
- **Freehand Drawing (Ink)**: Freehand drawing tool with customizable stroke color (stroke width is currently fixed, not user-adjustable).
- **Bookmarks Panel**: Page-level bookmarking with a quick bookmark navigation list. (The underlying data supports a custom label per bookmark, but no screen yet lets the user set or edit it.)
- **Eraser Tool**: Tap-to-remove tool for deleting individual markup or ink strokes from the overlay.
- **Clear All**: A single action (with confirmation) that removes every annotation on the current document in one step, separate from the per-stroke Eraser tool.
- **Export / Flatten Annotations**: Flattens and burns all overlay annotations into real PDF annotation objects in a permanent new copy of the PDF using `PdfBox-Android`. Bookmarks are also written into the new copy's own outline/table of contents, not just markup, notes, and ink. The result can be saved to a user-picked folder or shared, the same as the page-operation outputs below.

### 2.4 Page Operations & Document Reorganization (Copy-on-Write)

- **Visual Organize Pages Grid**: Interactive thumbnail grid screen allowing users to reorder pages via drag-and-drop, rotate pages (0°, 90°, 180°, 270°), or delete specific pages. Deleting a page shows an "Undo" action to restore it right away.
- **Merge PDFs**: Combine multiple selected PDF documents into a single unified PDF file.
- **Split PDF**: Split a multi-page PDF into separate single-page PDF files (one output file per page). To pull a specific page range out as text, images, or rendered pictures instead, see Data Extraction & Document Utilities (section 2.5).
- **Compress PDF**: Best-effort size reduction that strips optional document-info and XMP metadata and re-saves the file. It does not downsample embedded images or recompress content streams, so an already-optimized PDF will shrink little or not at all.
- **Encrypt PDF (Protect)**: Secure PDF files with user and owner passwords using a standard AES-256 security handler.
- **Decrypt PDF (Unlock)**: Remove password protection by producing an unencrypted PDF copy.
- **Save or Share the Result**: Every operation above produces a new file that the user can either save straight to a folder they pick, or send through the Android share sheet.

> **Note:** Merge, Split, Organize Pages, and Compress currently expect an already-unencrypted
> source file. For a password-protected PDF, run Decrypt (Unlock) first, then use the unlocked
> copy for these operations.

### 2.5 Data Extraction & Document Utilities

- **Text Extraction**: Extract plain text from page ranges or full document; copy to clipboard, share via Android share sheet, or save as `.txt` file.
- **Image Extraction**: Extract all embedded PNG and JPEG images from selected page ranges into a target folder.
- **Interactive Form Fields Reader**: Parse and display interactive PDF form fields (text inputs, checkboxes, radio buttons, dropdown choice lists); copy the field list to clipboard or share it as a `.json` file.
- **Render Pages to Images**: Export page ranges as high-resolution PNG/JPEG images with a customizable DPI slider (100–300 DPI).
- **Document Metadata Inspector**: Detailed metadata modal displaying Title, Author, Subject, Keywords, Creator, Producer, Creation Date, Modification Date, Page Count, File Size, PDF Version, and Encryption state.

### 2.6 PDF Printer & Content Importer ("Print to PDF" / Share Hub)

- **Android System Printer Integration**: Streams PDF documents, specific page ranges, or extracted plain text to the native Android print spooler (`PrintManager`) for printing to hardware printers or Android's built-in "Save as PDF".
- **Images-to-PDF Converter**: Import single or multiple images (JPEG, PNG) from system file picker or share intents and convert them into a single formatted PDF document (one image per page, fixed layout). A maximum of 100 images per import is enforced to keep conversion reliable; images past the 100th are silently dropped rather than causing an error.
- **Text-to-PDF Converter**: Import shared or typed plain text and convert it into a multi-page PDF document with automatic line-wrapping, pagination, font metrics, and UTF-8 / Latin-1 validation. If the text contains letters the bundled PDF font cannot draw (for example some non-Latin scripts), the app shows a clear "can't convert this text" message instead of producing a broken or blank PDF.
- **Save or Share the Converted PDF**: Both converters let the user save the new PDF straight to a folder they pick, or share it, the same as the page-operation outputs in section 2.4.
- **Open a Shared PDF Directly**: The app also accepts a PDF file shared straight from another app (`ACTION_SEND` for `application/pdf`), opening it for viewing/annotation — separate from the image/text-to-PDF conversion path above.
- **System Share & View Intent Filters**: Target for `ACTION_VIEW` and `ACTION_SEND` intents across Android (handles PDF files, images, and raw text shared from other apps). `ACTION_SEND_MULTIPLE` is registered for images only.

### 2.7 Digital Signature Verification & Trust Store

- **Native Cryptographic Engine**: Kotlin platform-channel engine leveraging `PdfBox-Android`, Bouncy Castle (`org.bouncycastle`), and Java `CertPathValidator`.
- **Fact-Based Verification Checks**:
  - Cryptographic byte integrity validation. SHA-1 and SHA-256 are used directly (SHA-1 for
    the legacy `adbe.pkcs7.sha1` signature type, SHA-256 for certificate/signer fingerprints);
    the general signature check follows whatever digest algorithm the signature itself
    declares, so other standard hash algorithms are supported by extension rather than
    hard-coded as a fixed list.
  - Byte coverage scope evaluation (`coversWholeFile` vs incremental updates appended after signing).
  - Validity period verification (`notBefore` and `notAfter` timestamp checks).
  - Signer details extraction: Signer Name, Location, Contact Info, Signing Reason, and Signing Time.
  - Full X.509 Certificate Chain Details: Subject DN, Issuer DN, Serial Number, SHA-256 Fingerprint, Public Key Algorithm.
  - Certificate revocation status, checked entirely offline from data embedded in the signature (the app never makes an online revocation lookup); the UI notes when revocation could not be checked.
- **Document-Level Summary Verdict**: Beyond each signature's own badge, the app computes one overall status for the whole document. If a document has several signatures, the weakest one decides the overall verdict (for example, one invalid signature makes the whole document show as not trusted).
- **Bundled & Custom Trust Stores**:
  - **Bundled Trust Lists**: Bundled European Union Trusted Lists (EU EUTL) root certificates for offline validation. (Adobe's AATL is deliberately not bundled, since its redistribution terms are not clearly open-source; users can still import AATL roots manually via the custom trust store below.)
  - **Custom Trust Store**: Certificate manager backed by SQLite (`trust_store` table). Import custom X.509 root/CA certificates (`.pem`, `.cer`, `.crt`, `.der`), up to 512 KB per file, for offline trust evaluation. Certificates that have expired are not removed automatically — they stay in the list marked with a red "expired" warning so the user can see and remove them on purpose.
- **Visual Signature Badges & Dashboard**: On-page signature badge indicators (Trusted green checkmark, Warning yellow, Invalid red) and dedicated document signatures dashboard. On the page itself, the app draws its own status overlay (trusted/invalid, signer name, and date) directly over the PDF viewer's native signature widget.

### 2.8 Themes, Settings & System Integration

- **Material 3 UI**: Built with modern Material 3 design principles, using a fixed brand seed color (not Android's wallpaper-based dynamic color).
- **Reading Themes**: Light, Dark, System default, and Sepia mode for comfortable reading in low light.
- **App Settings**: Theme selection (its own screen), Malayalam TTS voice toggle, and trust store certificate management (its own screen). Recent files are removed one at a time from the Home screen list (no bulk "clear history" option).
- **About Screen**: Data-driven from a bundled config file (`app_config.json`) — shows the app name, description, and version/build number, plus a details list (currently Author, Email, License statement, and the AI/IDE tools used to build the app). No field is hard-coded, so this list can grow without a code change.
