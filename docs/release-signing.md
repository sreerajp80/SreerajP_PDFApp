# Release signing — SreerajP_PDFApp

How to build a **signed production release** of the Android app. This is part of the
hardening phase (keystore wiring and release prep).

> **Secrets warning.** The keystore file (`*.jks`) and `android/key.properties`
> hold signing secrets. They are **gitignored** and must **never** be committed,
> shared, or pasted into chat. If you lose the keystore you can no longer update
> the app on the Play Store under the same signing identity — **back it up
> safely** (offline, encrypted).

---

## 1. What the build expects

When the Flutter project is scaffolded, the Android build is wired like this:

- `android/app/build.gradle.kts` reads `android/key.properties` **if it exists**
  and uses it to sign the `release` build. If the file is **absent**, it falls
  back to **debug** signing so the project still builds on any machine.
- `android/.gitignore` ignores `key.properties`, `*.jks`, and `*.keystore`.
- `android/key.properties.example` is a committed template (no real secrets).

So to ship a signed build you only need to (a) generate a keystore and
(b) create `key.properties`. No code changes are needed.

---

## 2. Generate the keystore (one time)

Run this from the `android/` folder. It creates `upload-keystore.jks` with one
key valid for ~27 years. Pick strong passwords when prompted and **write them
down somewhere safe**.

**Windows (PowerShell):**

```powershell
keytool -genkeypair -v `
  -keystore upload-keystore.jks `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias upload
```

**macOS / Linux (bash):**

```bash
keytool -genkeypair -v \
  -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

`keytool` ships with the JDK. If it is not on your PATH, use the one bundled with
Android Studio, e.g.
`"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"`.

`keytool` will ask for:
- a **keystore password** (this becomes `storePassword`),
- your name / organization / location (used in the certificate; any accurate
  values are fine),
- a **key password** for the `upload` alias (this becomes `keyPassword`; you can
  reuse the keystore password).

Keep `upload-keystore.jks` inside `android/` (it is gitignored) or anywhere else
you point `storeFile` at.

---

## 3. Create `android/key.properties`

Copy the template and fill in your real values:

```powershell
Copy-Item android/key.properties.example android/key.properties
```

Then edit `android/key.properties`:

```
storeFile=upload-keystore.jks
storePassword=<your keystore password>
keyAlias=upload
keyPassword=<your key password>
```

`storeFile` is resolved relative to the `android/` folder (or use an absolute
path).

---

## 4. Build the signed release

From the project root. Release builds are **obfuscated** per the Definition of
Done:

```powershell
flutter build appbundle --obfuscate --split-debug-info=build/symbols   # .aab for the Play Store (preferred)
# or
flutter build apk --release --obfuscate --split-debug-info=build/symbols
```

Keep the `build/symbols` folder — you need it to de-obfuscate crash stack traces.

Outputs:
- App bundle: `build/app/outputs/bundle/release/app-release.aab`
- APK: `build/app/outputs/flutter-apk/app-release.apk`

---

## 5. Verify it is really signed with your key

```powershell
keytool -list -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

The SHA-256 fingerprint shown must match your keystore's certificate — not the
Android debug key. Confirm the build did not fall back to debug by checking the
Gradle output signed the release with `signingConfig release`.

Also confirm the release does not request `INTERNET` in the merged manifest
(the app is offline-first) unless a specific optional online feature needs it.

---

## 6. Backup checklist

- [ ] `upload-keystore.jks` backed up offline (encrypted).
- [ ] `storePassword` / `keyPassword` stored in a password manager.
- [ ] Confirmed neither `key.properties` nor the `.jks` is tracked by git
      (`git status --ignored` should list them as ignored).
- [ ] `build/symbols` (obfuscation mapping) archived with the release.
