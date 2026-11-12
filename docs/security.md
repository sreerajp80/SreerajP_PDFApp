# Security — Folio

This document records the security posture, threat model, and technical controls of the
Folio app. It is this app's filled-in copy of the shared security blueprint. Read this
before changing any security-sensitive code, permissions, storage handling, logging, or
cryptographic validation.

> Read first: [../CLAUDE.md](../CLAUDE.md) and [../AGENTS.md](../AGENTS.md) for project rules,
> [PROJECT_PROFILE.md](PROJECT_PROFILE.md) for the declared profiles and platforms,
> [architecture.md](architecture.md) for system architecture, and
> [guidelines/security.md](guidelines/security.md) for the blueprint template.

---

## 1. Security Scope

- **App:** Folio (offline Android PDF reader, editor, printer, and signature verifier).
- **Data sensitivity level:** `moderate` — the app opens private user documents, handles PDF
  passwords, and keeps a certificate trust store.
- **Engineering standard profiles in force:**
  - `Core Baseline`
  - `Production App Extension`
  - `Sensitive Data Extension` (private files, PDF passwords, trust store integrity)
- **Platforms in scope:** Android only (minSdk 26). No other platform is declared.

---

## 2. Security Objectives

- Protect opened PDF documents and user data by enforcing Android Scoped Storage (SAF) boundaries
  without broad storage permissions.
- Prevent secret and credential leakage (PDF passwords, signing keys) in logs, debug consoles, or
  persistent storage.
- Ensure local, offline verification of PDF digital signatures against trusted root certificates,
  with no network traffic.
- Ensure copy-on-write isolation: never modify original documents in place.
- Harden release binaries against reverse engineering via code obfuscation and stripped debugging
  metadata.

---

## 3. Threat Model Summary

### In Scope Threats

- **Malicious PDF input:** crafted, corrupted, or malformed PDFs meant to crash the app or run
  code.
- **Log leakage of passwords:** accidental exposure of document passwords or certificate data in
  logs or the debugger.
- **Trust store tampering:** adding untrusted certificates to the local trust store without the
  user's clear consent.
- **Broad storage access:** other apps or this app reaching documents through loose storage
  permissions.
- **Binary reverse engineering:** reading the app's logic from the compiled release.
- **Leftover copies:** private document copies remaining in the cache after use.
- **Device sync on a shared WiFi** (plan `20261112_104132_device_sync_qr_wifi.md`):
  - *Another device on the same WiFi* tries to connect to the open session. Defence: it must
    prove the one-time 256-bit key from the QR code (AES-256-GCM `hello`); phones that fail are
    dropped, and five failures end the session.
  - *Someone photographs the QR code* and connects first. Defence: the session lives at most
    3 minutes and accepts one phone only; the receiving phone sees what will change and must tap
    Apply; the sending phone shows which address connected.
  - *A malicious or damaged code or sender.* Defence: a scanned code is accepted only with a
    private LAN IPv4 address (so it can never point the app at the internet); frame length is
    capped; every received setting is checked against an allow-list with type and range limits.
  - *Eavesdropping / tampering on the WiFi.* Defence: every message is encrypted and
    authenticated (AES-256-GCM, per-direction counter nonces, session id as AAD), so changed,
    replayed or reordered messages fail.
  - *A malicious sender offering harmful files.* Defence: the user sees names and sizes and must
    tap Accept; at most 50 files of at most 2 GiB; file names are cleaned (no folders, `..`, or
    control characters); size, SHA-256 and the `%PDF-` header are checked; files are written only
    into the folder the user chose, as new files, and are never opened automatically. Opening one
    later goes through the same hardened PDF path as any other PDF.
  - *A fast sender filling memory.* Defence: frames are capped at about 1 MiB and the receiver
    pauses reading when 8 frames are waiting, so TCP slows the sender down.

### Out Of Scope Threats

- **Fully compromised (rooted) OS:** the Android sandbox is assumed intact.
- **Side-channel / physical memory attacks:** extracting secrets from device memory with hardware
  probes.
- **Network-based revocation spying:** online CRL/OCSP checks are not done, to stay offline; a
  revoked certificate may therefore still show as valid (see §17).
- **Nation-state adversaries.**

---

## 4. Sensitive Data Inventory

