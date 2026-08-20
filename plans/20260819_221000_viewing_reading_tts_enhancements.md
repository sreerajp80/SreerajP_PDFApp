# Viewing, Reading & TTS Enhancements Plan

**Status:** Completed

## Overview
This plan implements five major enhancements requested for the PDF App across Viewing & Navigation and Reading, Search & Speech:
1. **OLED Pitch-Black Theme**: A pure black (`#000000`) theme mode alongside light, dark, and sepia modes to save battery on OLED displays.
2. **Reading Velocity & Time Estimates**: Real-time reading speed calculation (WPM / pages per minute) with remaining reading time per chapter and document.
3. **Foldable & Dual-Screen Support**: Responsive adaptive layout adjusting between single-page / continuous view on phones and dual-page book view on foldables and wide screens (with hinge awareness).
4. **Malayalam Keyboard Helper**: An on-screen phonetic transliteration and character keypad helper for users lacking native Malayalam keyboard support.
5. **TTS Controls**: Pitch controls, sentence-ending pause adjustments, and persistent background playback notification player controls.

---

## Files to Change and Create

### 1. OLED Pitch-Black Theme
- `lib/app/theme/app_theme.dart` [MODIFY]: Add `AppThemeMode.oled`, `AppTheme.oled({Color? accent})` with `#000000` background and dark contrast tokens, update `ResolvedTheme.of()`.
- `lib/features/settings/presentation/theme_screen.dart` [MODIFY]: Add OLED Pitch Black option with battery-saving indicator icon.
- `lib/features/settings/presentation/appearance_screen.dart` [MODIFY]: Include OLED Pitch Black in quick theme selection.
- `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb` [MODIFY]: Add localized strings for OLED theme.
- `lib/features/viewer/presentation/viewer_screen.dart` [MODIFY]: Ensure viewer background reflects OLED pitch black when selected.

### 2. Reading Velocity & Time Estimates
- `lib/features/reading/domain/reading_velocity.dart` [NEW]: Model and calculation logic for user reading velocity (words per minute, seconds per page) and chapter/document remaining time estimation.
- `lib/features/reading/data/reading_velocity_service.dart` [NEW]: State tracker monitoring page dwell time, calculating moving average WPM, and deriving chapter bounds from PDF outline.
- `lib/features/reading/presentation/providers.dart` [MODIFY]: Expose reading velocity and remaining time providers.
- `lib/features/viewer/presentation/viewer_screen.dart` [MODIFY]: Display remaining reading time per chapter/document in the reader bottom bar / HUD.
- `lib/features/settings/presentation/reader_settings_screen.dart` [MODIFY]: Add toggle for showing reading time estimates.
- `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb` [MODIFY]: Localized strings for reading speed, chapter remaining time, and document remaining time.

### 3. Foldable & Dual-Screen Support
- `lib/features/viewer/domain/view_mode.dart` [MODIFY]: Add `PdfViewMode.auto` for intelligent layout adaptation on foldable and wide screens.
- `lib/features/viewer/presentation/widgets/page_layouts.dart` [MODIFY]: Support dual-page spread layout with hinge gap detection when `DisplayFeature` hinge exists.
- `lib/features/viewer/presentation/viewer_screen.dart` [MODIFY]: Handle `PdfViewMode.auto` responding dynamically to screen dimensions, orientation, and fold/hinge states.
- `lib/features/settings/presentation/reader_settings_screen.dart` [MODIFY]: Allow setting "Auto (Single on phone, Dual on foldable/tablet)" as default layout.
- `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb` [MODIFY]: Localize auto foldable/dual-screen layout strings.

### 4. Malayalam Keyboard & Transliteration Helper
- `lib/core/search/malayalam_transliteration.dart` [NEW]: High-performance phonetic transliteration engine converting English/Manglish keystrokes into Malayalam script suggestions (vowels, consonants, chillu characters, and matras).
- `lib/features/reading/presentation/widgets/malayalam_input_helper.dart` [NEW]: On-screen transliteration preview bar and quick-insert Malayalam virtual keypad.
- `lib/features/reading/presentation/widgets/reader_search_bar.dart` [MODIFY]: Integrate the Malayalam transliteration helper toggle and suggestion bar directly above the keyboard.
- `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb` [MODIFY]: Localize transliteration toggle, helper, and keypad labels.

### 5. TTS Controls: Pitch, Sentence Pause & Notification Player
- `lib/core/constants/app_constants.dart` [MODIFY]: Add `prefTtsSentencePause` preference key.
- `lib/app/config/providers.dart` [MODIFY]: Add `ttsSentencePauseProvider` (0.0s - 2.0s).
- `lib/features/reading/data/tts_engine.dart` & `lib/features/reading/data/tts_service.dart` [MODIFY]:
  - Wire pitch adjustment (`setPitch`) into `TtsEngine` and `TtsService`.
  - Implement sentence-boundary splitting and sentence-pause insertion for more natural pacing.
  - Bridge playback state and controls to native notification channel.
- `lib/core/platform/tts_channel.dart` [MODIFY]: Add native methods for showing and updating media player notification with Play/Pause, Stop, Next Page, and Previous Page actions.
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/TtsHandler.kt` [MODIFY]: Implement native Android notification player controls using `NotificationManager` with media action buttons and intent receivers communicating with Dart.
- `lib/features/settings/presentation/tts_settings_screen.dart` [MODIFY]: Add sentence pause slider and pitch controls UI.
- `lib/features/viewer/presentation/viewer_screen.dart` [MODIFY]: Enhanced in-reader TTS bottom sheet/bar with pitch and sentence pause quick adjustments.
- `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb` [MODIFY]: Localize sentence pause labels and notification actions.

---

## Verification Plan

### Automated Tests
- Run `flutter test` to verify all unit and widget tests pass:
  - `test/app/theme_test.dart` (test OLED theme brightness, tokens, and contrast)
  - `test/core/malayalam_transliteration_test.dart` (test Manglish to Malayalam phonetic conversion)
  - `test/features/reading/reading_velocity_test.dart` (test reading speed and remaining time math)
  - `test/features/reading/tts_service_test.dart` (test pitch, sentence pause chunking, and playback state)
  - `test/features/viewer/page_layouts_test.dart` (test auto view mode and book spreads)
- Run `flutter analyze` to ensure 0 warnings and clean static analysis.

### Manual Verification
- Test switching to OLED Pitch-Black theme and verify pure black background.
- Test reading velocity tracking and remaining time display on a sample multi-page PDF.
- Test responsive layout switching on wide aspect ratios / foldable simulated displays.
- Test Malayalam transliteration typing and quick character keypad in search bar.
- Test TTS playback with pitch adjustments, sentence pauses, and background playback notification controls.
