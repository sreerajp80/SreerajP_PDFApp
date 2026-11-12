# Release Process — Folio

This document explains how to version, build, harden, sign, verify, and ship the Folio
app. It is this app's filled-in copy of the shared release template, for Android only. Read it
before making any production release build.

> Read first: [../CLAUDE.md](../CLAUDE.md) and [../AGENTS.md](../AGENTS.md) for project rules,
> [PROJECT_PROFILE.md](PROJECT_PROFILE.md) for the declared channels,
> [security.md](security.md) for security controls,
> [guidelines/platform_store_readiness.md](guidelines/platform_store_readiness.md) for the store
> gates, and [guidelines/release_process.md](guidelines/release_process.md) for the template.

> **Secrets warning.** Keystore files (`android/*.jks`) and `android/key.properties` hold the
> signing credentials. They are git-ignored and MUST never be committed, shared, or pasted into
> chat or logs. Keep at least two secure offline backups. Losing the keystore means you can never
> publish an update to the same app id.

---

## 1. Release Scope

- App: Folio (`in.sreerajp.pdfapp`)
- Release profile: `public`
- Supported release platforms (from [PROJECT_PROFILE.md](PROJECT_PROFILE.md)):
  - `Android` — channels: Google Play (App Bundle), signed split APKs for direct download
- Store gates in force: [platform_store_readiness.md](guidelines/platform_store_readiness.md)
  §1 (every store) and §2 (Google Play). The direct APK channel follows §1 and the signing rules
  in §7 below.
- Engineering standard profiles in force:
  - `Core Baseline`
  - `Production App Extension`
  - `Sensitive Data Extension`

---

## 2. Roles And Responsibilities

This is a one-maintainer project; one person holds every role.

| Role | Responsibility | Owner |
|---|---|---|
| Release owner | Coordinates release readiness and final sign-off | app maintainer |
| Engineering | Code freeze, fixes, validation | app maintainer |
| QA | Test execution and regression sign-off on a real device | app maintainer |
| Store or distribution owner | Uploads to Google Play and the direct-download page | app maintainer |

---

## 3. Versioning Policy

- Version format: `MAJOR.MINOR.PATCH+BUILD` (current: see `pubspec.yaml`, e.g. `2.7.4+24`).
- Source of truth: `pubspec.yaml`. `assets/config/app_config.json` (`version`, `build`) MUST match
  it before a release.
- Build-number increment rule: `+BUILD` goes up by 1 for every build uploaded anywhere. It becomes
  the Android `versionCode`, which Google Play requires to always increase.
- The `dev` flavor adds a `-dev` suffix to the version name.
- Git tag format: `vX.Y.Z` (e.g. `v2.7.4`).
- User-facing changes go into [../CHANGELOG.md](../CHANGELOG.md).

---

## 4. Branch And Merge Policy

- Release branch strategy: `master` only (trunk-based). Releases are cut from a tagged commit on
  `master`.
- Hotfix strategy: fix on `master`, bump PATCH and BUILD, release again (see §13).
- Required checks before merge:
  - `dart format --output=none --set-exit-if-changed .`, `flutter analyze` (0 issues),
    `flutter test` — run locally and in CI (`.github/workflows/ci.yml`).
  - An approved plan in `plans/` and a change log in `change_log/` for every change.

---

## 5. Environment And Flavor Matrix

| Flavor | Mode | Purpose | Example Command |
|---|---|---|---|
| `dev` | `debug` | Local development | `flutter run --flavor dev` |
| `dev` | `release` | Release-like QA, installs beside prod | `flutter build apk --flavor dev --release` |
| `prod` | `debug` | Prod config with debug tooling | `flutter run --flavor prod` |
| `prod` | `release` | Final release artifact | See §9 for the full commands |

> **Flavor signal at build time.** On Android, `--flavor <name>` is enough — Flutter injects
> `FLUTTER_APP_FLAVOR` itself and rejects it in `--dart-define`. `AppFlavorConfig`
> (`lib/app/config/app_flavor_config.dart`) reads it. A bare `flutter run` / `flutter build apk`
> fails because the project defines flavors.

---

## 6. Release Build Hardening

All production release builds MUST include the flags below. Missing any of them blocks the
release.

### 6.1 Obfuscation And Debug Symbols

```bash
--obfuscate
--split-debug-info=build/symbols/android-prod-<version>/
```

`<version>` is the full `pubspec.yaml` version, e.g. `2.7.4+24`.

**Symbol archive policy:**

- Archive the symbols folder securely after every production build, **outside the repository**,
  next to the release artifact (e.g. `<archive>/v2.7.4/symbols/`). Record the location in §14.
- Keep them for the life of the released version. Without them, stack traces from that version
  cannot be read.