| Data Type | Example | Where It Exists | Protection Required |
|---|---|---|---|
| Document passwords | Password for an encrypted PDF | Memory only | Held briefly, never persisted, never logged, never in SharedPreferences |
| Opened document copies | Copy of a picked PDF used for rendering | App cache (`cache/opened/`) | Private app sandbox; cleared by the user (Settings → Storage) or the OS (see §13, §17) |
| Operation outputs | Merged / split / compressed PDF before the user saves it | App cache (`page_ops/`, extraction and printer folders) | Private app sandbox; cleared before the next operation and by the user |
| Recent files | URI, display name, size, page count, last-opened time | sqflite `recent_files` | Private app database; user can clear from Settings |
| Reading positions | Page and zoom per document | sqflite `reading_positions` | Private app database; removed with its recent-file row |
| Annotations | Highlights, notes, ink, bookmarks | sqflite `annotations` | Private app database; user can delete per mark or per file |
| Trust store certificates | User-trusted signing certificates (DER) | sqflite `trust_store` | Added only after explicit user confirmation; user can remove |
| Document fingerprints | SHA-256 + size of opened files | sqflite | Identifier only; no document content |

---

## 5. Storage Model

### At Rest

- Primary local storage: `sqflite` (WAL mode) in the app's private data directory, plus
  `shared_preferences` for UI settings (no sensitive data).
- Secure key storage: none needed — the app stores no secrets. If a secret is ever stored, it
  MUST go into `flutter_secure_storage` (Android Keystore), never SharedPreferences.
- Backup behavior: not explicitly set yet — see §10 and §17.

### Scoped Storage Boundary (SAF)

- The app does **not** request broad storage permissions (`READ_EXTERNAL_STORAGE`,
  `WRITE_EXTERNAL_STORAGE`, `MANAGE_EXTERNAL_STORAGE` are absent).
- All file access goes through the **Storage Access Framework** and "Open with" / share intents.
- The app takes **persistable URI permissions** to remember recent documents. It copies document
  content to a private cache directory for rendering.
- Saving a result uses `ACTION_CREATE_DOCUMENT`, so the user picks the destination.

### In Memory

- Document passwords are kept in memory only for the open call, then dereferenced.
- Rendered page images live in Flutter's image cache, which is cleared on memory pressure
  (`lib/core/lifecycle/app_lifecycle_service.dart`).

### In Transit

- Internet use: **none**. The app never contacts an internet host; there is no HTTP or
  web-socket client (CI check).
- Local network use: **Device sync only** (`lib/features/nearby_transfer/data/`, the only folder
  allowed to open sockets — CI check). Phone-to-phone TCP on a private LAN address, only while
  the Device sync screen is open.
- Transport protections: AES-256-GCM on every message with a one-time key that is passed only
  inside the QR code (never sent over the network, never logged, held in memory only).
- What travels: the allow-listed settings, or the PDFs the user picked to send (names, sizes,
  SHA-256 and content). Never paths, history, reading positions, annotations or certificates.

---

## 6. Cryptography Design

The app stores no encrypted data of its own. Crypto is used only to read, write, and verify PDFs.

### PDF Decryption And Encryption

- Standard PDF decryption and encryption (RC4, AES-128, AES-256) run natively via
  **PdfBox-Android**.
- Passwords entered by the user are passed straight to Kotlin, used, and dereferenced. They are
  never written to disk.
- Encrypting a PDF writes a **new** file (copy-on-write).

### Signature Validation

- **Integrity checks:** the native Kotlin module uses Bouncy Castle (`bcprov`/`bcpkix`
  `jdk15to18`, provider used by instance, not by name) to verify PKCS#7 signatures against the
  ByteRange content.
- **ByteRange coverage audit:** the app checks whether the signature's ByteRange covers the whole
  file. Bytes after the ByteRange mean the file changed after signing, and this is reported.
- **Chain validation:** done offline with Android's `CertPathValidator`.
- **Trust anchors:**
  1. Bundled trusted certificate list (`assets/trust/`).
  2. User-added certificates in the local SQLite `trust_store` table.
  - The Android system CA store is **not** used: it holds TLS anchors, not document-signing
    anchors.

### Device Sync Transport

- Algorithm: AES-256-GCM (`cryptography` package, pure Dart).
- Key: 32 random bytes from `Random.secure()`, new for every session, shown only in the QR code.
- Nonce: 12 bytes = direction byte + 8-byte message counter per direction; never reused.
- AAD: the 8-byte random session id.
- A failed check closes the connection; nothing from it is used.

### Rules

- Keys, IVs, salts, and passwords must never be hard-coded.
- Randomness, where needed, must use a cryptographically secure generator.
- Document fingerprints use SHA-256.

---

## 7. Authentication And Access Control

- App-lock strategy: `none`. The app holds no account and no secret of its own; documents stay
  protected by the Android lock screen and app sandbox.
