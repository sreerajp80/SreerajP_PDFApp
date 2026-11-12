# Search fixes: keep zoom, hide keyboard, warn on broken Indic text

**Status:** completed

## The issues (from the user's screenshot, a Devanagari PDF)

1. **Search jumps lose the zoom.** `_goToCurrentMatch()` in the viewer calls
   `controller.goToPage(pageNumber)`. In pdfrx 2.6.5, `goToPage` with the default
   `top` anchor fits the page into the view and caps the zoom at the current zoom.
   So if the reader zoomed in, every jump zooms back out. It also only goes to the
   *top of the page*, not to the match, so the match can be off screen or under the
   keyboard. That is why the result looks like "showing something" with no visible
   highlight.
2. **No jump for the first match.** When results arrive, match 1 is selected but the
   viewer never moves to it. Only the up/down buttons move the view.
3. **Keyboard stays open** while stepping through results with up/down. The text
   field keeps focus, and the viewer has `resizeToAvoidBottomInset: false`, so the
   keyboard covers half the page.
4. **No note for "not proper Unicode" text.** `TextQualityCheck` only catches
   Private Use Area and replacement characters. Two common kinds of broken Indic
   PDFs pass as "good":
   - **Visual-order text**: the PDF stores letters in the order they are drawn, so a
     pre-base vowel sign (Devanagari `ि`, Malayalam `െ` `േ` `ൈ`) comes *before* its
     consonant, or a vowel sign / virama starts a word. Real Unicode never does this.
   - **Legacy font encodings** (Kruti Dev style, ISM, ML-TT fonts): the page shows
     Indic letters but the text layer is Latin letters and Latin-1 symbols
     (for example `Hkkjr`, `¼`, `ö`).
   Search on such text gives wrong or missing matches with no warning.

## Files to change

- `lib/features/viewer/presentation/viewer_screen.dart` — jump to the match itself,
  keep the zoom, jump on first match, hide keyboard on next/previous.
- `lib/features/reading/presentation/widgets/reader_search_bar.dart` — unfocus the
  text field when up/down is pressed.
- `lib/features/reading/domain/text_quality.dart` — new checks for broken Indic order
  and legacy encodings; new level `unreliable`.
- `lib/core/constants/app_constants.dart` — thresholds for the new checks.
- `lib/features/reading/presentation/widgets/text_quality_notice.dart` — notice for
  `unreliable`.
- `lib/features/viewer/presentation/viewer_screen.dart` — show the notice for
  `unreliable` (search stays on), and re-show a short hint in the search bar.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ `flutter gen-l10n`) — new
  strings: `titleUnreliableText`, `bodyUnreliableText`, `descSearchUnreliable`.
- Any other `switch` on `TextQuality` (copy, TTS, annotation text markup) — treat
  `unreliable` the same as `good` for enabling, but TTS shows the warning too.
- Tests: `test/features/reading/domain/text_quality_test.dart`,
  `test/features/reading/presentation/text_quality_notice_test.dart`,
  `test/features/reading/presentation/reader_search_bar_test.dart`.
- `docs/features.md` — mention the new notice.

## The fix

### A. Go to the match, keep the zoom
- New helper `_goToHit(SearchHit hit)`:
  - take the hit's first rect, convert it with
    `controller.calcRectForRectInsidePage(pageNumber, rect)` to document coordinates;
  - `controller.goTo(controller.calcMatrixFor(rect.center, zoom: controller.currentZoom))`.
  - `calcMatrixFor` keeps the current zoom and puts the match in the centre of the
    view (the keyboard is down after fix B, so the centre is visible).
  - If a hit has no rects, fall back to the old `goToPage`.
- In `_onSearchChanged`, when the current hit changes from none to the first hit,
  call `_goToHit` once (track the last hit we jumped to, so streaming results do not
  keep moving the view).

### B. Hide the keyboard while stepping
- In `ReaderSearchBar`, the up/down buttons call `_focus.unfocus()` before
  `onNext` / `onPrevious`. Tapping the text field brings the keyboard back.
  (Pressing the keyboard's Search key already closes it — Flutter does this for
  `TextInputAction.search`.)

### C. Warn on broken Indic text
- `TextQualityCheck.assess` gains two counts over Indic letters
  (Devanagari U+0900–097F, Malayalam U+0D00–0D7F):
  - **misplaced marks**: a dependent vowel sign, virama or anusvara that is at the
    start of the text, after a space/punctuation, or after another vowel sign of a
    kind that cannot follow it (for example `ि` + `ि`);
  - **legacy look**: share of Latin-1 Supplement symbols (U+00A0–U+00FF, except
    no-break space) among all letters.
- Result:
  - PUA / replacement too high → `garbled` (as today, search off).
  - misplaced marks ≥ 5 % of Indic marks, or legacy-look share ≥ 15 % → `unreliable`.
  - otherwise `good`.
- `unreliable` keeps search, copy and TTS **on** but shows a notice:
  "This PDF's text may not be stored as proper Unicode. Search and read aloud may
  miss words or read them wrongly." The search bar's status row shows a small
  warning icon with the same hint as tooltip.
- Thresholds are first guesses. I am about 70 % sure they are right; they need a
  check against real broken PDFs.

## Testing
- Unit tests for each new rule (good Devanagari, good Malayalam, visual-order
  Devanagari, visual-order Malayalam, Kruti Dev-style Latin, short text).
- Widget test: up/down unfocuses the text field.
- Widget test: notice shows for `unreliable`.
- `flutter analyze`, `flutter test`.
- Manual: the PDF from the screenshot — zoom in, search, step through results; the
  zoom must stay and the match must be in view with the keyboard down. It would help
  to add a copy of that PDF to `samples/` if it can be shared.

## Security impact
None. No permissions, storage, network or dependency changes.
