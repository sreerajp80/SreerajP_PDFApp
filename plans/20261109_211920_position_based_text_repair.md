# Search: repair word spacing from character positions (LibreOffice PDFs)

**Status:** completed

> Revision 2. The first version of this plan was approved, but measuring pdfium's
> real output (before writing any code) showed the first design was built on a wrong
> idea. This version replaces it and needs approval again.

## The issue

PDFs made by LibreOffice (tested with a 41-page Malayalam Bhagavad Gita PDF, 7,892
words) are hard to search in Folio. The PDF's text layer is **correct Unicode**: each
glyph has a correct `/ToUnicode` entry, and Poppler's `pdftotext` reads every page
correctly. The problem is in the **spaces** that pdfium (the engine behind `pdfrx`)
gives us.

Measured on the whole book with pdfium itself (same calls as `pdfrx`'s `loadText()`),
compared word by word with Poppler:

| Text | Correct words | Wrong words |
|---|---|---|
| pdfium as Folio reads it today | 6,685 | 866 |
| after fix A below | 6,813 | 540 |
| after fix A + fix B below | **7,838 (99.3%)** | **49** |

pdfium already rebuilds most of the reading order. Two faults are left:

- **Fault A, a space inside a word** (`അർ ത്ഥം` 42 times, `ഉ വാച`, `ധൃത രാഷ്ട്രർ`).
  LibreOffice draws the spaces of a line separately (font Tahoma). pdfium puts its
  own *generated* space in the right gap, but also keeps the *real* space glyph at a
  wrong place, further along the line. Its box clearly shows it belongs further
  left: its centre is left of the letter just before it.
- **Fault B, a missing space after ് (chandrakkala)** (`എന്ന്വിളിക്കുന്നു`,
  `യോദ്ധാക്കളോട്പൊരുതാൻ`, 34 × `എന്ന്`). The PDF has the space glyph, but pdfium
  **drops it** because the ് glyph's ink reaches into it. The only clue left is the
  gap between the boxes. 98% of all missing spaces in the book are right after ്.
  After ് *inside* a word, the next box always touches or overlaps (gap ≤ 0); at a
  word end there is always a real gap (≥ 0.15 × letter height). This is a clean
  split, and the result is the same for any threshold from 0.05 to 0.15.

**Why the first plan was wrong:** it assumed the spaces pile up at the end of each
line. That is true for another library (PyMuPDF), not for pdfium. Also, `pdfrx`'s
`loadStructuredText()` (what Folio uses now) merges runs of spaces into one and
**throws away each space's real box**, so the repair cannot work on its output. The
repair has to work on `page.loadText()` (pdfium's raw text and boxes) instead.

Libraries: Poppler (GPL) and MuPDF (AGPL) are not allowed (MIT / BSD / Apache only).
pdfium and PdfBox-Android are allowed and already in the app. No new dependency.

## The fix

### 1. New pure helper: `TextLayoutRepair`

New file `lib/features/reading/data/text_layout_repair.dart`:

```dart
/// Repairs pdfium's raw page text. [text] and [rects] are index-aligned (one box
/// per UTF-16 code unit, as `PdfPageRawText` gives them); the result is too.
static ({String text, List<PdfRect> rects}) repair(String text, List<PdfRect> rects)
```

Steps, in order:

1. **Fault B: add the space pdfium dropped after a virama.** If a virama (Malayalam
   ് U+0D4D; also Devanagari ् U+094D and the other Indic viramas, same cause) is
   followed by a visible character on the same line, and the gap between their boxes
   is more than `AppConstants.textRepairViramaGapRatio` (0.1) × the virama box's
   height, insert `' '` with a box covering the gap.
2. **Fault A: move a misplaced real space.** Work line by line (lines end at `\n`).
   A real space (its box is not empty) is misplaced when its centre is left of the
   left edge of the visible letter just before it. Take it out and find the gap
   between two neighbouring visible letters in the same line that its centre falls
   into (with a small tolerance). If a space is already there, drop it. If not,
   insert it there. If no gap fits, leave it where it was.
3. **Tidy blanks**, the way `loadStructuredText()` did: `\r\n` becomes `\n`, and a run
   of blank characters becomes one character (`\n` if the run has a line break,
   else `' '`), keeping the first non-empty box. Search turns each blank into one
   space and does not merge runs, so this keeps phrase search across line ends
   working.
4. **Keep pdfrx's vertical-text rule.** `pdfrx` removes the fake line breaks some
   Word PDFs put between each character of vertical text. That small rule is ported
   so nothing that works today breaks.
5. **Never throw, never make things worse.** A length mismatch or odd input returns
   the input with only step 3 applied. Pages with no virama gaps and no misplaced
   spaces only get step 3, which matches today's behaviour.

The order *inside* a cluster is never changed. A Malayalam cluster's vowel signs and
virama often share one box, so letters are never sorted by x.

### 2. Use it in `PdfTextSource`

In `PdfTextSource.page()`, replace `loadStructuredText()` with `loadText()` +
`TextLayoutRepair.repair(...)`. `_charRectsOf` (the fragment flattening) is no longer
needed and is removed. Search, copy, read-aloud (TTS) and the text quality check all
read through `PdfTextSource`, so all of them get the repaired text. Highlights stay
correct because every character keeps its own box. pdfium's generated spaces have
empty boxes, and `rectsForRange` already skips empty boxes. The doc comments
("exactly as pdfium gave it") are updated.

### Out of scope

- Long-press text selection in the viewer (`page_annotation_layer.dart`) reads pdfium
  directly. Not changed here.
- The last 49 wrong words (mostly a dash with spaces on both sides, such as `എ–`).
  Small; can be looked at later.
- Old non-Unicode fonts (ML-TT, Kruti Dev) and scanned PDFs. No change.

## Files to change

- `lib/features/reading/data/text_layout_repair.dart` — **new**: the repair helper.
- `lib/features/reading/data/pdf_text_source.dart` — use `loadText()` + repair; drop
  `_charRectsOf`; update doc comments.
- `lib/core/constants/app_constants.dart` — `textRepairViramaGapRatio` and the
  position tolerance.
- `test/features/reading/data/text_layout_repair_test.dart` — **new**: unit tests.
- `docs/features.md` — note that search repairs word spacing from character positions.
- `CHANGELOG.md` — user-facing line: better search in PDFs made by LibreOffice.
- `change_log/<timestamp>_position_based_text_repair.md` — after implementing.

## Tests

Unit tests with hand-built text and boxes, copied from pdfium's real output for the
test PDF (no native code needed):

- **Fault A:** `അർ ത്ഥം` (generated space before അ, real space misplaced after ർ) →
  `അർത്ഥം` with one space before അ. Same for `ഉ വാച` → `ഉവാച`.
- **Fault B:** `എന്ന്വിളിക്കുന്നു` with a 2.46 pt gap after ് → `എന്ന് വിളിക്കുന്നു`.
- **Virama inside a word** (gap ≤ 0, for example `ന്ന`) → no space added.
- **Different lines:** a virama at a line end followed by the next line → no space added.
- **Blanks:** `\r\n` → `\n`; `' \r\n'` → `\n`; double space → one space.
- **Normal text** (spaces already right) comes back the same apart from `\r\n` → `\n`.
- **Vertical text** rule kept.
- **Boxes stay aligned:** `rects.length == text.length` after every repair.
- **Bad input** (length mismatch, empty page) → no throw.

Then `flutter analyze`, `flutter test`, `dart format .`.

**Manual check on a device (you):** `flutter run --flavor dev`, open the Gita PDF,
search `അർത്ഥം`, `എന്ന് വിളിക്കുന്നു`, `ദൃഷ്ട്വാ തു`. Expected: found and highlighted.
Also search an ordinary PDF to check nothing changed.

## Risks

- **Fault B in other PDFs:** a virama followed by a gap could, in some other PDF, be
  a visible-virama spelling inside a word with letter spacing. In this book there
  were 0 such cases among 7,208 virama-inside-word cases. Low risk, and the result
  would be an extra space, not lost text.
- **Leaving `loadStructuredText()`:** its other work (right-to-left and vertical
  direction handling, space box clamping) only affects selection-style boxes, not
  the text that search uses. The vertical-text line-break rule is ported. Highlight
  boxes for generated spaces become empty (skipped), which is harmless.
- **Speed:** one pass per page, linear in the number of characters; pages are cached.

**Security impact:** none. No network, storage, permissions, platform code or new
dependencies. Text stays in memory as before and is never logged.
