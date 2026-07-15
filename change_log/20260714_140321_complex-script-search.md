# Change log — Proper Malayalam & Sanskrit search in PDFs

**Implements plan:** `plans/20260714_135744_complex-script-search.md`
**Date:** 2026-07-14

## What was asked

Make searching Malayalam and Sanskrit content inside PDFs work properly, and record the
implementation details in the project docs. First confirm it is implementable.

## Feasibility outcome

Confirmed implementable with the existing locked open-source stack (pdfrx/pdfium +
PdfBox-Android), for PDFs that have a real text layer. The only unsolvable case — scanned or
no-`ToUnicode` PDFs — was already out of scope (no OCR) and keeps degrading gracefully. No new
third-party package is required: NFC uses the device's built-in ICU (`android.icu`), and the
rest is a small pure-Dart `SearchNormalizer`.

## What changed (documentation only — no code)

1. **`doc/PDF-Idea.md`**
   - Expanded the "Search" shared-capability bullet to say search is Unicode-aware for
     Malayalam and Sanskrit.
   - Replaced the "Malayalam text inside PDFs" risk with a broader "Complex Indic scripts
     (Malayalam & Sanskrit)" risk covering both extraction (ToUnicode) and correct matching
     (NFC + canonical key), including the Sanskrit-in-Devanagari-or-Malayalam-script note.

2. **`doc/architecture.md`**
   - Updated the Reading module bullet to point at the new subsection.
   - Added **§6.1 Complex-script search (Malayalam & Sanskrit)**: the equivalence problem, the
     NFC + `SearchNormalizer` fold, ZWJ/ZWNJ treated as ignorable in the comparison key only
     (never removed from real text), chillu unify, optional accent-insensitive and strict
     modes, grapheme-cluster matching, highlight offset back-mapping, and script detection.
   - Added complex-script search unit tests and a Sanskrit fixture to §12.

3. **`doc/pdf-app-implementation-plan.md`**
   - Expanded Phase 2 "Build" with the full complex-script search steps.
   - Updated the risk register (Malayalam → Malayalam/Sanskrit; added a
     "complex-script search correctness" row).
   - Added `SearchNormalizer` unit tests and a Sanskrit fixture to §8.

4. **`doc/pdf-app-implementation-progress.md`**
   - Added Phase 2 checklist items (NFC, SearchNormalizer fold, grapheme matching, highlight
     back-mapping, script detection, Sanskrit fixtures) and broadened the extraction-guard item
     to Malayalam & Sanskrit.

## Key correctness decision

ZWJ/ZWNJ are meaningful for shaping in these scripts, so they are **not stripped** from stored
or displayed text. They are only treated as ignorable in a throwaway comparison key (standard
Unicode "default-ignorable" behavior), and the two Malayalam chillu encodings are **unified**
rather than dropped, preserving meaning while letting equivalent spellings match.

## Not done here

No `lib/`, `android/`, `pubspec`, or test code was written. Implementation happens in Phase 2
per the plan.
