# Plan — Proper Malayalam & Sanskrit search in PDFs

**Status:** completed

## 1. What the issue is

The user wants **search inside PDFs to work properly for Malayalam and Sanskrit text**.

Today the docs cover this only partly:

- `doc/PDF-Idea.md` and `doc/architecture.md` mention **Malayalam** extraction as a risk
  (missing `ToUnicode` → garbled text) and a "garbled-extraction guard", but they say
  nothing about **Sanskrit**, and nothing about making *search matching itself* correct.
- The implementation plan (`doc/pdf-app-implementation-plan.md`) Phase 2 lists "Text search +
  highlight + jump between matches" as one line, with no detail on complex-script handling.

The real gap: even when a PDF *does* have a good text layer, plain substring search **fails**
for these scripts, because the same visible word can be stored in several different Unicode
forms (Malayalam chillu atomic vs. ZWJ sequence; Devanagari nukta precomposed vs. combined;
invisible ZWJ/ZWNJ inside conjuncts; combining-mark order; Sanskrit Vedic accents). So a
user's typed word and the PDF's stored word are "the same" but never match byte-for-byte.

This is a **documentation change only**. No `lib/`, `android/`, or `pubspec` code is written
here. The goal is to record a proven, implementable design so Phase 2 can build it.

## 2. Feasibility (confirmed implementable)

- **In scope / solvable:** PDFs with a real text layer (proper `ToUnicode`). Proper search is
  achievable with the locked open-source stack plus one small pure-Dart normalizer. No banned
  SDK, no network, no OCR.
- **Out of scope / unchanged boundary:** scanned or no-`ToUnicode` PDFs — cannot search
  without OCR, which is already out of scope. These keep degrading gracefully via the existing
  scanned-PDF notice and the garbled-extraction guard.

Design that makes it proper (to be recorded in the docs):

1. **NFC normalization** of both extracted page text and the query, done natively with
   `android.icu.text.Normalizer2` (ICU, available since API 24; app is minSdk 26). Offline, no
   extra dependency.
2. **Canonical search-key fold** on top of NFC (pure Dart, testable). The fold is applied only
   to a throwaway comparison key; the real page text and query keep their exact bytes.
   - **Unify Malayalam chillu encodings** (`consonant + virama + ZWJ` ⇄ atomic chillu
     `U+0D7A…U+0D7F`) so both spellings of the same word match while meaning is preserved.
   - **Treat ZWJ/ZWNJ (U+200C/U+200D) as ignorable in the match key only** — NOT stripped from
     stored or displayed text. This is standards-backed: both are Unicode
     `Default_Ignorable_Code_Point = Yes` and the Unicode Collation Algorithm gives them
     ignorable weight, so a user need not type invisible joiners to find a word. Their meaning
     for shaping (chillu / half-form / explicit virama) is preserved in the untouched original.
   - **Optional accent-insensitive toggle** for Devanagari Sanskrit: fold away Vedic/combining
     accents in the key.
   - **Optional strict/exact mode** keeps ZWJ/ZWNJ significant for users who must distinguish
     joiner vs. non-joiner spellings.
3. **Grapheme-cluster-aware matching** (Dart `characters`) so matches never split a base +
   vowel-sign cluster.
4. **Offset back-mapping** from normalized offsets → original char indices → pdfium per-char
   rectangles (pdfrx `PdfPageText`) so highlights land correctly even though normalization
   changes string length.
5. **Script detection** for Malayalam (U+0D00–U+0D7F) and Devanagari (U+0900–U+097F, plus
   Devanagari Extended U+A8E0–U+A8FF and Vedic Extensions U+1CD0–U+1CFF) to pick the right fold
   and to drive the garbled-extraction guard.

**Sanskrit appears in two scripts (confirmed with user):** Sanskrit content may be written in
**Devanagari** *or* in **Malayalam script** (Manipravalam / traditional Kerala texts). The
design already covers both: Malayalam-script Sanskrit reuses the Malayalam NFC + chillu/ZWJ
fold, and Devanagari Sanskrit uses the Devanagari + Vedic ranges with the optional
accent-insensitive (Vedic-accent-stripping) fold. No separate mechanism is needed — just both
script ranges in detection. Cross-script search (typing one script to find another) stays out
of scope.

## 3. Files to change (docs only)

1. `doc/PDF-Idea.md`
   - Broaden the "Malayalam text inside PDFs" risk to **"Complex Indic scripts (Malayalam &
     Sanskrit)"**.
   - Update the "Search" shared-capability bullet to state that search normalizes Unicode so
     the same word in different encodings still matches, and that it needs a text layer.

2. `doc/architecture.md`
   - Add a new subsection (under §6 Reading, or a new **§6.1 Complex-script search**) describing
     the normalization pipeline, the offset/highlight back-mapping, script detection, and the
     native-NFC + pure-Dart-fold split.
   - Add a `SearchNormalizer` (core/search) note and where NFC happens (native extraction
     boundary).
   - Add "Sanskrit PDF" to the test fixtures list in §12.

3. `doc/pdf-app-implementation-plan.md`
   - Expand Phase 2 "Build" with: NFC at the extraction boundary, `SearchNormalizer` (chillu
     encoding unify + ZWJ/ZWNJ ignorable-in-key + optional accent-insensitive + optional strict
     mode; fold applied to the comparison key only, original text untouched),
     grapheme-cluster matching, offset back-mapping for highlights, script detection.
   - Update the risk register row from "Malayalam extraction garbled" to cover
     Malayalam **and** Sanskrit, and add a "complex-script search correctness" handling note.
   - Add "Sanskrit PDF" to the §8 fixtures list.

4. `doc/pdf-app-implementation-progress.md`
   - Add Phase 2 checklist items: NFC normalization, SearchNormalizer fold, grapheme-aware
     matching, highlight offset mapping, script detection, Sanskrit fixture.

5. `change_log/` — after implementation, add a change-log entry referencing this plan.

## 4. Plan for the fix

- Keep all edits in **plain, simple English**, consistent with the existing doc tone.
- Do not change any locked technology decision. The only new moving parts are: use of native
  ICU `Normalizer2` (already on-device, no new dependency) and a small pure-Dart
  `SearchNormalizer`. No new third-party package is required; if a Dart-side NFC ever becomes
  necessary, note `unorm_dart` (BSD, open source) as the fallback — but the design avoids it.
- Reflect that the scope boundary (no OCR, graceful degrade on no-text PDFs) is **unchanged**.

## 5. Out of scope

- Writing any Dart/Kotlin code, `pubspec` changes, or tests.
- OCR of scanned PDFs.
- Transliteration or cross-script search (e.g. typing Sanskrit in Malayalam script to find
  Devanagari) — could be a future idea, not part of this change.

## 6. Approval

Per the workflow rules, no project file will be edited until you approve this plan.

**Do you approve this plan?**
