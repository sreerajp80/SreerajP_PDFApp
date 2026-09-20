# Change Log: README Accuracy and Screenshots

**Date:** 2026-09-20 14:45:00  
**Plan Reference:** [plans/20260920_144300_readme_accuracy_and_screenshots.md](plans/20260920_144300_readme_accuracy_and_screenshots.md)

## Summary of Changes

1. **Captured Real Device UI Screenshots**:
   - Installed the development build on the connected Android emulator.
   - Pushed and opened a sample Malayalam Unicode document (`samples/LalithaSahasranaamam_Malayalam_Unicode.pdf`).
   - Captured 6 screenshots of key user flows and saved them into `docs/screenshots/`:
     - `docs/screenshots/01_home_screen.png`: Home dashboard with recent files and "Open PDF" floating action button.
     - `docs/screenshots/02_viewer_screen.png`: PDF reader screen displaying Malayalam text, top toolbar, and reading progress metrics.
     - `docs/screenshots/03_search_screen.png`: Indic search interface with phonetic query, match navigation, and search controls.
     - `docs/screenshots/04_annotations_screen.png`: Annotation toolbar showing highlight, strikethrough, ink drawing, notes, and bookmark tools.
     - `docs/screenshots/05_page_operations_screen.png`: Page operations grid showing thumbnail reordering, page rotation, and copy-on-write saving.
     - `docs/screenshots/06_settings_screen.png`: Settings hub showing theme, typography, language, TTS, virtual printer, certificates, and permissions.

2. **Updated Repository Homepage (`README.md`)**:
   - Added project status badges (Android minSdk 26 / targetSdk 35, Flutter 3.44.8+, Dart 3.12.2+, 100% Open Source, 100% Offline / Zero Telemetry).
   - Embedded a responsive screenshot gallery table showcasing all 6 captured screens with clear descriptions.
   - Documented the full feature catalog:
     - High-performance PDF viewing and reading metrics.
     - Indic phonetic and Sandhi search for Malayalam and Sanskrit.
     - Multi-language Read Aloud (TTS) with honest state reporting.
     - Annotations, ink sketching, sticky notes, and bookmarks.
     - Copy-on-write page operations (reorder, rotate, delete, merge, split, compress, watermark, trim margins, booklet layout, password protect).
     - Virtual PDF printer integration.
     - Local digital signature verification and offline certificate management.
     - Scoped storage and privacy guarantees.
   - Provided accurate tech stack, architecture layout, development prerequisites, flavor commands, testing commands, release instructions, and documentation links.

## Verification

- **Static Analysis**: Ran `flutter analyze` — passed with 0 issues found.
- **Unit & Widget Tests**: Ran `flutter test` — all 408 tests passed.
- **Image Assets**: Verified all 6 screenshots exist in `docs/screenshots/` and display properly.
