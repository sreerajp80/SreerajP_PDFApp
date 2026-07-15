# Change log — Phase 2: Reading (search, copy, metadata, TTS)

**Date:** 2026-07-15
**Implements:** `plans/20260714_162256_phase2-reading-search-tts.md`
**Phase:** 2 of the build plan (`doc/pdf-app-implementation-plan.md`)

---

## What was built

Implemented all Phase 2 features for text search (Indic-script aware), select-and-copy, document details/metadata, scanned/garbled PDF detection, and a shared Text-to-Speech (TTS) module.

### Indic-Aware Search & Normalization (pure Dart)
- **NFC Normalization** via `unorm_dart` performed at the grapheme boundary soIndic-script matches remain exact and testable off-device.
- **Search Normalization** (`SearchNormalizer`): folds Malayalam chillu letters to their atomic forms, ignores ZWJ/ZWNJ in the comparison keys, and supports Sanskrit accent-insensitive matching (ignoring Vedic chant accents).
- **Grapheme-Cluster-Aware Matching**: aligns search matches with grapheme clusters to prevent vowel mark splits and ensure correct highlight coordinates.
- **Highlight Overlay**: back-maps search keys to PDF character rectangles for correct drawing of match indicators in `ViewerScreen`.
- **Script Detection**: detects Malayalam and Devanagari/Sanskrit script ranges to pick the fold and guard against garbled text.

### Scanned & Garbled PDF Guards
- **Text Quality Checking**: assesses a sample of pages to determine if the PDF is scanned (no text layer) or garbled (no `ToUnicode` map).
- **Degraded Notices**: displays a material banner notice to explain why search, copy, and TTS are disabled, fulfilling the "never a dead button" rule.

### Document Details / Metadata
- **PdfBox-Android Native Bridge** (`PdfBoxHandler`): reads PDF-specific document metadata fields (title, author, subject, keywords, creator, producer, version, and encrypted flag) on a background thread.
- **Details Sheet**: presents the file and PDF fields to the user, with fallback for locked or unreadable fields.

### Shared Text-to-Speech (TTS)
- **State Machine** (`TtsService`): manages playback states (`idle`, `speaking`, `paused`) and language-specific states (`ready`, `needsInstall`, `unavailable`).
- **Malayalam voice integration**: settings toggle with automatic disabling and notification if the voice is lost/removed.
- **Guided Install Flow**: guides users to install the `ml-IN` voice via native intents (intent download, settings shortcut, Play Store fallbacks).
- **Viewer playback overlay**: replaces the bottom bar in `ViewerScreen` with play, pause, stop, and status indicators.

---

## Files modified / added

### Native (Android)
- `android/app/build.gradle.kts` — added `com.tom-roush:pdfbox-android` dependency.
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt` — native metadata loading on background threads.
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/TtsHandler.kt` — native speech installer intents.
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` — registered native handlers for PdfBox and TTS channels.

### Core & Presentation
- `lib/core/constants/app_constants.dart` — added pref keys, channel ids, and text quality thresholds.
- `lib/core/platform/pdfbox_channel.dart` — Dart interface for reading document metadata.
- `lib/core/platform/tts_channel.dart` — Dart interface for guided installer intents.
- `lib/core/search/script_detector.dart` — Indic script range identifier.
- `lib/core/search/search_normalizer.dart` — Unicode NFC normalizer and Indic folding keys.
- `lib/features/reading/` — models, search controllers, TTS services, widgets, and quality checks.
- `lib/features/settings/presentation/settings_screen.dart` — added Malayalam voice switch, voice status subtitle, and install sheet logic.
- `lib/features/viewer/presentation/viewer_screen.dart` — integrated search action, highlight overlays, read-aloud buttons, and TTS control bar.

### Tests
- `test/core/search/script_detector_test.dart` — Indic script detection test.
- `test/core/search/search_normalizer_test.dart` — NFC, chillu, strict/accent-insensitive key mapping unit tests.
- `test/features/reading/data/tts_service_test.dart` — TTS playback states and voice auto-disable unit tests.
- `test/features/settings/presentation/settings_screen_test.dart` — theme selection and Malayalam voice toggle widget tests.
