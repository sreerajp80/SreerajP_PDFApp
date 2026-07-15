# PDF App — Implementation Plan

**Status:** in_progress

This document is the full build plan for the **SreerajP PDF App**, a Flutter Android app for
"everything PDF". It is written from two source documents in `docs/`:

- `docs/PDF-Idea.md` — what the app must do (features, risks, library choices, constraints).
- `docs/GUIDELINES_MANIFEST.md` — the pointer to my shared Flutter guidelines (the master
  rulebook every app follows).

Read this plan top to bottom. It is split into **phases**. Each phase says what the issue is,
what to build, and which files change. The matching progress tracker is
`docs/pdf-app-implementation-progress.md`.

---

## 1. What we are building (in one paragraph)

An offline Android app, built in Flutter, that opens and reads PDF files, lets the user search,
copy, and listen (text-to-speech in English and Malayalam), annotate on an app-side overlay
layer, extract text/images/metadata, do page operations (merge, split, reorder, rotate, delete,
compress, encrypt/decrypt) always as a **new copy**, act as a **print-to-PDF target** for other
apps, and **verify PDF digital signatures** against a custom trust store. Only **open-source**
libraries are allowed.

---

## 2. Rules this plan must obey (from the guidelines)

These are hard rules pulled from the shared guidelines. Every phase must respect them.

- **Applicability profiles in force:** `Core Baseline` + `Production App Extension`. We also
  adopt **selected `Sensitive Data Extension` controls** because the app handles PDF passwords
  (encrypt/decrypt) and a signature trust store — see §11. It is *not* a full sensitive-data app
  (no accounts, no PII store), so we take the relevant controls, not the whole profile.
- **Open source only.** No Syncfusion, PSPDFKit, or Apryse — even their free tiers. Chosen stack:
  `pdfrx` (pdfium) for rendering, **PdfBox-Android** (Apache 2.0) for page ops/data, **Bouncy
  Castle** + Android `CertPathValidator` for signatures.
- **Folder structure** follows `guideline.md §3`. The About-screen config pattern
  (`assets/config/app_config.json`, `lib/core/config/app_config.dart`,
  `lib/core/config/config_service.dart`) is **fixed and mandatory**.
- **Copy-on-write.** Every page operation writes a new file. The original is never changed.
- **Scoped storage only.** Files come through the system picker (SAF) and "Open with" intents.
  No broad storage permission, no in-app file browser. Take persistable URI permissions.
- **File identity = content fingerprint** (size + hash). Reading positions, bookmarks, and
  overlay annotations are keyed to it. A changed file is treated as a new document.
- **minSdk 26** (Android 8.0). Fully **offline** — the release manifest must not request
  `INTERNET` unless a specific optional online feature needs it (opening remote links).
- **Never crash** on bad input. Corrupt, truncated, encrypted, or empty files show a friendly
  message. Every parser has a failure path.
- **Definition of Done** (engineering standard §23): `flutter analyze` clean, `flutter test`
  passing, `dart format` clean, tests added for changed logic, no secrets committed, obfuscated
  release builds, size budget checked.

---

## 3. Technology decisions (locked for this plan)

| Concern | Choice | Why |
|---|---|---|
| Rendering | `pdfrx` (pdfium) | BSD, lazy page loading, handles large files |
| Page ops + data | PdfBox-Android via a Kotlin platform channel | Apache 2.0, does merge/split/encrypt/extract |
| Signatures | Bouncy Castle (repackaged artifact) + `CertPathValidator`, native Kotlin | Only open-source path for PKCS#7/CMS |
| State management | **Riverpod** (one pattern for the whole app) | Guideline wants one clear way; good for async |
| Navigation | **go_router**, routes centralized | Guideline §6.9 wants centralized routes |
| Local database | **sqflite** (WAL on, FKs on) | reading positions, bookmarks, annotations, trust store |
| Key-value | `shared_preferences` | non-secret settings (theme, TTS toggle) |
| Secure storage | `flutter_secure_storage` | any secret material (see §11); **not** SharedPreferences |
| TTS | `flutter_tts` | English + Malayalam, with voice checks |
| Logging | `logger` behind `AppLogger` | guideline §14 |
| Flavors | `dev` + `prod` | guideline §5 |
| Structure tier | **Tier 2 feature-first** | app is large and multi-domain (viewer, edit, sign, print) |

