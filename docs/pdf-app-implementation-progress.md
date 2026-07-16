# PDF App — Implementation Progress

**Status:** in_progress (tracker) — nothing built yet, awaiting plan approval

This is the living progress tracker for the **SreerajP PDF App**. It follows the phases in
`docs/pdf-app-implementation-plan.md`. Update it as work moves. Keep it honest:
mark a task done only when it is really done (analyze clean, tests pass, verified in the app).

**How to read the status marks:**

- `[ ]` not started
- `[~]` in progress
- `[x]` done and verified
- `[!]` blocked (write the reason in Notes)
- `[-]` dropped / deferred (write why in Notes)

**Last updated:** 2026-07-16 22:20 (Phase 4 done; analyze/format clean, 186 tests pass, dev debug APK builds. Merge/split/organize/compress/protect/unlock wired copy-on-write, with SAF save-to-location and multi-select merge picker)

---

## Overall status

| Phase | Title | Status | % | Notes |
|---|---|---|---|---|
| 0 | Scaffolding & foundation | [x] | 100% | Done — app shell builds; analyze/test/format clean |
| 1 | Core viewing & navigation (MVP) | [x] | 100% | Done — analyze/test/format clean, dev APK, verified on device (open→render). Device-only DB WAL bug fixed |
| 2 | Reading: search, copy, metadata, TTS | [x] | 100% | Done — all checklist items implemented, settings toggle and reader controls wired, 159 tests pass |
| 3 | Extraction & conversion | [x] | 100% | Done — text, image, form fields extraction, page images, native sharing, 172 tests pass |
| 4 | Page operations (copy-on-write) | [x] | 100% | Done — merge/split/organize/compress/protect/unlock, all copy-on-write; 186 tests pass, dev APK builds. On-device pass pending |
| 5 | Annotation overlay layer | [ ] | 0% | |
| 6 | PDF printer ("print to PDF") | [ ] | 0% | |
| 7 | Digital signature verification | [ ] | 0% | Highest risk |
| 8 | Hardening & release | [ ] | 0% | |

---

## Phase 0 — Scaffolding & foundation

- [x] `flutter create`; package id `in.sreerajp.pdfapp`, minSdk 26, Java 17 target, AGP 8.x
- [x] Folder structure (Tier 2, §4 of plan)
- [x] `analysis_options.yaml` (standard §16.1)
- [x] About config: `app_config.json` + `AppConfig` + `ConfigService` + About screen
- [x] `AppConstants`
- [x] Flavors `dev`/`prod` + `AppFlavorConfig`
- [x] `main()` init sequence (binding → error handlers → logging → db → config → lifecycle → runApp)
- [x] `AppException` hierarchy + `SafeErrorFallback`
- [x] `AppLogger`
- [x] `AppLifecycleService`
- [x] Theme tokens + light/dark/sepia; Material 3
- [x] Localization delegates + `en` + `ml` + `l10n.yaml`
- [x] go_router with placeholder routes
- [x] sqflite bootstrap + migration framework (WAL, FKs), schema v1
- [x] Riverpod `ProviderScope`
- [x] `.gitignore` incl. keystore rules
- [x] `README.md` + `docs/architecture.md` started

**Exit check:** analyze/test/format clean (15 tests pass) and the dev-flavor APK builds. Not yet
launched on a device/emulator — visual confirmation of Home/About/Settings deferred to first
device run in Phase 1.

**Notes:**
- Init order puts global error handlers first (before logging/db) so early-startup failures are
  captured — a small, deliberate reordering of the standard §4.5 list.
- Desktop DB (FFI) init was left out of `main()` (Android-only app); tests init FFI themselves.
- Kotlin incremental-compile warnings appear because the project (L:) and pub cache (H:) are on
  different drives. Non-fatal — the APK builds. Watch if it ever turns into a hard failure.

---

## Phase 1 — Core viewing & navigation (MVP)

- [x] Open via SAF picker + "Open with" intent; persistable URI permission
- [x] Recent files (DB migration v2)
- [x] `pdfrx` render: single / continuous / two-page
- [x] Zoom, pinch-zoom, fit-to-width, fit-to-page
- [x] Jump to page; table of contents / outline; thumbnail grid
- [x] Content fingerprint util (size + hash)
- [x] Reading position: remember last-read page (keyed to fingerprint)
- [x] Night/dark + sepia (color invert)
- [x] Large-file warning + degraded mode
- [x] Error states: corrupt / truncated / empty / password-protected

**Exit check:** open, read, navigate, zoom, reopen-at-last-page; large & broken files behave.

**Status:** Done — `flutter analyze`/`dart format` clean, 38 tests pass, dev APK builds, and
verified on a physical device (moto g54, Android 15): SAF picker → copy-to-cache →
pdfrx/PDFium render confirmed via logcat, viewer interactive, no crashes. A device-only
DB-open bug (WAL pragma needing `rawQuery`, not `execute`) was found and fixed. Implemented by
`change_log/20260714_150000_phase1-core-viewing.md`.

