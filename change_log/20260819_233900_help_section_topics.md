# Change Log: Expand Help Section with New Topics

**Date:** 2026-08-19 14:19:00
**Plan Reference:** `plans/20260819_233000_help_section_topics.md`

## Overview
Expanded the Help section in Settings from a single topic to 6 comprehensive, structured guides covering key app functionality:
1. **PDF Printer Setup** (`/help/pdf-printer`): Guide to enabling the Android system virtual print service.
2. **Unicode & Malayalam PDF Printing** (`/help/unicode-printing`): Guide on capturing print jobs from other apps, font embedding, and preserving complex Indic/Malayalam glyph shaping without broken ligatures or question marks.
3. **Read Aloud (TTS) & Malayalam Voice** (`/help/tts`): Guide to text-to-speech setup, downloading offline Malayalam voice engines, and customizing speech speeds/pauses.
4. **Organizing & Modifying Pages** (`/help/page-ops`): Guide explaining page reorganization (reorder, rotate, delete), booklet creation, N-up grids, and the strict copy-on-write safety guarantee.
5. **Digital Signatures & Trust Store** (`/help/signatures`): Guide to local cryptographic signature validation, checking signer certificate chains, and managing the offline trust store.
6. **Privacy & Scoped Storage** (`/help/privacy-storage`): Guide detailing the zero-internet privacy guarantee, Scoped Storage (SAF) boundaries, and temporary cache management.

## Changes Made

### Localization
- `lib/l10n/app_en.arb`: Added localized strings for all 5 new help topics (headers, descriptions, numbered steps, tips, and action button labels).
- `lib/l10n/app_ml.arb`: Added corresponding Malayalam translations for all new help strings.

### Routing
- `lib/app/routing/app_router.dart`: Added `helpUnicodePrinting`, `helpTts`, `helpPageOps`, `helpSignatures`, and `helpPrivacyStorage` to `AppRoute` enum, path mapping extension, and `GoRoute` list.

### Presentation
- `lib/features/help/presentation/help_screen.dart`: Updated help hub to render all 6 topic cards with distinct icons, titles, and descriptions.
- `lib/features/help/presentation/unicode_printing_help_screen.dart`: Created step-by-step guide for Unicode printing with direct button to Printer Settings.
- `lib/features/help/presentation/tts_help_screen.dart`: Created guide for TTS and Malayalam voices with button to TTS Settings.
- `lib/features/help/presentation/page_ops_help_screen.dart`: Created guide for organizing pages and copy-on-write security.
- `lib/features/help/presentation/signatures_help_screen.dart`: Created guide for digital signature verification with button to Trust Store.
- `lib/features/help/presentation/privacy_storage_help_screen.dart`: Created guide for offline privacy and scoped storage with button to Storage Settings.

### Tests
- `test/features/help/presentation/help_screen_test.dart`: Updated widget tests to verify all 6 help cards render with appropriate icons and localized titles.
- `test/features/help/presentation/pdf_printer_help_screen_test.dart`: Updated to reflect updated title and view configuration.
- `test/features/help/presentation/unicode_printing_help_screen_test.dart`: Added widget tests for Unicode PDF printing guide.
- `test/features/help/presentation/topic_help_screens_test.dart`: Added widget tests for TTS, Page Ops, Signatures, and Privacy/Storage help screens.

## Verification
- `flutter gen-l10n`: Completed with 0 errors.
- `flutter test`: All 389 tests passed.
- `flutter analyze`: Completed with 0 issues.