- Fallback behavior: not applicable.
- Session-expiry rule: not applicable.
- Background lock rule: not applicable.
- Protected-route strategy: not applicable.
- Password-protected PDFs: the password is asked each time the file is opened and never
  remembered.

---

## 8. Binary Protections

### 8.1 Obfuscation

All production release builds MUST be compiled with:

```bash
--obfuscate --split-debug-info=build/symbols/android-prod-<version>/
```

The folder pattern is defined in [release_process.md](release_process.md) §6. Obfuscation raises
the cost of casual inspection; it is **not** a strong security boundary on its own.

The debug symbol files MUST be stored securely and kept for the life of the released version,
never committed (`build/` is git-ignored), and used only for crash symbolication.

### 8.2 R8 / ProGuard

Flutter enables R8 for release builds to strip dead code. `android/app/proguard-rules.pro` keeps
the PdfBox-Android classes used through reflection and silences warnings for optional Bouncy
Castle classes. See
[guidelines/flutter_build_flavors_guide.md](guidelines/flutter_build_flavors_guide.md).

### 8.3 Debuggable Flag

The merged release manifest must not contain `android:debuggable="true"`. Check it before every
production release (see [release_process.md](release_process.md) §6).

---

## 9. Logging And Telemetry Policy

### Never Log

- PDF passwords, keys, or certificate private material
- Document text, decrypted content, or extracted data
- Full database rows
- File names or URIs at `info` level or above

### Allowed Diagnostic Context

- Operation name (e.g. "merge", "verify signature")
- Screen or flow name
- Error category and exception type
- Non-sensitive counts (page count, file size)

### Logging Controls

- Logger implementation: `AppLogger` (`lib/core/logging/app_logger.dart`) on the `logger`
  package — engineering standard §14.
- Verbose logging gate: `AppFlavorConfig.instance.isDev` — `trace`/`debug` only in the `dev`
  flavor.
- Log level in production: `info` and above only.
- Output: console only. No log files are written and nothing leaves the device.
- Telemetry: none. No analytics, crash reporting, or network SDKs (blocked in
  [dependencies.md](dependencies.md)).

---

## 10. Platform Security Controls

### Android

- `android:allowBackup="false"` and `android:fullBackupContent="false"` in
  `android/app/src/main/AndroidManifest.xml`: no cloud backup of app data (Android 11 and lower,
  and cloud backup on all versions).
- `android:dataExtractionRules="@xml/data_extraction_rules"`
  (`android/app/src/main/res/xml/data_extraction_rules.xml`): on Android 12+ every domain
  (`root`, `file`, `database`, `sharedpref`, `external`) is excluded from both cloud backup and
  device-to-device transfer. Checked in the merged manifest of the dev build.
- Screenshot protection (`FLAG_SECURE`): not used. The app shows the user's own documents and the
  user may want screenshots; this is a deliberate choice.
- `android:debuggable`: MUST be `false` in release builds (§8.3).
- Root / integrity detection: none (offline app, no server to attest to).
- Exported components: `MainActivity` (launcher, VIEW, SEND, PROCESS_TEXT intents) and
  `PdfPrintService` (protected by `android.permission.BIND_PRINT_SERVICE`). Every incoming
  intent's content is treated as untrusted input.

---

## 11. Permissions

| Permission | Why It Is Needed | Requested When | Denial Handling |
|---|---|---|---|
| `android.permission.INTERNET` | Device sync only: phone-to-phone on the local WiFi (Android needs it for any socket). Never used to reach an internet host | Install time (normal permission) | Not applicable |
| Persisted folder access (SAF tree URI, read + write) | Device sync: the one folder the user chose for received PDFs | When the user picks it | Choosing another folder releases the old one; "Delete all data" releases it; a lost folder asks again |
| `android.permission.CAMERA` | Device sync only: scanning the pairing / settings QR code | First time the Scan code screen opens | The screen explains why and offers the system settings; sharing settings still works |
| `RECORD_AUDIO`, `WRITE_EXTERNAL_STORAGE` | Added by the camera plugin; **removed** with `tools:node="remove"` | Never | Not applicable |
| `READ_EXTERNAL_STORAGE` | Not asked for by any library: the manifest merger **implies** it whenever a library asks for `WRITE_EXTERNAL_STORAGE`, even after that is removed. **Removed** with `tools:node="remove"` | Never | Not applicable |
| `ACCESS_NETWORK_STATE` | Added by `media3` (read-aloud media controls); reads only whether a network is connected | Install time (normal permission) | Not applicable |
| `android.permission.BIND_PRINT_SERVICE` | Guards the print service so only the system can bind to it (not requested by the app) | — | — |

