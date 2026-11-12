# Device sync, Part 1: settings by QR code or local WiFi

Implements Part 1 of plan `plans/20261112_104132_device_sync_qr_wifi.md`. Part 2 (sending PDFs
over WiFi) is not done yet.

## What changed

### New feature: `lib/features/nearby_transfer/`

- **Settings › Device sync** screen. One rule: the phone that has the settings shows a code, the
  other phone scans it.
- **Share my settings** has two modes:
  - **QR only**: the settings are inside the QR code. No network.
  - **WiFi**: the QR code holds the phone's private WiFi/hotspot address, a random port, a random
    session id and a one-time 256-bit key. The other phone connects directly.
- **Receive settings** opens the camera scanner. After a scan, the screen lists the settings
  that will change and applies nothing until the user taps **Apply**. The settings providers are
  refreshed, so theme, language and the rest change at once with no restart.
- Files:
  - `domain/synced_setting.dart`: the allow-list (21 settings), short wire ids, and type/range checks.
    The Malayalam voice choice and the PDF printer switch are left out because they depend on each phone.
  - `domain/settings_snapshot.dart`: snapshot, wire format v1, QR text, `changesFrom`.
  - `domain/pairing_code.dart`: WiFi pairing code, `ScannedCode.parse` (never throws), private-LAN-IPv4 check.
  - `domain/transfer_offer.dart`: what the sending phone offers (settings now; files in Part 2).
  - `data/transfer_cipher.dart`: AES-256-GCM, per-direction counter nonces, session id as AAD.
  - `data/transfer_protocol.dart`: length-prefixed frames (size capped) and typed JSON messages.
  - `data/transfer_connection.dart`: one encrypted connection; failures reach every waiter, so nothing waits forever.
  - `data/transfer_host.dart`: binds to the WiFi address only, one phone, hello check, 3-minute limit, 5 bad attempts end the session.
  - `data/transfer_guest.dart`: connects, says hello, reads the offer, sends the answer.
  - `data/lan_address_service.dart`: finds the WiFi/hotspot IPv4 address with `dart:io` (no extra permission).
  - `data/settings_sync_service.dart`: reads and applies allow-listed settings with checks.
  - `presentation/`: providers (controllers), hub, share, scan and review screens, and text helpers.

### Other code

- `lib/core/errors/app_exception.dart`: new `TransferException` and `TransferFailure` reasons.
- `lib/app/routing/app_router.dart`: 4 new routes under `/settings/device-sync`.
- `lib/features/settings/presentation/settings_screen.dart`: "Device sync" card.
- `lib/features/settings/presentation/permissions_screen.dart`: new Camera and "Local WiFi only"
  items; the privacy item now reads "No internet servers".
- `lib/l10n/app_{en,ml,sa}.arb`: 47 new keys in all three languages. 9 existing privacy texts that
  said "100% offline / zero internet" were rewritten so they stay true.
- `android/app/src/main/AndroidManifest.xml`: adds `INTERNET` and `CAMERA`; camera feature is
  optional (`required="false"`); removes `RECORD_AUDIO`, `WRITE_EXTERNAL_STORAGE` (added by the
  camera plugin) and the Google Play services module hint (added by `image_picker`).
- `pubspec.yaml`: `qr_flutter` (BSD-3), `flutter_zxing` (MIT), `cryptography` (Apache-2.0).
  Licenses and Android manifests of these and their new dependencies were checked; none adds
  networking or closed-source code. `mobile_scanner` was not used because it relies on Google ML Kit.
- `.github/workflows/ci.yml`: the "no INTERNET permission" step is replaced by two checks:
  no HTTP / web-socket client in `lib/`, and socket code only in `lib/features/nearby_transfer/data/`.

### Rules and docs

- `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md`: Hard Rule 2 is now **"No internet"**, with
  `INTERNET` allowed only for Device sync on the local network. The connectivity row and the
  security rule were updated in all three files.
- `docs/security.md` (threat model, in transit, crypto, permissions, M5, tests, checklist),
  `docs/architecture.md`, `docs/features.md` (§2.10), `docs/dependencies.md`,
  `docs/project_structure.md`, `docs/release_process.md`, `README.md`, `CHANGELOG.md`.
- `docs/guidelines/` was not touched.

### Tests

- New: `test/features/nearby_transfer/` (pairing code, snapshot, cipher, framing, settings
  service, LAN address choice, host/guest sessions over loopback, and screen tests).
- Updated: three existing tests that checked the old "zero internet" texts, and a taller test
  viewport for the longer Permissions screen.
- Result: `flutter analyze` clean; `flutter test` 544 passed. The Sanskrit Hindi-marker check passes.

## Different from the plan

- The WiFi session stops on background through an `AppLifecycleListener` in the share screen, not
  through `lib/core/lifecycle/app_lifecycle_service.dart`. It keeps the rule next to the session.
- `cache_service.dart`, `open_document_channel.dart`, `MainActivity.kt`, the home and viewer
  screens are not changed yet: they belong to Part 2 (files).
- Two bugs were found by the loopback tests and fixed before finishing: on a server socket,
  cancelling the listener already closes it, so a later `close()` never finished; and awaiting
  `close()` on an events stream with no listener never finished.

## Not verified yet

- No Gradle build was run, so the manifest merge (the `tools:replace` / `tools:node="remove"`
  lines) and the merged permission list are not yet checked on a real APK.
- Not tried on two real phones: camera permission flow, scanning from a screen, and WiFi
  networks that block phone-to-phone traffic.

## Needs native-reader review

New Malayalam and Sanskrit terms (flagged per the language pack):

- Malayalam: ഉപകരണ സമന്വയം (Device sync), സ്കാൻ ചെയ്യുക, വൈഫൈ, ഹോട്ട്‌സ്പോട്ട്,
  ഒറ്റത്തവണ താക്കോൽ (one-time key), and the rewritten privacy texts.
- Sanskrit: यन्त्रसमन्वयः (Device sync), सङ्केतः (code), सङ्केतपठनम् (scan code),
  छायाचित्रयन्त्रम् (camera), दूरभाषः (phone), स्थानीयजालम् (local network), एकवारिककुञ्चिका
  (one-time key), अन्तर्जालसेवकः (internet server). "Wi-Fi", "QR" and "hotspot" are kept in Latin
  letters in Sanskrit, like "PDF".