> **Tier note.** The app is big enough that Tier 2 (feature-first) is justified from the start.
> The fixed `lib/core/config/` About path still applies unchanged.

---

## 4. Target folder structure (Tier 2)

```text
lib/
  main.dart                     # thin: init sequence then runApp
  app/
    app.dart                    # root MaterialApp.router
    routing/                    # go_router routes (centralized)
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
```

`test/` mirrors `lib/`. Native Kotlin code lives under `android/` only where the platform forces
it (PdfBox, signatures, print service).

---

## 5. Phase plan (build order)

Each phase is shippable and testable on its own. Later phases depend on earlier ones. The
"Files" lists are the main touch points, not every file.

### Phase 0 — Project scaffolding & foundation
**Issue:** There is no Flutter project yet — only `docs/`. Nothing can be built until the skeleton,
init sequence, and cross-cutting services exist.

**Build:**
- `flutter create` the app; set package id, minSdk 26, Java 17, AGP 8.x (not 9), Impeller default.
- Folder structure from §4. `analysis_options.yaml` from engineering standard §16.1.
- About config pattern: `assets/config/app_config.json`, `AppConfig`, `ConfigService`, About screen.
- `AppConstants` (db name, table names, method-channel ids, size thresholds).
- Flavors `dev`/`prod` with `AppFlavorConfig` (two-variable pattern, §5.2 of standard).
- `main()` init sequence (standard §4.5): binding → db open+migrate → config load → logging →
  lifecycle observer → global error handlers (`FlutterError.onError`,
  `PlatformDispatcher.instance.onError`, release `ErrorWidget.builder` → `SafeErrorFallback`) →
  `runApp`.
- `AppException` sealed hierarchy; `AppLogger`; `AppLifecycleService`.
- Theme tokens + light/dark/sepia; Material 3; localization delegates + `en` + `ml`, `l10n.yaml`.
- go_router with placeholder routes (Home, Viewer, Settings, About).
- sqflite bootstrap with versioned migrations (WAL on, FKs on), schema v1 = empty base tables.
- Riverpod `ProviderScope` at root.
- `.gitignore` including keystore rules (`guideline.md §2`).

**Files:** whole skeleton under `lib/`, `android/app/build.gradle.kts`, `pubspec.yaml`,
`analysis_options.yaml`, `l10n.yaml`, `assets/config/app_config.json`, `README.md`,
`docs/architecture.md` (fill in from `architecture.md` template).

**Done when:** app launches to an empty Home + working About + Settings, analyze/test/format clean.

---

### Phase 1 — Core viewing & navigation (the MVP)
**Issue:** The primary job is to open and read a PDF. Nothing else matters if this is weak.

**Build:**
- Open PDF via SAF picker and "Open with" intent; take persistable URI permission; recents list
  in DB.
- `pdfrx` render: single page, continuous scroll, two-page/book view.
- Zoom in/out, pinch-to-zoom, fit-to-width, fit-to-page.
- Jump to page number; table of contents / outline tree; thumbnail grid.
- Reading position: content fingerprint (size + hash) util; remember last-read page per file.
- Night/dark and sepia (color invert for comfort); theme switch.
- Large-file handling: lazy pages; above a threshold show a warning + degraded paged view.
- Error states for corrupt/truncated/empty/password-protected files (friendly, no crash).

**Files:** `features/viewer/**`, `core/storage/fingerprint.dart`, DB migration v2
(recent_files, reading_positions), routing, `core/platform/` open-intent handling.

**Done when:** user can open, read, navigate, zoom, and reopen at last page; large and broken
files behave.

---

### Phase 2 — Reading: search, copy, metadata, TTS
**Issue:** Reading comfort features and the shared modules other features reuse.