Permission review rules:

- Request only permissions the app currently uses. Remove unused ones promptly.
- Before every release, check that the **merged release** manifest asks for exactly `INTERNET`
  and `CAMERA` (plus `BIND_PRINT_SERVICE` on the service) and nothing else.
- Any future dangerous permission MUST be requested at the point of use with a rationale, and the
  app MUST keep working in a safe, degraded state if it is denied.

---

## 12. OWASP Mobile Top 10 Compliance

Review and sign off each item before every production release (MUST under the Sensitive Data
Extension).

| ID | Risk | Control | Status |
|---|---|---|---|
| M1 | Improper Credential Usage | No hard-coded secrets; app holds no credentials | `verified` |
| M2 | Inadequate Supply Chain Security | `pubspec.lock` committed; open-source licenses checked; block list in `dependencies.md` | `verified` |
| M3 | Insecure Authentication | No accounts or app lock; PDF passwords never stored | `n/a` |
| M4 | Insufficient Input/Output Validation | Every parser has a failure path; parameterized SQL only; intents treated as untrusted | `verified` |
| M5 | Insecure Communication | No internet traffic; Device sync is LAN-only, AES-256-GCM with a one-time QR key, private-address check | `verified` (unit + loopback tests) |
| M6 | Inadequate Privacy Controls | Data inventory reviewed; no document content in logs; backup exclusion **not yet set** | `risk-accepted` (see below) |
| M7 | Insufficient Binary Protections | `--obfuscate` applied; R8 on; `debuggable` false | `verified` |
| M8 | Security Misconfiguration | Permissions minimal; backup config **not yet explicit** | `risk-accepted` (see below) |
| M9 | Insecure Data Storage | No sensitive data in SharedPreferences; DB in private storage | `verified` |
| M10 | Insufficient Cryptography | Crypto via PdfBox / Bouncy Castle; no custom crypto; no hard-coded keys | `verified` |

**M6 / M8 backup:** fixed — cloud backup and device transfer are off (§10). Re-check the merged
release manifest before each release ([release_process.md](release_process.md) §6.4).

---

## 13. Data Retention And Purge Policy

### Retention Schedule

| Data Type | Retention / Rotation Policy | Deletion Trigger |
|---|---|---|
| Recent files + reading positions | Until cleared | "Clear recent files" or "Delete all data" in Settings → Storage; app uninstall |
| Annotations | Until deleted | Delete per mark, "clear all" per file, "Delete all data", app uninstall |
| Trust store certificates (user-added) | Until removed | Remove in the manage-certificates screen; "Delete all data"; app uninstall |
| Opened document copies (`cache/opened/`) | At most 24 h after the session ends | Removed at the next start when older than 24 h; "Clear temporary cache" / "Delete all data"; OS cache eviction; app uninstall |
| Page-operation / extraction / annotation-export outputs | Until the next operation, at most 24 h | Cleared before each new operation; removed at start when older than 24 h; "Clear temporary cache"; "Delete all data"; OS |
| Printer outputs | Until cleared | "Clear printer cache" in Settings → Printer; "Delete all data"; OS |
| Logs | Not stored | Console only |
| UI settings (SharedPreferences) | Until changed | "Delete all data"; app uninstall |
| Lasting file permissions (SAF) | Until released | "Delete all data" releases all of them; app uninstall |

### Purge Implementation

- Settings → Storage offers "Clear temporary cache" and "Clear recent files". Settings → Printer
  offers "Clear printer cache".
- **"Delete all data"** (Settings → Storage, engineering standard §15.4) is implemented by
  `AppDataPurgeService` (`lib/core/storage/app_data_purge_service.dart`). After a destructive
  confirm dialog it deletes all rows in `recent_files`, `reading_positions`, `annotations` and
  `trust_store` (the schema and `meta` stay), releases every lasting file permission, clears
  SharedPreferences, and empties the temp cache (including the printer spool). The app then
  restarts in place from the home screen (`AppRestartScope`), so nothing deleted stays in memory.
  The user's own PDF files are never touched. There are no log files or secure-storage entries
  to remove.
- At startup, stale working files (older than 24 h) are removed from `opened/`, `page_ops/`,
  `extracted/` and `annotations/` (`CacheService.clearStaleWorkingFiles`).
- Temporary files are created under `getTemporaryDirectory()` / the Android `cacheDir`.

### Data Purge On Uninstall

