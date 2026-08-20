# Plan: Settings Screen Redesign with Section Cards, Appearance (Theme & Accent Color), and Permissions

**Status:** Proposed

## 1. Overview
The Settings screen will be updated to use modern card-based sections modeled after the reference application design. Additionally, the Appearance configuration will be expanded to include Theme Mode selection and customizable Accent Color (with presets, live preview, and custom HSV color wheel), and a dedicated Permissions screen will be introduced to explain scoped storage, system virtual print service, and offline privacy capabilities.

## 2. Changes to Make

### A. Theme and Accent Color System
- **File:** `lib/app/theme/app_theme.dart` & `lib/app/theme/tokens.dart`
  - Add support for customizable accent colors (light accent and dark accent) with preset palettes.
  - Implement `AppColors` ThemeExtension (or tokens) for consistent card surfaces, muted text colors, and brand tints.
  - Implement `contrastOn(Color)` helper to guarantee readable text against any custom accent color.
  - Update `ResolvedTheme` to build `ThemeData` seeded with the user-selected accent color for light, dark, and sepia modes.

- **File:** `lib/app/config/providers.dart`
  - Add `accentColorProvider` / notifiers to persist and update `lightAccent` and `darkAccent` via `SharedPreferences`.

### B. Appearance Settings Screen & Screens
- **File:** `lib/features/settings/presentation/appearance_screen.dart` (NEW)
  - Hub screen for appearance settings with cards for Theme Mode and Accent Color.
- **File:** `lib/features/settings/presentation/theme_mode_screen.dart` (NEW / refactor `theme_screen.dart`)
  - Screen for selecting Theme Mode (Light, Dark, System, Sepia) with SegmentedButtons / preview cards.
- **File:** `lib/features/settings/presentation/accent_color_screen.dart` (NEW)
  - Interactive accent color picker with:
    - Live preview banner and sample text with auto-contrast.
    - Preset color swatches.
    - Custom Hue/Saturation color wheel and brightness slider.
    - Reset button to restore defaults.

### C. Permissions Screen & Platform Bridge
- **File:** `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt`
  - Add `openAppSettings` method call to open the Android application details settings page.
- **File:** `lib/core/platform/open_document_channel.dart`
  - Add `openAppSettings()` method.
- **File:** `lib/features/settings/presentation/permissions_screen.dart` (NEW)
  - Categorized permissions list:
    - Explicit / System Capabilities: Scoped Storage (SAF), Virtual Print Service (`BIND_PRINT_SERVICE`).
    - Implicit / Declarations: Zero Internet (100% Offline & Private), TTS Service Query, Process Text.
    - Action to open system settings.

### D. Settings Screen Card Layout
- **File:** `lib/features/settings/presentation/settings_screen.dart`
  - Redesign into distinct card sections:
    - Appearance Card (Icon, Title, Subtitle with active theme & color dot, Chevron -> Appearance screen).
    - Read Aloud / Malayalam Voice Card (Icon, Title, Subtitle with voice status, Switch toggle).
    - Trusted Certificates Card (Icon, Title, Subtitle, Chevron -> Trust Store screen).
    - Permissions Card (Icon, Title, Subtitle, Chevron -> Permissions screen).
    - About Card (Icon, Title, Subtitle with version info, Chevron -> About screen).

### E. Navigation and Routing
- **File:** `lib/app/routing/app_router.dart`
  - Register routes for Appearance, Accent Color, and Permissions.

### F. Localization
- **Files:** `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb`
  - Add localized strings in English and Malayalam for all new cards, titles, descriptions, and buttons.
  - Run `flutter gen-l10n`.

## 3. Verification Plan
- Run `flutter gen-l10n`.
- Run `flutter analyze` to ensure 0 warnings/errors.
- Run `flutter test` to ensure all existing tests pass and add unit tests for accent color persistence and theme resolution.
- Verify visually on device / emulator.
