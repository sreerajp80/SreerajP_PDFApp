# Plan: Update Feature Analysis and Roadmap Document

**Status:** completed

## Issue / Task Description
The user wants to reanalyze `docs/feature_analysis_and_roadmap.md` to update non-implemented features, mark implemented features, and add new features. Before updating, we inspected `L:\Android\MyFlutterApps\myapps.md` which lists 18 existing Flutter apps developed by the user.

## Files to be changed
- `docs/feature_analysis_and_roadmap.md`

## Analysis of Ecosystem Apps (`myapps.md`)
The user has 18 ready Flutter apps including:
- `SreerajP_TextApp`: Plain text and structured data reader.
- `SreerajP_CodeApp`: Code syntax reader and editor.
- `vault-files`: Secure file vault.
- `SreerajP_Journal_Vault`: Encrypted daily journal and notes vault.
- `sreeraj_qr_reader`: QR code and barcode scanner.
- `SreerajPContactSphere`: Contact manager.
- `sms-sentry`: SMS security filter.
- `SreerajP_Authenticator`: 2FA TOTP authenticator.

## Proposed Plan for `docs/feature_analysis_and_roadmap.md`

1. **Mark Completed Phase 1 to 8 Features**:
   - Explicitly note which base core features (rendering, SAF opening, Malayalam/English TTS, text search, extraction, basic copy-on-write page operations, annotation overlay schema v3, PDF printer, digital signature PKCS#7 verification) are now implemented and production-ready.

2. **Categorize and Update Non-Implemented Advanced Features**:
   - **Indic Phonetic & Sandhi Search**: Advanced compound splitting for Malayalam and Sanskrit.
   - **Offline Visual PDF Diff & Heatmap**: Overlay image rendering for visual document comparison.
   - **Smart Redactor**: Local regex PII detection + true text stream deletion + black box drawing.
   - **Forensic Revision Inspector**: Parsing xref stream timeline to view prior PDF versions before edits.
   - **Bionic & Karaoke Reader**: Bold first letters (Bionic) + word-level TTS highlight.
   - **Air-Gapped Barcode Decoupler**: PDF barcode extraction + seamless integration with `sreeraj_qr_reader`.
   - **Smart Margin & Booklet Engine**: Auto blank margin crop + 2-Up imposition layout generator.

3. **Add New Ecosystem Integration Features (Leveraging `myapps.md`)**:
   - **Vault Files Interop**: Direct export of sensitive PDFs into `vault-files`.
   - **TextApp / CodeApp Sharing**: Pass extracted text streams or code snippets straight into `SreerajP_TextApp` and `SreerajP_CodeApp`.
   - **Journal Vault Note Attachments**: Save PDF excerpts and audio notes as attachments inside `SreerajP_Journal_Vault`.
   - **QR Reader Integration**: Send extracted QR/barcode data directly to `sreeraj_qr_reader`.

4. **Update Implementation Roadmap Phases**:
   - Re-organize future development into Phase 9 (Advanced Reading & Visual Tools), Phase 10 (Redaction & Forensic History), and Phase 11 (Ecosystem & Booklet Innovations).
