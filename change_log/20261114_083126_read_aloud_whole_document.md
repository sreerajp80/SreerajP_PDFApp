# Read aloud: whole document, auto page turn, and pause fix

Implements plan: `plans/20261114_082440_read_aloud_whole_document.md`

## What changed

### Whole-document reading
- `lib/features/reading/domain/tts_state.dart`: new `TtsPageText` (page + text) and the
  `TtsNextPage` callback type.
- `lib/features/reading/data/tts_service.dart`:
  - `speak()` takes an optional `nextPage` callback. When a page's last piece ends, the
    service asks for the next page instead of stopping.
  - End of document → stops and sets a one-time flag (`takeDocumentFinished()`).
  - Next page has no voice → stops and keeps the reason (`takeStopProblem()`).
  - Otherwise it changes the voice language if needed, updates `speakingPage` and the
    notification, and carries on.
  - A run counter (`_run`) goes up on every start, pause and stop. An old reading loop that
    wakes up late sees it is out of date and quits. This stops two loops reading at once
    after a quick pause and play.
- `lib/core/constants/app_constants.dart`, `lib/app/config/providers.dart`: new saved
  setting `ttsReadWholeDocumentProvider` (key `settings.tts_read_whole_document`, default
  off).
- `lib/features/viewer/presentation/viewer_screen.dart`:
  - New button in the read-aloud bar (page icon / book icon) to switch the setting.
  - `_nextPageToRead` finds the next page with text, skipping blank pages. It reads the
    setting each time, so a change while reading takes effect at the end of the page.
  - The TTS listener shows "Finished reading the document." and the no-voice message.

### Auto page turn
- `_followSpokenPage` turns the reader to the page being read when **Scroll with speech**
  (`ttsAutoScrollProvider`) is on. That setting existed but was not used before.

### Pause fix
- `_speakCurrentPage`: speaking → pause; paused → resume; only idle → start from the
  current page. Before, play after pause started the page again.
- `TtsService.pause()`: if a piece was cut half-way, its index is stepped back so resume
  reads it again from its start.

### Strings
- New keys in `app_en.arb`, `app_ml.arb`, `app_sa.arb`: `tooltipTtsReadWholeDocument`,
  `tooltipTtsReadThisPage`, `descTtsDocumentFinished`. Regenerated `app_localizations*.dart`.

### Tests
- `test/features/reading/data/tts_service_test.dart`: reads on to the next pages and
  reports the end; one page only without the callback; stops on a page with no voice;
  stop does not go on to the next page; resume repeats the cut piece.

### Docs
- `docs/features.md`, `CHANGELOG.md`.

## Checks
- `flutter analyze`: no issues.
- `flutter test`: all 600 tests pass.
- Not yet checked on a real device.

## For native-reader review
- Malayalam: "മുഴുവൻ രേഖ വായിക്കുക", "ഈ താൾ മാത്രം വായിക്കുക", "രേഖ മുഴുവൻ വായിച്ചുകഴിഞ്ഞു."
- Sanskrit: "सकलः लेखः पठ्यताम्", "इदं पृष्ठमेव पठ्यताम्", "सकलः लेखः पठितः।"
  ("Document" uses the language-pack glossary words: രേഖ / लेखः.)

## Not done
- The new setting is not added to Device sync.
