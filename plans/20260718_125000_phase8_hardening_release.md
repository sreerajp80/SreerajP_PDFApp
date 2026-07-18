# Phase 8 — Hardening & release

**Status:** completed

Implements Phase 8 of [pdf-app-implementation-plan.md](file:///l:/Android/SreerajP_PDFApp/docs/pdf-app-implementation-plan.md) (§5, §11). This is the final phase of the project, focusing on production-readiness, accessibility compliance, performance checks, security verification, and release tooling.

---

## 1. What the issue is

The application functionality is complete up to Phase 7. To prepare it for release, we must complete the following:
1. **Release signing configuration in Gradle**: The app currently signs release builds with debug keys. We need to implement Strategy A (local `key.properties`) to read release keystore parameters dynamically and block release builds of the `prod` flavor if `key.properties` is missing.
2. **Unit test failures**: An outdated unit test (`test/core/storage/migration_v3_test.dart`) is currently failing due to the database version having been bumped from 3 to 4 in Phase 7. This cascading failure leaves the database open in the FFI connection cache, causing subsequent tests to fail as well. We need to correct this expectation.
3. **Accessibility review**: Ensure touch targets, contrast in light/dark/sepia themes, semantic labels on custom screens, and text scaling (1.0x, 1.5x, 2.0x) behave correctly without UI layout breaks.
4. **Performance pass**: Confirm isolates are used for heavy calculations, check startup time targets (<2s), verify image cache budgets, and run size analysis using `--analyze-size`.
5. **16 KB page-size compliance check**: Google Play requires 16 KB memory alignment on Android 15+ targets. We need to audit native dependencies (specifically `pdfrx` / PDFium and `PdfBox-Android` / Bouncy Castle).
6. **Documentation updates**: Create the project-specific `docs/security.md`, complete `docs/architecture.md`, write a `CHANGELOG.md`, and complete the release runbook process.

---

## 2. Proposed Changes

### Build & Release Configuration

#### [MODIFY] [build.gradle.kts](file:///l:/Android/SreerajP_PDFApp/android/app/build.gradle.kts)
- Implement dynamic loading of `key.properties` at the top level of the file.
- Configure `signingConfigs.release` to read parameters if `key.properties` exists.
- Configure the `release` build type to use the `release` signing config if available, falling back to the `debug` signing config so local development builds continue to run.
- Add an `afterEvaluate` task checking if the task contains `assembleProdRelease` or `bundleProdRelease`. If `key.properties` is missing, fail the build with a descriptive `GradleException` explaining how to configure signing.

#### [NEW] [key.properties.example](file:///l:/Android/SreerajP_PDFApp/android/key.properties.example)
- Create a template containing dummy/example keys (`storeFile`, `storePassword`, `keyAlias`, `keyPassword`) to serve as a guide for developers without exposing production secrets.

### Database Test Fixes

#### [MODIFY] [migration_v3_test.dart](file:///l:/Android/SreerajP_PDFApp/test/core/storage/migration_v3_test.dart)
- Update `expect(await db.getVersion(), 3);` to expect `AppConstants.databaseVersion` (which is 4) since the database migrations have been upgraded to support the signature trust store. This will fix the test assertion and prevent cascading failures in subsequent in-memory tests.

### Accessibility, Manifest, & Performance Audits

- **16 KB Page-Size Audit**: We will inspect native dependencies to ensure compliance.
  - `pdfrx` uses a precompiled Google PDFium library (`libpdfium.so`). Let's verify that the `pdfrx` package has been compiled with 16 KB page alignment.
  - Native signature checks run inside our native Kotlin runner and standard Java cryptographic APIs, which are runtime-interpreted and comply automatically.
- **Offline / Internet check**: The merged release manifest (`android/app/src/main/AndroidManifest.xml`) has been checked and contains no `uses-permission android.permission.INTERNET` declaration, confirming offline compliance.
- **App Size Analysis**: We will run size checks using `flutter build apk --flavor prod --release --analyze-size` to verify binary size budget:
  - Arm64 APK limit: 30 MB (Target) / 50 MB (Hard limit).

### Documentation

#### [NEW] [security.md](file:///l:/Android/SreerajP_PDFApp/docs/security.md)
- Document the application's security posture, specifically detailing:
  - Encryption and password handling policies (stored in memory, not logged, never in `SharedPreferences`).
  - Trust store integrity checks (user trust certificate validation logic).
  - Scoped storage boundaries (SAF, no broad permissions).
  - Merged manifest analysis showing zero internet permission.

#### [MODIFY] [architecture.md](file:///l:/Android/SreerajP_PDFApp/docs/architecture.md)
- Verify and fill in the final database schema, version (v4), method channels, and folder structure.

#### [NEW] [CHANGELOG.md](file:///l:/Android/SreerajP_PDFApp/CHANGELOG.md)
- Create a central `CHANGELOG.md` at the project root documenting all releases and phases from Phase 0 to Phase 8.

---

## 3. Verification Plan

### Automated Tests
We will execute the complete test suite to ensure everything compiles and passes with zero warnings:
```powershell
flutter analyze
flutter test
```

### Manual Verification
1. Verify Gradle `prodRelease` build block when `key.properties` is missing:
   ```powershell
   flutter build apk --flavor prod --release
   ```
   **Expected result**: Gradle fails with the custom `SIGNING REQUIRED` exception.
2. Verify release build compiles when dummy signing properties are provided (using debug key):
   - Copy key properties and run the build.
3. Verify that no internet permission is requested in the final release manifest.
