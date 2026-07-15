# Plan — Phase 2: Reading (search, copy, metadata, TTS)

**Status:** completed

**Approved:** 2026-07-14. NFC decision: **`unorm_dart`** (pure Dart) — the default option.

This plan implements **Phase 2** of `docs/pdf-app-implementation-plan.md`: reading-comfort
features and the shared modules other phases reuse — text search (with proper Malayalam &
Sanskrit handling), select-and-copy, document metadata, scanned-PDF detection, and the shared
Text-to-Speech (TTS) module (English + Malayalam).

Written in plain, simple English per the project rules. No project code is written until you
approve this plan.

---

## 1. What the issue is

After Phase 1 the app can open, render, and navigate a PDF, but it cannot **search, copy,
read aloud, or show file/PDF details**. Phase 2 adds those. Three things make it non-trivial:

1. **Complex-script search.** Plain substring search fails for Malayalam and Sanskrit, because
   the same visible word can be stored in different Unicode forms. This is designed in
   `docs/architecture.md §6.1` and must be built properly (NFC + a canonical fold + grapheme
   matching + highlight back-mapping + script detection).
2. **Scanned / no-text PDFs.** When a PDF has no text layer, search / copy / TTS must degrade
   with a clear notice, never a dead button or a silent failure.
3. **Malayalam TTS.** The `ml-IN` voice may be missing. The module must report its state and
   guide install; reader controls must never be a silently broken button.

---

## 2. What we will build (in build order)

Phase 2 is built in five ordered steps. Each step is self-contained, keeps
`flutter analyze` / `flutter test` / `dart format` clean, and is verified before the next
starts. Progress is ticked in `docs/pdf-app-implementation-progress.md` per step.

### Step 1 — PdfBox-Android channel scaffold + metadata

- Add **PdfBox-Android** (`com.tom-roush:pdfbox-android`, Apache 2.0 — open-source rule met) to
  `android/app/build.gradle.kts`. Initialize `PDFBoxResourceLoader` once at native startup.
- Native Kotlin handler for the existing method-channel id `AppConstants.channelPdfBox`
  (`in.sreerajp.pdfapp/pdfbox`). First method: `readMetadata(path)` → returns title, author,
  subject, keywords, creator, producer, creation date, modification date, page count,
  encrypted flag, PDF version.
- Dart wrapper `core/platform/pdfbox_channel.dart` (`PdfBoxChannel`) with a typed
  `PdfMetadata` model and a `StorageException`/`PdfException` failure path (never crashes on a
  bad file — returns a typed error the UI maps to a friendly message).
- A **metadata sheet** in the reader: file name, file size, dates (from the DB recent entry /
  file), plus the PDF fields above. Reached from a new reader app-bar menu item.

Why PdfBox for metadata (not pdfrx): pdfrx does not expose PDF document info fields cleanly;
PdfBox reads them reliably. Text search still uses pdfrx (see Step 3) because only pdfrx gives
per-character rectangles needed for highlights.

### Step 2 — Text services (pure Dart, heavily unit-tested)

New shared code under `lib/core/search/`:

- **`ScriptDetector`** — detects Malayalam (`U+0D00–U+0D7F`) and Devanagari
  (`U+0900–U+097F` + Devanagari Extended `U+A8E0–U+A8FF` + Vedic Extensions `U+1CD0–U+1CFF`).
  Drives fold choice and the garbled-extraction guard.
- **`SearchNormalizer`** — builds a throwaway **comparison key** from text; the real text is
  never changed. Steps: **NFC** → **fold** (unify the two Malayalam chillu encodings; treat
  ZWJ/ZWNJ `U+200C`/`U+200D` as ignorable **in the key only**; optional accent-insensitive mode
  that folds Devanagari/Vedic accents; optional strict mode that keeps ZWJ/ZWNJ significant).
- **Cluster-granular index map.** Normalization changes string length and can reorder combining
  marks, so we map at **grapheme-cluster** granularity (Dart `characters`), which is also the
  natural highlight unit: each cluster carries its original char-index range, and the key
  records key-offset → cluster boundaries. This is what makes highlight back-mapping correct
  and simple, and it sidesteps code-unit index drift from NFC.

