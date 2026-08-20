# Release Process — SreerajP_PDFApp

This document details how to build, harden, sign, verify, and package the SreerajP PDF App for release.

Read this before generating production release binaries. Full security controls live in [security.md](security.md).

> **Secrets warning.** Keystore files (`android/*.jks`) and `android/key.properties` hold sensitive signing credentials. They are git-ignored and MUST never be checked into version control, shared, or exposed in chat logs. Keep secure offline backups.

---

## 1. Prerequisites & Signing Configuration

The Android build is configured in `android/app/build.gradle.kts` to detect `android/key.properties`:

- If `android/key.properties` exists, Gradle signs the release build with your release key.
- If absent, Gradle falls back to debug signing so developers can run local debug builds without credentials.

### `android/key.properties` Format

```properties
storeFile=upload-keystore.jks
storePassword=<keystore-password>
keyAlias=upload
keyPassword=<key-password>
```

---

## 2. Keystore Generation (One-Time)

Generate the release keystore inside the `android/` directory:

```powershell
keytool -genkeypair -v `
  -keystore upload-keystore.jks `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias upload
```

---

## 3. Production Build Commands

Release builds MUST be compiled with code obfuscation and debug symbol splitting:

```powershell
# Production Android App Bundle (for Google Play Store)
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols

# Production APK (for direct sideloading or internal distribution)
flutter build apk --release --obfuscate --split-debug-info=build/symbols --split-per-abi
```

### Build Artifact Locations:
- App Bundle: `build/app/outputs/bundle/release/app-release.aab`
- Split APKs: `build/app/outputs/flutter-apk/app-*-release.apk`
- Symbol Maps: `build/symbols/` (archive safely for crash de-obfuscation)

---

## 4. Verification & Validation

After building the release binary:

1. **Verify Signature**:
   ```powershell
   keytool -list -printcert -jarfile build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
   ```
   Confirm the SHA-256 fingerprint matches your production key and not the Android debug certificate.

2. **Verify Manifest Hardening**:
   - Confirm `android:debuggable="false"` (omitted from release manifest).
   - Confirm `android.permission.INTERNET` is absent (offline-first requirement).
   - Confirm `android:allowBackup="false"` is set.

---

## 5. Release Checklist

- [ ] `app_config.json` and `pubspec.yaml` versions match.
- [ ] `flutter analyze` reports 0 issues.
- [ ] `flutter test` passes 100% of tests.
- [ ] Release binaries generated with `--obfuscate` and `--split-debug-info`.
- [ ] Keystore certificate verified against output APK.
- [ ] Debug symbols archived securely alongside release assets.
