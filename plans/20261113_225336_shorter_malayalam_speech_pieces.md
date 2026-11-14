# Read aloud: shorter pieces for Malayalam

**Status:** completed

Follows `plans/20261113_223414_read_aloud_sentences_and_voice_check.md`.

## The issue

Text is read in pieces of at most 200 characters (UTF-16 units). A new speed is used from
the next piece. Malayalam needs many characters per syllable (consonant + virama + vowel
signs), so a 200-character Malayalam piece took about 15 s at 0.75× on the emulator. A speed
change can take that long to be heard. Pause and Stop are not affected; they cut in at once.

## The fix

- `TtsService.speak()` passes a smaller limit to `splitForSpeech()` for Malayalam text:
  **100** characters (about 7 s at 0.75×, 3–4 s at 1×). English keeps 200, because English
  text is usually cut at `. ` long before the limit.
- The limits become named constants in `lib/features/reading/domain/tts_text_splitter.dart`:
  `maxSpeechPieceLength = 200` (as now) and `maxMalayalamSpeechPieceLength = 100`.
- `splitForSpeech()` itself does not change. It already cuts at the last space before the
  limit, so words are not broken.

Honest downside: more pieces means a short pause (the sentence-pause setting, 0.4 s by
default) more often inside Malayalam verses. 100 is a middle value; we can tune it after
listening.

## Files to change

- `lib/features/reading/domain/tts_text_splitter.dart` — new constant.
- `lib/features/reading/data/tts_service.dart` — choose the limit by language.
- `test/features/reading/data/tts_service_test.dart` — Malayalam pieces are at most 100
  characters; English pieces may still be up to 200.
- `CHANGELOG.md`, `docs/features.md` — mention the shorter Malayalam pieces.

## Checks

- `dart format`, `flutter analyze`, `flutter test`.
- Build, then on the emulator: time the first Malayalam piece at 0.75× (expect about 7 s or
  less). Install the dev build on the test phone. Then `android\gradlew --stop` and check for
  leftover daemons.

**Security impact:** none.
