# Plan: Update and Expand docs/features.md

**Status:** pending approval

## Issue
The user requested a critical analysis of `docs/features.md` to ensure all features of the **SreerajP PDF App** are exhaustively cataloged and that the App Description is fully inclusive.

## Files to be changed
- `docs/features.md` (MODIFY)

## Proposed Plan
1. Analyze `docs/features.md` against `docs/PDF-Idea.md`, `docs/architecture.md`, and the `lib/` source code.
2. Update `docs/features.md` to include missing technical details and feature capabilities:
   - **App Overview & Description**: Add dual-language localization (English & Malayalam), bundled offline trust lists (EU EUTL & Adobe AATL), Storage Access Framework (SAF) URI permission persistence (`takePersistableUriPermission`), and zero-telemetry offline security model.
   - **PDF Viewing & Navigation Engine**: Add Fit-to-Width / Fit-to-Page options, zoom preservation across orientation/window changes, and stale URI handling in recents list.
   - **Search, Indic Engine & TTS**: Add Strict Joiner Mode option, Sanskrit accent-insensitive search, Text Quality Inspector (missing ToUnicode detection banner), and complete TTS playback controls (pitch, rate, language picker, voice installer helper, auto-disabling logic).
   - **Page Operations & Conversion Utilities**: Add Page Range Export, Print Page Range, Print Extracted Text, and Text-to-PDF / Images-to-PDF conversion formatting specs.
   - **Digital Signature Verification & Trust Store**: Add details on bundled trust lists (EU EUTL / Adobe AATL), custom X.509 certificate import formats (`.pem`, `.cer`, `.crt`, `.der`), and visual status badges.
   - **UI, Themes & Localization**: Document full English/Malayalam localization (`l10n`), Sepia reading mode, and complete App Settings options.
3. After user approval, write changes to `docs/features.md` and log the change in `change_log/20260802_203500_update_features_md.md`.
