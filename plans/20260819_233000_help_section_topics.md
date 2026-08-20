# Implementation Plan: Expand Help Section with New Topics

**Status:** Proposed
**Date:** 2026-08-19 13:48:00
**Author:** AI Assistant

## Problem / Issue
The Help section under Settings (`/help`) currently contains only one single topic: "PDF Printer". Users need guidance on other core features of the app, specifically:
1. "Unicode PDF Printing" (how to print complex Indic/Malayalam scripts without corrupted characters or missing fonts).
2. "Malayalam & Offline Read Aloud (TTS)" (how to configure speech engines and install voice packs).
3. "Organizing & Modifying Pages" (how to merge, split, reorder, booklet, and N-up with copy-on-write guarantees).
4. "Digital Signatures & Trust Store" (how offline signature verification and certificate trust work).
5. "Privacy & Scoped Storage" (why the app requires zero internet access and how SAF protects user data).

## Proposed Solution
Expand the Help section by creating dedicated, clean help topic screens and cards for each of these areas, complete with localized English and Malayalam text, step-by-step guides, helpful visual callouts, and direct action buttons linking to relevant settings screens.

## Files to Modify / Create

### Localization
- `lib/l10n/app_en.arb` (add strings for all new help topics)
- `lib/l10n/app_ml.arb` (add Malayalam translations)

### Routing
- `lib/app/routing/app_router.dart` (add routes for the new help topic screens)

### Presentation
- `lib/features/help/presentation/help_screen.dart` (update list of topics with icons and navigation)
- `lib/features/help/presentation/unicode_printing_help_screen.dart` (new screen for Unicode PDF Printing)
- `lib/features/help/presentation/tts_help_screen.dart` (new screen for Read Aloud & Malayalam TTS)
- `lib/features/help/presentation/page_ops_help_screen.dart` (new screen for Organizing Pages & Copy-on-Write)
- `lib/features/help/presentation/signatures_help_screen.dart` (new screen for Signatures & Trust Store)
- `lib/features/help/presentation/privacy_storage_help_screen.dart` (new screen for Privacy & Scoped Storage)

### Tests
- `test/features/help/presentation/help_screen_test.dart` (update to assert all topics)
- `test/features/help/presentation/unicode_printing_help_screen_test.dart` (new widget test)
- `test/features/help/presentation/topic_help_screens_test.dart` (new widget test for remaining help screens)

## Verification Plan
- Run `flutter gen-l10n`
- Run `flutter test test/features/help/presentation/`
- Run `flutter test`
- Run `flutter analyze`
