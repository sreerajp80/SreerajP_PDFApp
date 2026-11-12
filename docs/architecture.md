# Architecture — Folio

Technical design for the Flutter Android app for **everything PDF**: opening, reading,
searching, listening (text-to-speech), annotating, extracting, reorganizing (page operations),
acting as a **print-to-PDF target**, and **verifying PDF digital signatures**. This document
explains how the app is structured, which open-source packages it uses, and how the hard parts
(rendering, native platform channels, annotation overlay, signatures, security) fit together.
Read this before changing the app structure, state management, or layer boundaries.

This file is this app's filled-in copy of the shared architecture blueprint and its
**engineering-standard architecture record** (`flutter_project_engineering_standard.md` §21).
Phase-by-phase status lives in [implementation_progress.md](implementation_progress.md).

> Read first: [../CLAUDE.md](../CLAUDE.md) and [../AGENTS.md](../AGENTS.md) for project rules,
> [PROJECT_PROFILE.md](PROJECT_PROFILE.md) for declared platforms and languages,
> [pdf_idea.md](pdf_idea.md) for the full product concept,
> [features.md](features.md) for the current feature catalog, and
> [guidelines/architecture.md](guidelines/architecture.md) for the blueprint template.

**Rule reminder:** every library named here is **open source**. No commercial or
source-available SDKs (Syncfusion, PSPDFKit, and Apryse are banned).

---

## 1. Scope

- Product: Folio (`in.sreerajp.pdfapp`)
- Repository type: `application`
- Engineering standard profiles in force:
  - `Core Baseline`
  - `Production App Extension`
  - `Sensitive Data Extension` (private files, PDF passwords, trust store — see [security.md](security.md))
- Platforms: `Android` only (from [PROJECT_PROFILE.md](PROJECT_PROFILE.md))

---

## 2. Goals And Non-Goals

### Goals

- **Modern, adaptive UI** (Material 3) that works on phones and tablets, portrait and
  landscape, in light / dark / sepia / OLED themes.
- **One shared core**, reused across features — search, TTS, share, export/convert, metadata,
  print, reading position, fingerprint.
- **Bounded memory** even on very large PDFs (up to a few hundred MB) through pdfium's lazy
  page loading; above the limit, a degraded mode instead of a crash.
- **Offline-first, no internet**; the only network use is Device sync between the user's own
  phones on the local WiFi (no internet host is ever contacted).
- **Security by default** — untrusted file input, scoped storage, local signature
  verification, no secret logging.
- **Never crash, never modify the original** — every page operation is copy-on-write.

### Non-Goals

- OCR of scanned PDFs (a scanned PDF shows a notice instead).
- Editing the text content of an existing PDF.
- Any platform other than Android.
- Cloud sync, accounts, or any internet service. (Device sync is phone-to-phone on the local
  network only; it has no server.)
- Driving real printers (discovery, printer capabilities) — the app's print service is a
  virtual "Save as PDF" destination only.

---

## 3. Architecture Summary

The app uses a Tier 2 feature-first Flutter structure with Riverpod for state management.
Screens delegate work to providers/controllers, which call feature services and repositories.
Local data lives in a sqflite database behind DAOs and repositories. Heavy PDF work (page
operations, signatures, printing, file access) runs in native Kotlin behind method channels
wrapped in `lib/core/platform/`. App-wide values (preferences, About config, database) are
built in `main()` and injected through Riverpod overrides at the root. The app is fully
offline; the release build declares `INTERNET` only for Device sync on the local WiFi (§7).

```
+------------------------------------------------------------------+
| UI layer (screens + widgets, Material 3)                          |
|   Home/Recent, Viewer, Reading tools, Page ops, Annotation,       |
|   Printer, Signature, Settings, Help, About                       |
+------------------------------------------------------------------+
| State layer (Riverpod providers / notifiers)                      |
|   Holds per-document state, orchestrates services, view state     |
+------------------------------------------------------------------+
| Core + services (pure Dart, testable)                             |
|   config, fingerprint, search, export/convert, metadata,          |
|   errors, logging, lifecycle, format                              |
+------------------------------------------------------------------+
| Data / platform layer                                             |
|   SAF file access, sqflite DB, prefs, native Kotlin channels      |
|   (PdfBox, signature, print, TTS, open/share/save)                |
+------------------------------------------------------------------+
```

### 3.1 Feature modules

Each module plugs into the shared core and uses the shared capabilities it needs.

- **Viewer** — opens a PDF via the SAF picker / "Open with" intent (persistable URI permission),
  renders with `pdfrx`, remembers the last-read page keyed to the content fingerprint, and
  shows a warning + degraded paged view for very large files.
