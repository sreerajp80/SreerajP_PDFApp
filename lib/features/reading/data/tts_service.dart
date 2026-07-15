import 'package:flutter/foundation.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/core/search/script_detector.dart';
import 'package:pdfapp/features/reading/data/tts_engine.dart';
import 'package:pdfapp/features/reading/domain/tts_state.dart';

/// Reads text aloud, and always knows whether it can.
///
/// The shared read-aloud module (project rule §6: never a dead button). Reader
/// screens ask it for [status] and draw whatever it reports — ready, needs
/// installing, or not possible — instead of offering a control that quietly
/// fails.
///
/// Malayalam is off unless the reader turns it on, because the voice is an extra
/// download on most phones. When it is on but the voice has since been removed,
/// the toggle **turns itself off** and says so, rather than staying on and doing
/// nothing.
class TtsService extends ChangeNotifier {
  TtsService({
    required TtsEngine engine,
    required Future<void> Function({required bool enabled})
    saveMalayalamEnabled,
    bool malayalamEnabled = false,
  }) : _engine = engine,
       _saveMalayalamEnabled = saveMalayalamEnabled {
    _status = TtsStatus(malayalamEnabled: malayalamEnabled);
    _engine.onComplete = _onComplete;
    _engine.onError = _onError;
  }

  final TtsEngine _engine;
  final Future<void> Function({required bool enabled}) _saveMalayalamEnabled;

  TtsStatus _status = const TtsStatus();
  TtsStatus get status => _status;

  /// Set when the Malayalam voice vanished after being switched on, so the
  /// reader can be told once. Reading it clears it.
  bool _voiceLostNotice = false;
  bool takeVoiceLostNotice() {
    final lost = _voiceLostNotice;
    _voiceLostNotice = false;
    return lost;
  }

  /// Asks the engine which voices exist. Call once at startup and again after
  /// the reader comes back from installing one.
  Future<void> refreshVoices() async {
    final english = await _check(TtsLanguage.english);
    final malayalam = await _check(TtsLanguage.malayalam);

    // The reader switched Malayalam on, and the voice has since gone. Turn the
    // switch off rather than leave it on and silent.
    final lost = _status.malayalamEnabled && malayalam != TtsVoiceState.ready;
    if (lost) {
      _voiceLostNotice = true;
      await _saveMalayalamEnabled(enabled: false);
      AppLogger.info(
        'The Malayalam voice is gone; the setting was turned off.',
      );
    }

    _set(
      _status.copyWith(
        english: english,
        malayalam: malayalam,
        malayalamEnabled: _status.malayalamEnabled && !lost,
      ),
    );
  }

  /// Works out the state of one language.
  ///
  /// "Installed" and "the engine has heard of it" are different things, and the
  /// difference decides what we offer: a download, or an honest "not possible".
  Future<TtsVoiceState> _check(TtsLanguage language) async {
    final languages = await _engine.availableLanguages();
    if (languages.isEmpty) return TtsVoiceState.unavailable;

    final code = language.code.toLowerCase();
    final known =
        languages.contains(code) ||
        // Engines report tags loosely: 'ml' may stand in for 'ml-IN'.
        languages.any((l) => l.startsWith('${code.split('-').first}-')) ||
        languages.contains(code.split('-').first);
    if (!known) return TtsVoiceState.unavailable;

    return await _engine.isLanguageInstalled(language.code)
        ? TtsVoiceState.ready
        : TtsVoiceState.needsInstall;
  }

  /// Turns the Malayalam voice on or off and remembers the choice.
  ///
  /// Returns the voice's state, so the caller can offer the install flow when it
  /// is [TtsVoiceState.needsInstall]. The switch still goes on: the reader asked
  /// for it, and it starts working the moment the voice arrives.
  Future<TtsVoiceState> setMalayalamEnabled({required bool enabled}) async {
    await _saveMalayalamEnabled(enabled: enabled);
    _set(_status.copyWith(malayalamEnabled: enabled));

    if (!enabled) return _status.malayalam;

    final state = await _check(TtsLanguage.malayalam);
    _set(_status.copyWith(malayalam: state));
    return state;
  }

  /// Reads [text] aloud, picking the voice from the script it is written in.
  ///
  /// Does nothing (and says why through [status]) when there is no usable voice
  /// — the caller should not have offered the control in that case anyway.
  Future<void> speak(String text, {int? page}) async {
    final words = text.trim();
    if (words.isEmpty) return;

    final language = _languageFor(words);
    if (_stateOf(language) != TtsVoiceState.ready) return;

    await stop();
    try {
      await _engine.setLanguage(language.code);
      _set(
        _status.copyWith(
          playback: TtsPlaybackState.speaking,
          speakingPage: page,
        ),
      );
      await _engine.speak(words);
    } catch (e) {
      AppLogger.warning('Read aloud failed.', error: e);
      _set(
        _status.copyWith(
          playback: TtsPlaybackState.idle,
          clearSpeakingPage: true,
        ),
      );
    }
  }

  /// Picks the voice for [text].
  ///
  /// Malayalam text is only read in Malayalam when the reader switched it on and
  /// the voice is there; otherwise English is used, which is honest for the
  /// Latin text in the same document and simply skips what it cannot say.
  TtsLanguage _languageFor(String text) {
    final malayalam =
        ScriptDetector.dominantScript(text) == PdfScript.malayalam;
    return malayalam && _status.malayalamUsable
        ? TtsLanguage.malayalam
        : TtsLanguage.english;
  }

  TtsVoiceState _stateOf(TtsLanguage language) => switch (language) {
    TtsLanguage.english => _status.english,
    TtsLanguage.malayalam => _status.malayalam,
  };

  /// Pauses if the engine can; stops if it cannot, so the control always does
  /// something the reader can see.
  Future<void> pause() async {
    if (!_status.isSpeaking) return;
    if (await _engine.pause()) {
      _set(_status.copyWith(playback: TtsPlaybackState.paused));
    } else {
      await stop();
    }
  }

  Future<void> stop() async {
    if (_status.isIdle) return;
    await _engine.stop();
    _set(
      _status.copyWith(
        playback: TtsPlaybackState.idle,
        clearSpeakingPage: true,
      ),
    );
  }

  void _onComplete() => _set(
    _status.copyWith(playback: TtsPlaybackState.idle, clearSpeakingPage: true),
  );

  void _onError(String message) {
    AppLogger.warning('The speech engine reported: $message');
    _set(
      _status.copyWith(
        playback: TtsPlaybackState.idle,
        clearSpeakingPage: true,
      ),
    );
  }

  void _set(TtsStatus status) {
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    // Speech outlives the screen otherwise — it is played by the system.
    _engine.stop();
    super.dispose();
  }
}
