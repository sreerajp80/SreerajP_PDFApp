# Architecture — SreerajP_PDFApp

Technical design for the Flutter Android app for **everything PDF**: opening, reading,
searching, listening (text-to-speech), annotating, extracting, reorganizing (page operations),
acting as a **print-to-PDF target**, and **verifying PDF digital signatures**. This document
explains how the app is structured, which open-source packages to use, and how the hard parts
(rendering, native platform channels, annotation overlay, signatures, security) fit together.

This file is also the project's **engineering-standard architecture record**
(`flutter_project_engineering_standard.md §21`): where the design is forward-looking, it notes
what is built now versus planned. Phase-by-phase status lives in
[pdf-app-implementation-progress.md](pdf-app-implementation-progress.md).

Read [CLAUDE.md](../CLAUDE.md) first for the project rules. See
[PDF-Idea.md](PDF-Idea.md) for the full product idea and
[pdf-app-implementation-plan.md](pdf-app-implementation-plan.md) for the phased build plan.

**Applicability profiles in force:** Core Baseline + Production App Extension, plus selected
Sensitive Data controls (PDF passwords, signature trust store — see the implementation plan §11).

**Rule reminder:** every library named here is **open source**. No commercial or
source-available SDKs (Syncfusion, PSPDFKit, and Apryse are banned).

---

## 1. Design goals

- **Modern, adaptive UI** (Material 3) that works on phones and tablets, portrait and
  landscape, in light / dark / sepia.
- **One shared core**, reused across features — search, TTS, share, export/convert, metadata,
  print, reading position, fingerprint.
- **Bounded memory** even on very large PDFs (up to a few hundred MB) through pdfium's lazy
  page loading; above the limit, a degraded mode instead of a crash.
- **Offline-first**; the only optional online part is opening remote links.
- **Security by default** — untrusted file input, scoped storage, local signature
  verification, no secret logging.
- **Never crash, never modify the original** — every page operation is copy-on-write.

---

## 2. Layered architecture

```
+------------------------------------------------------------------+
| UI layer (screens + widgets, Material 3)                          |
|   Home/Recent, Viewer, Reading tools, Page ops, Annotation,       |
|   Printer, Signature, Settings, About                             |
+------------------------------------------------------------------+
| State layer (Riverpod providers / notifiers)                      |
|   Holds per-document state, orchestrates services, view state     |
+------------------------------------------------------------------+
| Core + services (pure Dart, testable)                             |
|   config, fingerprint, search, TTS, export/convert, share,        |
|   metadata, errors, logging, lifecycle                            |
+------------------------------------------------------------------+
| Data / platform layer                                             |
|   SAF file access, sqflite DB, secure storage, prefs,             |
|   native Kotlin channels (PdfBox, signature, print)               |
+------------------------------------------------------------------+
```

Rule: **lower layers never depend on upper layers.** The core and services are plain Dart so
they can be unit-tested without a device. Native work (PdfBox-Android, Bouncy Castle, print
service) sits behind platform channels wrapped in `core/platform/`, so the Dart side stays
testable and swappable.

---

## 3. Recommended open-source packages

State management uses **Riverpod** (one pattern for the whole app). All packages below are
open source; confirm the license before adding any new one.

