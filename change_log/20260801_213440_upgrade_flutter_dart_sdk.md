# Change Log — Upgrade Flutter and Dart SDK requirements

## Summary
Upgraded project SDK constraints and documentation to target **Flutter 3.44.8** and **Dart 3.12.2**.

## Reference Plan
Implemented [plans/20260801_213440_upgrade_flutter_dart_sdk.md](file:///l:/Android/SreerajP_PDFApp/plans/20260801_213440_upgrade_flutter_dart_sdk.md).

## Detailed Changes
1. **`pubspec.yaml`**:
   - Updated `environment.sdk` from `^3.11.5` to `^3.12.2`.
2. **`AGENTS.md` & `.agents/AGENTS.md`**:
   - Updated minimum tech stack version requirements to Flutter `3.44.8 or higher` and Dart `3.12.2 or higher`.
3. **`CLAUDE.md`**:
   - Updated tech stack section to Flutter `3.44.8 or higher` and Dart `3.12.2 or higher`.
4. **`README.md`**:
   - Updated prerequisites section to Flutter `3.44.8+` and Dart `3.12.2+`.
5. **`docs/PDF-Idea.md`**:
   - Updated Development Tools section to Flutter `3.44.8 or higher` and Dart `3.12.2 or higher`.
6. **Code Maintenance for Flutter 3.44 / Dart 3.12**:
   - Migrated deprecated `onReorder` callback to `onReorderItem` in [organize_pages_screen.dart](file:///l:/Android/SreerajP_PDFApp/lib/features/page_ops/presentation/widgets/organize_pages_screen.dart).
   - Updated constructors across repositories and services (`AppDatabase`, `AnnotationRepository`, `TtsService`, `SignatureRepository`, `PdfRepository`) to use Dart 3.12 initializing formals.

## Verification
- Ran `flutter pub get`: Dependencies resolved cleanly.
- Ran `flutter analyze`: Passed with zero issues.
- Ran `flutter test`: All tests passed.