- Never commit them (`build/` is in `.gitignore`).

### 6.2 ProGuard / R8

Flutter enables R8 for Android release builds. `android/app/proguard-rules.pro` keeps the
PdfBox-Android classes (`com.tom_roush.pdfbox.**`, used through reflection) and silences warnings
for optional Bouncy Castle and JP2 classes. After adding any dependency, do a full release build
and test it: R8 can strip reflection-only classes, which shows up as `ClassNotFoundException`
only in release.

### 6.3 App Size Analysis

```bash
flutter build apk --flavor prod --release --target-platform android-arm64 --analyze-size
```

Record the output in §14 and compare with the last release. A rise of more than 10% without a
reason is a review item.

| Platform | Target | Hard Limit |
|---|---|---|
| Android APK arm64 | < 30 MB | 50 MB |
| Android AAB download | < 20 MB | 40 MB |

### 6.4 Debuggable And Backup Verification

Check the merged release manifest before every production release:

1. **`android:debuggable`** must be absent or `false`.
2. **`android:allowBackup`** must be `false`, with `android:dataExtractionRules` pointing to
   `@xml/data_extraction_rules`, as [security.md](security.md) §10 records.

```bash
# bash / zsh
APK="build/app/outputs/flutter-apk/app-arm64-v8a-prod-release.apk"
aapt2 dump badging "$APK" | grep -i debuggable
aapt2 dump xmltree "$APK" --file AndroidManifest.xml | grep -i -E "allowBackup|uses-permission"
```

```powershell
# PowerShell (Windows)
$APK = "build\app\outputs\flutter-apk\app-arm64-v8a-prod-release.apk"
aapt2 dump badging $APK | Select-String -Pattern "debuggable"
aapt2 dump xmltree $APK --file AndroidManifest.xml | Select-String -Pattern "allowBackup|uses-permission"
```

**Expected:** no `application-debuggable` line; `allowBackup` matches [security.md](security.md)
§10; the only permissions are `android.permission.INTERNET` and `android.permission.CAMERA`
(Device sync, Hard Rule 2) — no `RECORD_AUDIO`, no storage permission.

### 6.5 Network Security Configuration And Cleartext Traffic