**Build:**
- Text search across the document with highlight + jump between matches (needs text layer).
- **Complex-script search (Malayalam & Sanskrit) done properly** — the same word can be stored
  in different Unicode forms, so raw substring search fails. Build:
  - **NFC normalization** of extracted text and query at the extraction boundary, using the
    device's built-in ICU (`android.icu.text.Normalizer2`; no extra dependency, offline).
  - **`SearchNormalizer`** (pure Dart, unit-tested) that builds a canonical *comparison key*
    (the real text is never changed): unify the two Malayalam chillu encodings; treat ZWJ/ZWNJ
    as ignorable in the key only (they are Unicode default-ignorable); optional
    accent-insensitive mode for Devanagari Sanskrit; optional strict mode.
  - **Grapheme-cluster-aware matching** (`characters`) so matches never split a base + vowel
    cluster.
  - **Highlight offset back-mapping**: normalized-key offset → original char index → pdfium
    per-char rectangle (`pdfrx` `PdfPageText`) for correct highlight boxes and jump-to-match.
  - **Script detection** (Malayalam `U+0D00–U+0D7F`; Devanagari `U+0900–U+097F` + Devanagari
    Extended + Vedic Extensions) to pick the fold and drive the garbled-extraction guard.
  - Sanskrit may be in Devanagari *or* Malayalam script — both use the same pipeline.
- Select and copy text.
- Metadata: file size, dates, plus PDF fields (title, author, page count, creation date) via
  PdfBox-Android channel.
- **Scanned-PDF detection:** if no text layer, show the "no selectable text" notice and disable
  search, copy, extraction, and TTS gracefully. OCR is out of scope.
- **TTS shared module:** English + Malayalam. Malayalam is a Settings toggle. On enable, check
  `ml-IN` voice; if missing, guide install (`INSTALL_TTS_DATA`, system TTS settings, or Play
  Store Google TTS). Auto-disable with a notice if the voice later disappears. Reader screens ask
  the module for state — never a dead button.
- **Garbled-extraction guard:** detect missing/garbled complex-script (Malayalam) extraction and
  tell the user instead of reading nonsense or showing empty results.

**Files:** `features/reading/**`, `core/platform/pdfbox_channel.dart`, Kotlin PdfBox metadata +
text extraction, `features/settings/**` (Malayalam toggle), shared `TtsService`.

**Done when:** search/copy/metadata work on text PDFs; scanned PDFs degrade cleanly; TTS works in
both languages with the full install/guide/auto-disable behavior.

---

### Phase 3 — Extraction & conversion
**Issue:** Turn PDF content into other useful outputs, and share them.

**Build:**
- Extract plain text (per page / range). Extract embedded images. Read form field values.
- Single conversion service: PDF → text, PDF → images (PNG/JPEG), page/range export as image.
- Share via Android share sheet: the file, or exported output.
- Heavy work (large extraction, image encode) runs off the UI isolate (`compute`).

**Files:** `features/extraction/**`, `core/platform/pdfbox_channel.dart` (extract calls),
Kotlin PdfBox extraction, `ShareService`.

**Done when:** text/images/forms extract correctly; conversions produce valid files; share works.

---

### Phase 4 — Page operations (always copy-on-write)
**Issue:** Editing pages without ever touching the original.

**Build:**
- Merge multiple PDFs; split into separate files; reorder / rotate / delete pages.
- Compress (best-effort — clearly labelled as such).
- Password protect / unlock (encrypt / decrypt) — passwords handled per §11 (not logged, not in
  SharedPreferences).
- Every op writes a **new copy** to a user-chosen location; original untouched.

**Files:** `features/page_ops/**`, `core/platform/pdfbox_channel.dart` (page-op calls),
Kotlin PdfBox merge/split/reorder/encrypt.

**Done when:** each op produces a correct new file, original verified unchanged; encrypt/decrypt
round-trips; passwords never leak to logs.

---

### Phase 5 — Annotation overlay layer (advanced)
**Issue:** Open-source renderers are view-only, so annotation is built by us as an overlay.

