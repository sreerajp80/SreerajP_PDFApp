# Read aloud: stop on close, real speed, speed button in the reader

**Status:** completed

## The issues (checked on a real phone, Android 10, MIUI)

1. **Reading goes on after the PDF is closed.**
   `ViewerScreen.dispose()` calls `ref.read(ttsServiceProvider).stop()`.
   Riverpod 3 does not allow `ref` once the widget is leaving the screen. It throws
   `StateError('Using "ref" when a widget is about to or has been unmounted is unsafe...')`.
   So `stop()` never runs, and the voice keeps reading on the home screen. Release builds
   hide the error, so nothing shows in logcat. (Confirmed: new sentences kept starting
   after the PDF was closed.)

2. **Reading is far too fast ("superspeed").**
   On Android the `flutter_tts` plugin doubles the rate (`rate * 2.0f`, "Android 1.0 is
   mapped to flutter 0.5"). Our default is `1.0`, so the phone gets **2× speed**. The
   Settings slider (0.5–2.0) really gives 1×–4×, so the reader can never go to normal or slower.

3. **Speed cannot be changed while reading.** The only control is in Settings → Read aloud,
   and a change applies only on the next Play.

4. **Small extra problems found on the way:**
   - Tapping the speaker icon in the top bar while reading hides the read-aloud bar but
     keeps reading. Then there is no Pause/Stop on screen.
   - `TtsService.pause()` finishes the sentence wait *before* it marks the state as paused.
     With the sentence pause set to 0, the loop can start one more sentence after Pause.

Not a bug: Pause and Stop in the bar work with a finger. Taps sent from a PC screen mirror
are blocked by MIUI ("Permission denied: injecting event"), so they never reached the app.

## The fix

1. **Stop on close.** Keep the `TtsService` in a field that is set in `initState()`
   (the same way `_repo` is kept). Call `_tts.stop()` in `dispose()`, not `ref.read`.
2. **Real speed.** In `FlutterTtsEngine.setSpeechRate`, send `rate / 2` to the plugin, so
   the app's `1.0` means normal speed on Android. Explain it in a short code comment. The
   Settings slider keeps 0.5–2.0, which now really means 0.5×–2×.
   Note: anyone who saved a speed before will hear it at half the old speed. That is the
   point of the fix (the old default was 2×).
3. **Speed button in the read-aloud bar** (the user's choice: tap to cycle).
   - A text button showing the current speed, e.g. `1×`, `1.25×`, placed before Play/Pause.
   - Each tap goes 0.75× → 1× → 1.25× → 1.5× → 2× → back to 0.75×. If the saved speed is
     not one of these (set from the Settings slider), it goes to the next higher step.
   - The new speed is saved (`ttsSpeechRateProvider`) and used from the **next sentence**
     while reading. A new `TtsService.setSpeechRate(double)` passes it to the engine.
   - The step logic is a small pure function (`nextSpeechRate`) so it can be unit tested.
   - Localized tooltip "Reading speed"; the number is formatted with `DisplayFormat`.
4. **Speaker icon while reading:** turning the bar off also calls `stop()`.
5. **Pause order:** in `pause()`, set the state to paused first, then end the sentence
   wait, then call `engine.pause()`.

## Files to change

- `lib/features/viewer/presentation/viewer_screen.dart` — `_tts` field, `dispose()`,
  speaker-icon stop, speed button in `_buildTtsBottomBar`.
- `lib/features/reading/data/tts_engine.dart` — Android rate mapping.
- `lib/features/reading/data/tts_service.dart` — `setSpeechRate()`, pause order.
- `lib/features/reading/domain/tts_speed.dart` (new) — speed steps + `nextSpeechRate()`.
- `lib/l10n/app_en.arb`, `app_ml.arb`, `app_sa.arb` (+ generated `app_localizations*.dart`) —
  new keys `tooltipTtsSpeed` ("Reading speed" / "വായനാ വേഗം" / "पठनवेगः") and
  `labelTtsSpeedValue` ("{rate}×", same pattern in all three; only the number changes).
- `test/features/reading/data/tts_service_test.dart` — rate change while speaking; pause
  does not start another sentence.
- `test/features/reading/domain/tts_speed_test.dart` (new) — cycle steps and odd values.
- `docs/features.md`, `CHANGELOG.md` — mention the speed button and the fixes.

## Checks

- `flutter gen-l10n`, `dart format .`, `flutter analyze` (0 issues), `flutter test`.
- On the phone (you run it): open the test PDF, read aloud, tap the speed button, close the
  PDF and confirm the voice stops. Then `android\gradlew --stop` and check no Gradle/Kotlin
  daemons are left.

**Security impact:** none. No network, storage, permission, or dependency changes.

Translations to flag for native-reader review: `വായനാ വേഗം`, `पठनवेगः`.
