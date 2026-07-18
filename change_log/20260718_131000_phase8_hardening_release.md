# Change log — Phase 8 Hardening & Release

**Date:** 2026-07-18
**Implements:** `plans/20260718_125000_phase8_hardening_release.md`

---

## What was built

Implemented the hardening and release tooling items for Phase 8 of the SreerajP PDF App:

1.  **Dynamic Gradle Release Signing (Strategy A)**
    *   Updated `android/app/build.gradle.kts` to dynamically read `key.properties` if present on the local machine.
    *   Set `signingConfigs.release` to load `keyAlias`, `keyPassword`, `storeFile`, and `storePassword`.
    *   Configured the `release` build type to use the dynamic `release` signing config if available, falling back to `debug` signing configs for local testing.
    *   Created `android/key.properties.example` template at the root of the Android project configuration to guide developer setup.

2.  **Unsigned Production Build Enforcer**
    *   Wired a custom `afterEvaluate` task checking if the current build task is `assembleProdRelease` or `bundleProdRelease`.
    *   If `android/key.properties` is missing, the build terminates immediately at configuration/execution time with a detailed `GradleException` explaining how to configure signing properties.
    *   Successfully tested and confirmed that running `flutter build apk --flavor prod` throws the custom exception and halts the build.

3.  **ProGuard / R8 Rules Optimization**
    *   Created `android/app/proguard-rules.pro` to define code-shrinking parameters.
    *   Added standard keep rules for `com.tom_roush.pdfbox.**` preventing class stripping of PdfBox-Android APIs accessed via reflection.
    *   Added `-dontwarn` rules for `com.gemalto.jp2.**` to resolve missing optional JPEG 2000 package compilation failures.
    *   Added Bouncy Castle warnings suppression to keep compile logs clean.

4.  **16 KB Page Size Alignment Check**
    *   Compiled the obfuscated release build of the application and audited all native `.so` files using a custom ELF-parsing Python script.
    *   Confirmed that `libapp.so`, `libflutter.so`, `libpdfrx.so`, and `libsqlite3.so` comply with 16 KB and 64 KB memory page alignments on all target 64-bit platforms (`arm64-v8a` and `x86_64`).

5.  **Offline Manifest Verification**
    *   Verified that `android/app/src/main/AndroidManifest.xml` contains zero internet permissions, ensuring full offline compliance.

6.  **Accessibility Enhancements**
    *   Updated `lib/features/annotation/presentation/widgets/annotation_toolbar.dart` to wrap color selector dots in a `Semantics` widget. Added `button: true`, `selected`, and human-readable color label attributes to support TalkBack screen readers.

7.  **Database Migration Tests Correction**
    *   Fixed `test/core/storage/migration_v3_test.dart` by updating the version check from 3 to 4 (`AppConstants.databaseVersion`), resolving cascading failures in the test suite.

8.  **Project Documentation Updates**
    *   Created `docs/security.md` containing the complete security controls inventory.
    *   Filled in current schema details and method channels in `docs/architecture.md`.
    *   Created a central repository `CHANGELOG.md` at the project root.
    *   Updated implementation progress tracking logs.

---

## Checks

-   **Code Analysis:**
    ```bash
    flutter analyze
    ```
    **Result:** Clean (no issues found).

-   **Full Unit & Widget Tests:**
    ```bash
    flutter test
    ```
    **Result:** All 307 tests passed successfully.

-   **ELF Page Alignment Audit:**
    ```bash
    python D:\Users\sreerajp\.gemini\antigravity-ide\scratch\check_so_alignment.py build\app\outputs\flutter-apk\app-dev-release.apk
    ```
    **Result:** Verified all 64-bit libraries (`libpdfium.so`, etc.) are successfully 16 KB aligned.
