# Plan — Upgrade Flutter and Dart SDK requirements

**Status:** completed

## List of files to be changed
1. `pubspec.yaml`
2. `AGENTS.md`
3. `.agents/AGENTS.md`
4. `CLAUDE.md`
5. `README.md`
6. `docs/PDF-Idea.md`

## What the issue is
The active local Flutter toolchain was updated to:
- Flutter: `3.44.8` (channel stable)
- Dart: `3.12.2`

The project's dependency constraints and documentation currently pin minimum versions to Flutter `3.41.9` and Dart `3.11.5` (`sdk: ^3.11.5`).

## Plan for the fix
1. Update `pubspec.yaml` environment SDK constraint to `sdk: ^3.12.2`.
2. Update Flutter and Dart minimum toolchain version specifications across project documentation:
   - `AGENTS.md`: Flutter `3.44.8` or higher, Dart `3.12.2` or higher.
   - `.agents/AGENTS.md`: Flutter `3.44.8` or higher, Dart `3.12.2` or higher.
   - `CLAUDE.md`: Flutter `3.44.8` or higher, Dart `3.12.2` or higher.
   - `README.md`: Flutter `3.44.8+` and Dart `3.12.2+`.
   - `docs/PDF-Idea.md`: Flutter `3.44.8` or higher, Dart `3.12.2` or higher.
3. Run verification:
   - `flutter pub get`
   - `flutter analyze`
   - `flutter test`
4. Write change log to `change_log/20260801_213440_upgrade_flutter_dart_sdk.md`.
