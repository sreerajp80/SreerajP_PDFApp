# Plan: Comprehensive Settings Screens and Detailed Permissions Rationale

**Status:** Proposed

## 1. Overview
This change expands the Settings section of the application into a full-featured preferences system, providing user control over:
1. **In-App Language Selection** (System Default, English, Malayalam).
2. **PDF Viewer & Reading Preferences** (Remember last position toggle, default page layout, double-tap zoom, page indicator overlay, inverted colors mode).
3. **PDF Virtual Printer Preferences** (Virtual printer toggle, default paper size, color mode, orientation, print cache cleaner).
4. **Text-to-Speech (TTS) Settings** (Speech rate slider, pitch slider, Malayalam voice toggle, auto-scroll with speech).
5. **Storage & Privacy Management** (Remember recent files toggle, clear recent files history, cache size breakdown, clear temporary cache).
6. **Signatures & Verification** (Auto-verify signatures toggle, trust store management).
7. **Comprehensive Permissions Breakdown** (Listing all explicit and implicit permissions/capabilities, reasons for usage, and what the app achieves with each).

---

## 2. Architecture & File Changes

### A. Core Constants & Preference Keys
- **File:** `lib/core/constants/app_constants.dart`
  - Add preference keys:
    - `prefAppLocale` (`settings.app_locale`)
    - `prefRememberReadingPosition` (`settings.remember_reading_position`)
    - `prefDefaultPageLayout` (`settings.default_page_layout`)
    - `prefShowPageIndicator` (`settings.show_page_indicator`)
    - `prefPdfInvertColors` (`settings.pdf_invert_colors`)
    - `prefDoubleTapZoom` (`settings.double_tap_zoom`)
    - `prefPdfPrinterEnabled` (`settings.printer_enabled`)
    - `prefDefaultPaperSize` (`settings.default_paper_size`)
    - `prefDefaultPrintColorMode` (`settings.default_print_color_mode`)
    - `prefDefaultPrintOrientation` (`settings.default_print_orientation`)
    - `prefTtsSpeechRate` (`settings.tts_speech_rate`)
    - `prefTtsPitch` (`settings.tts_pitch`)
    - `prefTtsAutoScroll` (`settings.tts_auto_scroll`)
    - `prefRememberRecentFiles` (`settings.remember_recent_files`)
    - `prefAutoVerifySignatures` (`settings.auto_verify_signatures`)

### B. State Management Providers
- **File:** `lib/app/config/providers.dart`
  - Add `appLocaleProvider` (Notifier managing `Locale?` for dynamic language switching).
  - Add `readerPreferencesProvider` / individual preference notifiers (`rememberReadingPositionProvider`, `defaultPageLayoutProvider`, `showPageIndicatorProvider`, `pdfInvertColorsProvider`, `doubleTapZoomProvider`).
  - Add `printerPreferencesProvider` (`pdfPrinterEnabledProvider`, `defaultPaperSizeProvider`, `defaultPrintColorModeProvider`, `defaultPrintOrientationProvider`).
  - Add `ttsPreferencesProvider` (`ttsSpeechRateProvider`, `ttsPitchProvider`, `ttsAutoScrollProvider`).
  - Add `storagePreferencesProvider` (`rememberRecentFilesProvider`).
  - Add `signaturePreferencesProvider` (`autoVerifySignaturesProvider`).

### C. App Entry & Localization Wiring
- **File:** `lib/app/app.dart`
  - Wire `locale: ref.watch(appLocaleProvider)` into `MaterialApp.router`.

### D. Data Repositories & DAOs
- **File:** `lib/features/viewer/data/recent_files_dao.dart`
  - Add `clearAll()` method to wipe recent files list.
- **File:** `lib/features/viewer/data/reading_position_dao.dart`
  - Add `clearAll()` method to clear reading positions.
- **File:** `lib/features/viewer/data/pdf_repository.dart`
  - Check `rememberRecentFiles` and `rememberReadingPosition` flags before persisting history/position.
  - Expose `clearRecentFiles()` and `clearReadingPositions()` methods.