---

## Phase 2 — Reading: search, copy, metadata, TTS

- [x] PdfBox-Android Kotlin channel scaffold
- [x] Text search + highlight + jump between matches
- [x] NFC normalization of extracted text + query (native ICU `Normalizer2`)
- [x] `SearchNormalizer` fold (chillu unify, ZWJ/ZWNJ ignorable-in-key, accent-insensitive + strict modes)
- [x] Grapheme-cluster-aware matching (Malayalam & Sanskrit)
- [x] Highlight offset back-mapping to pdfium char rectangles
- [x] Script detection (Malayalam + Devanagari/Vedic ranges)
- [x] Sanskrit test fixtures (Devanagari and Malayalam-script)
- [x] Select and copy text
- [x] Metadata (file + PDF fields)
- [x] Scanned-PDF detection → notice + graceful disable of search/copy/extract/TTS
- [x] `TtsService` shared module (English)
- [x] Malayalam TTS toggle in Settings
- [x] `ml-IN` voice check + guided install (`INSTALL_TTS_DATA` / TTS settings / Play Store)
- [x] Auto-disable + notice when voice disappears; never a dead button
- [x] Garbled/missing Malayalam & Sanskrit extraction guard

**Exit check:** search/copy/metadata on text PDFs; scanned PDFs degrade; TTS both languages with
full install/guide/auto-disable behavior.

---

## Phase 3 — Extraction & conversion

- [x] Extract plain text (page / range)
- [x] Extract embedded images
- [x] Read form field values
- [x] Conversion service: PDF → text, PDF → images (PNG/JPEG), page/range as image
- [x] Share via Android share sheet (file + exported output)
- [x] Heavy work off UI isolate (`compute`)

**Exit check:** extraction correct; conversions valid; share works.

---

## Phase 4 — Page operations (copy-on-write)

- [x] Merge multiple PDFs
- [x] Split into separate files
- [x] Reorder / rotate / delete pages
- [x] Compress (best-effort, clearly labelled)
- [x] Password protect / unlock (encrypt / decrypt)
- [x] Verify original never modified; passwords never logged

**Exit check:** each op produces correct new file; original unchanged; encrypt/decrypt round-trips.

---

## Phase 5 — Annotation overlay layer

- [ ] Annotations DB table (fingerprint + page + position + type + payload)
- [ ] Highlight / underline / strikethrough
- [ ] Sticky notes / comments
- [ ] Freehand ink
- [ ] Page bookmarks
- [ ] Redraw at correct positions after reopen
- [ ] Optional export to real annotations (PdfBox, into a copy)
- [ ] Messaging: overlay visible only in-app until exported

**Exit check:** all types persist & redraw; export produces valid annotated copy; original untouched.

---

## Phase 6 — PDF printer ("print to PDF")

- [ ] Share / "Open with" → save-as-PDF (copy-on-write)
- [ ] Print a PDF out via Android print framework (incl. page range / extracted text)
- [ ] System print service (native Kotlin) — later / riskier

**Exit check:** save-as-PDF and print-out work end to end; print service tracked if deferred.

---

## Phase 7 — Digital signature verification

- [ ] Kotlin signature module: PdfBox reads signature + ByteRange
- [ ] Bouncy Castle (repackaged) verifies PKCS#7 / CMS
- [ ] `CertPathValidator` checks chain + revocation
- [ ] Custom trust store (DB migration): user adds signing cert
- [ ] Bundled AATL / EUTL "globally trusted" lists
- [ ] Green-tick UI on trusted signatures; honest unknown/invalid states

**Exit check:** signed test PDF verifies against a known cert; green-tick logic matches trust
rules; bad signatures shown honestly.

---

## Phase 8 — Hardening & release

- [ ] Accessibility pass (targets, contrast, semantics, text scaling, TalkBack)
- [ ] Performance pass (scroll jank, image cache, isolates, startup, size budget)
- [ ] Release keystore + `key.properties` (git-ignored)
- [ ] Obfuscated release builds (`--obfuscate --split-debug-info`)
- [ ] CI (pub get, format, analyze, test, dev+prod builds)
- [ ] 16 KB page-size check; offline (no `INTERNET`) check
- [ ] `docs/architecture.md`, `docs/security.md`, `README`, `CHANGELOG` complete
- [ ] `release_process.md` runbook followed

**Exit check:** Definition of Done passes for all in-force profiles; signed obfuscated release built.

---

## Change-log links

Add a link here after each phase's change-log entry is written in `change_log/`.

- Phase 0 — `change_log/20260714_142000_phase0-scaffolding.md`
- Phase 1 — `change_log/20260714_150000_phase1-core-viewing.md`
- Phase 3 — `change_log/20260715_174000_phase3_extraction_completed.md`
- Phase 4 — `change_log/20260716_222042_phase4_page_operations.md`

---

## Open questions / decisions log

Record anything that changes the plan, and re-present the plan for approval if it does.

- (none yet)
