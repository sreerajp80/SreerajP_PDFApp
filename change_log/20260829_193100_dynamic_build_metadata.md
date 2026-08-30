# Change Log: Dynamic Build Metadata Generation & About Screen Build Date

**Plan:** [plans/20260829_192600_dynamic_build_metadata.md](plans/20260829_192600_dynamic_build_metadata.md)

## Summary
Configured automatic generation of build metadata (`app_version.g.dart` and `build_date.g.dart`) during Android/Flutter builds and displayed the build date in the About screen.

## Changes Made

### 1. Build Tooling
- **`tool/generate_app_version.dart`**: Reads `version:` from `pubspec.yaml`, writes `lib/core/constants/app_version.g.dart` (`kAppVersion`), and prints `app_version.g.dart updated → <version>`.
- **`tool/generate_build_date.dart`**: Gets the current date in ISO-8601 (`YYYY-MM-DD`) format, writes `lib/core/constants/build_date.g.dart` (`kBuildDate`), and prints `build_date.g.dart updated → <date>`.
- **`tool/refresh_build_metadata.ps1`**: Helper PowerShell script to run both generators manually.

### 2. Gradle Integration
- **`android/app/build.gradle.kts`**: Registered `generateBuildMetadata` Gradle task and wired it into `preBuild` and `compileFlutterBuild*` tasks to automatically regenerate metadata before compiling Android APK or app bundles.

### 3. Localization & About Screen
- **`lib/l10n/app_en.arb`** & **`lib/l10n/app_ml.arb`**: Added `aboutBuildDateLabel` key (`"Build date"` in English, `"ബിൽഡ് തീയതി"` in Malayalam).
- **`lib/features/about/presentation/about_screen.dart`**: Added a `ListTile` showing `l10n.aboutBuildDateLabel` with `kBuildDate`.

### 4. Tests
- **`test/widget/about_screen_test.dart`**: Verified that the About screen renders the build date row.

## Verification
- Verified `generateBuildMetadata` Gradle task executes and prints the expected lines.
- `flutter analyze`: 0 issues found.
- `flutter test`: All 390 tests passed.