| Concern | Package (open source) |
|---|---|
| State management | `flutter_riverpod` |
| Navigation | `go_router` (centralized routes) |
| PDF rendering | `pdfrx` (pdfium — Google's BSD PDF engine) |
| Page ops + data (native) | PdfBox-Android (Apache 2.0) via a Kotlin platform channel |
| Signature crypto (native) | Bouncy Castle (repackaged artifact) + Android `CertPathValidator` |
| File pick / SAF | `file_picker` + a persistable-URI helper (platform channel / `saf_util`-style) |
| Local DB (recents, positions, annotations, trust store) | `sqflite` (WAL on, FKs on) |
| Preferences (non-secret) | `shared_preferences` |
| Secure storage (secrets) | `flutter_secure_storage` |
| Text-to-Speech | `flutter_tts` |
| Share | `share_plus` |
| Print / print-out | `printing` |
| Logging | `logger` (behind `AppLogger`) |
| App info / version | `package_info_plus` (used with the config file for About) |

---

## 4. Project / module layout (Tier 2, feature-first)

The app is large and multi-domain, so Tier 2 (feature-first) is used from the start. The fixed
`lib/core/config/` About path still applies unchanged.

```text
lib/
  main.dart                     # thin: init sequence then runApp
  app/
    app.dart                    # root MaterialApp.router
    config/                     # AppFlavorConfig + root Riverpod providers
    routing/                    # go_router routes (centralized, AppRoute enum)
    theme/                      # tokens.dart, light/dark/sepia themes
  core/
    config/                     # AppConfig + ConfigService (FIXED path)
    constants/                  # app_constants.dart (db names, channel ids, thresholds)
    errors/                     # AppException hierarchy, error boundaries, SafeErrorFallback
    logging/                    # AppLogger
    lifecycle/                  # AppLifecycleService
    storage/                    # db bootstrap, migrations, fingerprint util
    platform/                   # platform-channel Dart wrappers (PdfBox, signature, print)
  features/
    viewer/       {data,domain,presentation}   # open, render, scroll, zoom, TOC, thumbnails
    reading/      {data,domain,presentation}   # search, copy, metadata, TTS
    extraction/   {data,domain,presentation}   # text/images/forms, convert, share
    page_ops/     {data,domain,presentation}   # merge/split/reorder/rotate/delete/compress/encrypt
    annotation/   {data,domain,presentation}   # overlay layer + optional export
    printer/      {data,domain,presentation}   # print-to-PDF target + print-out
    signature/    {data,domain,presentation}   # verify + trust store
    settings/     {presentation}               # settings + Malayalam TTS toggle
    about/        {presentation}               # About screen (reads ConfigService)
  l10n/                         # app_en.arb, app_ml.arb
android/
  app/src/main/kotlin/...       # PdfBox, Bouncy Castle, print service, method channels

assets/
  config/app_config.json        # About section source of truth

test/                           # mirrors lib/; fixtures under test/fixtures/
```

Native Kotlin code lives under `android/` only where the platform forces it (PdfBox,
signatures, print service).

---

## 5. Modern UI approach

- **Material 3 (Material You)**: `useMaterial3: true`, dynamic color where available with a
  safe fallback scheme.
- **Themes**: light / dark / sepia (night-mode color invert for reading comfort) plus "follow
  system", through a central `ThemeController`. `AppThemeMode` (system / light / dark / sepia)
  is persisted in `shared_preferences`. Single token source in `app/theme/tokens.dart`. Respect
  system font scaling and screen readers.
- **State plumbing**: Riverpod only, `ProviderScope` at the root. Root providers live in
  `app/config/`; `sharedPreferencesProvider`, `appConfigProvider`, and `appDatabaseProvider` are
  overridden in `main()` with values built during startup so widgets read them synchronously.
- **Navigation**: go_router, routes centralized in `app/routing/` behind an `AppRoute` enum.
- **Viewer**: single page, continuous scroll, and two-page / book view; zoom, pinch-to-zoom,
  fit-to-width, fit-to-page; jump-to-page; table-of-contents (outline) tree; thumbnail grid.
- **Adaptive layout**: `NavigationRail` on wide screens (tablets, landscape), compact / bottom
  navigation on phones.
- **Empty and error states**: friendly Home empty state ("Open a PDF"), and clear,
  never-crashing screens for corrupt / truncated / empty / password-protected files, plus the
  "this PDF has no selectable text" notice for scanned PDFs.

---

## 6. Feature modules (architectural view)

Each module plugs into the shared core and declares which shared capabilities it uses.

- **Viewer** — opens a PDF via SAF picker / "Open with" intent (persistable URI permission),
  renders with `pdfrx`, remembers the last-read page keyed to the content fingerprint, and
  shows a warning + degraded paged view for very large files.
- **Reading** — text search with highlight and jump-between-matches, select-and-copy, metadata
  (file + PDF fields), and the shared **TTS** module (English + Malayalam). Search is
  **Unicode-normalized for complex Indic scripts (Malayalam & Sanskrit)** — see §6.1. Malayalam
  TTS is a Settings toggle with a full check / guided-install / auto-disable behavior — reader
  screens ask the module for state and **never show a dead button**. Detects scanned (no text
  layer) PDFs and garbled complex-script extraction and tells the user instead of failing
  silently.
- **Extraction / convert** — extract plain text (page/range), embedded images, and form field
  values; a single conversion service (PDF → text, PDF → images PNG/JPEG, page/range as image);
  share via the Android share sheet. Heavy work runs off the UI isolate (`compute`).
- **Page operations** — merge, split, reorder, rotate, delete, compress (best-effort, clearly
  labelled), encrypt/decrypt. **Always copy-on-write**: every op writes a new file to a
  user-chosen location; the original is never modified.
- **Annotation (overlay layer)** — open-source renderers are view-only, so annotations
  (highlight, underline, strikethrough, sticky notes, freehand ink, page bookmarks) live in the
  app's own DB, keyed to fingerprint + page + position, and are drawn on top of the rendered
  page. The original PDF is never modified. Optional export writes real PDF annotations into a
  **copy**. Overlay annotations are visible only in this app until exported.
- **PDF printer** — (1) register as a share / "Open with" target for printable content and save
  it as a new PDF (copy-on-write); (2) print a PDF out via Android's print framework (page range
  or extracted text); (3) a system print service (native Kotlin) as a later, riskier item.
