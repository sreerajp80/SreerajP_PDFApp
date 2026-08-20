# Change Log: Settings Screen Redesign with Section Cards, Appearance (Theme & Accent Color), and Permissions

**Plan Reference:** `plans/20260819_205500_settings_cards_appearance_permissions.md`

## 1. Summary of Changes
- Redesigned the Settings screen into modern, rounded card sections with 48x48 accent-tinted leading icons, bold titles, and descriptive subtitles.
- Added an Appearance configuration hub (`AppearanceScreen`) featuring:
  - Theme Mode selection card (`ThemeScreen` with Light, Dark, System, and Sepia options).
  - Accent Color picker card (`AccentColorScreen`) with a live preview chip, preset color swatches, interactive HSV color wheel, brightness slider, auto-contrast computation, and reset-to-default actions.
- Introduced `AppColors` ThemeExtension and updated `AppTheme` / `ResolvedTheme` to support dynamic user-chosen accent color seeds for both Light and Dark modes.
- Added a Permissions screen (`PermissionsScreen`) listing explicit capabilities (Scoped Storage SAF, Virtual Print Service) and privacy declarations (Zero Internet / 100% Offline, TTS Query, Process Text) with a deep link to system app settings.
- Added native `openAppSettings` method in `MainActivity.kt` and `OpenDocumentChannel`.
- Added complete English and Malayalam translations (`app_en.arb` and `app_ml.arb`) for all new UI strings.
- Added unit and widget tests for all new screens and theme configurations.

## 2. Files Modified / Created
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt`
- `lib/app/app.dart`
- `lib/app/config/providers.dart`
- `lib/app/routing/app_router.dart`
- `lib/app/theme/app_theme.dart`
- `lib/core/constants/app_constants.dart`
- `lib/core/platform/open_document_channel.dart`
- `lib/features/settings/presentation/accent_color_screen.dart` [NEW]
- `lib/features/settings/presentation/appearance_screen.dart` [NEW]
- `lib/features/settings/presentation/permissions_screen.dart` [NEW]
- `lib/features/settings/presentation/settings_screen.dart`
- `lib/features/settings/presentation/theme_screen.dart`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ml.arb`
- `test/features/settings/presentation/accent_color_screen_test.dart` [NEW]
- `test/features/settings/presentation/appearance_screen_test.dart` [NEW]
- `test/features/settings/presentation/permissions_screen_test.dart` [NEW]
- `test/features/settings/presentation/settings_screen_test.dart`
- `test/features/settings/presentation/theme_screen_test.dart`

## 3. Verification
- `flutter gen-l10n` executed successfully.
- `flutter analyze` completed with 0 errors and 0 warnings.
- `flutter test` ran 356 tests with 100% pass rate.
