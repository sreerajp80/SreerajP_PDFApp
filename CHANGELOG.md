# Changelog

All notable changes to the SreerajP PDF App project will be documented in this file.

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
