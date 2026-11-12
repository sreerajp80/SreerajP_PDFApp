# Search fixes: keep zoom, hide keyboard, warn on broken Indic text

Implements plan: `plans/20261109_205634_search_zoom_keyboard_text_check.md`

## What changed

### Search moves to the match and keeps the zoom
- `lib/features/viewer/presentation/viewer_screen.dart`
  - New `_goToHit(SearchHit)`. It converts the match's first rectangle to
    document coordinates and moves the view with
    `controller.calcMatrixFor(...)`, which keeps the current zoom. Before, it
    used `goToPage`, which fitted the page to the screen (zoom lost) and showed
    only the top of the page.
  - It does not move at all when the match is already in view. It allows for the
    keyboard: the keyboard's height is taken off the bottom of the visible area,
    and the match is centred in the part that is not covered.
  - `_onSearchChanged` now moves to the current match whenever it changes. So
    the first match is shown as soon as it is found, and up / down use the same
    path. A `_jumpedHit` field stops streaming results from moving the view
    again and again.
  - `_textUsable` now uses the new `TextQuality.isUsable`.
  - The search bar gets `unreliableText` when the PDF's text is unreliable.

### Keyboard put away while stepping
- `lib/features/reading/presentation/widgets/reader_search_bar.dart`
  - Up / down now unfocus the text field first, so the keyboard closes. Tapping
    the field brings it back.
  - New `unreliableText` option: shows a warning icon (tap for the tooltip) next
    to the match counter.

### Note for text that is not proper Unicode
- `lib/features/reading/domain/text_quality.dart`
  - New level `TextQuality.unreliable`, and `isUsable` (good or unreliable).
  - New check for Indic text stored in drawing order. It counts combining marks
    (vowel signs, virama, nukta, anusvara) that sit where real Unicode never puts
    them: at the start of a word, after a space or another script, after an
    independent vowel, a vowel sign after a virama, or two vowel signs in a row
    (except the valid two-part vowels such as Malayalam `െ` + `ാ`). It works for
    all Indic blocks from Devanagari to Malayalam, because they share one layout.
  - New check for old fonts (Kruti Dev / ML-TT style). It looks for rare Latin-1
    symbols (`¼ ½ ¡ ¢ ¥ ¿` …) in text with almost no real Indic letters.
    Accented letters and common symbols (© ® ° · « » §) are not counted, so
    normal European text is not flagged.
- `lib/core/constants/app_constants.dart` — four new thresholds for these checks.
- `lib/features/reading/presentation/widgets/text_quality_notice.dart` — warning
  banner for `unreliable`.
- For `unreliable` PDFs, search, copy, text markup and read-aloud stay on. The
  banner says read-aloud may also be wrong; no separate read-aloud message was
  added.

### Strings (all three languages)
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ regenerated
  `app_localizations*.dart`): `titleUnreliableText`, `bodyUnreliableText`,
  `descSearchUnreliable`.

### Tests
- `test/features/reading/domain/text_quality_test.dart` — good Devanagari, good
  Malayalam with decomposed vowels, drawing-order Devanagari and Malayalam,
  vowel sign after an independent vowel, too few marks, Kruti Dev style text,
  French / German / Spanish text, Devanagari with a few symbols, `isUsable`.
- `test/features/reading/presentation/reader_search_bar_test.dart` — up / down
  put the keyboard away; the warning icon shows only for unreliable text.
- `test/features/reading/presentation/text_quality_notice_test.dart` — banner for
  unreliable text.

### Docs
- `docs/features.md` — search behaviour and the new warning.

## Checks
- `flutter analyze`: no issues.
- `flutter test`: all 470 tests pass.
- `dart format`: clean.
- The Malayalam sample PDF in `samples/` is still judged "good" (checked with
  text extracted by a desktop tool, not pdfium).

## Not yet checked
- Not tested on a device. The zoom / keyboard behaviour needs a manual check:
  zoom in, search, step through results.
- The thresholds (5 % misplaced marks, 3 % rare symbols) are first guesses. They
  have not been checked against real broken PDFs, as none are in `samples/`.

## Needs native-reader review
- Malayalam: `titleUnreliableText` "എഴുത്ത് തെറ്റാകാം", and the body and tooltip
  using "ശരിയായ യൂണിക്കോഡിൽ ആയിരിക്കില്ല".
- Sanskrit: `titleUnreliableText` "पाठ्यांशः अशुद्धः स्यात्"; body uses the optative
  forms "न लभ्येरन्" and "पठ्येत"; "यूनिकोड-रूपे" is a loan word with no pack glossary entry.

## Security impact
None. No permissions, storage, network or dependency changes.