**NFC choice (a deviation from the locked design — please confirm in approval).**
`docs/architecture.md §6.1` locks NFC to *native ICU* (`android.icu.text.Normalizer2`) with
`unorm_dart` (BSD) named as the explicit fallback. I recommend using the **`unorm_dart` (BSD,
open-source)** fallback here, done in pure Dart per grapheme cluster, because:
- back-mapping stays exact and testable in one Dart pass (a native round-trip returns an opaque
  normalized string with no index map, which breaks highlight mapping across the NFC step);
- no per-page platform round-trips; `SearchNormalizer` stays pure Dart and fully unit-testable
  on the host (no device needed);
- it is open-source and offline, so no project rule is broken.

If you prefer to keep native ICU exactly as locked, I will instead add an `nfcNormalize` method
to the PdfBox channel and map at cluster granularity around it — more moving parts, slightly
slower, same end behavior. **Default (unless you say otherwise): `unorm_dart`.**

### Step 3 — Page text source + search engine

- **`PdfTextSource`** (`features/reading/data/`) — wraps pdfrx `PdfPageText` per page: pulls
  `fullText` + per-character rectangles, splits into grapheme clusters with rects, and builds
  the comparison key via `SearchNormalizer`. Cached per page, loaded lazily.
- **Scanned / garbled guard** — sample pages; if there is no usable text layer, mark the doc
  "no selectable text". If complex-script text looks garbled/missing (script detected but
  extraction empty/nonsense), flag it. Both drive the notice + disabling in Step 4/5.
- **Search engine** (`SearchController`, Riverpod) — searches across the document on a
  background isolate where the work is heavy (`compute`), returns matches as (page, cluster
  range → union rect), supports next/previous match and a match counter. Modes: normal,
  strict, accent-insensitive.

### Step 4 — Search UI, highlight overlay, copy

- Reader **search bar** (open from app-bar): query field, result count, next/previous, close.
- **Highlight overlay** drawn over the rendered page for matches, with the current match
  emphasized; jump-to-match scrolls/goes to the page and centers the match.
- **Select-and-copy** of page text (pdfrx text selection → clipboard), with a copy affordance.
- **Scanned-PDF notice**: when there is no text layer, show "This PDF has no selectable text"
  and disable search / copy / TTS gracefully (controls visible but clearly unavailable with a
  reason — never a dead button).
- New `l10n` strings (en + ml) for all of the above.

### Step 5 — Shared TTS module (English + Malayalam)

- Add **`flutter_tts`**. Build **`TtsService`** (`features/reading/`, shared) as a small **state
  machine**: `idle / speaking / paused`, plus a **capability state** per language
  (`ready / needsInstall / unavailable`). Pure-Dart-testable core with a thin plugin adapter.
- **Reader TTS controls**: play / pause / stop, read from current page. Reads the on-screen
  page text (from `PdfTextSource`, so it matches what search/copy see). Disabled with a reason
  on scanned PDFs (never a dead button).
- **Malayalam toggle** in Settings (persisted via `shared_preferences`, new key). On enable,
  check the `ml-IN` voice:
  - present → ready;
  - missing → guide install: fire `ACTION_INSTALL_TTS_DATA`, offer "open TTS settings", and a
    Play-Store link for Google TTS. These use small **native intents** (added to the open/
    platform channel or a tiny `tts` channel) and/or `url_launcher` for the store link.
  - **Auto-disable with a notice** if the voice later disappears.
- Reader screens **ask the module for state** and render ready / needs-install / unavailable —
  the project's "never a dead button" rule.

---

## 3. Files to change / add

