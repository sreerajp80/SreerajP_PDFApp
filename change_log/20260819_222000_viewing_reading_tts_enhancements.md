# Viewing, Reading & TTS Enhancements Change Log

Referenced Plan: `plans/20260819_221000_viewing_reading_tts_enhancements.md`

## Summary of Changes

Implemented viewing, reading, and text-to-speech enhancements:
1. **OLED Pitch-Black Theme**:
   - Added `AppThemeMode.oled` with pure black (`#000000`) background and surfaces to maximize battery savings on OLED devices.
   - Updated theme options in appearance and theme selection screens.
   - Updated PDF viewer background to match OLED dark tone.
2. **Reading Velocity & Time Estimates**:
   - Created `ReadingVelocity` domain model calculating words per minute and seconds per page.
   - Created `ReadingVelocityService` tracking active page dwell time and deriving chapter boundaries from the document outline.
   - Added remaining reading time display in the reader bottom bar for the current chapter and total document.
   - Added user setting to toggle reading time estimates in reader settings.
3. **Foldable & Dual-Screen Support**:
   - Added `PdfViewMode.auto` dynamically selecting single/continuous view on phones and dual-page book view on wide screens and foldable devices.
   - Added display hinge gap spacing support for dual-screen devices.
   - Added auto view mode selection in the view mode dialog and reader settings.
4. **Malayalam Keyboard & Transliteration Helper**:
   - Created `MalayalamTransliteration` engine supporting Manglish-to-Malayalam phonetic conversion, vowel matras, consonants, conjuncts, and chillu characters.
   - Created `MalayalamInputHelper` providing live transliteration suggestions and a 3-tab virtual Malayalam keypad (Vowels, Consonants, Signs & Chillu).
   - Integrated the Malayalam helper toggle and suggestion bar in the in-reader search bar.
5. **TTS Controls & Notification Player**:
   - Added pitch adjustment and configurable sentence-ending pauses in TTS engine and service.
   - Implemented persistent media notification player controls on Android with play/pause and stop action buttons.
   - Added sentence pause slider and pitch controls in TTS settings.
   - Localized all new user-facing strings in English and Malayalam.

## Files Modified and Created

- `lib/app/theme/app_theme.dart`
- `lib/features/settings/presentation/theme_screen.dart`
- `lib/features/settings/presentation/appearance_screen.dart`
- `lib/features/settings/presentation/reader_settings_screen.dart`
- `lib/features/settings/presentation/tts_settings_screen.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ml.arb`
- `lib/core/constants/app_constants.dart`
- `lib/app/config/providers.dart`
- `lib/features/reading/domain/reading_velocity.dart`
- `lib/features/reading/data/reading_velocity_service.dart`
- `lib/features/reading/presentation/providers.dart`
- `lib/features/viewer/domain/view_mode.dart`
- `lib/features/viewer/presentation/widgets/page_layouts.dart`
- `lib/features/viewer/presentation/viewer_screen.dart`
- `lib/core/search/malayalam_transliteration.dart`
- `lib/features/reading/presentation/widgets/malayalam_input_helper.dart`
- `lib/features/reading/presentation/widgets/reader_search_bar.dart`
- `lib/core/platform/tts_channel.dart`
- `lib/features/reading/data/tts_engine.dart`
- `lib/features/reading/data/tts_service.dart`
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/TtsHandler.kt`
- `test/app/theme_test.dart`
- `test/core/malayalam_transliteration_test.dart`
- `test/features/reading/reading_velocity_test.dart`
- `test/features/reading/data/tts_service_test.dart`
- `test/features/settings/presentation/settings_screen_test.dart`
- `test/features/viewer/page_layouts_test.dart`

## Verification
- `flutter analyze` completed with 0 warnings/errors.
- `flutter test` executed and all 370 tests passed.
