# Change Log: Update features.md with Complete and Accurate Implemented Features

**Date:** 2026-08-19 14:26:00
**Plan Reference:** `plans/20260819_232400_update_features_md.md`

## Overview
Updated `docs/features.md` to ensure it reflects every implemented feature in the codebase accurately and exhaustively, while removing outdated or inaccurate statements.

## Summary of Changes

### Documentation Updates in `docs/features.md`
1. **Core Libraries & Typography**:
   - Added bundled fonts (`Manjari`, `Anek Malayalam`, `Noto Sans Malayalam`) and updated the open-source library reference table.
2. **PDF Viewing & Navigation**:
   - Added **Foldable & Dual-Screen Support** (Auto layout mode `PdfViewMode.auto`, display hinge gap spacing).
   - Added **Reading Velocity & Time Estimates** (WPM tracking, seconds per page, chapter-aware and document remaining time).
   - Added **Double-Tap Zoom** configurable toggle (Fit to Width vs 200% Zoom).
3. **Search, Indic Engine & TTS**:
   - Added **Malayalam Input Helper & Virtual Keypad** (Live Manglish-to-Malayalam transliteration suggestions and 3-tab virtual keypad).
   - Updated **TTS Playback Controls & Player** (Speech rate 0.5x–2.0x slider, pitch 0.5x–2.0x slider, sentence pause 0.0s–2.0s slider, auto-scroll toggle, persistent media playback notification, and voice helper).
4. **Page Operations & Tools**:
   - Added **Custom Text Watermarks** (opacity, rotation angle, font size, colors, tiling grid, page ranges).
   - Added **N-Up Multi-Page Imposition** (2-in-1, 4-in-1, 6-in-1, 9-in-1 grid layouts, borders, orientation, margins).
   - Added **Batch Operations** (Batch Compress, Watermark, Protect, Unlock, Trim Margins, Extract Text, Merge).
   - Added **Smart Margin Trim / Crop** (Auto-detect whitespace margins with preview and trim).
   - Added **Booklet Creator** (Saddle-stitch imposition order with 4-page rounding padding).
5. **PDF Printer & Hub**:
   - Added **Web Content Cleaner (Reader Mode)** (Strips headers, footers, navigation, sidebars, cookie banners, scripts, ads, and tracking parameters).
   - Added **N-Up Grid Printing** to hardware printers / print spooler.
6. **Digital Signatures & Trust Store**:
   - Added **Visual Signature Stamp Touch Inspection** (interactive overlay on signature stamps in reader).
   - Added **Trust Store Certificate Export** (export individual or all certificates as `.pem` bundles).
7. **Themes & Comprehensive Settings**:
   - Updated **Appearance Options**: Theme Modes (Light, Dark, OLED Pitch-Black `#000000`, System), Typography (4 fonts, 4 text scales), Accent Color (8 presets, HSV color wheel with hue/sat/val sliders).
   - Updated **Settings Hub Structure**: Documented all 10 dedicated sub-screens (Appearance, Language, Reader Settings, Read Aloud, Virtual Printer, Storage & Privacy with bulk clear history and cache cleaner, Trust Store, App Permissions, Help Center, About).
8. **Help Center & User Guides**:
   - Added dedicated section documenting all 6 built-in guides (`/help/pdf-printer`, `/help/unicode-printing`, `/help/tts`, `/help/page-ops`, `/help/signatures`, `/help/privacy-storage`).

## Verification
- Verified that all items documented in `docs/features.md` map to active code in `lib/` and `android/`.
- Verified that no unbuilt or removed features are present.
- Relative paths and privacy rules were adhered to throughout.
