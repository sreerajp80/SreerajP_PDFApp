# Read aloud: stop on close, real speed, speed button

Implements plan: `plans/20261113_212250_read_aloud_stop_and_speed.md`

## What changed

### Read aloud stops when the reader closes
- `lib/features/viewer/presentation/viewer_screen.dart`: the `TtsService` is now kept in a
  `_tts` field, set at the top of `initState()`. `dispose()` calls `_tts.stop()`. Before, it
  called `ref.read(...)` in `dispose()`, which Riverpod 3 rejects with a `StateError`, so
  the voice never stopped.
- Turning the read-aloud bar off with the speaker icon now also stops the voice. Before, the
  bar went away and the voice kept going with no control on screen.

### Real speed
- `lib/features/reading/data/tts_engine.dart`: `FlutterTtsEngine.setSpeechRate` sends
  `rate / 2` (`pluginRateFor`), because `flutter_tts` doubles the rate on Android. The app's
  `1.0` is now normal speed. Before, the default read at 2×, and the Settings slider gave 1×–4×.
- Anyone who saved a speed before will now hear it at half the old speed.

### Speed button in the read-aloud bar
- New `lib/features/reading/domain/tts_speed.dart`: `ttsSpeedSteps` (0.75, 1, 1.25, 1.5, 2),
  `nextSpeechRate()` (next higher step, wraps around; a slider value between steps goes up
  to the next step) and `speechRateFractionDigits()` (shows `1×`, `1.5×`, `1.25×`).
- `viewer_screen.dart`: `_buildSpeedButton` before Play/Pause. A tap saves the new speed
  (`ttsSpeechRateProvider`) and calls the new `TtsService.setSpeechRate`, so it applies from
  the next sentence.
- New strings `tooltipTtsSpeed` ("Reading speed" / "വായനാ വേഗം" / "पठनवेगः") and
  `labelTtsSpeedValue` ("{rate}×") in all three ARB files; `flutter gen-l10n` rerun.
- `test/l10n/translation_parity_test.dart`: `labelTtsSpeedValue` added to the
  same-as-English allow-list. It is only a number and the × symbol.

### Pause order
- `lib/features/reading/data/tts_service.dart`: `pause()` marks the state as paused before
  it ends the sentence wait. Before, with the sentence pause at 0, the loop could start one
  more sentence after Pause.

### Tests and docs
- `test/features/reading/data/tts_service_test.dart`: Pause does not start the next
  sentence; `setSpeechRate` reaches the engine; `pluginRateFor` halves the rate.
- New `test/features/reading/domain/tts_speed_test.dart`: speed steps, wrap-around,
  between-step values and display digits.
- `docs/features.md` and `CHANGELOG.md` updated.

## Checks
- `flutter gen-l10n`, `dart format .` (no changes), `flutter analyze` (no issues),
  `flutter test` (581 passed).
- Checked on an Android emulator with the prod release build: the speed button shows `1×` and
  changes to `1.25×` on tap; sentences take about 3–4 s (about 2 s before); after pressing
  Back while reading, no new sentence started.
- A dev debug build was installed on the test phone for the user to try by hand. The prod
  build could not be installed there, because the installed copy has a different signature.

## For native-reader review
- Malayalam `വായനാ വേഗം` and Sanskrit `पठनवेगः` (tooltip "Reading speed").
