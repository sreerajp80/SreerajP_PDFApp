# Change Log: Comprehensive Settings Suite and In-Depth Permissions Rationale

**Reference Plan:** `plans/20260819_213800_comprehensive_settings_and_permissions.md`

## Summary of Changes

Expanded the application Settings screen into a comprehensive preferences hub with dedicated sub-screens and overhauled the Permissions screen with exhaustive rationale and capability details:

1. **In-App Language Selection:**
   - Added dynamic `appLocaleProvider` and `LanguageScreen` (`/settings/language`) allowing instant switching between System Default, English, and Malayalam.
   - Connected `locale: ref.watch(appLocaleProvider)` in `PdfApp`.

2. **Reader & Viewer Preferences:**
   - Created `ReaderSettingsScreen` (`/settings/reader`) with settings for:
     - Remember Reading Position toggle (save last viewed page and zoom).
     - Default Page Layout selector (Continuous Scroll vs. Single Page).
     - Page Number Indicator overlay toggle.
     - PDF Color Inversion mode toggle (for night reading).
     - Double-Tap Zoom action selector (Fit to Width vs. Zoom 200%).

3. **Text-to-Speech (Read Aloud) Settings:**
   - Created `TtsSettingsScreen` (`/settings/tts`) with:
     - Malayalam voice toggle with guided install sheet trigger.
     - Speech Rate slider (0.5x to 2.0x).
     - Voice Pitch slider (0.5x to 2.0x).
     - Auto-Scroll with spoken sentences toggle.

4. **PDF Virtual Printer Preferences:**
   - Created `PrinterSettingsScreen` (`/settings/printer`) with:
     - PDF Virtual Printer integration toggle.
     - Default Paper Size selector (A4, US Letter, Legal).
     - Default Color Mode selector (Color, Grayscale, Monochrome).
     - Default Orientation selector (Auto, Portrait, Landscape).
     - One-tap Clear Printer Cache action with live storage calculation.

5. **Storage & Privacy Management:**
   - Created `CacheService` to compute directory sizes and safely purge temporary files.
   - Added `clearAll()` methods to `RecentFilesDao` and `ReadingPositionDao`.
   - Created `StorageSettingsScreen` (`/settings/storage`) with:
     - Remember Recent Files history toggle.
     - Clear Recent Files History action (with confirmation dialog).
     - Live App Temp Cache size display and one-tap Clear Cache action.

6. **Permissions & Capabilities Breakdown:**
   - Upgraded `PermissionsScreen` to list and detail every permission:
     - **Explicit Grants**: Scoped Storage (SAF), System Virtual Print Service (`BIND_PRINT_SERVICE`), and Secure File Provider (`androidx.core.content.FileProvider`).
     - **Implicit Queries & Intents**: Text-to-Speech Engine Query (`TTS_SERVICE`), Voice Data Installer (`INSTALL_TTS_DATA`), Text Processing Action (`PROCESS_TEXT`), and Receive Shares & "Open with" (`SEND`, `SEND_MULTIPLE`, `VIEW`).
     - **Privacy Guarantee**: Zero Internet Guarantee (100% offline).
     - For every capability, presented: Classification Badge, Why it is needed, and What the app achieves with it.

7. **Localization:**
   - Added complete English (`app_en.arb`) and Malayalam (`app_ml.arb`) translations for all new screens, cards, dialogs, sliders, and descriptions.

## Verification
- `flutter gen-l10n` compiled without errors or missing keys.
- `flutter analyze` completed with 0 errors and 0 warnings.
- `flutter test` passed all 358 unit and widget tests.