**Build:**
- App-side overlay: highlight, underline, strikethrough, sticky notes/comments, freehand ink,
  page bookmarks. Stored in the app DB, keyed to fingerprint + page + position, drawn on top of
  the rendered page. Original PDF never modified.
- Optional export: write real PDF annotations into a **copy** via PdfBox-Android.
- Clear messaging: overlay annotations are visible only in this app until exported.

**Files:** `features/annotation/**`, DB migration (annotations table), Kotlin PdfBox annotation
export.

**Done when:** all annotation types persist and redraw at correct positions after reopen; export
produces a valid annotated copy; original untouched.

---

### Phase 6 — PDF printer for Android ("print to PDF")
**Issue:** Other apps should be able to send content here to be saved as PDF; and print PDFs out.

**Build (in risk order):**
1. **Share / "Open with" → save-as-PDF** (simpler, first): register as a share target for
   printable content; save incoming content as a new PDF (copy-on-write).
2. **Print a PDF out** to a real printer via Android's standard print framework; print a page
   range or extracted text.
3. **System print service** (native Kotlin, later): register as an Android print service so other
   apps' Print menus can target this app. Treated as a later, riskier item.

**Files:** `features/printer/**`, `android/**` print service + intent filters, method channel.

**Done when:** step 1 and step 2 work end to end; step 3 tracked as a follow-up if deferred.

---

### Phase 7 — Digital signature verification (highest risk, native)
**Issue:** Real cryptography with a custom trust store. No first-class Flutter library exists.