- Android deletes all app data on uninstall. Backup and device transfer are off (§10), so no
  copy of the database can come back on reinstall or on a new phone.

---

## 14. Backup, Import, Export, And Recovery

- Backup supported: no in-app backup.
- Device sync: settings can be copied to another phone (allow-list only, user confirms on the
  receiving phone), and PDFs the user picks can be sent to another phone. Nothing else (history,
  positions, annotations, certificates) is exported by it.
- Backup format: not applicable.
- Import supported: PDFs, images, text and web content arrive through SAF and share intents; a
  certificate can be imported into the trust store after confirmation.
- Recovery flow: not applicable (no account, no secrets).
- Plaintext export policy: results are saved only where the user picks
  (`ACTION_CREATE_DOCUMENT`). Decrypting a PDF writes a new, unprotected copy only after the user
  asks for it.

### Validation Requirements

- Every import parser rejects malformed data with a friendly message, without partial state.
- Certificates added to the trust store are parsed and shown to the user before they are trusted.

---

## 15. Security Testing Strategy

| Area | Test Type | Notes |
|---|---|---|
| Database migrations | Unit | `test/core/storage/migration_v*_test.dart` |
| Trust store | Unit | `test/features/signature/data/` |
| Signature verification | Unit + manual | Native verifier checked with signed sample PDFs in `samples/` |
| Encrypt / decrypt | Unit + manual | Copy-on-write output; wrong password handled |
| Bad input | Unit / widget | Corrupt, empty, truncated, password-protected files show a message |
| Obfuscation | Release build verification | `--obfuscate` present in release commands |
| Debuggable | Release build verification | Merged release manifest checked |
| Device sync | Unit + loopback | `test/features/nearby_transfer/` — cipher, framing, pairing code, allow-list, host/guest sessions |
| Permission audit | Release build verification | Merged release manifest has only `INTERNET` + `CAMERA`; no `RECORD_AUDIO` / storage |

### Required Test Vectors Or Regression Areas

- Migration path v1 → v2 → v3 → v4 round-trip.
- Corrupt or truncated PDF opens without a crash.
- Signed PDF with bytes appended after the ByteRange is reported as modified.

---

## 16. Incident Response Notes

- Triage owner: app maintainer.
- Severity model: **high** — data leak or wrong "valid signature" result; **medium** — crash on
  a crafted file; **low** — cosmetic.
- Immediate containment actions:
  - Halt the Google Play rollout and remove the affected APK from the direct-download page.
  - Publish a fixed build (hotfix process in [release_process.md](release_process.md) §13).
- User communication trigger: any issue that could show a tampered PDF as validly signed, or
  expose document content.
- Patch release process reference: [release_process.md](release_process.md).

---

## 17. Open Risks And Future Hardening

- Done: `android:allowBackup="false"` plus data-extraction rules that exclude everything (§10).
- Risk: copies of opened documents in `cache/opened/` are not deleted when the reader closes.
  Startup now removes copies older than 24 h (done). Remaining option: delete the copy when the
  reader closes.
- Done: "Delete all data" in Settings → Storage (§13). Remaining option: an on-device
  integration test of the full purge.
- Risk: no online revocation checks, so a revoked signing certificate may still show as valid.
  Hardening option: support offline CRLs embedded in the PDF (DSS / LTV data).
- Done: CI (`.github/workflows/ci.yml`) runs format, analyze, tests, the Sanskrit gate, a
  "no HTTP client / sockets only in Device sync" checks, and a hardened (`--obfuscate --split-debug-info`) prod build.

---

## 18. Security Review Checklist

Complete before every production release.

- [ ] Threat model reviewed and current.
- [ ] Sensitive data inventory updated.
- [ ] Logging policy reviewed — no new log statements expose document content or passwords.
- [ ] Storage and backup behavior reviewed (`allowBackup` decision, §10).
- [ ] Permission usage reviewed — merged release manifest has only `INTERNET` + `CAMERA`
      (no `RECORD_AUDIO`, no storage), and Device sync is still the only socket user.
- [ ] `--obfuscate` confirmed in all release build commands.
- [ ] Debug symbols archived for this release version.
- [ ] `android:debuggable` is not `true` in the merged release manifest.
- [ ] ProGuard rules verified (PdfBox-Android keep rules; release build tested).
- [ ] OWASP Mobile Top 10 checklist (§12) completed and signed off.
- [ ] Data retention policy reviewed — purge paths tested.
- [ ] Import and export paths tested with bad input.
- [ ] Tests cover the highest-risk failure modes (§15).
