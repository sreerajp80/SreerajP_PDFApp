# Change log: repair word spacing from character positions

Implements plan: `plans/20261109_211920_position_based_text_repair.md` (revision 2).

## What changed

- **New** `lib/features/reading/data/text_layout_repair.dart` — `TextLayoutRepair.repair()`
  takes pdfium's raw page text and one box per character, and returns repaired text with
  boxes still index-aligned. In order:
  1. `\r\n` and a lone `\r` become `\n`.
  2. The fake line breaks some Word PDFs put between vertical characters are removed
     (same rule as `pdfrx`'s structured text).
  3. **Fault B:** after an Indic virama (Malayalam `്`, Devanagari `्` and the other
     Indic viramas), if the next visible character on the same line starts after a gap
     larger than 0.1 × the virama box height, a space is inserted with a box covering
     the gap. pdfium drops the real space there because the virama's ink overlaps it.
  4. **Fault A:** in each line, a real space (non-empty box) whose centre is left of
     the letter before it is taken out and put back into the gap it was drawn in. It is
     dropped if that gap already has a space, and left where it was if no gap fits.
  5. Runs of blanks become one character (`\n` if the run has a line break, else a
     space), keeping the first non-empty box.
  It never throws; on input it cannot pair up, it returns the text with padded boxes.
  The order inside a line is never re-sorted by x, so Malayalam clusters stay intact.
- `lib/features/reading/data/pdf_text_source.dart` — reads `page.loadText()` (raw text
  and boxes) and runs the repair, instead of `loadStructuredText()`, which merges spaces
  and loses each space's real box. The fragment-flattening helper `_charRectsOf` and its
  `_noRect` placeholder were removed. Doc comments updated.
- `lib/core/constants/app_constants.dart` — `textRepairViramaGapRatio` (0.1) and
  `textRepairGapTolerance` (1.0 pt).
- **New** `test/features/reading/data/text_layout_repair_test.dart` — 18 tests. They use
  boxes copied from pdfium's real output for a LibreOffice-made Malayalam PDF (`അർ ത്ഥം`,
  `ഉ വാച`, `എന്ന്വിളി`), plus a virama inside a word, a shared conjunct box, a virama at a
  line end, Devanagari, blank merging, unchanged normal text, vertical text, non-BMP
  characters, length mismatch and an empty page.
- `docs/features.md` — new "Word Spacing Repair" entry under search.
- `CHANGELOG.md` — user-facing "Fixed" line.

## Results

Measured on a 41-page, 7,892-word Malayalam PDF made by LibreOffice, word by word
against Poppler's `pdftotext` (used only as a reference on a desktop, not in the app):

| Text | Correct words | Wrong words |
|---|---|---|
| Before (pdfium via structured text) | 6,685 | 866 |
| After (this change, run through the Dart code) | 7,838 (99.3%) | 49 |

The result is the same for virama-gap thresholds from 0.05 to 0.15, so it is not tuned
to this one book.

## Checks

- `dart format` — clean.
- `flutter analyze` — no issues.
- `flutter test` — all 488 tests pass.

## Not done / follow-ups

- **Device check not done yet:** search the test PDF on a phone (`അർത്ഥം`,
  `എന്ന് വിളിക്കുന്നു`, `ദൃഷ്ട്വാ തു`) and an ordinary PDF.
- Search highlight boxes now follow each glyph's own height instead of the full line
  height (raw boxes instead of structured ones). They may look a little less tall.
  Worth a look during the device check.
- Long-press text selection in the viewer still reads pdfium directly and does not get
  the repair.
- The remaining 49 wrong words are mostly a dash with spaces on both sides (`എ–`).
