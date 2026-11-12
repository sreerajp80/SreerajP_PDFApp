# Device sync (settings) and nearby PDF sending, by QR and local WiFi

**Status:** completed (Part 1: `change_log/20261112_111116_device_sync_part1_settings.md`; Part 2: `change_log/20261112_114427_device_sync_part2_send_pdfs.md`)

## 1. What is asked

1. **Settings sync** between two phones that both have Folio. Only settings are synced. Recent
   files, reading positions, annotations, bookmarks and trusted certificates are **not** synced.
2. **Send PDFs** (one or many, picked in Folio) from one phone to Folio on another phone, over
   **local WiFi only**.
3. Pairing works like an authenticator or gallery app: **one phone shows a QR code, the other
   phone scans it.**

## 2. The issue

- Folio has no sync and no nearby transfer today. The only way out is the Android share sheet.
- On Android, **any** network socket (even phone-to-phone on the same WiFi) needs the
  `android.permission.INTERNET` permission. Hard Rule 2 says the release app must never request
  it. The CI check `.github/workflows/ci.yml` fails the build if it appears in the main manifest.
- So this change **rewrites Hard Rule 2**. The user decided this on 2026-11-12. The new rule
  must still be strict and checkable, so "offline" turns into "**no internet; local WiFi only,
  and only while the transfer screen is open**".

## 3. The design

### 3.1 One simple rule for users

> **The phone that has the data shows a QR code. The other phone scans it.**

| Mode | Phone A (has the data) | Phone B (gets the data) | Needs WiFi? |
|---|---|---|---|
| Settings by QR | Shows a QR code that holds the settings | Scans it, reviews, taps "Apply" | **No** |
| Settings by WiFi | Starts a short session, shows a QR code | Scans, connects, reviews, applies | Yes |
| PDFs by WiFi | User picks PDFs, starts a session, shows a QR code | Scans, sees the file list, taps "Accept", picks a folder | Yes |

Settings by QR needs no network at all, so it still works with WiFi off. It exists because the
settings are small (about 25 values, under 1 KB). PDFs are too big for a QR code, so they go by
WiFi only.

### 3.2 What the WiFi QR code holds

`folio-sync:v1;<host>:<port>;<session id>;<one-time 256-bit key, base64url>`

- `host` must be a **private LAN IPv4 address** (10.x, 172.16–31.x, 192.168.x). Any other
  address (public IP, hostname, loopback) is rejected with a friendly message. So a scanned
  code can never make Folio contact the internet.
- The key is random, made fresh for each session, held in memory only, and **never logged**.
  Seeing the QR code is the proof of being "in the room".

### 3.3 How the WiFi session runs

1. Phone A finds its WiFi (or hotspot) address with `dart:io` `NetworkInterface.list()` and
   binds a `ServerSocket` to **that address only** (not `0.0.0.0`), on a random port.
2. Phone B connects with a plain `dart:io` `Socket`. No HTTP library and no web server package.
3. Every message is encrypted and checked with **AES-256-GCM** using the key from the QR code,
   with a counter nonce (a number used only once) per message. A wrong key or a changed byte
   fails the check and the connection is dropped.
4. Phone A accepts **one** phone only, then stops listening.
5. Phone B is shown what is coming (the settings changes, or file names and sizes) and must tap
   **Apply** / **Accept**. Nothing is applied or saved without that tap.
6. The session ends when the transfer is done, after **3 minutes** with no connection, when
   either screen is closed, or when the app goes to the background. The socket is closed and
   the key is dropped.

### 3.4 Settings sync rules

- Only an **allow-list** of `settings.*` keys is sent (theme, accents, font, text size,
  language, reader options, TTS rate/pitch/pause/auto-scroll, print defaults, signature
  auto-verify, remember options).
- **Not sent** (they belong to one phone): `settings.malayalam_tts` (the voice engine may not be
  installed on the other phone) and `settings.printer_enabled` (tied to the system print service).
- Phone B checks each value's type and range. Unknown keys and bad values are skipped, never a
  crash (Hard Rule 4). The payload carries a format version.
- Phone B shows "These settings will change" with a list, then applies through the existing
  Riverpod notifiers, so the app updates at once with no restart.

### 3.5 PDF sending rules

- **Pick on phone A:** long-press a Recent file to enter select mode, tick one or more, tap
  "Send to nearby device". The viewer's menu also gets "Send to nearby device" for the open PDF.
  Limit: 50 files per session.