### E. Cache & Storage Service
- **File:** `lib/core/storage/cache_service.dart` (NEW)
  - Calculate total cache size across private cache folders (`printer/`, temporary rendered files, extracted text).
  - Provide `clearTempCache()` function to safely purge cache files.

### F. Dedicated Settings Screens
- **File:** `lib/features/settings/presentation/settings_screen.dart`
  - Reorganize main settings screen with beautiful categorized cards:
    - Appearance
    - Language
    - Reader & Viewer
    - Text-to-Speech (Read Aloud)
    - PDF Printer
    - Storage & Privacy
    - Signatures & Security
    - Permissions & Privacy
    - Help & Guides
    - About
- **File:** `lib/features/settings/presentation/language_screen.dart` (NEW)
  - Select between System Default, English, and Malayalam with live UI update.
- **File:** `lib/features/settings/presentation/reader_settings_screen.dart` (NEW)
  - Controls for saving last position, default layout (vertical continuous vs horizontal single page), double-tap zoom behavior, page indicator visibility, and color inversion.
- **File:** `lib/features/settings/presentation/tts_settings_screen.dart` (NEW)
  - Malayalam voice availability switch, speech rate slider (0.5x to 2.0x), pitch slider, and auto-scroll toggle.
- **File:** `lib/features/settings/presentation/printer_settings_screen.dart` (NEW)
  - Virtual print service toggle, default paper size selection (A4, Letter, Legal), default orientation, default color mode, and print cache cleanup.
- **File:** `lib/features/settings/presentation/storage_settings_screen.dart` (NEW)
  - Remember recent files toggle, Clear Recent Files action (with confirmation dialog), Cache Size calculation, and Clear Temp Cache action.
- **File:** `lib/features/settings/presentation/permissions_screen.dart`
  - Comprehensive breakdown of all permissions:
    - **Explicit Permissions & Capabilities**: Storage Access Framework (SAF document picker), System Virtual Print Service (`BIND_PRINT_SERVICE`), FileProvider content sharing.
    - **Implicit Capabilities & Intent Queries**: Text-to-Speech Engine Query (`TTS_SERVICE`), Voice Data Installer (`INSTALL_TTS_DATA`), Text Processing (`PROCESS_TEXT`), "Open with" & Share Receiving (`SEND`, `SEND_MULTIPLE`, `VIEW`).
    - **Offline Privacy Guarantee**: Zero Internet permission (`INTERNET` absent).
    - For each item, display: Permission Name, Classification, Reason for usage, and What the app achieves.

### G. Routing
- **File:** `lib/app/routing/app_router.dart`
  - Register new routes:
    - `/settings/language` (`AppRoute.language`)
    - `/settings/reader` (`AppRoute.readerSettings`)
    - `/settings/tts` (`AppRoute.ttsSettings`)
    - `/settings/printer` (`AppRoute.printerSettings`)
    - `/settings/storage` (`AppRoute.storageSettings`)

### H. Localization
- **Files:** `lib/l10n/app_en.arb` & `lib/l10n/app_ml.arb`
  - Add all localized strings in English and Malayalam for every new setting, card, title, subtitle, slider, and permission explanation.
  - Run `flutter gen-l10n`.

---

## 3. Verification Plan
1. **Code generation & Analysis**:
   - Run `flutter gen-l10n` to compile localization messages.
   - Run `flutter analyze` to ensure zero errors and zero warnings.
2. **Automated Testing**:
   - Run `flutter test` to ensure existing and new tests pass.
   - Add unit tests for preference notifiers, cache calculation, and DAO clearing.
3. **Manual / Functional Verification**:
   - Test changing language dynamically between System, English, and Malayalam.
   - Test changing reading position toggle, theme, and TTS sliders.
   - Test clearing recents and clearing cache.
   - Verify permissions screen displays all explicit and implicit permissions with clear descriptions.