**Build:**
- Native Kotlin behind a platform channel: PdfBox-Android reads the signature + ByteRange;
  Bouncy Castle (repackaged artifact, to avoid Android's stripped BC classloader conflict)
  verifies the PKCS#7/CMS data; Android `CertPathValidator` checks chain + revocation.
- Custom trust store: user can add a signing certificate to the app's trust store.
- "Globally trusted" = a bundled certificate list (Adobe AATL / EU EUTL), **not** the Android
  system CA store (that store is for TLS).
- UI: show a **green tick** on the signature part when trusted (after add, or already globally
  trusted); clear "not trusted / unknown" states otherwise.

**Files:** `features/signature/**`, DB migration (trust_store table), `android/**` Kotlin
signature module + Bouncy Castle dependency + bundled AATL/EUTL lists, method channel.

**Done when:** a signed test PDF verifies correctly against a known cert; green tick logic matches
the trust rules; unknown/invalid signatures are shown honestly.

---

### Phase 8 — Hardening & release
**Issue:** Ship it well: accessibility, performance, size, signing, CI, docs.

**Build:**
- Accessibility pass (standard §7): touch targets, contrast in all themes, semantics on custom
  widgets (viewer, annotation canvas), text scaling 1.0/1.5/2.0, TalkBack on critical flows.
- Performance pass (standard §10): scroll jank under budget, image cache limits, isolates for
  heavy ops, startup under 2s, size budget checked via `--analyze-size`.
- Release keystore at `android/<name>.jks` + `android/key.properties` (git-ignored);
  obfuscated release builds `--obfuscate --split-debug-info=...`.
- CI (standard §19): pub get, format check, analyze, test, dev+prod builds.
- 16 KB page-size check on release (standard §5.3.1). Offline check: no `INTERNET` in merged
  manifest unless justified.
- Fill in `docs/architecture.md`, `docs/security.md` (for the trust store + passwords), `README`,
  `CHANGELOG`, run through `release_process.md`.

**Done when:** all Definition-of-Done items pass for `Core Baseline` + `Production App Extension`
+ the selected sensitive-data controls; a signed obfuscated release build is produced.

---

## 6. Database schema (planned migrations)

| Version | Adds | Purpose |
|---|---|---|
| 1 | base/meta table | schema baseline |
| 2 | `recent_files`, `reading_positions` | Phase 1 recents + last-read page (keyed to fingerprint) |
| 3 | `annotations` | Phase 5 overlay layer (fingerprint + page + position + type + payload) |
| 4 | `trust_store` | Phase 7 user-added signing certificates |

Migrations are append-only, atomic, WAL on, FKs on, and covered by upgrade-path tests
(standard §13, §18.2). Current version recorded in `docs/architecture.md §11`.

---

## 7. Cross-cutting behaviors (apply to every phase)

- **Copy-on-write** for anything that writes a PDF.
- **Never crash** — every parser and platform call has a typed failure path mapped to a friendly
  UI state (loading / empty / success / error, standard §6.3).
- **No secrets in logs** — PDF passwords and any key material are never logged (standard §14.3).
- **Offline** — no network call without an explicit user action.
- **Heavy work off the UI isolate** — extraction, compression, image encode use `compute`.
- **`const` everywhere it compiles; `ListView.builder` for unbounded lists; `AppLogger` only.**

---

## 8. Testing strategy

- **Unit:** fingerprint util, config/loader, exception mapping, TTS state machine, trust rules,
  conversion service, **`SearchNormalizer`** (NFC equivalence, chillu unify, ZWJ/ZWNJ ignored
  in key, Devanagari nukta precomposed ⇄ combined, accent-insensitive + strict modes, offset
  back-mapping).
- **Widget:** viewer states, scanned-PDF notice, Malayalam-toggle install flow, annotation canvas,
  signature badge states.
- **Integration:** open→read→reopen-at-page; page-op copy-on-write leaves original intact;
  encrypt/decrypt round-trip; DB upgrade v1→current; offline (airplane-mode) no-network check.
- Deterministic test PDFs kept under `test/fixtures/` (text PDF, scanned PDF, signed PDF,
  Malayalam PDF, **Sanskrit PDF — Devanagari and Malayalam-script samples**, corrupt PDF,
  large PDF).

---

## 9. Risk register (from `PDF-Idea.md`, with our handling)

| Risk | Phase | Handling |
|---|---|---|
| Signature verification (highest) | 7 | Native Kotlin + repackaged Bouncy Castle; bundled AATL/EUTL; late phase |
| Non-destructive annotation | 5 | App-side overlay in DB; optional export to a copy |
| Malayalam/Sanskrit extraction garbled | 2 | Detect missing/garbled ToUnicode; warn user, don't read nonsense |
| Complex-script search correctness (Malayalam & Sanskrit) | 2 | NFC + `SearchNormalizer` (chillu unify, ZWJ/ZWNJ ignorable-in-key, optional accent-insensitive/strict) + grapheme matching + highlight back-mapping |
| Malayalam TTS voice missing | 2 | Toggle + check + guided install + auto-disable + never a dead button |
| Very large PDFs | 1 | Lazy pdfium pages; warning + degraded mode above threshold |
| System print service | 6 | Share→save-as-PDF first; native print service is a later item |
| Compression is weak | 4 | Best-effort, clearly labelled |

---

## 10. Sequencing summary

Phase 0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8.
Phases 3–6 depend on the PdfBox-Android channel built in Phase 2. Phase 7 is intentionally last
because it is the highest-risk, native-heavy feature. Each phase ends with its own change-log
entry in `change_log/` and a progress-tracker update.

---

## 11. Security posture (selected Sensitive Data controls)

We are not a full sensitive-data app, but two areas need care:

- **PDF passwords (encrypt/decrypt):** never stored in SharedPreferences, never logged; held only
  in memory for the operation; if we ever persist one it goes to `flutter_secure_storage`.
- **Signature trust store:** holds public certificates (not secret), but integrity matters — only
  the user adds certs, and the bundled AATL/EUTL lists are read-only assets.
- Release builds obfuscated; `android:debuggable=false`; minimal permissions; input from opened
  files treated as untrusted. Details recorded in `docs/security.md` at Phase 8.

---

## 12. Approval

This plan needs explicit approval before any project code is written (per the global workflow
rules). The plan document and the progress document may be created now; **no `lib/`, `android/`,
or `pubspec` code will be created until you approve.**

**Do you approve this plan?**
