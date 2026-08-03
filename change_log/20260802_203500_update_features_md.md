# Change Log: Update docs/features.md

**Date:** 2026-08-02
**Plan Implemented:** [plans/20260802_203500_update_features_md.md](../plans/20260802_203500_update_features_md.md)

## Summary of Changes
- Critically analyzed and updated [docs/features.md](../docs/features.md) to ensure an exhaustive feature catalog and fully inclusive app description:
  - **App Overview & Architectural Principles**: Added native dual UI localization (English `en` & Malayalam `ml`), bundled digital signature trust lists (EU EUTL & Adobe AATL), Storage Access Framework (SAF) URI permission persistence (`takePersistableUriPermission`) for recent documents, and zero-telemetry offline security model.
  - **PDF Viewing & Navigation Engine**: Cataloged Page Fit options (Fit-to-Width & Fit-to-Page), zoom scale preservation across window resizes/orientation changes, and stale URI handling in the recent files dashboard.
  - **Search, Indic Engine & TTS**: Added Strict Joiner Mode option (configurable ZWJ/ZWNJ matching toggle), Sanskrit cantillation accent stripping (Vedic accents), Text Quality Inspector (`TextQualityNotice` banner for missing/garbled `ToUnicode` maps), and detailed TTS playback controls (pitch, rate, language selector, voice helper, auto-disable logic).
  - **Page Operations & Utilities**: Cataloged Export Page Ranges capability, Text-to-PDF & Images-to-PDF formatting specs, and System Printer options for printing page ranges and plain text.
  - **Digital Signature Verification & Trust Store**: Detailed support for bundled trust lists (EU EUTL / Adobe AATL), importing custom X.509 certificates (`.pem`, `.cer`, `.crt`, `.der`), and visual signature status badges (green checkmark, yellow warning, red invalid).
  - **Themes, Settings & System Integration**: Documented Sepia reading mode alongside Light/Dark/System themes and all App Settings toggles.
