# Dynamic Build Metadata Generation & About Screen Build Date

**Status:** completed

## Issue
Currently, build metadata (app version and build date) is not automatically generated during Flutter/Android builds, and the About screen does not display the build date.

## Fix
1. Create generator scripts:
   - `tool/generate_app_version.dart`: Extracts the version string from `pubspec.yaml` and writes `lib/core/constants/app_version.g.dart` (`kAppVersion`), printing `app_version.g.dart updated → <version>`.
   - `tool/generate_build_date.dart`: Captures the current date (`YYYY-MM-DD`) and writes `lib/core/constants/build_date.g.dart` (`kBuildDate`), printing `build_date.g.dart updated → <date>`.
   - `tool/refresh_build_metadata.ps1`: Helper PowerShell script to manually run both generators.

2. Hook into Gradle build process:
   - In `android/app/build.gradle.kts`, register a `generateBuildMetadata` task running the Dart generators before `preBuild` and Flutter compilation tasks. This ensures `flutter build apk` and `flutter run` automatically regenerate metadata and print the progress messages to the console.

3. Localization & About Screen:
   - Add `aboutBuildDateLabel` to `lib/l10n/app_en.arb` ("Build date") and `lib/l10n/app_ml.arb` ("ബിൽഡ് തീയതി").
   - Update `lib/features/about/presentation/about_screen.dart` to display the build date row under the version row.

4. Tests:
   - Update `test/widget/about_screen_test.dart` to assert that the build date row is displayed.

## Files to change
- `tool/generate_app_version.dart` (new)
- `tool/generate_build_date.dart` (new)
- `tool/refresh_build_metadata.ps1` (new)
- `lib/core/constants/app_version.g.dart` (new / generated)
- `lib/core/constants/build_date.g.dart` (new / generated)
- `android/app/build.gradle.kts` (modify)
- `lib/l10n/app_en.arb` (modify)
- `lib/l10n/app_ml.arb` (modify)
- `lib/features/about/presentation/about_screen.dart` (modify)
- `test/widget/about_screen_test.dart` (modify)