- **Reading** — text search with highlight and jump-between-matches, select-and-copy, metadata
  (file + PDF fields), and the shared **TTS** module (English + Malayalam). Search is
  **Unicode-normalized for complex Indic scripts (Malayalam & Sanskrit)** — see §3.2. Malayalam
  TTS is a Settings toggle with a full check / guided-install / auto-disable behavior — reader
  screens ask the module for state and **never show a dead button**. Detects scanned (no text
  layer) PDFs and garbled complex-script extraction and tells the user instead of failing
  silently.
- **Extraction / convert** — extract plain text (page/range), embedded images, and form field
  values; a single conversion service (PDF → text, PDF → images PNG/JPEG, page/range as image);
  share via the Android share sheet. Heavy work runs off the UI isolate.
- **Page operations** — merge, split, reorder, rotate, delete, compress (best-effort, clearly
  labelled), encrypt/decrypt, N-up and booklet imposition, margin trim. **Always
  copy-on-write**: every op writes a new file; the user picks where to save it; the original is
  never modified.
- **Annotation (overlay layer)** — open-source renderers are view-only, so annotations
  (highlight, underline, strikethrough, sticky notes, freehand ink, page bookmarks) live in the
  app's own DB, keyed to fingerprint + page + position, and are drawn on top of the rendered
  page. The original PDF is never modified. Optional export writes real PDF annotations into a
  **copy**. Overlay annotations are visible only in this app until exported.
- **PDF printer** — (1) a share / "Open with" target for pictures and text, saved as a new PDF
  built by PdfBox (copy-on-write); (2) print a PDF out via Android's print framework (whole
  document, page range, or extracted text); (3) a **virtual print service** (`PdfPrintService`)
  that appears in Android's print dialog as "Save as PDF (Folio)": other apps print
  to it, the spooled PDF is written to the cache, and the app opens it. It can be turned off in
  Settings → Printer. A page range is printed by slicing a range-only copy with PdfBox first and
  handing that to the spooler. **Limit:** text → PDF only works for Latin-1 letters (see §21).
- **Signature verification** — verify PDF digital signatures against a custom trust store and
  show a **green tick** on trusted signatures; honest "not trusted / unknown / invalid" states
  otherwise. See §14 and [security.md](security.md) §6.

### 3.2 Complex-script search (Malayalam & Sanskrit)

Search must work properly for **Malayalam** and **Sanskrit** (Sanskrit may be written in
**Devanagari** *or* in **Malayalam script**). Plain substring search is not enough: in these
scripts the *same visible word* can be stored in several different Unicode forms, so a user's
query and the stored text can be "the same word" yet never match byte-for-byte.

**Boundary.** Search needs a real text layer. Scanned PDFs and PDFs whose fonts lack a
`ToUnicode` map cannot be searched (no OCR — out of scope). These degrade gracefully via the
scanned-PDF notice and the **garbled-extraction guard**, which flags missing or nonsense
complex-script extraction so the app never shows empty or wrong results silently.

**Why raw matching fails (the equivalence problem).**

- Malayalam **chillu** letters have an atomic form (`U+0D7A…U+0D7F`) and an older
  `consonant + virama + ZWJ` form. Both look identical.
- Devanagari **nukta** letters can be precomposed (e.g. `U+0958`) or combined (`base + U+093C`).
- Invisible **ZWJ / ZWNJ** (`U+200D` / `U+200C`) sit inside conjuncts and control shaping.
- Combining marks — vowel signs, nukta, virama, and Sanskrit **Vedic accents** — can be
  ordered differently.

**Normalization pipeline.** Both the extracted page text and the query pass through the same
steps before comparison:

1. **NFC normalization** in pure Dart with `unorm_dart` (MIT). This replaced the earlier plan
   to use the device's ICU, so the fold and its index map stay in one testable Dart pass.
2. A **canonical search-key fold** (`SearchNormalizer`, `lib/core/search/`), applied only to a
   throwaway comparison key — the real page text and query keep their exact bytes:
   - **Unify the two chillu encodings** into one canonical form.
   - **Treat ZWJ/ZWNJ as ignorable in the match key only**; they are **not** removed from stored
     or displayed text, so shaping stays correct.
   - **Optional accent-insensitive mode** for Devanagari Sanskrit (fold away Vedic accents).
   - **Optional strict/exact mode** keeps ZWJ/ZWNJ significant.
3. **Grapheme-cluster-aware matching** (Dart `characters`) so a match never splits a base
   letter + vowel-sign cluster.
4. **Phonetic and Sandhi-aware matching** (`indic_phonetic_engine.dart`, `sandhi_engine.dart`,
   `malayalam_transliteration.dart`) for the advanced Indic search modes.

