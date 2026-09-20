# Implementation Plan: README Accuracy and Screenshots

**Status:** Completed
**Date:** 2026-09-20 14:43:00

## 1. Overview
The `README.md` file serves as the GitHub home page for the repository. Currently, it is a minimal 72-line document focusing mainly on developer build instructions. It lacks visual previews (screenshots), a comprehensive overview of app features, accurate details about recent capabilities (such as Sanskrit localization, virtual printing, Indic Sandhi search, and digital signature verification), and clear privacy guarantees.

This plan details the steps to capture high-quality screenshots from the connected Android emulator (`emulator-5554`) and update `README.md` into an accurate, complete, and visually attractive project showcase.

## 2. Screenshots to Capture (`docs/screenshots/`)
Using `adb` and the connected emulator `emulator-5554`, we will capture six key screens displaying the app's interface:
1. `01_home_screen.png`: Home dashboard showing recent files, quick action cards, and clean Material 3 design.
2. `02_viewer_screen.png`: Reader view displaying a sample Malayalam Unicode PDF (`samples/LalithaSahasranaamam_Malayalam_Unicode.pdf`) with bottom navigation controls, zoom controls, and reading metrics.
3. `03_search_screen.png`: Search bar with Malayalam transliteration suggestions, virtual Malayalam keypad, and on-page search match highlights.
4. `04_annotations_screen.png`: Annotation overlay toolbar with text markups, sticky notes, ink drawing, and bookmarks panel.
5. `05_page_operations_screen.png`: Visual page reorganization grid showing page thumbnails, reordering, rotation, and deletion tools.
6. `06_settings_screen.png`: Settings hub showing theme options (Light, Dark, OLED Pitch-Black), Malayalam typography presets, accent color picker, and permissions.

Screenshots will be stored in `docs/screenshots/` so they are tracked in version control and rendered on GitHub without increasing the packaged app APK size.

## 3. README.md Enhancements
1. **Header & Badges**:
   - App title, description, and status badges (Platform: Android minSdk 26 / targetSdk 35; Framework: Flutter 3.44.8+ / Dart 3.12.2+; License: 100% Open Source; Privacy: 100% Offline / Zero Telemetry).
2. **Core Principles & Guarantees**:
   - 100% Open Source (no proprietary SDKs).
   - Offline-First (no `android.permission.INTERNET`, zero telemetry).
   - Scoped Storage only (Storage Access Framework, no broad storage permissions).
   - Copy-on-Write (original files are never modified in place).
   - Never crash on bad input (graceful handling of encrypted or corrupt files).
   - Scanned PDF graceful degradation (clear notice when text layer is absent).
3. **Visual Showcase**:
   - Responsive Markdown table displaying the captured screenshots with descriptive captions.
4. **Comprehensive Feature Catalog**:
   - PDF Viewing & Navigation (continuous, single-page, dual-page book view, foldable support, reading speed/time estimates, TOC outline, thumbnail grid).
   - Search & Indic Engine (full-text search, Sandhi compound splitting/joining, phonetic sound-alike matching, Manglish input helper, 3-tab virtual Malayalam keypad, cantillation accent stripping).
   - Text-to-Speech (TTS) (English and Malayalam speech, pitch/rate/pause sliders, background media playback notification, voice installer helper).
   - Annotations & Bookmarks (highlights, underlines, strikethroughs in 7 colors, sticky notes, ink drawing, bookmarks, PDF flattening/export).
   - Page Operations (visual reorder/rotate/delete, watermarks, N-up imposition, booklet creator, margin trim, merge, split, compress, encrypt/decrypt).
   - Virtual PDF Printer & Share Hub (system virtual print service, web content cleaner/reader mode, images-to-PDF, text-to-PDF, intent filters).
   - Digital Signature Verification (cryptographic integrity, cert chain validation, visual stamp overlay, EU trusted lists, custom trust store).
   - Customization & Languages (Light/Dark/OLED Black themes, Manjari/Anek/Noto fonts, accent color picker, English/Malayalam/Sanskrit UI).
5. **Developer & Build Guide**:
   - Accurate prerequisites (Flutter 3.44.8+, Dart 3.12.2+, JDK 17, minSdk 26, targetSdk 35).
   - Setup and running (`--flavor dev` vs `--flavor prod`).
   - Testing (`flutter test` with host-side SQLite via `sqflite_common_ffi`).
   - Localization (`flutter gen-l10n` covering `en`, `ml`, `sa`).
   - Database migrations and release build commands.
6. **Documentation Links**:
   - Links to `docs/architecture.md`, `docs/features.md`, `docs/security.md`, `docs/release_process.md`, `docs/dependencies.md`, `docs/project_structure.md`, and `AGENTS.md`.

## 4. Files to Change
- `docs/screenshots/`:
  - `01_home_screen.png` [NEW]
  - `02_viewer_screen.png` [NEW]
  - `03_search_screen.png` [NEW]
  - `04_annotations_screen.png` [NEW]
  - `05_page_operations_screen.png` [NEW]
  - `06_settings_screen.png` [NEW]
- `README.md`:
  - Update content to provide the complete, accurate GitHub home page with screenshots and feature overview.

## 5. Verification Plan
1. **Screenshot Quality & Sizing**:
   - Verify all 6 screenshots are clear, properly sized, and placed in `docs/screenshots/`.
2. **README Accuracy & Links**:
   - Verify all markdown links in `README.md` resolve to existing repository files.
   - Verify all listed commands and technical specifications match the project's actual configuration.
3. **Static Analysis & Testing**:
   - Run `flutter analyze` to ensure 0 errors and 0 warnings.
   - Run `flutter test` to ensure existing tests pass.
