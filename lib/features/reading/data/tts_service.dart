import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/core/platform/tts_channel.dart';
import 'package:pdfapp/core/search/script_detector.dart';
import 'package:pdfapp/features/reading/data/tts_engine.dart';
import 'package:pdfapp/features/reading/domain/tts_state.dart';

/// Reads text aloud, and always knows whether it can.
///
/// Features pitch adjustment, sentence-boundary pause insertions for natural
/// cadence, and persistent background notification player controls.
class TtsService extends ChangeNotifier {
  TtsService({
    required this.engine,
    required this.saveMalayalamEnabled,
    this.ttsChannel,
    bool malayalamEnabled = false,
  }) {
    _status = TtsStatus(malayalamEnabled: malayalamEnabled);
    engine.onComplete = _onSentenceComplete;
    engine.onError = _onError;
    ttsChannel?.onActionReceived = _handleNotificationAction;
  }

  final TtsEngine engine;
  final Future<void> Function({required bool enabled}) saveMalayalamEnabled;
  final TtsChannel? ttsChannel;

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

  // Sentence queue & pause control
  List<String> _sentenceQueue = [];
  int _currentSentenceIndex = 0;
  double _sentencePauseSeconds = 0.4;
  Timer? _pauseTimer;
  Completer<void>? _currentSentenceCompleter;
  String _activeDocTitle = '';

  void _handleNotificationAction(String action) {
    switch (action.toLowerCase()) {
      case 'play':
        if (_status.isPaused) resume();
        break;
      case 'pause':
        if (_status.isSpeaking) pause();
        break;
      case 'stop':
        stop();
        break;
    }
  }

  /// Asks the engine which voices exist. Call once at startup and again after
  /// the reader comes back from installing one.
  Future<void> refreshVoices() async {
    final english = await _check(TtsLanguage.english);
    final malayalam = await _check(TtsLanguage.malayalam);

    final lost = _status.malayalamEnabled && malayalam != TtsVoiceState.ready;
    if (lost) {
      _voiceLostNotice = true;
      await saveMalayalamEnabled(enabled: false);
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

  Future<TtsVoiceState> _check(TtsLanguage language) async {
    final languages = await engine.availableLanguages();
    if (languages.isEmpty) return TtsVoiceState.unavailable;

    final code = language.code.toLowerCase();
    final known =
        languages.contains(code) ||
        languages.any((l) => l.startsWith('${code.split('-').first}-')) ||
        languages.contains(code.split('-').first);
    if (!known) return TtsVoiceState.unavailable;

    return await engine.isLanguageInstalled(language.code)
        ? TtsVoiceState.ready
        : TtsVoiceState.needsInstall;
  }

  Future<TtsVoiceState> setMalayalamEnabled({required bool enabled}) async {
    await saveMalayalamEnabled(enabled: enabled);
    _set(_status.copyWith(malayalamEnabled: enabled));

    if (!enabled) return _status.malayalam;

    final state = await _check(TtsLanguage.malayalam);
    _set(_status.copyWith(malayalam: state));
    return state;
  }

  /// Reads [text] aloud sentence by sentence, inserting [sentencePauseSeconds]
  /// pause between sentences for natural prosody.
  Future<void> speak(
    String text, {
    int? page,
    String? documentTitle,
    double? speechRate,
    double? pitch,
    double? sentencePauseSeconds,
  }) async {
    final raw = text.trim();
    if (raw.isEmpty) return;

    final language = _languageFor(raw);
    if (_stateOf(language) != TtsVoiceState.ready) return;

    await stop();

    _activeDocTitle = documentTitle ?? 'PDF Document';
    _sentencePauseSeconds = sentencePauseSeconds ?? 0.4;
    _sentenceQueue = _splitIntoSentences(raw);
    _currentSentenceIndex = 0;

    try {
      await engine.setLanguage(language.code);
      if (speechRate != null) await engine.setSpeechRate(speechRate);
      if (pitch != null) await engine.setPitch(pitch);

      _set(
        _status.copyWith(
          playback: TtsPlaybackState.speaking,
          speakingPage: page,
        ),
      );

      _updateNotification(isPlaying: true);
      unawaited(_playNextSentence());
    } catch (e) {
      AppLogger.warning('Read aloud failed.', error: e);
      await stop();
    }
  }

  List<String> _splitIntoSentences(String text) {
    final matches = text.split(RegExp(r'(?<=[.!?।|\n])\s+'));
    return matches.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  Future<void> _playNextSentence() async {
    if (_status.playback != TtsPlaybackState.speaking) return;

    if (_currentSentenceIndex >= _sentenceQueue.length) {
      await stop();
      return;
    }

    final sentence = _sentenceQueue[_currentSentenceIndex];
    _currentSentenceIndex++;

    _currentSentenceCompleter = Completer<void>();
    await engine.speak(sentence);
    await _currentSentenceCompleter?.future;

    if (_status.playback != TtsPlaybackState.speaking) return;

    if (_currentSentenceIndex < _sentenceQueue.length &&
        _sentencePauseSeconds > 0) {
      _pauseTimer?.cancel();
      await Future<void>.delayed(
        Duration(milliseconds: (_sentencePauseSeconds * 1000).round()),
      );
    }

    if (_status.playback == TtsPlaybackState.speaking) {
      await _playNextSentence();
    }
  }

  void _onSentenceComplete() {
    if (_currentSentenceCompleter != null &&
        !_currentSentenceCompleter!.isCompleted) {
      _currentSentenceCompleter!.complete();
    }
  }

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

  /// Pauses mid-playback.
  Future<void> pause() async {
    if (!_status.isSpeaking) return;
    _pauseTimer?.cancel();
    if (_currentSentenceCompleter != null &&
        !_currentSentenceCompleter!.isCompleted) {
      _currentSentenceCompleter!.complete();
    }
    await engine.pause();
    _set(_status.copyWith(playback: TtsPlaybackState.paused));
    _updateNotification(isPlaying: false);
  }

  /// Resumes playback from pause.
  Future<void> resume() async {
    if (!_status.isPaused) return;
    _set(_status.copyWith(playback: TtsPlaybackState.speaking));
    _updateNotification(isPlaying: true);
    await _playNextSentence();
  }

  Future<void> stop() async {
    _pauseTimer?.cancel();
    _sentenceQueue.clear();
    _currentSentenceIndex = 0;
    if (_currentSentenceCompleter != null &&
        !_currentSentenceCompleter!.isCompleted) {
      _currentSentenceCompleter!.complete();
    }

    if (!_status.isIdle) {
      await engine.stop();
      _set(
        _status.copyWith(
          playback: TtsPlaybackState.idle,
          clearSpeakingPage: true,
        ),
      );
    }
    unawaited(ttsChannel?.cancelNotification());
  }

  void _onError(String message) {
    AppLogger.warning('The speech engine reported: $message');
    stop();
  }

  void _updateNotification({required bool isPlaying}) {
    final page = _status.speakingPage;
    final content = page != null ? 'Reading page $page' : 'Reading aloud';
    ttsChannel?.showNotification(
      title: _activeDocTitle.isNotEmpty ? _activeDocTitle : 'SreerajP PDF App',
      content: content,
      isPlaying: isPlaying,
    );
  }

  void _set(TtsStatus status) {
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _pauseTimer?.cancel();
    engine.stop();
    ttsChannel?.cancelNotification();
    super.dispose();
  }
}