**Highlight back-mapping.** Normalization changes string length, so `SearchNormalizer` keeps an
index map: normalized-key offset → original character index → pdfium per-character rectangle
(from `pdfrx`'s `PdfPageText`).

**Script detection.** `script_detector.dart` detects Malayalam (`U+0D00–U+0D7F`) and Devanagari
(`U+0900–U+097F`, plus Devanagari Extended `U+A8E0–U+A8FF` and Vedic Extensions
`U+1CD0–U+1CFF`) to pick the right fold and to drive the garbled-extraction guard.

---

## 4. Repository Structure

### Current Structure Tier

- `Tier 2` (feature-first)
- Why this tier is appropriate:
  - The app is large and has many separate domains (viewer, reading, page ops, annotation,
    printer, signature).
  - Each feature owns its own `data/`, `domain/`, `presentation/` folders, which keeps changes local.

### Top-Level Source Layout

```text
lib/
|-- main.dart                     # thin: init sequence then runApp
|-- app/
|   |-- app.dart                  # root MaterialApp.router, locales, delegates
|   |-- config/                   # AppFlavorConfig + root Riverpod providers
|   |-- routing/                  # go_router routes (centralized, AppRoute enum)
|   `-- theme/                    # tokens.dart, app_theme.dart (light/dark/sepia/oled)
|-- core/
|   |-- config/                   # AppConfig + ConfigService (FIXED path)
|   |-- constants/                # app_constants.dart (db names, channel ids, thresholds)
|   |-- errors/                   # AppException hierarchy, SafeErrorFallback
|   |-- format/                   # DisplayFormat (sizes, locale-safe dates)
|   |-- lifecycle/                # AppLifecycleService
|   |-- logging/                  # AppLogger
|   |-- platform/                 # method-channel wrappers (open/share, PdfBox, signature, TTS)
|   |-- search/                   # SearchNormalizer, script detector, phonetic + Sandhi engines
|   |-- storage/                  # AppDatabase, migrations, fingerprint, CacheService
|   `-- widgets/                  # shared widgets (MadeWithLove badge)
|-- features/
|   |-- viewer/      {data,domain,presentation}   # open, render, scroll, zoom, TOC, thumbnails
|   |-- reading/     {data,domain,presentation}   # search, copy, metadata, TTS
|   |-- extraction/  {data,presentation}          # text/images/forms, convert, share
|   |-- page_ops/    {data,domain,presentation}   # merge/split/reorder/rotate/delete/compress/encrypt
|   |-- annotation/  {data,domain,presentation}   # overlay layer + optional export
|   |-- printer/     {data,presentation}          # print-to-PDF target + print-out
|   |-- signature/   {data,domain,presentation}   # verify + trust store
|   |-- settings/    {presentation}               # settings screens
|   |-- help/        {presentation}               # built-in help pages
|   `-- about/       {presentation}               # About screen (reads ConfigService)
`-- l10n/                         # app_en.arb (template), app_ml.arb, app_sa.arb + generated code
android/app/src/main/kotlin/...   # MainActivity, PdfBoxHandler, SignatureHandler, PrintHandler,
                                  # PdfPrintService, TtsHandler
assets/config/app_config.json     # About section source of truth
assets/trust/                     # bundled trust anchors (EU trusted list)
test/                             # mirrors lib/ (app/, core/, features/, l10n/)
```

### Ownership Rules

| Path | Responsibility |
|---|---|
| `lib/app/` | App shell: root widget, routing, theme, flavor config, root providers |
| `lib/core/` | Shared, feature-agnostic services and widgets; no feature imports |
| `lib/features/<f>/data/` | DAOs, repositories, services that talk to the DB or native channels |
| `lib/features/<f>/domain/` | Immutable models and pure logic |
| `lib/features/<f>/presentation/` | Screens, widgets, and that feature's providers/controllers |
| `lib/l10n/` | ARB files; generated `app_localizations*.dart` (do not edit by hand) |
| `android/app/src/main/kotlin/` | Native work only where the platform forces it |

---

## 5. App Initialization Sequence

`lib/main.dart` (engineering standard §4.5, §11.1). Each step degrades safely rather than
crashing silently.

| Step | Code / Call | Notes |
|---|---|---|
| 1 | `WidgetsFlutterBinding.ensureInitialized()` | Always first |
| 2 | `AppLogger.init()` | Flavor comes from compile-time `AppFlavorConfig`. `AppLogger` starts with a console-only logger, so a log call never throws, even before this step |
| 3 | Global error boundaries | `FlutterError.onError`, `PlatformDispatcher.instance.onError` (both log through `AppLogger`), release `ErrorWidget.builder` → `SafeErrorFallback` (localized message) |
| 4 | FFI / platform binding init | N/A — Android only, no FFI |
| 5 | Secure storage / key bootstrap | N/A — the app stores no secrets |
| 6 | `AppDatabase().open()` | Opens and migrates to schema v4 |
| 7 | `SharedPreferences.getInstance()` + `ConfigService().loadAndVerify()` | Preferences (incl. saved language) + About config |
| 8 | `pdfrxFlutterInitialize()` | PDF engine; failure is logged and the viewer shows its own error |
| 9 | `AppLifecycleService(database: …).init()` + `cleanUpPreviousSession()` | Lifecycle observer; removes stale working files (older than 24 h) left by an earlier session, before any document opens |
| 10 | `runApp(ProviderScope(overrides: …, child: PdfApp()))` | Riverpod retry disabled so failures show at once |

Nothing is deferred except per-feature services, which Riverpod creates on first use.

---

## 6. App Lifecycle Behavior

| Lifecycle State | App Behavior |
|---|---|
| `resumed` | Logged only (debug). No lock to re-validate (no app lock). If the DB was closed on `detached` and the same engine comes back, the DB is reopened |
| `inactive` | Logged only. No screen obscuring (no `FLAG_SECURE` — see [security.md](security.md) §10) |
| `paused` | Logged only. Reading positions and annotations are written to the DB as they change, so nothing is pending |
| `detached` | The DB connection is closed (engineering standard §9.3). It stays open for the rest of the app lifetime |
| Memory pressure | Clears Flutter's image cache and live images |
| Startup | Stale working files (older than 24 h) in the private temp folders `opened/`, `page_ops/`, `extracted/`, `annotations/` are deleted. The `printer/` spool is never touched automatically |

---

## 7. Offline Behavior

- **Connectivity requirement**: `fully offline` (no feature needs the internet)
- **Network permission**: `INTERNET` is in the main manifest **only** for Device sync
  (`lib/features/nearby_transfer/`): phone-to-phone on a private LAN address, paired by QR code,
  AES-256-GCM with a one-time key, open only while the Device sync screen is open.
- **Offline data source**: sqflite + files picked through SAF.

Rules:

- The app MUST NOT contact an internet host. No HTTP or web-socket client is allowed in `lib/`,
  and raw sockets are allowed only in `lib/features/nearby_transfer/data/` (both checked in CI).
  A scanned pairing code is accepted only with a private LAN IPv4 address (10/8, 172.16/12,
  192.168/16), and the host binds only to the phone's own WiFi/hotspot address.
- The merged release manifest's permissions are exactly the reviewed set (`INTERNET`, `CAMERA`,
  no `RECORD_AUDIO`, no storage). Check the built artifact (`aapt2 dump permissions <apk>`), as in
  [release_process.md](release_process.md) §6.4.