- **Signature verification** — verify PDF digital signatures against a custom trust store and
  show a **green tick** on trusted signatures; honest "not trusted / unknown / invalid" states
  otherwise. See §7 and §10.

### 6.1 Complex-script search (Malayalam & Sanskrit)

Search must work properly for **Malayalam** and **Sanskrit** (Sanskrit may be written in
**Devanagari** *or* in **Malayalam script**). Plain substring search is not enough: in these
scripts the *same visible word* can be stored in several different Unicode forms, so a user's
query and the stored text can be "the same word" yet never match byte-for-byte. This has two
parts — getting usable text out, and matching it correctly.

**Boundary (unchanged).** Search needs a real text layer. Scanned PDFs and PDFs whose fonts
lack a `ToUnicode` map cannot be searched (no OCR — out of scope). These degrade gracefully via
the existing scanned-PDF notice and the **garbled-extraction guard**, which flags missing or
nonsense complex-script extraction so the app never shows empty or wrong results silently.

**Why raw matching fails (the equivalence problem).**
- Malayalam **chillu** letters have an atomic form (`U+0D7A…U+0D7F`) and an older
  `consonant + virama + ZWJ` form. Both look identical.
- Devanagari **nukta** letters can be precomposed (e.g. `U+0958`) or combined (`base + U+093C`).
- Invisible **ZWJ / ZWNJ** (`U+200D` / `U+200C`) sit inside conjuncts and control shaping.
- Combining marks — vowel signs, nukta, virama, and Sanskrit **Vedic accents** — can be
  ordered differently.

**Normalization pipeline.** Both the extracted page text and the query pass through the same
steps before comparison:
1. **NFC normalization**, done natively at the extraction boundary with the device's built-in
   ICU (`android.icu.text.Normalizer2`, available since API 24; app is minSdk 26). No extra
   dependency, fully offline. If a Dart-side NFC is ever needed, `unorm_dart` (BSD) is the
   open-source fallback, but the design avoids it.
2. A **canonical search-key fold** (`SearchNormalizer`, pure Dart, unit-tested), applied only
   to a throwaway comparison key — the real page text and query keep their exact bytes:
   - **Unify the two chillu encodings** into one canonical form, so both spellings match while
     meaning is preserved.
   - **Treat ZWJ/ZWNJ as ignorable in the match key only** (they are Unicode
     `Default_Ignorable_Code_Point`; the Unicode Collation Algorithm ignores them by default).
     They are **not** removed from stored or displayed text, so shaping stays correct.
   - **Optional accent-insensitive mode** for Devanagari Sanskrit (fold away Vedic accents).
   - **Optional strict/exact mode** keeps ZWJ/ZWNJ significant.
3. **Grapheme-cluster-aware matching** (Dart `characters`) so a match never splits a base
   letter + vowel-sign cluster.

