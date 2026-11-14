# Read aloud: shorter pieces for Malayalam

Implements plan: `plans/20261113_225336_shorter_malayalam_speech_pieces.md`

## What changed

- `lib/features/reading/domain/tts_text_splitter.dart`: new constant
  `maxMalayalamSpeechPieceLength = 100`, with a comment on why (a Malayalam syllable takes
  several UTF-16 units). `maxSpeechPieceLength` stays 200.
- `lib/features/reading/data/tts_service.dart`: `speak()` passes 100 to `splitForSpeech()`
  for Malayalam text and 200 for English.
- `test/features/reading/data/tts_service_test.dart`: Malayalam pieces are at most 100
  characters; a new test checks that English text with no marks still uses the 200 limit.
- `docs/features.md`, `CHANGELOG.md` updated.

## Checks

- `dart format`, `flutter analyze` (no issues), `flutter test` (595 passed).
- Emulator, prod release build, Malayalam PDF at 0.75×: each piece now takes about 8 s
  (8.1 s and 7.6 s), down from about 15 s. A speed change is heard within that time.
- Dev debug build installed on the test phone.
- Gradle daemon stopped; no leftover Gradle or Kotlin daemons.

## Notes

- Not yet heard by the user on the phone. The 100 limit may still be tuned after listening.