- No dependency may bring in network access; the block list is in
  [dependencies.md](dependencies.md).
- Signature validation runs fully offline; no CRL / OCSP requests.
- Opening a web link hands it to another app; this app never fetches it.

---

## 8. State Management

- Primary pattern: **Riverpod** (`flutter_riverpod` 3.x), one pattern for the whole app.
- Why this pattern was chosen:
  - Compile-safe providers and easy overrides in tests.
  - Per-document state can be scoped and disposed with the viewer.
- State boundaries:
  - Widgets own: UI-only concerns (animation, scroll controllers, text field focus).
  - State layer owns: per-document state (open document, search hits, TTS state, annotations),
    settings state (theme, locale, text scale), and view state.
  - Services own: PDF work, DB access, native calls, search normalization.
- `ProviderScope` sits at the root. Root providers live in `lib/app/config/`;
  `sharedPreferencesProvider`, `appConfigProvider`, and `appDatabaseProvider` are overridden in
  `main()` with values built during startup so widgets read them synchronously.

---

## 9. Data Flow

```text
Widget -> Provider / Controller -> Service or Repository -> DAO / Platform channel -> SQLite / Kotlin
```

### Rules

- Lower layers never depend on upper layers. Core and services are plain Dart so they can be
  unit-tested without a device.
- Widgets must not know: SQL, SharedPreferences keys, file paths, or platform channels.
- Services must not know: `BuildContext`, routes, or UI strings.
- Repositories abstract: the sqflite tables and the native channels.
- Native work sits behind wrappers in `lib/core/platform/`, so the Dart side stays testable and
  swappable.

### Security boundaries

Full rules are in [security.md](security.md). In summary:

- **Untrusted input everywhere** — every opened PDF and incoming intent is validated; parsers
  have failure paths; the app never crashes on bad data.
