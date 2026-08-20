# Dependencies — SreerajP_PDFApp

This document catalogs all dependencies used in the project, their open-source licenses, their purposes, and the explicit blocked dependencies list.

Read this before adding or updating any library in the project. Full architectural context is in [architecture.md](architecture.md).

---

## 1. Open-Source Policy

Every library used in this project **MUST be open source** (MIT, BSD, Apache 2.0, or equivalent permissive licenses).
Commercial or source-available SDKs are **strictly banned** (e.g., Syncfusion, PSPDFKit, and Apryse). Check a package's license before adding it to `pubspec.yaml` or `build.gradle.kts`.

---

## 2. Runtime Dependencies

| Package | Version | License | Concern / Purpose |
|---|---|---|---|
| `flutter` | SDK | BSD-3-Clause | UI framework and runtime |
| `flutter_localizations` | SDK | BSD-3-Clause | Multi-language localization support (en, ml) |
| `cupertino_icons` | ^1.0.8 | MIT | iOS / Material icon assets |
| `flutter_riverpod` | ^2.6.1 | MIT | Reactive state management and dependency injection |
| `go_router` | ^14.6.2 | BSD-3-Clause | Declarative URL-driven navigation and deep linking |
| `sqflite` | ^2.4.1 | BSD-2-Clause | Local SQLite database engine for annotations, recents, and trust store |
| `path` | ^1.9.0 | BSD-3-Clause | Cross-platform filesystem path manipulation |
| `path_provider` | ^2.1.5 | BSD-3-Clause | App-private storage directory path resolution |
| `shared_preferences` | ^2.3.4 | BSD-3-Clause | Key-value store for app settings (themes, voice toggles) |
| `logger` | ^2.5.0 | MIT | Structured logging behind `AppLogger` abstraction |
| `package_info_plus` | ^8.1.2 | BSD-3-Clause | Application build version inspection for About screen |
| `intl` | ^0.20.2 | BSD-3-Clause | Internationalization, number, date, and currency formatting |
| `pdfrx` | ^1.0.98 | BSD-3-Clause | High-performance PDF rendering engine (pdfium wrapper) |
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
   - `dio`, `http` (the app is strictly offline-first; remote access is intentionally omitted)
