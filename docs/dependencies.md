# Dependencies — Folio

This document catalogs all dependencies used in the project, their open-source licenses, their purposes, and the explicit blocked dependencies list. Read this before adding or updating any library in the project.

> Read first: [../CLAUDE.md](../CLAUDE.md) and [../AGENTS.md](../AGENTS.md) for project rules, [architecture.md](architecture.md) for architectural context, and [guidelines/flutter_project_engineering_standard.md](guidelines/flutter_project_engineering_standard.md) for dependency rules.

---

## 1. Open-Source Policy

Every library used in this project **MUST be open source** (MIT, BSD, Apache 2.0, or equivalent permissive licenses).
Commercial or source-available SDKs are **strictly banned** (e.g., Syncfusion, PSPDFKit, and Apryse). Check a package's license before adding it to `pubspec.yaml` or `build.gradle.kts`.

---

## 2. Runtime Dependencies

| Package | Version | License | Concern / Purpose |
|---|---|---|---|
| `flutter` | SDK | BSD-3-Clause | UI framework and runtime |
| `flutter_localizations` | SDK | BSD-3-Clause | `GlobalWidgetsLocalizations` and the generated `AppLocalizations` (en, ml, sa) |
| `cupertino_icons` | ^2.0.0 | MIT | iOS / Material icon assets |
| `material_ui` | ^1.5.0 | BSD-3-Clause | Material widgets and `GlobalMaterialLocalizations` (moved out of the SDK in Flutter 3.47, engineering standard §6.1). Flutter team; no network dependencies |
| `cupertino_ui` | ^1.1.1 | BSD-3-Clause | Cupertino localizations used by the Sanskrit fallback delegate (§8.3.1). Flutter team; no network dependencies |
| `flutter_riverpod` | ^3.4.3 | MIT | Reactive state management and dependency injection |
| `go_router` | ^18.0.2 | BSD-3-Clause | Declarative URL-driven navigation and deep linking |
| `sqflite` | ^2.4.1 | BSD-2-Clause | Local SQLite database engine for annotations, recents, and trust store |
| `path` | ^1.9.0 | BSD-3-Clause | Cross-platform filesystem path manipulation |
| `path_provider` | ^2.1.5 | BSD-3-Clause | App-private storage directory path resolution |
| `shared_preferences` | ^2.3.4 | BSD-3-Clause | Key-value store for app settings (themes, voice toggles) |
| `qr_flutter` | ^4.1.0 | BSD-3-Clause | Draws the Device sync QR code. Pure Dart (uses `qr`, BSD-3); no network |
| `flutter_zxing` | ^3.1.1 | MIT | Scans the Device sync QR code with the camera (zxing-cpp, Apache-2.0). Chosen instead of `mobile_scanner`, whose Android build uses closed-source Google ML Kit. Pulls in `camera` (BSD-3, CameraX Apache-2.0) and `image_picker` (BSD-3, unused: the gallery button is hidden). Its `RECORD_AUDIO`, `WRITE_EXTERNAL_STORAGE` and Google Play services module hint are removed in the app manifest. No network |
| `cryptography` | ^2.9.0 | Apache-2.0 | AES-256-GCM for Device sync messages. Pure Dart; no network |
| `logger` | ^2.5.0 | MIT | Structured logging behind `AppLogger` abstraction |
| `package_info_plus` | ^10.2.2 | BSD-3-Clause | Application build version inspection for About screen |
| `intl` | ^0.20.2 | BSD-3-Clause | Internationalization, number, date, and currency formatting |
| `pdfrx` | ^2.6.5 | MIT | High-performance PDF rendering engine (pdfium wrapper). Brings in `pdfrx_engine`, `pdfium_flutter`, `pdfium_dart` (all MIT) and `material_ui` / `cupertino_ui` (BSD-3-Clause). Needs Flutter 3.47+ / Dart 3.13+. |
| `crypto` | ^3.0.6 | BSD-3-Clause | SHA-256 computation for document fingerprinting |
| `characters` | ^1.4.0 | BSD-3-Clause | Unicode grapheme cluster processing for Malayalam search |
| `unorm_dart` | ^0.3.2 | MIT | Unicode NFC normalization for Indic script search and collation |
| `flutter_tts` | ^4.2.5 | MIT | Text-to-speech platform bridge for English and Malayalam reading |