The app never contacts an internet host. `INTERNET` is declared only for Device sync, which uses
raw `dart:io` sockets on the local WiFi with its own AES-256-GCM encryption (no HTTP stack, so
Android's cleartext rules do not apply to it). No `networkSecurityConfig` or
`usesCleartextTraffic` is set. Confirm on each release that neither was added.

### 6.6 Pre-Release Asset And Secret Leak Audit

Files under `assets/` are not encrypted inside the APK. Audit them:

```bash
# bash / zsh
unzip -l build/app/outputs/flutter-apk/app-arm64-v8a-prod-release.apk "assets/*"
```

```powershell
# PowerShell (Windows)
tar -tf build\app\outputs\flutter-apk\app-arm64-v8a-prod-release.apk | Select-String "assets/"
```

- [ ] No `.env`, keystore, or credential files packaged.
- [ ] The only `.pem` is `assets/trust/eutl_certificates.pem` (public trust anchors — expected).
- [ ] No database files or private test data bundled.
- [ ] Only declared runtime config (`assets/config/app_config.json`) is included.

### 6.7 Exported Component Audit

- `MainActivity` is exported (launcher, VIEW, SEND, SEND_MULTIPLE, PROCESS_TEXT). All incoming
  content is treated as untrusted input.
- `PdfPrintService` is exported but guarded by `android.permission.BIND_PRINT_SERVICE`.
- Every other component MUST be `android:exported="false"`.

---

## 7. Signing And Secret Handling

> Keystore location, `key.properties` naming, and `.gitignore` rules come from
> [guidelines/guideline.md](guidelines/guideline.md) §2 (the source of truth).

- Signing config location: `android/key.properties` (local only, git-ignored), read by
  `android/app/build.gradle.kts`. If the file is missing, Gradle falls back to debug signing so
  local builds still work — such a build MUST NOT be distributed.
- Keystore: `android/upload-keystore.jks`, alias `upload`. Owner: app maintainer.
- Google Play: uses Play App Signing; the local key is the **upload** key.
- Secret rotation process: if the upload key leaks, request an upload-key reset in the Play
  Console. Direct-download APKs cannot change key without users reinstalling, so guard the key.
- Rules:
  - Signing material never lives in source control.
  - Keep the keystore in at least two separate secure offline locations.

### 7.1 `android/key.properties` Format

```properties
storeFile=upload-keystore.jks
storePassword=<keystore-password>
keyAlias=upload
keyPassword=<key-password>
```

### 7.2 Keystore Generation (One-Time)

Run inside the `android/` folder.

```powershell
keytool -genkeypair -v `
  -keystore upload-keystore.jks `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias upload
```

```bash
keytool -genkeypair -v \
  -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

---

## 8. Release Checklist

Complete these items before every release.

### Code And Quality

- [ ] `dart format --output=none --set-exit-if-changed .` passed.
- [ ] `flutter analyze` passed with zero issues.
- [ ] `flutter test` passed.
- [ ] No release-blocking bugs remain open.
- [ ] (No code generation is used in this project — `build_runner` is not a dependency.)

### Performance

- [ ] Release build checked for jank while scrolling and zooming a large PDF.
- [ ] App size analyzed and within budget (§6.3).
- [ ] Cold start under 2 seconds on a mid-range device.

### Security

- [ ] `--obfuscate` and `--split-debug-info` applied to all release builds.
- [ ] Debug symbols archived securely for this version.
- [ ] ProGuard / R8 rules verified (§6.2).
- [ ] `android:debuggable` absent / `false` in the merged release manifest.
- [ ] `android:allowBackup` is `false` (or strict exclusion) and matches [security.md](security.md) §10.
- [ ] Permissions are only `INTERNET` + `CAMERA` (Device sync); no cleartext / network config added (§6.5).
- [ ] Asset audit passed (§6.6).
- [ ] Exported component audit passed (§6.7).
- [ ] OWASP Mobile Top 10 signed off in [security.md](security.md) §12.
- [ ] Security review checklist in [security.md](security.md) §18 complete.
- [ ] Data retention and purge behavior verified ([security.md](security.md) §13).

### Localization

- [ ] `app_en.arb`, `app_ml.arb`, `app_sa.arb` in parity; `test/l10n/translation_parity_test.dart` passes.
- [ ] No English value left in `app_ml.arb` or `app_sa.arb`.
- [ ] [Sanskrit/Malayalam language pack](guidelines/language_packs/sanskrit_malayalam.md) §7 checklist passes.
- [ ] New or changed Malayalam and Sanskrit strings reviewed by a fluent reader.
- [ ] Short-label budget respected (`test/l10n/label_length_test.dart`).
- [ ] Every screen opened in English, Malayalam and Sanskrit on a clean device — no missing
      glyphs, overflow, or clipped text.
- [ ] Language picker works: System default + each language by endonym, persists, applies
      without restart.
- [ ] Gradle disables App Bundle language splitting (`bundle { language { enableSplit = false } }`)
      so Play users get every language. Done (`enableSplit = false`).
- [ ] Date pickers and dialogs work under `sa` (`test/l10n/sa_material_localizations_test.dart`).
- [ ] Every icon-only control has a localized tooltip.
- [ ] About signature badge "Made with ❤️ from India" shows, localized and centered, in every language.

### Store Readiness

- [ ] [platform_store_readiness.md](guidelines/platform_store_readiness.md) §1 passes.
- [ ] Google Play §2 gate completed — target API level re-checked, `versionCode` increased, App
      Bundle + Play App Signing, Data safety form (no data collected), listings and screenshots
      (`en-IN`, `ml-IN`), internal testing and pre-launch report clean, staged rollout planned.
- [ ] A public **privacy policy URL** exists and is entered in the Play Console and
      [PROJECT_PROFILE.md](PROJECT_PROFILE.md). **Not yet available — required before the first
      Play release.**

### Product And Documentation

- [ ] `pubspec.yaml` version updated; `app_config.json` `version` / `build` match.
- [ ] [../CHANGELOG.md](../CHANGELOG.md) updated.
- [ ] [features.md](features.md) reflects any user-visible change.
- [ ] Store metadata ready.

### Artifact Validation

- [ ] Release artifacts built successfully.
- [ ] Signature verified (§9 step 10) — release key, not the debug key.
- [ ] APK installs and launches on a clean device.
- [ ] App title has no "Dev" suffix (correct `prod` flavor).
- [ ] Version name and build number correct (Settings → About).
- [ ] Release build tested end to end: open, search, TTS, annotate, page ops, print, verify signature.

---

## 9. Android Release Steps

1. Pull the release commit on `master` and check it is clean (`git status`).
2. Check the version in `pubspec.yaml` and `assets/config/app_config.json`.
3. `flutter pub get`.
4. Run format, analyze, and test checks.
5. Build the App Bundle (Google Play) and split APKs (direct download) with all hardening flags.
6. Run size analysis and record it (§6.3).
7. Check `debuggable`, `allowBackup`, and the permission list in the merged manifest (§6.4).
8. Run the asset audit (§6.6).
9. Install the APK on a device and run the artifact checks (§8).
10. Verify the signing certificate (below).
11. Archive debug symbols from `build/symbols/android-prod-<version>/` to the secure archive.
12. Complete the Google Play gate before uploading to Play.
13. Upload the `.aab` to Google Play (staged rollout) and publish the signed APKs for direct
    download.
14. Tag the release: `git tag v<X.Y.Z>` and push the tag.

### Build Commands

**Bash:**

```bash
# 1. Pre-build checks
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test

# 2. Version from pubspec.yaml
VERSION=$(grep '^version:' pubspec.yaml | cut -d' ' -f2)

# 3. App Bundle for Google Play
flutter build appbundle \
  --flavor prod \
  --release \
  --obfuscate \
  --split-debug-info=build/symbols/android-prod-$VERSION/

# 4. Split APKs for direct download
flutter build apk \
  --flavor prod \
  --release \
  --obfuscate \
  --split-debug-info=build/symbols/android-prod-$VERSION/ \
  --split-per-abi
```

**PowerShell:**

```powershell
# 1. Pre-build checks
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test

# 2. Version from pubspec.yaml
$VERSION = (Get-Content pubspec.yaml | Select-String '^version:').ToString().Split(' ')[1].Trim()

# 3. App Bundle for Google Play
flutter build appbundle `
  --flavor prod `
  --release `
  --obfuscate `
  --split-debug-info="build/symbols/android-prod-$VERSION/"

# 4. Split APKs for direct download
flutter build apk `
  --flavor prod `
  --release `
  --obfuscate `
  --split-debug-info="build/symbols/android-prod-$VERSION/" `
  --split-per-abi
```

### Build Artifact Locations

- App Bundle: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`
- Split APKs: `build/app/outputs/flutter-apk/app-*-prod-release.apk`
- Debug symbols: `build/symbols/android-prod-<version>/`

### Verify The Signing Certificate

```bash
keytool -list -printcert -jarfile build/app/outputs/flutter-apk/app-arm64-v8a-prod-release.apk
```

Confirm the SHA-256 fingerprint is the release (upload) key, not the Android debug certificate.

---

## 12. Distribution Channels

Sections 10, 11, 11A and 11B of the template (iOS, Windows, macOS, Linux) are not used: Android
is the only declared platform.

| Channel | Artifact | Audience | Notes |
|---|---|---|---|
| Google Play | `.aab` | Public | Staged rollout; gate §2 of `platform_store_readiness.md` |
| Direct APK | split `.apk` (arm64-v8a, armeabi-v7a, x86_64) | Public | Signed with the release keystore; publish SHA-256 checksums |

---

## 13. Rollback And Hotfix Process

- Rollback trigger: a crash on open for common files, data loss, a wrong signature-validity
  result, or any security issue in [security.md](security.md) §16.
- Rollback method: halt the Google Play staged rollout; remove the bad APK from the
  direct-download page; ship a hotfix release (Android cannot downgrade a `versionCode`).
- Hotfix branch naming: none — hotfixes land on `master` and are tagged `vX.Y.Z` with PATCH + 1.
- Verification after rollback or hotfix:
  - The full release checklist (§8) MUST be completed even for hotfixes.
  - Debug symbols for the hotfix build MUST be archived.

---

## 14. Release Evidence

Record these after each release (in the release notes or the matching `change_log/` entry).
Use relative or descriptive locations only — no local machine paths.

- CI run: none yet (local checks; see §16).
- Test report: `flutter test` summary.
- Size analysis output: location of the saved `--analyze-size` report.
- Debug symbols archive: secure archive entry for `v<X.Y.Z>`.
- Built artifact: release entry for `v<X.Y.Z>`.
- Release notes: [../CHANGELOG.md](../CHANGELOG.md).
- Store submission or rollout record: Google Play Console release name.
- OWASP checklist sign-off: signed by the app maintainer, with date.

---

## 15. Post-Release Checks

- [ ] Post-install test on a clean device (no crash reporting — the app is offline).
- [ ] Google Play pre-launch report and Android vitals reviewed.
- [ ] User-reported issues triaged.
- [ ] Release tag created and pushed: `git tag v<version> && git push origin v<version>`.
- [ ] Debug symbols confirmed in the secure archive.
- [ ] Follow-up tasks recorded in a new plan.

---

## 16. Open Release Items

These block or weaken the first Google Play release. Each needs its own plan.

- [x] Set `android:allowBackup="false"` (or exclusion rules) — [security.md](security.md) §10.
- [ ] Publish a privacy policy and record its URL.
- [x] Disable App Bundle language splitting in `android/app/build.gradle.kts`.
- [x] Add CI that runs format, analyze, test, and a hardened release build
      (`.github/workflows/ci.yml`).