- **Scoped storage / SAF only** — no broad storage permission, no in-app browser; persistable
  URI permissions for recents; denied or stale URIs are handled gracefully.
- **Copy-on-write** — page operations write a new file; the original is never touched.
- **Local signature verification** — PKCS#7 / CMS verified on-device. "Globally trusted" means
  the bundled EU trusted list (Adobe AATL is **not** bundled — its redistribution terms are not
  clearly open), **not** the Android TLS CA store.
- **No secret logging** — file contents, PDF passwords, and key material are never logged.

---

## 10. Error Handling Architecture

- **Global error handler**: `FlutterError.onError` and `PlatformDispatcher.instance.onError` in
  `main()`; release builds swap `ErrorWidget.builder` for `SafeErrorFallback`
  (`lib/core/errors/safe_error_fallback.dart`).
- **Domain exception hierarchy**: sealed `AppException` in `lib/core/errors/app_exception.dart`.

| Exception Class | Thrown By | Meaning |
|---|---|---|
| `StorageException` | Repositories, open channel | DB or file access failure (lost URI permission, unreadable file) |
| `ValidationException` | Services | Input failed business rules |
| `PdfOpenException` | Viewer data layer | PDF could not be opened (generic) |
| `PdfCorruptException` | Viewer / PdfBox | File is damaged or truncated |
| `PdfPasswordRequiredException` | Viewer / PdfBox | Password needed or wrong |
| `PdfEmptyException` | Viewer | File has no pages / zero bytes |
| `PdfUnsupportedTextException` | Printer | Text → PDF with non-Latin-1 letters |
| `PrintException` | Print bridge | Android print framework failure |
| `SignatureCheckException` | Signature channel | Verification could not run |
| `InvalidCertificateException` | Trust store | Certificate file could not be parsed |

- **Error escalation policy**: services throw typed exceptions; providers map them to UI states
  with a friendly localized message. Internal detail goes to `cause` and the logs.
- **Fatal error screen**: `SafeErrorFallback` (release builds only).

---

## 11. Domain Model

### Current Schema Version

SQLite schema version: **4**. Migrations are append-only, run inside a transaction via
`AppDatabase`, and live in `lib/core/storage/migrations.dart`.

| Version | Change Summary |
|---|---|
| 1 | `meta` table — schema baseline (Phase 0) |
| 2 | `recent_files`, `reading_positions` — recents + last-read page, keyed to fingerprint (Phase 1) |
| 3 | `annotations` — overlay layer: fingerprint + page + position + type + JSON payload (Phase 5) |
| 4 | `trust_store` — user-added signing certificates (Phase 7) |

**File identity = content fingerprint** (file size + SHA-256), with the persisted URI as a fast
path, so reading positions, bookmarks, and overlay annotations survive move / rename / re-pick.
A modified file is treated as a **new document** — old positions and annotations are not applied.

### Core Models Or Entities

| Type | Purpose | Mutable? | Notes |
|---|---|---|---|
| `PdfDocumentRef` | A document the app can open (URI, name, size, fingerprint) | No | `viewer/domain/` |
| `RecentFile` | Row in the recents list | No | `viewer/domain/` |
| `ReadingPosition` | Last page / zoom per fingerprint | No | `viewer/domain/` |
| `ViewMode` | Single / continuous / two-page | No (enum) | `viewer/domain/` |
| `SearchHit` | One match with back-mapped rectangles | No | `reading/domain/` |
| `TtsState` | Ready / needs-install / unavailable / speaking | No | Drives "never a dead button" |
| `TextQuality` | Text layer present / scanned / garbled | No | `reading/domain/` |
| `Annotation`, `AnnotationType` | Overlay mark + its normalized geometry | No | `annotation/domain/` |
| `PdfSignature`, `SignatureStatus` | One signature and its verdict | No | `signature/domain/` |
| `TrustedCertificate` | Trust store entry | No | `signature/domain/` |
| `AppConfig` | About-screen values from JSON | No | `core/config/` |

### Serialization Strategy

- JSON models: yes — `AppConfig` (asset JSON) and the annotation `payload` column.
- Database models: yes — DAOs map rows to the immutable domain models.
- Separate domain entities from transport models: no separate transport layer (no network);
  DAOs convert directly.

### Database Indexes

| Table | Indexed Columns | Reason |
|---|---|---|
| `recent_files` | `last_opened_at DESC` | Home lists newest first |
| `annotations` | `fingerprint, page` | Load marks for the visible page |
| `trust_store` | `added_at DESC` | Manage-certificates screen lists newest first |

---

## 12. Dependency Management And Injection

