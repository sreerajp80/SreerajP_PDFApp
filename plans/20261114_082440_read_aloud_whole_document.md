# Read aloud: whole document, auto page turn, and pause fix

**Status:** completed

## What the issue is

1. Read aloud only reads one page. When the page ends, `TtsService._playNextSentence()`
   calls `stop()`. The reader must press play again on every page.
2. The setting **Settings › Read aloud › Scroll with speech** (`ttsAutoScrollProvider`) is
   saved, but nothing uses it. It is a dead setting today.
3. Bug: pause, then press play, and the page starts again from the top. `_speakCurrentPage`
   only checks "speaking", not "paused", so it calls `speak()` again instead of `resume()`.
   Also, `resume()` today skips the rest of the piece that was cut by pause, because the
   piece index has already moved on.

## The plan for the fix

### 1. A "whole document" switch

- A new saved setting: `ttsReadWholeDocumentProvider` (bool, default **off**, so the app
  behaves as before until the reader turns it on). New pref key
  `settings.tts_read_whole_document` in `AppConstants`.
- A new icon button in the read-aloud bottom bar, next to the speed button:
  - off: page icon, tooltip "Read whole document"
  - on: book icon (highlighted), tooltip "Read this page only"
  Tapping it flips the setting. It takes effect at the end of the current page.

### 2. Keep reading at the end of a page (in `TtsService`)

- `speak()` gets an optional `nextPage` callback:
  `Future<TtsPageText?> Function(int finishedPage)`. `TtsPageText` is a small immutable
  class (page number + text) in `tts_state.dart`.
- When the last piece of a page is spoken and `nextPage` is set, the service asks for the
  next page instead of stopping:
  - `null` back → end of document → stop, and set a "finished" flag the viewer reads once to
    show "Finished reading the document."
  - text back → check the voice for that text (`voiceProblemFor`). If there is no voice
    (for example a Malayalam page and the voice is off), stop and keep the problem so the
    viewer shows the same message it shows today. Otherwise switch language if needed,
    split the text, set `speakingPage`, update the notification, and carry on.
- The viewer's callback skips pages with no text (blank pages, image-only pages), so the
  reader does not hear silence or get stopped by a blank page.
- When the switch is off, the viewer passes no callback, so one page is read as today.

### 3. Auto page turn

- The viewer listens to `TtsService`. When `speakingPage` changes while reading, and
  "Scroll with speech" is on, it calls `_controller.goToPage(pageNumber: page)`.
- This makes the existing "Scroll with speech" setting real, instead of adding a second
  switch for the same thing. If the reader turns it off, reading still goes on, but the
  screen stays where they are.

### 4. Pause fix

- `_speakCurrentPage`: if paused → `resume()`. If speaking → `pause()` (any page, not only
  the current one). Only when idle → start reading from the current page.
- `TtsService.pause()`: step the piece index back by one, so `resume()` repeats the piece
  that was cut, from its start. Pieces are one sentence or shorter, so this sounds natural.

### 5. Strings (all three languages)

- `tooltipTtsReadWholeDocument` — "Read whole document"
- `tooltipTtsReadThisPage` — "Read this page only"
- `descTtsDocumentFinished` — "Finished reading the document."

Each gets an `@` description in `app_en.arb` and real Malayalam and Sanskrit text. Then
`flutter gen-l10n`.

### 6. Tests (`test/features/reading/data/tts_service_test.dart`)

- Goes on to the next page and updates `speakingPage`.
- Stops at the end of the document and sets the "finished" flag.
- Stops on a page with no voice and reports the problem.
- Without a callback, stops after one page (old behaviour).
- Pause then resume repeats the cut piece, and does not restart the page.

### 7. Docs

- `docs/features.md` and `CHANGELOG.md`: describe whole-document reading, page turning and
  the pause fix.

## Files to be changed

- `lib/features/reading/data/tts_service.dart`
- `lib/features/reading/domain/tts_state.dart`
- `lib/features/viewer/presentation/viewer_screen.dart`
- `lib/app/config/providers.dart`
- `lib/core/constants/app_constants.dart`
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, `lib/l10n/app_sa.arb` (and the generated
  `lib/l10n/app_localizations*.dart`)
- `test/features/reading/data/tts_service_test.dart`
- `docs/features.md`
- `CHANGELOG.md`

## Not in this plan

- The new setting is not added to Device sync (`synced_setting.dart`). It can be added later.
- No change to the Settings screen; the switch lives in the reader's bottom bar.

## Security impact

None. No new permission, no network, no file access. One new local SharedPreferences bool.
Page text is never logged.