- Files are read through the existing SAF path (`resolveToCache`). Nothing is read outside SAF.
- Each file is sent with its name, size and SHA-256. Phone B writes into its **private cache**,
  checks the SHA-256 and the `%PDF` header, and drops any file that fails, with a message.
- File names are cleaned (no `/`, `\`, `..` or control characters) before use.
- **Save on phone B (decided 2026-11-12: remember the folder):**
  - The first time, the user picks a folder with the system folder picker
    (`ACTION_OPEN_DOCUMENT_TREE`). Folio takes a persistable permission on that one folder
    (`takePersistableUriPermission`, read + write) and remembers its URI.
  - Later transfers save straight there. The receive screen shows **"Saving to: <folder name>"**
    with a **Change** button that opens the picker again. On change, the old folder's permission
    is released, so Folio never holds more than one folder.
  - If the saved folder is gone or its permission was removed (folder deleted, SD card out,
    permission revoked in system settings), Folio says so and opens the picker instead of failing
    (Hard Rule 6).
  - All files are saved as **new files** (copy-on-write). Name clashes get a suffix such as
    `report (2).pdf`. The cache copies are deleted afterwards. Saved files are added to Recents.
  - The remembered folder is a per-phone value: it is **not** in the Device sync allow-list.
    Settings › Storage › "Delete all data" forgets it and releases its permission.

### 3.6 Never a dead button

- No camera, or camera permission denied: show why and offer "Open app settings". Settings by
  QR and WiFi receiving both need scanning, so the screen explains this instead of failing quietly.
- No WiFi or hotspot address: the WiFi options show "Connect both phones to the same WiFi" and
  stay disabled with that reason. Settings by QR still works.
- Phones on different networks, or WiFi that blocks phone-to-phone traffic (common in hotels,
  offices and guest networks): after a 10-second connect timeout show "Could not reach the other
  phone. Use the same home WiFi, or turn on a hotspot on one phone."

## 4. New packages (license check before adding; recorded in `docs/dependencies.md`)

| Package | Use | License (to confirm at add time) | Note |
|---|---|---|---|
| `qr_flutter` | Draw the QR code | BSD-3 | Pure Dart, no network |
| `flutter_zxing` | Scan QR with the camera | MIT (zxing-cpp: Apache-2.0) | Chosen **instead of** `mobile_scanner`, whose Android build uses Google ML Kit (closed-source) |
| `camera` (pulled in by `flutter_zxing`) | Camera preview | BSD-3 | CameraX underneath, Apache-2.0 |
| `cryptography` | AES-256-GCM | Apache-2.0 | Pure Dart |

For each, check the license and every transitive dependency for networking, analytics or
closed-source code. If any one fails, stop and come back to the user before choosing another.

## 5. Files to change

### New feature: `lib/features/nearby_transfer/`

- `domain/pairing_payload.dart` — parse/build the QR text; private-IP check.
- `domain/settings_snapshot.dart` — the allow-list, types, ranges, format version.
- `domain/transfer_manifest.dart` — file list (name, size, SHA-256).
- `data/lan_address_service.dart` — finds the WiFi/hotspot IPv4 address.
- `data/transfer_cipher.dart` — AES-256-GCM, counter nonces, key creation.
- `data/transfer_protocol.dart` — message framing (length + type + encrypted body); safe
  failure on short, long or garbage input.
- `data/transfer_server.dart` — phone A side: one client, timeouts, progress stream.
- `data/transfer_client.dart` — phone B side: connect, receive to cache, verify.
- `data/settings_sync_service.dart` — read allow-listed settings, apply checked values.
- `presentation/providers.dart` — session state (idle / waiting / connected / sending /
  done / failed with reason).
- `presentation/device_sync_screen.dart` — hub: "Share my settings", "Receive".
- `presentation/show_code_screen.dart` — shows the QR, waiting state, progress.
- `presentation/scan_code_screen.dart` — camera scanner with permission handling.
- `presentation/review_settings_screen.dart` and `presentation/review_files_screen.dart` —
  Apply / Accept steps, folder pick, results.

### Changed

- `lib/app/routing/app_router.dart` — new routes.
- `lib/features/settings/presentation/settings_screen.dart` — "Device sync" entry.
- `lib/features/viewer/presentation/home_screen.dart` — select mode on Recents + "Send to nearby device".
- `lib/features/viewer/presentation/viewer_screen.dart` — menu item "Send to nearby device".
- `lib/core/lifecycle/app_lifecycle_service.dart` — end any session when the app goes to the background.
- `lib/core/platform/open_document_channel.dart` + `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt`
  — new `pickFolder()` (takes the persistable permission), `releaseFolder()`,
  `folderStatus()` (still reachable? display name) and `saveFilesToFolder()` (SAF tree,
  copy-on-write, unique names).
- `lib/core/constants/app_constants.dart` — new key for the remembered receive folder (not synced).
- `lib/core/storage/app_data_purge_service.dart` — "Delete all data" forgets the folder and
  releases its permission.
- `lib/core/storage/cache_service.dart` — clean the transfer cache folder.
- `lib/features/settings/presentation/permissions_screen.dart` — honest INTERNET and CAMERA entries.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` — all new strings, plus rewritten
  "100% offline / Zero Internet" texts (`descPermZeroInternetReason`, `helpPrivacyStorageStep1`,
  `descPermissionsImplicitSubtitle` and related). Real Malayalam and Sanskrit, flagged for
  native review.
- `android/app/src/main/AndroidManifest.xml` — add `INTERNET` and `CAMERA`
  (`<uses-feature android:name="android.hardware.camera" android:required="false"/>` so phones
  without a camera can still install). Update the comment.
- `pubspec.yaml` — the four packages above.
- `.github/workflows/ci.yml` — replace "no INTERNET" with checks that are still strict:
  (a) no HTTP client in `lib/` (`package:http`, `HttpClient`, `dio`, `WebSocket`);
  (b) `Socket`/`ServerSocket` used **only** inside `lib/features/nearby_transfer/data/`.

### Docs and rules

- `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md` — new Hard Rule 2 text (kept in sync), roughly:
  "**No internet.** The app never contacts an internet host and has zero telemetry. The
  `INTERNET` permission exists only for Nearby transfer: phone-to-phone on a private local
  network, opened only while the transfer screen is open, encrypted, and paired by QR code."
- `docs/security.md` — threat model (someone else on the same WiFi, a stolen QR photo, a
  malicious sender), M5 row, permissions table, §14 import/export, test strategy, checklist.
- `docs/features.md`, `docs/architecture.md`, `docs/pdf_idea.md`, `docs/dependencies.md`,
  `docs/project_structure.md`, `README.md`, `CHANGELOG.md`.
- `docs/guidelines/` is **not** touched. If the shared guideline says "no INTERNET" in a way
  that now conflicts, I will write a note for the user instead.

## 6. Tests (in `test/features/nearby_transfer/...`)

- Cipher: round trip; wrong key fails; changed byte fails; nonce never repeats.
- Protocol: truncated, oversized and random input all fail safely.
- Pairing payload: good code parses; public IP, hostname, loopback, wrong version, bad key all rejected.
- Settings snapshot: round trip; unknown keys skipped; wrong types and out-of-range values skipped;
  excluded keys never exported.
- File name cleaner: `../x.pdf`, `a/b.pdf`, empty, very long names.
- Server + client end-to-end over loopback (loopback allowed in tests only): settings, 3 PDFs,
  a corrupted file caught by SHA-256, timeout, second client refused.
- Widget tests: camera denied state, no-WiFi state, review screens.
- Existing `test/l10n/translation_parity_test.dart` and `label_length_test.dart` must pass.

## 7. Suggested order (two parts, each with its own change log)

- **Part 1:** rule and doc changes, packages, settings by QR (no network yet), scanner, settings
  by WiFi (brings in the socket, cipher, protocol). Settings sync is complete at the end.
- **Part 2:** PDFs by WiFi: select mode, file streaming, folder save, viewer menu item.

## Security impact

Large. Adds `INTERNET` and `CAMERA` permissions and a listening socket. Limits: binds to the
private WiFi address only, one client, one-time 256-bit key from the QR code, AES-256-GCM on
every message, 3-minute timeout, closes on background, private-IP check on scanned codes, no
HTTP stack, CI guard that keeps sockets inside one folder. The Play Store listing will show
"full network access" and the Data safety form must say data moves only device to device and
is not collected. The "100% offline" claim in the app and docs is removed and replaced with
"no internet; local WiFi only for Nearby transfer".

## Risks and open points

- Some WiFi networks block phone-to-phone traffic; hotspot is the workaround (message in §3.6).
- Pure-Dart AES-GCM may be slow for very large PDFs (rough guess 10–30 MB/s). If too slow,
  move encryption to Kotlin (`javax.crypto`) in a later change.
- Newer Android versions are adding a separate "local network" permission for apps that target
  them. Check the current target SDK rule at implementation time and add it if needed.
- Anyone who photographs the QR code within its 3 minutes could connect first. Phone B's
  Apply / Accept step and the one-client limit reduce this, and phone A shows which address
  connected.