- DI approach: Riverpod providers (no service locator).
- App-root dependencies (overridden in `main()`):
  - `sharedPreferencesProvider`
  - `appConfigProvider`
  - `appDatabaseProvider`
- Feature services and repositories are plain providers that read these.
- Test replacement strategy: `ProviderScope` / `ProviderContainer` overrides with fakes;
  `sqflite_common_ffi` runs the real schema on the test host; method channels are mocked with
  `TestDefaultBinaryMessengerBinding`.

---

## 13. Navigation

- Navigation approach: `go_router`.
- Route definition location: `lib/app/routing/` — every route is an `AppRoute` enum value with
  one path; screens navigate by name (`context.goNamed` / `pushNamed`).
- Protected-route strategy: none needed (no app lock or accounts).
- Deep-link support: no URL deep links. External entry is through Android intents (VIEW, SEND,
  SEND_MULTIPLE, PROCESS_TEXT) handled in `MainActivity` and routed to the viewer or import screen.

---

## 14. Persistence And External Systems

### Local Storage

- Database: `sqflite`.
- WAL mode: enabled (set with `rawQuery` in `onConfigure`), foreign keys on.
- Key-value storage: `shared_preferences` (theme, locale, text scale, reader and TTS settings —
  nothing sensitive).
- Secure storage: none — the app stores no secrets. If one is ever needed, use
  `flutter_secure_storage`.
- Temporary files: the app cache (`opened/`, `page_ops/`, printer and extraction folders) — see
  [security.md](security.md) §13.

### Packages

All packages are open source; confirm the license before adding any new one. The full list with
licenses is in [dependencies.md](dependencies.md).

