# Upgrade the Android toolchain: AGP 9.4.1, Gradle 9.8.0, Kotlin 2.4.10

**Status:** in_progress

## The issue

The user asked to move the app to Flutter 3.47.6, AGP 9.4.1, Gradle 9.8.0 and Kotlin 2.4.10.

Checked today:

| Tool | Now | Target | Note |
|---|---|---|---|
| Flutter | 3.47.6 (Dart 3.13.5) | 3.47.6 | **Already done.** No change. |
| AGP (Android Gradle Plugin) | 8.12.1 | 9.4.1 | Exists on Google Maven. Major version jump. |
| Gradle | 8.14 | 9.8.0 | Exists on services.gradle.org. Major version jump. |
| Kotlin Gradle Plugin | 2.2.20 | 2.4.10 | Exists on Maven Central. |
| JDK | 17 | 17 | AGP 9 needs 17 or newer. No change. |

What breaks or needs care:

1. **`project.exec { }` is gone in Gradle 9.** `android/app/build.gradle.kts` uses it twice in
   the `generateBuildMetadata` task (it runs the Dart scripts that write
   `app_version.g.dart` and `build_date.g.dart`). The build fails until it uses an injected
   `ExecOperations`.
2. **`flutter_tts` 4.2.5** applies `kotlin-android` itself and uses the old `kotlinOptions { }`
   block. This works only while `android.builtInKotlin=false`, so that flag must stay `false`.
   Its Groovy build file may still warn or fail on Kotlin 2.4. If it fails, the fallback is a
   newer `flutter_tts` (checked for license and network use first).
3. **Other plugins look fine.** `package_info_plus` already handles both Kotlin modes.
   `path_provider_android`, `shared_preferences_android`, `sqflite_android`,
   `url_launcher_android`, `jni`, `jni_flutter` show nothing risky. `pdfrx` 2.x has no
   Android Gradle module (it uses a build hook to fetch PDFium).
4. **Flutter may warn** that AGP 9.4.1 / Gradle 9.8.0 are newer than the versions it was
   tested with (Flutter 3.47.6 itself generates AGP 9.1.0 / Gradle 9.3.1). A warning is fine;
   a hard error means stepping back to the newest version Flutter accepts.

Not changing: `android.builtInKotlin=false` and `android.newDsl=false` stay as Flutter wrote
them (flavors guide, "Android Toolchain Baseline"). Built-in Kotlin is a separate migration.

## Files to change

- `android/settings.gradle.kts` — AGP `8.12.1` → `9.4.1`; Kotlin `2.2.20` → `2.4.10`.
- `android/gradle/wrapper/gradle-wrapper.properties` — Gradle `8.14` → `9.8.0`.
- `android/app/build.gradle.kts` — `generateBuildMetadata` uses `ExecOperations`.
- `docs/dependencies.md`, `README.md` and `docs/release_process.md` — update the version
  numbers where they are written (only where they appear).
- `change_log/<timestamp>_toolchain_upgrade_agp9_gradle9.md` — the change log.

`android/gradle.properties` is not changed. No file in `docs/guidelines/` is changed.

## Plan for the fix

1. Change `generateBuildMetadata` to an abstract task class (or `doLast` with an injected
   `ExecOperations` service) so it runs the two Dart scripts without `project.exec`.
2. Bump AGP and Kotlin in `settings.gradle.kts`, and Gradle in the wrapper file.
3. Clean build check, **before any other change** (flavors guide rule):
   `flutter clean`, `flutter pub get`, `flutter build apk --flavor dev`, then
   `flutter build appbundle --flavor prod --release --obfuscate --split-debug-info=...`.
4. If `flutter_tts` fails to build, stop and report. Then propose the fallback (newer
   `flutter_tts`) as a small add-on to this plan, with approval.
5. Run `flutter analyze` and `flutter test`.
6. Check on a device: app starts, About shows the right version and build date (proves the
   metadata task still runs), open a PDF, read aloud works.
7. Run `android\gradlew --stop` and end any leftover `GradleDaemon` / `KotlinCompileDaemon`.
8. Update docs with the new versions and write the change log.

**Rollback:** revert the three build files. Nothing else depends on the new versions.

**Security impact:** none expected. No permission, manifest or security control changes.
R8 full mode stays on.