**Highlight back-mapping.** Normalization changes string length, so `SearchNormalizer` keeps an
index map: normalized-key offset → original character index → pdfium per-character rectangle
(from `pdfrx`'s `PdfPageText`). Matches found in the normalized key are mapped back to the
correct on-page rectangles for highlighting and jump-to-match.

**Script detection.** A small helper detects Malayalam (`U+0D00–U+0D7F`) and Devanagari
(`U+0900–U+097F`, plus Devanagari Extended `U+A8E0–U+A8FF` and Vedic Extensions
`U+1CD0–U+1CFF`) to pick the right fold and to drive the garbled-extraction guard.

`SearchNormalizer` lives in the shared core (`core/search/` or `features/reading/domain/`) so it
is plain, testable Dart, and is reused by search, copy-match, and any find-in-text feature.

---

## 7. Platform channels (native Kotlin)

Some work has no first-class Flutter package and runs in native Kotlin behind method channels,
wrapped by Dart classes in `core/platform/`:

- **PdfBox-Android** (Apache 2.0) — merge, split, reorder/rotate/delete pages, encrypt/decrypt,
  text extraction, metadata, form field reads, and annotation export into a copy.
- **Signature module** — PdfBox-Android reads the signature and ByteRange; **Bouncy Castle**
  (the **repackaged** artifact, to avoid Android's stripped built-in Bouncy Castle causing
  classloader conflicts) verifies the PKCS#7 / CMS data; Android's built-in `CertPathValidator`
  checks the certificate chain and revocation.
- **Print service** — registering as an Android print service to accept print jobs from other
  apps (the riskier, later part of the printer feature).

---

## 8. Data / database

- **sqflite** with **WAL on** and **foreign keys on**, both applied in `onConfigure` (runs per
  connection); versioned, append-only, atomic migrations covered by upgrade-path tests. The
  migration map lives in `core/storage/migrations.dart` and runs inside a transaction via
  `AppDatabase`.

| Version | Adds | Purpose | State |
|---|---|---|---|
| 1 | base/meta table | schema baseline | **current** |
| 2 | `recent_files`, `reading_positions` | recents + last-read page (keyed to fingerprint) | Phase 1 |
| 3 | `annotations` | overlay layer (fingerprint + page + position + type + payload) | Phase 5 |
| 4 | `trust_store` | user-added signing certificates | Phase 7 |

- **File identity = content fingerprint** (file size + hash), with the persisted URI as a fast
  path, so reading positions, bookmarks, and overlay annotations survive move / rename / re-pick.
  A modified file is treated as a **new document** — old positions and annotations are not applied.

---

## 9. Initialization sequence (`main()`)

Order (engineering standard §4.5, §11.1). Each step degrades safely rather than crashing silently:

1. `WidgetsFlutterBinding.ensureInitialized()`.
2. Global error boundaries: `FlutterError.onError` (log), `PlatformDispatcher.instance.onError`
   (log + suppress), release `ErrorWidget.builder` → `SafeErrorFallback`.
3. `AppLogger.init()`.
4. Database open + migrate (`AppDatabase.open()`).
5. Config load: `SharedPreferences.getInstance()` + `ConfigService.loadAndVerify()`.
6. Lifecycle observer (`AppLifecycleService.init()`).
7. `runApp(ProviderScope(overrides: …, child: PdfApp()))`.

Global error boundaries are installed **first** (before logging/db) so early-startup failures are
still captured — a small, deliberate reordering of the standard §4.5 list.

---

## 10. Errors & logging

- **Errors** — a sealed `AppException` hierarchy (`StorageException`, `ValidationException`,
  `PdfException`, …) with error boundaries and a `SafeErrorFallback`. Services throw typed
  exceptions; state layers map them to UI states. User messages stay human-readable; internal
  detail goes to `cause` + logs.
- **Logging** — `AppLogger` over the `logger` package. `trace`/`debug` are gated to the dev
  flavor. It **never** logs secrets or PDF passwords (engineering standard §14.3). Log
  rotation / file output is not enabled yet (reconsider under §14.4 when disk logging is added).

---

## 11. Settings screen + About config

A single Settings screen with preferences grouped into Material 3 card sections. Non-sensitive
settings persist via `shared_preferences`; any secret material uses `flutter_secure_storage`.

Sections:

1. **Appearance** — theme (light / dark / sepia / follow system), font scaling, default view
   mode (single / continuous / two-page), default fit.
2. **Reading** — search defaults, remember-last-page on/off.
3. **Speech (TTS)** — English on/off, **Malayalam TTS** toggle with the guided install /
   auto-disable behavior (checks the `ml-IN` voice; guides install via `INSTALL_TTS_DATA`,
   system TTS settings, or the Play Store Google TTS page; never shows a dead button).
4. **Files** — recents management, default save location behavior for copy-on-write output.
5. **Security** — signature trust store management (view / add / remove certificates), optional
   app-lock, screenshot protection.
6. **About** — **reads its values from a config file**, not hardcoded strings.

### 11.1 About section + config file

`assets/config/app_config.json` is the single source of truth for the About screen. A
`ConfigService` loads it at startup (via `rootBundle`) into a typed `AppConfig` model. The About
section shows app name, description, version/build (cross-checked with `package_info_plus`), and
flexible `details` entries (Author, Email with `mailto:` behavior, License note). Changing the
About content is a config edit, not a code change.

```json
{
  "appName": "PDF App",
  "description": "Open, read, annotate, extract, and reorganize PDF files. Print to PDF.",
  "version": "1.0.0",
  "build": "1",
  "details": {
    "Author": "Sreeraj P",
    "Email": "sreerajp@zohomail.in",
    "License": "All libraries used are open source."
  }
}
```

---

## 12. Security architecture

Full rules are in [security-rules.md](security-rules.md). In summary:

- **Untrusted input everywhere** — every opened PDF is validated before use; parsers have
  failure paths; the app never crashes on bad data.
- **Scoped storage / SAF only** — no broad storage permission, no in-app browser; persistable
  URI permissions for recents; handle denied or stale URIs gracefully.
- **Copy-on-write** — page operations write a new file; write access to the original is not
  required, so the original is never corrupted.
- **Local signature verification** — PKCS#7 / CMS verified on-device (native Bouncy Castle +
  `CertPathValidator`). "Globally trusted" = bundled Adobe AATL / EU EUTL lists, **not** the
  Android TLS CA store. Green tick only for a signature that truly verifies against a trusted cert.