| Concern | Package / mechanism |
|---|---|
| State management | `flutter_riverpod` |
| Navigation | `go_router` |
| PDF rendering | `pdfrx` (pdfium — Google's BSD PDF engine) |
| Page ops + data (native) | PdfBox-Android (Apache 2.0) via a Kotlin channel |
| Signature crypto (native) | Bouncy Castle (`jdk15to18`) + Android `CertPathValidator` |
| File pick / SAF / save / share | Native channel in `MainActivity` (`ACTION_OPEN_DOCUMENT`, `ACTION_CREATE_DOCUMENT`, share sheet) — no package |
| Local DB | `sqflite` (+ `sqflite_common_ffi` in tests) |
| Preferences (non-secret) | `shared_preferences` |
| Text-to-Speech | `flutter_tts` + a native `TtsHandler` for voice checks / install |
| Print / print-out | Android print framework via a native channel — no package |
| Unicode NFC / graphemes | `unorm_dart`, `characters` |
| Hashing | `crypto` (SHA-256 fingerprint) |
| Logging | `logger` (behind `AppLogger`) |
| App info / version | `package_info_plus` (cross-checks `app_config.json`) |
| Localization | `flutter_localizations`, `intl` |

### Network

- Network client: none (no HTTP). Device sync uses `dart:io` sockets on the local WiFi only.
- Offline behavior: fully offline (§7).

### Platform Channels Or Native Integrations

Wrapped by Dart classes in `lib/core/platform/`:

- **Open / save / share (`MainActivity`)**: system picker, persistable URI permissions,
  "Open with" and share intents, copy to cache, save to a user-chosen location, share sheet.
- **PdfBox-Android (`PdfBoxHandler`)**: merge, split, reorder/rotate/delete pages,
  encrypt/decrypt, compress, imposition, text extraction, metadata, form field reads, annotation
  export into a copy, and building a new PDF out of shared pictures or text.
- **Signature module (`SignatureHandler`)**: PdfBox-Android reads the signature and ByteRange;
  Bouncy Castle verifies the PKCS#7 / CMS data (provider used by instance, never by the name
  "BC", which resolves to Android's stripped copy); `CertPathValidator` checks the chain.
- **Print bridge (`PrintHandler`)**: hands a finished PDF to Android's `PrintManager` through a
  `PrintDocumentAdapter`. Android draws the print dialog.
- **Virtual print service (`PdfPrintService`)**: a system `PrintService` that receives print
  jobs from other apps as a "Save as PDF" destination, writes them to the cache, and opens them
  in `MainActivity`. Bound only by the system (`BIND_PRINT_SERVICE`).
- **TTS (`TtsHandler`)**: checks for the `ml-IN` voice and opens the install / settings flows.

---

## 15. Environment And Build Model

- Flavors used: `dev` and `prod` (`android/app/build.gradle.kts`, `environment` dimension).
- Runtime config mechanism: native flavor; Flutter injects `FLUTTER_APP_FLAVOR`, read by
  `AppFlavorConfig` (`lib/app/config/app_flavor_config.dart`).
- Obfuscation: enabled for prod release — symbols in `build/symbols/android-prod-<version>/`,
  archived outside the repo ([release_process.md](release_process.md) §6.1).
- Toolchain: Java 17, AGP 9.4.1, Gradle 9.8.0, Kotlin Gradle Plugin 2.4.10 (built-in Kotlin off), Impeller default.

### Target Platforms And Distribution

| Platform | Minimum OS | Release artifact | Channel(s) | Signing | Platform-specific notes |
|---|---|---|---|---|---|
| Android | `minSdk 26` (hard project rule) | `.aab` / split `.apk` | Google Play / direct download | Release (upload) keystore + Play App Signing | 16 KB page size verified on 64-bit; `INTERNET` + `CAMERA` for Device sync only (no internet host); print service guarded by `BIND_PRINT_SERVICE` |

### Platform Differences

N/A — Android is the only declared platform.

---

## 16. UI System

- Theme source of truth: `lib/app/theme/app_theme.dart`.
- Design tokens location: `lib/app/theme/tokens.dart`.
- Shared widget strategy: app-wide widgets in `lib/core/widgets/`; feature widgets in each
  feature's `presentation/widgets/`.
- **Material 3**, built from a user-selected accent color (preset quick picks + custom wheel).
- **Themes**: system / light / dark / sepia / OLED (`AppThemeMode`), persisted in
  `shared_preferences`; plus an in-app text scale and font choice (bundled Malayalam fonts).
- **Viewer**: single page, continuous scroll, and two-page / book view; zoom, pinch-to-zoom,
  fit-to-width, fit-to-page; jump-to-page; table-of-contents tree; thumbnail grid.
- **Adaptive layout**: works in portrait and landscape on phones and tablets.
- **Empty and error states**: friendly Home empty state ("Open a PDF"), clear never-crashing
  screens for corrupt / truncated / empty / password-protected files, and the "this PDF has no
  selectable text" notice for scanned PDFs.
- **Localization**: English, Malayalam, Sanskrit; in-app language picker (System default + each
  language by endonym) in Settings → Language.
- Accessibility expectations:
  - Minimum touch target: 48 × 48 dp.
  - Color contrast: WCAG AA minimum (4.5:1 normal text, 3:1 large text).
  - Screen reader: TalkBack tested before each release.
  - Text scale: layouts verified at 1.0×, 1.5×, 2.0×.
  - Every icon-only control has a localized tooltip.

### 16.1 Settings screens

Settings is a hub of grouped Material 3 sections, each opening its own screen: Appearance
(theme, accent color, typography), Language, Reader, Speech (TTS, including the Malayalam TTS
toggle with guided install / auto-disable), Printer (incl. clear printer cache), Storage (clear
temporary cache, clear recent files), Permissions, Features, Help, and About. Signature trust
store management is reached from the signatures screens.

### 16.2 About section + config file

`assets/config/app_config.json` is the single source of truth for the About screen. A
`ConfigService` loads it at startup (via `rootBundle`) into a typed `AppConfig` model and
cross-checks the version with `package_info_plus`. Text values are localized per language
(`en`, `ml`, `sa`). The About section shows app name, description, version/build, and the
`details` rows (author, email with `mailto:`, license note, AI used, IDE used), and ends with the
signature badge "Made with ❤️ from India" (`MadeWithLove`). Changing the About content is a
config edit, not a code change.

---

## 17. Logging

- Logger implementation: `AppLogger` (`lib/core/logging/app_logger.dart`) over `logger`.
- Log file location: none — console output only.
- Log rotation policy: N/A (no disk logs). Reconsider under engineering standard §14.4 if disk
  logging is ever added.
- Verbose logging gate: `AppFlavorConfig.instance.isDev` (`trace`/`debug` only in `dev`).
- Sensitive data policy: never log PDF passwords, document text, key material, or full DB rows
  ([security.md](security.md) §9).

---

## 18. Testing Strategy

| Test Type | Scope | Notes |
|---|---|---|
| Unit | Fingerprint, config loader, exception mapping, migrations, `SearchNormalizer`, phonetic + Sandhi engines, TTS state, signature trust rules, booklet planner, display format | `sqflite_common_ffi` for DB tests |
| Widget | Home, viewer states, scanned-PDF notice, settings screens, signatures screen, About | Riverpod overrides with fakes |
| Localization | Key parity, label length, Sanskrit framework fallback | `test/l10n/` |
| Integration / manual | Open → read → reopen-at-last-page; copy-on-write leaves the original intact; encrypt/decrypt round-trip; print; signature verify | On a real device with `samples/` PDFs |

### Test Layout

```text
test/
|-- app/          # flavor config, theme
|-- core/         # config, errors, format, platform, search, storage, widgets
|-- features/     # mirrors lib/features/
`-- l10n/         # parity, label length, sa fallback
```

### Critical Test Areas

- Database upgrade path from version 1 to current (`test/core/storage/migration_v*_test.dart`).
- Indic phonetic search and Sandhi normalization: NFC equivalence, chillu atomic ⇄ ZWJ-sequence,
  ZWJ/ZWNJ ignored in the key, nukta precomposed ⇄ combined, accent-insensitive Sanskrit mode,
  strict mode, offset back-mapping.
- PDF decryption/encryption parsing and wrong-password handling.
- Copy-on-write file generators.
- Custom trust store validation.
- Error boundary behavior for unhandled exceptions.

---

## 19. Operational Constraints

- Minimum supported OS: Android 8.0 (API 26).
- Performance constraints:
  - Cold startup under 2 seconds to first meaningful frame (release build).
  - Frame budget 16 ms at 60 Hz; sustained jank above 5% is release-blocking.
  - Fast open and smooth scrolling with bounded memory; lazy page loading; heavy work
    (extraction, compression, image encoding) off the UI isolate.
  - APK size budget: engineering standard §10.7 defaults ([release_process.md](release_process.md) §6.3).
- **Large files**: PDFs up to a few hundred MB should open; above the limit, a clear warning and
  a degraded (raw paged) mode instead of crashing.
- **Error handling**: corrupt / truncated / empty / password-protected files show friendly
  messages; every parser and platform call has a typed failure path.
- Regulatory or store constraints: Google Play policies (target API level, Data safety, privacy
  policy) — [release_process.md](release_process.md) §8.
- Team constraints: single developer.
- Offline constraints: no internet host, no HTTP/network packages; `INTERNET` only for local
  Device sync.

---

## 20. Decisions And Tradeoffs

| Decision | Chosen Option | Why | Tradeoff |
|---|---|---|---|
| Structure | Tier 2 feature-first | Many independent domains | More folders than Tier 1 |
| State | Riverpod | One pattern, easy test overrides | Learning curve |
| Renderer | `pdfrx` (pdfium) | Open source, fast, lazy loading | View-only — annotations need an overlay |
| Page ops / signatures | PdfBox-Android + Bouncy Castle in Kotlin | No open-source Dart equivalent | Native code and a channel to maintain |
| Annotations | App-side overlay in SQLite | Never modify the original | Marks are app-only until exported to a copy |
| Printing | Own native print bridge, no package | Native-channel path already existed; the `printing` package wraps the same `PrintManager` | More code we own (a preference, not a constraint) |
| System print service | Virtual "Save as PDF" destination only (`PdfPrintService`) | Lets any app "print to PDF" into this app (first dropped in Phase 6, added in a later update) | Does not drive real printers; adds an exported, system-bound service |
| NFC normalization | `unorm_dart` in Dart | Fold + index map in one testable pass | One more small dependency instead of device ICU |
| Trust anchors | Bundled EU trusted list + user trust store | Offline, open redistribution | Adobe AATL not available; no online revocation |
| File access | Native SAF channel, no picker package | Full control of persistable URIs and intents | More Kotlin |

---

## 21. Known Risks And Follow-Ups

- Risk: **Text → PDF is Latin-1 only.** Writing Malayalam or Devanagari into a PDF needs an
  embedded Unicode font *and* a complex-script shaping engine; PdfBox-Android has neither.
  Mitigation: the app detects this and says so. Lifting it means bundling a font plus a shaping
  engine (e.g. HarfBuzz) — a project of its own.
- Risk: opened-document copies in `cache/opened/` are not deleted when the reader closes.
  Startup now removes copies older than 24 h; deleting on close is still open
  ([security.md](security.md) §17).
- Risk: no automated offline (airplane-mode) scenario test and no `test/fixtures/` PDF set;
  these checks are manual with `samples/`. Mitigation: add them with the CI work.
- Risk: log rotation / disk logs not implemented. Mitigation: none needed while logs are
  console-only (§17).

---

## 22. Related Documents

- [../README.md](../README.md)
- [PROJECT_PROFILE.md](PROJECT_PROFILE.md)
- [security.md](security.md)
- [release_process.md](release_process.md)
- [dependencies.md](dependencies.md)
- [project_structure.md](project_structure.md)
- [features.md](features.md)
- [pdf_idea.md](pdf_idea.md)
- [guidelines/flutter_project_engineering_standard.md](guidelines/flutter_project_engineering_standard.md)
- [guidelines/flutter_build_flavors_guide.md](guidelines/flutter_build_flavors_guide.md)
- [guidelines/platform_store_readiness.md](guidelines/platform_store_readiness.md)
