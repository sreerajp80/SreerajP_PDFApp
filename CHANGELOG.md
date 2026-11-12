# Changelog

All notable changes to the Folio app project will be documented in this file.

---

## [Unreleased]

*   **Fixed** search now scrolls to the first match even when it is on a later page. Before, the view stayed where it was until you tapped Next.
*   **Fixed** search could miss whole pages of a PDF (and read-aloud could skip them) when a page had not finished loading yet. The page is now waited for, and an unloaded page is tried again instead of being treated as empty.
*   **Fixed** Organize pages: a rotated page now shows its thumbnail turned, not only a "90°" label.
*   **Fixed** Malayalam and Sanskrit texts now use the app's own name (ഗ്രന്ഥം / ग्रन्थः) instead of "Folio". Where a text points to an Android screen, "(Folio)" is added, because Android shows the name in the phone's language.
*   **Fixed** the release build no longer asks for permission to read shared storage. Android added it automatically because of the camera library; the app never used it.
*   **Added** sending PDFs to a nearby phone over your local WiFi: long-press recent files on Home to select them, or use "Send to nearby phone" in the viewer menu. The other phone scans the code in Device sync › Receive, sees the files, and taps Accept. Each file is checked on arrival and saved as a new file in a folder you choose once (shown as "Saving to" with a Change button).
*   **Added** Device sync (Settings › Device sync): copy your settings to another phone. One phone shows a QR code, the other scans it. "QR only" needs no network; "WiFi" connects the two phones directly on your local WiFi or hotspot, encrypted with a one-time key. You see what will change and nothing is applied until you tap Apply.
*   **Changed** permissions: the app now declares `INTERNET` (used only for Device sync on the local WiFi, never for an internet server) and `CAMERA` (used only to scan a Device sync code). The privacy texts now say "no internet servers" instead of "100% offline".
*   **Changed** the app name to **Folio** (Malayalam: ഗ്രന്ഥം, Sanskrit: ग्रन्थः). The launcher, About screen, print service and help texts use the new name. Existing installs update normally.
*   **Fixed** text watermarks in Malayalam, Sanskrit and other non-Latin scripts. They used to fail; now the letters are drawn and joined correctly.
*   **Changed** the watermark default text and preset words now follow the app language.
*   **Fixed** search, copy and read-aloud in PDFs made by LibreOffice (common for Malayalam and Sanskrit). Words were often split by a stray space or joined without one, so many words could not be found.
*   **Changed** a few remaining English labels (language "Auto", paper sizes, image quality, "No text found", signature overlay) now follow the app language.

---

## [2.2.0] - 2026-07-18

### Phase 8 — Hardening & Release
*   **Added** secure release signing configuration via Strategy A (local `key.properties`).
*   **Added** `android/key.properties.example` template for development setup.
*   **Added** Gradle enforcement check (`afterEvaluate`) to block unsigned production builds.
*   **Fixed** database unit test failures in `migration_v3_test.dart` due to the Phase 7 database version increase.
*   **Added** comprehensive security documentation in `docs/security.md`.
*   **Updated** architectural records in `docs/architecture.md`.
*   **Audited** native dependencies (e.g. `pdfrx` / PDFium) for Android 16 KB memory page size compliance.
*   **Verified** offline compliance in the production Android manifest (omitted internet permissions).

---

## [2.1.0] - 2026-07-18

### Phase 7 — Digital Signature Verification
*   **Added** native Kotlin method channel `in.sreerajp.pdfapp/signature` for verification.
*   **Added** local PKCS#7 signature verification using repackaged Bouncy Castle.
*   **Added** offline certificate chain validation via Android `CertPathValidator`.
*   **Added** local trust store database (v4 table `trust_store`) for user-managed trusted certificates.
*   **Added** bundled EU Trusted Lists (EUTL) as read-only assets for global trust validation.
*   **Added** green checkmark UI states and invalid signature diagnostics in the reader screen.
*   **Added** "Trusted certificates" management screen under settings.

---

## [2.0.0] - 2026-07-17

### Phase 6 — PDF Printer
*   **Added** share target to convert incoming text/images into a new PDF.
*   **Added** integration with the native Android printing framework to print whole documents, page ranges, or text.
*   **Added** UI states stating limits on complex script rendering in pure text-to-pdf conversion.

---

## [1.5.0] - 2026-07-17

### Phase 5 — Annotation Overlay Layer
*   **Added** app-side overlay layer (highlights, underlines, strikethroughs, sticky comments, bookmarks).
*   **Added** database migration v3 (`annotations` table) to persist overlay marks by document fingerprint.
*   **Added** canvas overlay drawing matching page scroll and zoom.
*   **Added** native export option using PdfBox-Android to save overlay annotations into a real PDF copy.

---

## [1.4.0] - 2026-07-16

### Phase 4 — Page Operations (Copy-On-Write)
*   **Added** page operation channels (merge, split, organize, compress, protect, unlock).
*   **Added** copy-on-write enforcement ensuring original files are never modified.
*   **Added** secure in-memory password management for locked/unlocked PDFs.

---

## [1.3.0] - 2026-07-15

### Phase 3 — Extraction & Sharing
*   **Added** content extraction (plain text, embedded images, form fields).
*   **Added** conversion service to convert PDF to text/images and export page ranges.
*   **Added** native sharing sheet integration.
*   **Added** isolate worker (`compute`) for heavy file operations to maintain UI responsiveness.

---

## [1.2.0] - 2026-07-15

### Phase 2 — Reading Search & TTS
*   **Added** text search with highlights and match navigation.
*   **Added** NFC normalization and `SearchNormalizer` supporting Malayalam Sandhi and Devanagari Sanskrit.
*   **Added** scanned-PDF detection and fallback screens.
*   **Added** shared `TtsService` supporting English and Malayalam read-aloud options.
*   **Added** Malayalam voice check, toggle, and guided installation flow.

---

## [1.1.0] - 2026-07-14

### Phase 1 — Core Viewing & Navigation
*   **Added** Storage Access Framework (SAF) file picker and "Open with" intent handling.
*   **Added** database migration v2 (`recent_files`, `reading_positions`).
*   **Added** lazy page rendering via `pdfrx` / PDFium.
*   **Added** double-tap zoom, pinch-zoom, and reading position memory.
*   **Added** light, dark, and sepia reader themes.

---

## [1.0.0] - 2026-07-14

### Phase 0 — Project Scaffolding
*   **Added** core project structure (Tier 2 feature-first folder architecture).
*   **Added** application configurations and about screens.
*   **Added** logger, global exceptions boundary, and sqflite schema baseline.