- **No secret logging** — file contents, PDF passwords, and key material are never logged, even
  in debug builds; PDF passwords live only in memory for the operation (never in
  `shared_preferences`).
- **Offline by design** — no telemetry, no upload of document content without an explicit user
  action (share / export). Release manifest requests no `INTERNET` unless a specific optional
  online feature needs it.

---

## 13. Platform / build

- **Android only.** minSdk 26, Java 17, AGP 8.x, Gradle 8.14, Impeller default.
- **Localization** — `flutter_localizations` + generated `AppLocalizations`; supported locales
  `en` and `ml`. Config in `l10n.yaml`; strings in `lib/l10n/app_en.arb` and `app_ml.arb`.
- **Flavors** — `dev` / `prod` in `android/app/build.gradle.kts`.
- **Offline** — the manifest requests no `INTERNET` permission.

---

## 14. Non-functional requirements

- **Large files** — PDFs up to a few hundred MB should open (pdfium lazy page loading); above
  the limit, a clear warning and a degraded (raw paged) mode instead of crashing.
- **File identity** — reading positions, bookmarks, and overlay annotations keyed to a content
  fingerprint (size + hash), URI as a fast path; a modified file is a new document.
- **Offline** — full offline operation; only opening remote links is an optional online part.
- **Error handling** — corrupt / truncated / empty / password-protected files show friendly
  messages; every parser and platform call has a typed failure path.
- **Performance & memory** — fast open, smooth scrolling, bounded memory; prefer lazy page
  loading; heavy work (extraction, compression, image encode) off the UI isolate.
- **Accessibility & localization** — support system font scaling and screen readers where
  practical; localizable UI (at least English and Malayalam).

---

## 15. Testing strategy

- **Unit** — fingerprint util, config loader, exception mapping, TTS state machine, signature
  trust rules, conversion service.
- **Widget** — viewer states, scanned-PDF notice, Malayalam-toggle install flow, annotation
  canvas, signature badge states.
- **Integration** — open → read → reopen-at-last-page; page-op copy-on-write leaves the original
  intact; encrypt/decrypt round-trip; DB upgrade v1 → current; offline (airplane-mode) no-network
  check.
- **Complex-script search** — `SearchNormalizer` unit tests: NFC equivalence, chillu
  atomic ⇄ ZWJ-sequence unify, ZWJ/ZWNJ ignored in the key, Devanagari nukta precomposed ⇄
  combined, accent-insensitive Sanskrit mode, strict mode, and offset back-mapping onto the
  correct character rectangles.
- **Fixtures** — deterministic test PDFs under `test/fixtures/`: text PDF, scanned PDF, signed
  PDF, Malayalam PDF, **Sanskrit PDF (Devanagari and Malayalam-script samples)**, corrupt PDF,
  large PDF.

---

## 16. Known risks / follow-ups

- Real release signing config (keystore + `key.properties`) is added in Phase 8 — see
  [release-signing.md](release-signing.md).
- Log rotation / disk log output is not yet implemented (§14.4).
- 16 KB page-size compliance to be verified once native `.so`-bearing dependencies (pdfrx,
  PdfBox, Bouncy Castle) are added in later phases.