**Native (Android):**
- `android/app/build.gradle.kts` — add PdfBox-Android dependency.
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/PdfBoxHandler.kt` (new) — metadata (and the
  `PDFBoxResourceLoader` init); wired from `MainActivity`.
- `MainActivity.kt` — register the PdfBox method channel; add TTS-install / TTS-settings
  intents (or a small separate handler).

**Dart — core:**
- `core/platform/pdfbox_channel.dart` (new) — `PdfBoxChannel` + `PdfMetadata`.
- `core/search/script_detector.dart`, `core/search/search_normalizer.dart`,
  `core/search/cluster_map.dart` (new).
- `core/constants/app_constants.dart` — new pref key(s), any new channel id, sample thresholds.
- `core/errors/app_exception.dart` — a `PdfException` case if not already present.

**Dart — features:**
- `features/reading/data/pdf_text_source.dart` (new).
- `features/reading/domain/` — search match, metadata view models, TTS state types (new).
- `features/reading/presentation/` — search bar, highlight overlay, metadata sheet, TTS
  controls, providers (new).
- `features/viewer/presentation/viewer_screen.dart` — wire search / copy / metadata / TTS into
  the reader UI (app-bar + overlay), respecting the scanned-PDF state.
- `features/settings/presentation/settings_screen.dart` — Malayalam TTS toggle + install flow.
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb` — new strings.

**Dependencies (`pubspec.yaml`):** `flutter_tts`, `unorm_dart` (pending the NFC decision),
`url_launcher` (Play-Store link). `characters` ships with Flutter.

**Tests (`test/` mirrors `lib/`):**
- Unit: `ScriptDetector`; `SearchNormalizer` (NFC equivalence, chillu unify, ZWJ/ZWNJ
  ignorable-in-key, Devanagari nukta precomposed⇄combined, accent-insensitive + strict modes,
  offset/cluster back-mapping); `PdfMetadata` mapping; `TtsService` state machine; search
  match/offset logic.
- Widget: metadata sheet, search bar states, scanned-PDF notice, Malayalam-toggle install flow.
- Fixtures under `test/fixtures/`: text PDF, scanned PDF, Malayalam PDF, **Sanskrit PDF
  (Devanagari and Malayalam-script)**. (Native metadata/extraction is checked on-device;
  host tests cover the pure-Dart logic.)

---

## 4. Rules this phase must obey

- **Open source only** — PdfBox-Android (Apache 2.0), flutter_tts (MIT), unorm_dart (BSD),
  url_launcher (BSD). No banned SDK.
- **Never crash on bad input** — every native call and parser has a typed failure path mapped
  to a friendly UI state.
- **Never a dead button** — search / copy / TTS report ready / unavailable with a reason.
- **Offline** — no network except the optional user-triggered Play-Store link for TTS install.
  Release manifest still requests no `INTERNET` unless that link forces it; if it does, it is
  justified and noted (final call verified in Phase 8).
- **Heavy work off the UI isolate** — search / extraction use `compute` where heavy.
- **No secrets in logs.** (No passwords handled in this phase, but the rule stands.)
- **Definition of Done** — analyze / test / format clean, tests added, dev APK builds, verified
  on device for the native + TTS paths.

---

## 5. Out of scope for Phase 2

- OCR of scanned PDFs (permanently out of scope).
- Extraction-to-file and conversion/share (Phase 3).
- Page operations, annotations, printing, signatures (Phases 4–7).
- Cross-script search (typing one script to find another).

---

## 6. Risks and how we handle them

| Risk | Handling |
|---|---|
| Complex-script match correctness | NFC + `SearchNormalizer` fold + grapheme matching + cluster back-mapping; heavy unit tests |
| Highlight boxes land wrong after NFC | Map at grapheme-cluster granularity (NFC-stable unit), not code units |
| Garbled Malayalam/Sanskrit extraction | Script-detected-but-empty guard → warn, don't show wrong/empty results silently |
| PdfBox increases APK size / init cost | One-time `PDFBoxResourceLoader` init; metadata only in Phase 2; watch size budget (Phase 8) |
| Malayalam TTS voice missing | Toggle + check + guided install + auto-disable + never a dead button |
| Native round-trips slow | Text search uses in-process pdfrx text; PdfBox only for metadata |

---

## 7. Approval

Per the workflow rules, no `lib/`, `android/`, or `pubspec` code will be written until you
approve. One open decision needs your call (see Step 2): **NFC via pure-Dart `unorm_dart`
(my recommendation) or native ICU exactly as locked in architecture.md §6.1.** Default is
`unorm_dart` unless you say otherwise.

**Do you approve this plan?**
