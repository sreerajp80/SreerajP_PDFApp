# Read aloud: split Malayalam text, and say when a voice is missing

**Status:** completed

Follows `plans/20261113_212250_read_aloud_stop_and_speed.md`.

## The issues

1. **The speed change does nothing for Malayalam.**
   `TtsService._splitIntoSentences` uses `(?<=[.!?।|\n])\s+`. It only cuts where a mark is
   followed by a space. Malayalam verse text (for example the Lalitha Sahasranamam sample) has
   no `.` and only bare line breaks, so nothing matches: page 2 becomes one 741-character
   "sentence". A new speed is used from the next sentence, so it never takes effect. (The
   same long piece also makes Pause and Resume jump a whole page.) English works because it
   has `. ` after each sentence. The `\n` in the pattern never matched as intended, and
   `॥` (double danda) is missing.

2. **A missing voice silently falls back to English.**
   `_languageFor` picks Malayalam only when the Malayalam voice is switched on *and*
   installed; otherwise it uses English. Devanagari (Sanskrit) text always goes to English.
   The English voice then mangles or skips the text. The user wants a clear message instead.
   Also, when even the chosen voice is not ready, `speak()` just returns: a silent, dead
   Play button, against hard rule 6.

## The fix

1. **Sentence splitting** (in a new pure helper, `splitForSpeech`, in
   `lib/features/reading/domain/tts_text_splitter.dart`, so it can be unit tested):
   - Cut after `.` `!` `?` `।` `॥` `|` when followed by whitespace (or the end).
   - Lines are joined with spaces first, so a line wrap in the middle of a sentence does not
     cause a pause.
   - Any piece still longer than about 200 characters is cut at the last space before that
     limit (or hard-cut if there is no space). So even text with no punctuation is spoken in
     short pieces, and speed, Pause and Stop all respond within a few seconds.

2. **Voice check before reading.** A new `TtsService.voiceProblemFor(text)` looks at the
   page's main script and returns one of:
   - `none` — a ready voice exists for it (English text → English voice; Malayalam text →
     Malayalam voice that is on and installed).
   - `malayalamOff` — Malayalam text, the voice is installed, but the setting is off.
   - `malayalamNotInstalled` — Malayalam text, the voice is not installed (or not supported).
   - `noSanskritVoice` — Devanagari text. The app has no Sanskrit voice.
   - `noVoice` — English text and no English voice.
   `speak()` uses the same check and never falls back to English.
   The viewer checks first. If there is a problem, it shows a snackbar and does not start:
   - Malayalam off / not installed: message + a **Settings** action that opens
     Settings › Read aloud (where the switch and the install helper already are).
   - No Sanskrit voice: message only.
   - No voice: the existing `descTtsUnavailableNoVoice` text.

3. Mixed pages keep using the main script of the page (as today). A few English words on a
   Malayalam page are read by the Malayalam voice.

Not included (could be a later idea): using a Hindi voice to read Devanagari text.

## Files to change

- `lib/features/reading/domain/tts_text_splitter.dart` (new) — `splitForSpeech()`.
- `lib/features/reading/domain/tts_state.dart` — new enum `TtsVoiceProblem`.
- `lib/features/reading/data/tts_service.dart` — use `splitForSpeech`; add
  `voiceProblemFor()`; `speak()` returns the problem (or `none`) and no longer falls back.
- `lib/features/viewer/presentation/viewer_screen.dart` — `_speakCurrentPage` shows the
  message (with the Settings action) instead of starting.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ generated files) — new strings:
  - `descTtsMalayalamVoiceOff`: "This page is in Malayalam. Turn on the Malayalam voice in
    Settings › Read aloud."
  - `descTtsMalayalamVoiceMissing`: "This page is in Malayalam, but the Malayalam voice is not
    installed."
  - `descTtsNoSanskritVoice`: "This page is in Sanskrit. There is no Sanskrit voice, so it
    cannot be read aloud."
  - `actionTtsOpenSettings`: "Settings" (short label for the snackbar action).
- `test/features/reading/domain/tts_text_splitter_test.dart` (new) — punctuation, `॥`,
  joined lines, long text with no marks, very long word.
- `test/features/reading/data/tts_service_test.dart` — each voice problem; no English
  fallback; Malayalam text is split into short pieces.
- `CHANGELOG.md`, `docs/features.md`.

## Checks

- `flutter gen-l10n`, `dart format .`, `flutter analyze`, `flutter test`.
- Build, then on the emulator: the Malayalam PDF (voice not installed there) shows the
  message; the Sanskrit PDF shows the message; English still reads. On the Redmi (Folio Dev):
  Malayalam with the voice on reads in short pieces, and the speed button changes the speed.
  Then `android\gradlew --stop` and check for leftover daemons.

**Security impact:** none. No network, storage, permission, or dependency changes.

Translations to flag for native-reader review: the three new Malayalam and Sanskrit messages.
