# PDF App

# What is this app
This is an Android app built in Flutter for **everything PDF**: opening, reading, navigating,
annotating, extracting from, and reorganizing PDF files — including whatever editing is
possible on Android. It also works as a **PDF printer for Android**: other apps can "print
to PDF" / send content to this app to be saved as a PDF. It is one of five separate apps
split out from the original single "File Reader" idea (the others cover text/data files,
code files, HTML, and EPUB).

# Development Tools versions
Flutter 3.44.8 or higher
Dart 3.12.2 or higher

# Licensing constraint
Every library used by this app must be **open source**. Commercial or source-available SDKs
are not allowed, even when they have a free community license (for example Syncfusion,
PSPDFKit, Apryse). See [PDF library decision](#pdf-library-decision-open-source-only) for
what this means for the feature set.

# Shared Capabilities (build once, reuse everywhere)
- **Search** — find text, highlight matches, and jump between matches across the document
  (needs a text layer; see scanned-PDF note below). Search is **Unicode-aware for complex
  Indic scripts (Malayalam and Sanskrit)**: the same word can be stored in a PDF in several
  different Unicode forms and still looks identical on screen, so search normalizes both the
  query and the page text before matching. This means a user finds the word even when they
  type it in a slightly different (but equivalent) encoding. See
  [Risks & Hard Features](#risks--hard-features) for how this works.
- **Text-to-Speech (TTS)** — read the PDF aloud in **English and Malayalam**. Malayalam TTS
  is controlled by a **toggle in the app's Settings** and depends on a Malayalam voice being
  installed on the device. If no voice is present, the app guides the user to install one; if
  the toggle is on but the voice goes missing, the app turns the toggle off and tells the
  user why. Reader screens ask this shared module for the current state, so they never show a
  dead button. (See [Risks & Hard Features](#risks--hard-features).)
- **Share** — send the file, or exported output (an image, a page range, a new PDF), to
  other apps via the Android share sheet.
- **Export / Convert** — a single conversion service: PDF → text, PDF → images (PNG/JPEG),
  and page/range exports.
- **Metadata** — file size, created / modified date, plus PDF-specific fields (title, author,
  page count, creation date).
- **Themes & reading comfort** — light / dark / sepia (night-mode color invert for reading
  comfort), plus zoom and fit options.
- **Reading position** — remember the last-read page per file, keyed to the file's content
  fingerprint (see [Non-Functional Requirements](#non-functional-requirements)).
- **Copy** — select and copy text from pages (needs a text layer).

# Features

## Viewing & navigation
Open PDF files. Render and scroll pages (single page, continuous, two-page / book view).
Zoom in/out, pinch-to-zoom, fit-to-width / fit-to-page. Jump to a specific page number.
Table of contents / bookmarks (outline) — navigate via the PDF's built-in chapter tree.
Thumbnail grid to jump around quickly. Remember last-read page (reading position).
Night/dark mode or sepia tint (invert colors for comfort).

## Reading, search & speech
Text search — find and highlight a word/phrase across the document. Select and copy text.
Text-to-speech — read the PDF aloud (English and Malayalam; complex-script extraction is a
risk — see [Risks & Hard Features](#risks--hard-features)). **Scanned (image-only) PDFs:** if
the PDF has no text layer, the app shows a notice ("this PDF has no selectable text") and
gracefully disables search, copy, text extraction, and TTS; **OCR is out of scope**.

## Annotation (app-side overlay layer)
Add bookmarks to pages. Highlight, underline, strikethrough text. Add sticky notes /
comments. Draw / freehand ink markup. **(Advanced — built as an app-side overlay layer:
annotations are stored in the app's own database and drawn on top of the rendered page.
Optional export writes them into a copy of the file with PdfBox-Android.)** These can be
saved as a layer or exported — the original content stays intact. (See
[Risks & Hard Features](#risks--hard-features).)

## Extraction
Extract plain text from pages. Extract images embedded in the PDF. Extract metadata (title,
author, page count, creation date). Read form field values (if it's a fillable form).

## Page operations (always copy-on-write)
Merge multiple PDFs into one. Split a PDF into separate files. Reorder / rotate / delete
pages. Compress to reduce file size (best-effort — open-source tools cannot match commercial
PDF compressors). Password protect / unlock (encrypt / decrypt). Export a page or range as an
image (PNG/JPEG). Convert to other formats (PDF → text, PDF → images). **All page operations
(merge, split, reorder, rotate, delete, compress, encrypt/decrypt) always write a new copy —
the original file is never modified in place.**

## Digital signature verification (Advanced — highest-risk feature)
Allow adding a PDF signature certificate to the app's trust store and, once added, show the
signature as trusted with a **green tick** on the signature part. If the signature is
globally trusted, show the green tick without adding. Note: this is real cryptography
(PKCS#7 / CMS, certificate-chain and revocation checks) and likely needs native
platform-channel code. See [Risks & Hard Features](#risks--hard-features).

## PDF printer for Android ("print to PDF")
The app acts as a **print / PDF target** for the rest of the device:
- Register as an Android **print service / print target** and as a **share/"Open with"
  target for printable content**, so from another app's Print or Share menu the user can
  send a document, web page, or image to this app and **save it as a PDF**.
- Save the incoming print job / shared content to a chosen location as a new PDF file
  (copy-on-write; nothing existing is overwritten).
- The app can also **print a PDF out** to a real printer via Android's standard print
  framework, and print a page range or the extracted text.
- Where registering as a system print service needs native (Kotlin) platform-channel work,
  that part is treated as a risk / later-phase item; the simpler share-to-save-as-PDF path
  is the first target.

# Risks & Hard Features

- **PDF digital signature verification with a custom trust store** — *highest risk.* Real
  cryptography: PKCS#7 / CMS parsing, certificate-chain validation, and revocation checks.
  Flutter has no first-class library for this. The chosen open-source path is native Android
  (Kotlin) behind a platform channel: **PdfBox-Android** reads the signature and ByteRange,
  **Bouncy Castle** verifies the PKCS#7 data, and Android's built-in **`CertPathValidator`**
  checks the chain and revocation. "Globally trusted" means a certificate list bundled with
  the app (Adobe AATL / EU EUTL), not the Android system CA store (that store is for TLS, not
  document signing). Caveat: Android ships a stripped, outdated Bouncy Castle, so the app
  must use the repackaged Bouncy Castle artifact to avoid classloader conflicts. Treat as an
  advanced, later-phase feature.
- **PDF non-destructive annotation** (highlight, underline, strikethrough, ink, sticky notes
  saved as a layer without changing the original) — open-source renderers are view-only, so
  this is built as an **overlay layer**: annotations live in the app's own database, keyed to
  page and position, and are drawn on top of the rendered page. The original PDF is never
  modified. Optional export writes real PDF annotations into a copy using PdfBox-Android.
  Trade-off: overlay annotations are visible only in this app until exported.
- **Complex Indic scripts (Malayalam & Sanskrit) inside PDFs** — this has **two separate
  problems**: getting the text out, and matching it correctly.
  1. **Extraction depends on a ToUnicode map.** Extracting complex-script text (Malayalam, or
     Sanskrit in Devanagari or Malayalam script) from a PDF depends on the font carrying a
     proper ToUnicode map; many PDFs do not, so extraction comes out garbled or empty. This
     silently breaks PDF search, copy, and TTS on such files. The app must detect garbled or
     missing extraction and tell the user, instead of reading nonsense aloud or showing empty
     search results. (Scanned / no-text PDFs stay out of scope — no OCR.)
  2. **Even good text needs normalization to search properly.** In these scripts the *same
     visible word* can be stored in several different Unicode forms — Malayalam **chillu**
     letters have an atomic form and an older "consonant + virama + ZWJ" form; Devanagari
     **nukta** letters can be precomposed or combined; invisible **ZWJ/ZWNJ** joiners sit
     inside conjuncts; combining marks (including Sanskrit **Vedic accents**) can be ordered
     differently. So a user's typed word and the PDF's stored word can be "the same" yet never
     match byte-for-byte. The decided approach:
     - **Normalize to Unicode NFC** on both the query and the extracted text before matching
       (done with the device's built-in ICU — no extra library, fully offline).
     - **Build a canonical search key** (used *only* for comparison; the real text is never
       changed): unify the two chillu encodings into one form, and treat the invisible
       ZWJ/ZWNJ joiners as ignorable for matching. This is standard Unicode behavior — those
       joiners are "default-ignorable" — so the user need not type them to find a word, while
       their meaning for on-screen shaping stays intact in the untouched original.
     - **Optional accent-insensitive search** for Sanskrit (ignore Vedic accents), and an
       **optional strict mode** that keeps the joiners significant.
     - **Grapheme-cluster-aware matching and highlighting**, so a match never lands in the
       middle of a base letter + vowel-sign cluster, and highlight boxes map back to the
       correct characters on the page.
   - **Sanskrit note:** Sanskrit text may be written in **Devanagari** or in **Malayalam
     script** (traditional Kerala / Manipravalam texts). Both are handled by the same pipeline.
- **Malayalam text-to-speech** — depends on the device having a Malayalam TTS voice
  installed. Many devices do not ship one. The decided behavior:
  - **Settings toggle.** Malayalam TTS is an on/off option in Settings.
  - **Check when enabling.** On turning it on, the app checks whether a Malayalam voice
    (`ml-IN`) is available.
  - **Guide the user to install the voice.** If none is found, show a message with an
    **Install voice** button: `LANG_MISSING_DATA` → open the engine's voice-download screen
    via `INSTALL_TTS_DATA`; `LANG_NOT_SUPPORTED` → open system TTS settings, or the Play
    Store page for Google TTS (`com.google.android.tts`) if not installed (it supports
    `ml-IN` for free). Re-check when the user returns.
  - **Auto-disable with a notification.** If the toggle is on but no voice is later found,
    turn it off and tell the user why, with the same install help path.
  - **Never a silent failure.** Reader screens render the ready / needs-install / unavailable
    state; they never show a dead button.
- **Very large PDFs** — PDFs up to a few hundred MB should open (pdfium loads pages lazily).
  Above the limit, show a clear warning and a degraded mode instead of crashing.
- **PDF printer / system print service** — registering as an Android print service to accept
  print jobs from other apps needs native (Kotlin) work behind a platform channel and is the
  riskier part of the "print to PDF" feature; the share/"Open with" → save-as-PDF path is
  simpler and comes first.
- **Compression is best-effort only** — open-source tools cannot match commercial PDF
  compressors.

## PDF library decision (open source only)
The app uses **open-source libraries only**. Commercial PDF SDKs (Syncfusion, PSPDFKit,
Apryse) are not an option, even with a free community license. The chosen open-source stack:

- **Viewing / rendering** — a pdfium-based Flutter package (e.g. `pdfrx`). pdfium is Google's
  BSD-licensed PDF engine, the same one used in Chrome.
- **Page operations and data** — **PdfBox-Android** (Apache 2.0) for merge, split, reorder /
  rotate / delete pages, encrypt / decrypt, text extraction, metadata, and reading form
  fields.
- **Signature cryptography** — **Bouncy Castle** plus Android's built-in `CertPathValidator`,
  running in native Kotlin behind a platform channel.

Two honest trade-offs come with this stack:
1. **Annotation is built by us as an overlay layer** (above) instead of coming from an SDK.
2. **Compression is best-effort only** — open-source tools cannot match commercial
   compressors.

# Non-Functional Requirements

- **Large files** — PDFs up to **a few hundred MB** should open (pdfium loads pages lazily).
  Above the limit, show a clear warning and a degraded mode (e.g. a raw paged view) instead
  of crashing.
- **Storage & permissions** — modern Android uses **scoped storage**. Files are opened
  through the **system file picker (Storage Access Framework)** and **"Open with" intents
  only** — no broad storage permission and no in-app file browser. Take persistable URI
  permissions for recent files. Handle denied access or a stale persisted URI. All page
  operations write a **new copy** (copy-on-write), so write access to the original is not
  required.
- **File identity** — reading positions, app-side bookmarks, and overlay annotations are
  keyed to a **content fingerprint** (file size + hash), with the persisted URI as a fast
  path, so they survive move, rename, and re-pick. A modified file is treated as a new
  document — old positions and annotations may no longer fit and are not applied.
- **Minimum Android version** — **minSdk 26 (Android 8.0)**. Phones and tablets, portrait
  and landscape.
- **Offline** — the app works fully **offline**. The only online parts are optional (opening
  remote links).
- **Error handling** — corrupt, truncated, password-protected, or empty files must show a
  clear, friendly message and **never crash**. Every parser needs a failure path.
- **Performance & memory** — fast file open, smooth scrolling, bounded memory even on large
  files. Prefer lazy page loading over loading everything at once.
- **Privacy & security** — treat opened files as untrusted input. Do not send file contents
  anywhere without the user's explicit action (share/export). Signature verification is done
  locally.
- **Accessibility & localization** — support system font scaling and screen readers where
  practical; the UI itself should be localizable (at least English, given the Malayalam
  content focus).