---

## 3. Native Android Dependencies

| Library | License | Purpose |
|---|---|---|
| `PdfBox-Android` | Apache 2.0 | PDF document manipulation, merging, splitting, metadata, and form fields |
| `Bouncy Castle` (`org.bouncycastle:bcprov-jdk18on`, `bcpkix-jdk18on`) | Bouncy Castle (MIT-like) | Native PKCS#7 / CMS digital signature parsing and cryptographic verification |

---

## 4. Development & Test Dependencies

| Package | Version | License | Purpose |
|---|---|---|---|
| `flutter_test` | SDK | BSD-3-Clause | Flutter widget and unit testing framework |
| `flutter_lints` | ^6.0.0 | BSD-3-Clause | Recommended lint rules for Flutter and Dart |
| `sqflite_common_ffi` | ^2.3.4 | BSD-2-Clause | FFI SQLite engine for running database unit tests on host machines |

---

## 4A. Bundled Fonts

Fonts are bundled under `assets/fonts/` (never fetched at runtime — the app is offline) and
listed under `fonts:` in `pubspec.yaml`. Each one's license file sits next to it
(engineering standard §17.4).

| Family | Files | Script | License | Source |
|---|---|---|---|---|
| Manjari | `Manjari-Regular.ttf`, `Manjari-Bold.ttf` | Malayalam | SIL OFL 1.1 (`OFL-Manjari.txt`) | Swathanthra Malayalam Computing |
| Anek Malayalam | `AnekMalayalam-Regular.ttf`, `AnekMalayalam-Bold.ttf` | Malayalam | SIL OFL 1.1 (`OFL-AnekMalayalam.txt`) | Ek Type |
| Noto Sans Malayalam | `NotoSansMalayalam-Regular.ttf`, `NotoSansMalayalam-Bold.ttf` | Malayalam | SIL OFL 1.1 (`OFL-NotoSansMalayalam.txt`) | Noto project |
| Noto Sans Devanagari | `NotoSansDevanagari-Regular.ttf`, `NotoSansDevanagari-Bold.ttf` | Devanagari (Sanskrit) | SIL OFL 1.1 (`OFL-NotoSansDevanagari.txt`) | Noto project (`notofonts/devanagari`, hinted TTF) |

`Noto Sans Malayalam` and `Noto Sans Devanagari` are the theme's `fontFamilyFallback`
(`AppTokens.scriptFontFallback`), so both scripts render whatever font the user picks
(engineering standard §8.3.3, language pack §2).

---

## 5. Explicit Blocked Dependencies

To maintain offline-first security, privacy, and open-source rules, the following classes of libraries MUST NEVER be added:

1. **Commercial / Proprietary PDF SDKs**:
   - `syncfusion_flutter_pdf`, `syncfusion_flutter_pdfviewer`
   - `pspdfkit_flutter`
   - `pdftron_flutter` / Apryse
2. **Cloud / BaaS / Backend SDKs**:
   - `firebase_*`, `supabase_flutter`, `amplify_flutter`
3. **Analytics & Tracking**:
   - `firebase_analytics`, `mixpanel_flutter`, `amplitude_flutter`, `appsflyer_sdk`
4. **Crash Reporting & Remote Logging**:
   - `sentry_flutter`, `firebase_crashlytics`, `datadog_flutter`
5. **Ad SDKs**:
   - `google_mobile_ads`, `unity_ads_plugin`
6. **Network HTTP Clients**:
   - `dio`, `http`, `web_socket_channel` (the app never contacts an internet host; Device sync
     uses plain `dart:io` sockets on the local WiFi only, inside `lib/features/nearby_transfer/data/`)
