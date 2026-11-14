# Read aloud: short pieces for Malayalam, and no English fallback

Implements plan: `plans/20261113_223414_read_aloud_sentences_and_voice_check.md`

## What changed

### Text is read in short pieces
- New `lib/features/reading/domain/tts_text_splitter.dart` with `splitForSpeech()`:
  line breaks become spaces; text is cut after `.` `!` `?` `।` `॥` `|` followed by a space;
  any piece over 200 characters is cut at the last space before the limit (hard cut when
  there is no space, never splitting a surrogate pair). It always returns a growable list,
  because `TtsService.stop()` clears the queue.
- `lib/features/reading/data/tts_service.dart` uses it in place of the old
  `_splitIntoSentences`. The old pattern only cut where a mark was followed by a space, so
  Malayalam verse text with only line breaks became one piece per page, and a new speed
  never took effect.

### No fallback to the English voice
- `lib/features/reading/domain/tts_state.dart`: new enum `TtsVoiceProblem`
  (`none`, `malayalamOff`, `malayalamNotInstalled`, `noSanskritVoice`, `noVoice`).
- `TtsService.voiceProblemFor(text)` checks the page's main script. `speak()` now returns a
  `TtsVoiceProblem` and does not start when there is one. The old `_languageFor` /
  `_stateOf` (which fell back to English, or returned silently) are removed.
- `lib/features/viewer/presentation/viewer_screen.dart`: `_explainVoiceProblem` shows a
  snackbar. For Malayalam problems it has a **Settings** action that opens
  Settings › Read aloud.
- New strings in all three ARB files (+ generated files): `descTtsMalayalamVoiceOff`,
  `descTtsMalayalamVoiceMissing`, `descTtsNoSanskritVoice`, `actionTtsOpenSettings`.
  The wording reuses the app's existing terms (`ക്രമീകരണങ്ങൾ`, `ഉറക്കെ വായിക്കുക`,
  `विन्यासः`, `उच्चैःपठनम्`), and the Sanskrit uses the polite passive form like the other
  read-aloud strings.

### Tests and docs
- New `test/features/reading/domain/tts_text_splitter_test.dart`: marks including `॥`,
  numbers like `2.5`, joined line wraps, blank text, verse text with no marks, a very long
  word, and surrogate pairs.
- `test/features/reading/data/tts_service_test.dart`: each voice problem, nothing spoken
  when there is a problem, and Malayalam verse is spoken in pieces of 200 characters or less.
- `docs/features.md`, `CHANGELOG.md` updated.

## Checks
- `flutter gen-l10n`, `dart format`, `flutter analyze` (no issues), `flutter test` (594 passed).
- Emulator, prod release build:
  - Malayalam PDF (Malayalam voice installed and on there): read with the Malayalam voice.
    The same first piece took about 15 s at 0.75× and about 7 s at 2×, so the speed now
    changes for Malayalam.
  - Sanskrit PDF: shows the "no Sanskrit voice" message; nothing is spoken.
- The "Malayalam voice off / not installed" messages were checked by unit tests only, not
  on a device.
- Dev debug build installed on the test phone for the user to try.
- Gradle daemons stopped; two leftover Kotlin daemon processes ended.

## Notes
- A 200-character Malayalam piece takes about 15 s at 0.75×. Pause and Stop cut in at once,
  but a speed change is heard only from the next piece, so it can take up to that long. The
  limit may need to be smaller for Malayalam.
- For native-reader review: the three new Malayalam and Sanskrit messages.
