import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/core/platform/tts_channel.dart';
import 'package:pdfapp/core/search/script_detector.dart';
import 'package:pdfapp/features/reading/data/tts_engine.dart';
import 'package:pdfapp/features/reading/domain/tts_state.dart';
import 'package:pdfapp/features/reading/domain/tts_text_splitter.dart';

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

  /// True while a piece has been handed to the engine and has not finished.
  bool _pieceInProgress = false;

  /// Goes up on every start, pause and stop, so an old reading loop that wakes
  /// up late can see it is out of date and quit instead of reading twice.
  int _run = 0;

  // Whole-document reading
  TtsNextPage? _nextPage;
  TtsLanguage? _activeLanguage;
  bool _documentFinished = false;
  TtsVoiceProblem _stopProblem = TtsVoiceProblem.none;

  /// True once, after reading reached the end of the document. Reading it
  /// clears it.
  bool takeDocumentFinished() {
    final finished = _documentFinished;
    _documentFinished = false;
    return finished;
  }

  /// Why whole-document reading stopped on a later page (for example a
  /// Malayalam page with the voice off), once. Reading it clears it.
  TtsVoiceProblem takeStopProblem() {
    final problem = _stopProblem;
    _stopProblem = TtsVoiceProblem.none;
    return problem;
  }

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

  /// Whether [text] can be read aloud, judged by its main script.
  ///
  /// Never suggests another language's voice as a stand-in.
  TtsVoiceProblem voiceProblemFor(String text) {
    switch (ScriptDetector.dominantScript(text)) {
      case PdfScript.devanagari:
        return TtsVoiceProblem.noSanskritVoice;
      case PdfScript.malayalam:
        if (_status.malayalam != TtsVoiceState.ready) {
          return TtsVoiceProblem.malayalamNotInstalled;
        }
        return _status.malayalamEnabled
            ? TtsVoiceProblem.none
            : TtsVoiceProblem.malayalamOff;
      case PdfScript.other:
        return _status.english == TtsVoiceState.ready
            ? TtsVoiceProblem.none
            : TtsVoiceProblem.noVoice;
    }
  }

  /// Reads [text] aloud piece by piece, inserting [sentencePauseSeconds]
  /// pause between pieces for natural prosody.
  ///
  /// With [nextPage], reading does not stop at the end of [page]: it asks for
  /// the next page and carries on, until the document ends or a page has no
  /// voice. Without it, only [text] is read.
  ///
  /// Returns why it did not start, or [TtsVoiceProblem.none] when it did (or
  /// there was nothing to read).
  Future<TtsVoiceProblem> speak(
    String text, {
    int? page,
    String? documentTitle,
    double? speechRate,
    double? pitch,
    double? sentencePauseSeconds,
    TtsNextPage? nextPage,
  }) async {
    final raw = text.trim();
    if (raw.isEmpty) return TtsVoiceProblem.none;

    final problem = voiceProblemFor(raw);
    if (problem != TtsVoiceProblem.none) return problem;
    final language = ScriptDetector.dominantScript(raw) == PdfScript.malayalam
        ? TtsLanguage.malayalam
        : TtsLanguage.english;

    await stop();

    _activeDocTitle = documentTitle ?? 'PDF Document';
    _sentencePauseSeconds = sentencePauseSeconds ?? 0.4;
    _nextPage = page == null ? null : nextPage;
    _documentFinished = false;
    _stopProblem = TtsVoiceProblem.none;
    _loadQueue(raw, language);

    try {
      await engine.setLanguage(language.code);
      _activeLanguage = language;
      if (speechRate != null) await engine.setSpeechRate(speechRate);
      if (pitch != null) await engine.setPitch(pitch);

      _set(
        _status.copyWith(
          playback: TtsPlaybackState.speaking,
          speakingPage: page,
        ),
      );

      _updateNotification(isPlaying: true);
      unawaited(_playNextSentence(++_run));
    } catch (e) {
      AppLogger.warning('Read aloud failed.', error: e);
      await stop();
    }
    return TtsVoiceProblem.none;
  }

  void _loadQueue(String text, TtsLanguage language) {
    _sentenceQueue = splitForSpeech(
      text,
      maxLength: language == TtsLanguage.malayalam
          ? maxMalayalamSpeechPieceLength
          : maxSpeechPieceLength,
    );
    _currentSentenceIndex = 0;
  }

  bool _isCurrent(int run) =>
      run == _run && _status.playback == TtsPlaybackState.speaking;

  Future<void> _playNextSentence(int run) async {
    if (!_isCurrent(run)) return;

    if (_currentSentenceIndex >= _sentenceQueue.length) {
      final page = _status.speakingPage;
      if (_nextPage != null && page != null) {
        await _continueAfter(page, run);
      } else {
        await stop();
      }
      return;
    }

    final sentence = _sentenceQueue[_currentSentenceIndex];
    _currentSentenceIndex++;

    _currentSentenceCompleter = Completer<void>();
    _pieceInProgress = true;
    await engine.speak(sentence);
    await _currentSentenceCompleter?.future;
    _pieceInProgress = false;

    if (!_isCurrent(run)) return;

    if (_currentSentenceIndex < _sentenceQueue.length &&
        _sentencePauseSeconds > 0) {
      _pauseTimer?.cancel();
      await Future<void>.delayed(
        Duration(milliseconds: (_sentencePauseSeconds * 1000).round()),
      );
    }

    await _playNextSentence(run);
  }

  /// Moves on to the page after [finishedPage], or stops at the end of the
  /// document or on a page with no voice.
  Future<void> _continueAfter(int finishedPage, int run) async {
    final nextPage = _nextPage;
    if (nextPage == null) return;

    TtsPageText? next;
    try {
      next = await nextPage(finishedPage);
    } catch (e) {
      AppLogger.warning('Could not get the next page to read.', error: e);
      await stop();
      return;
    }
    // The reader may have paused or stopped while the page was loading.
    if (!_isCurrent(run)) return;

    final text = next?.text.trim() ?? '';
    if (next == null || text.isEmpty) {
      _documentFinished = true;
      await stop();
      return;
    }

    final problem = voiceProblemFor(text);
    if (problem != TtsVoiceProblem.none) {
      _stopProblem = problem;
      await stop();
      return;
    }

    final language = ScriptDetector.dominantScript(text) == PdfScript.malayalam
        ? TtsLanguage.malayalam
        : TtsLanguage.english;
    try {
      if (language != _activeLanguage) {
        await engine.setLanguage(language.code);
        _activeLanguage = language;
      }
    } catch (e) {
      AppLogger.warning('Read aloud failed.', error: e);
      await stop();
      return;
    }
    if (!_isCurrent(run)) return;

    _loadQueue(text, language);
    _set(_status.copyWith(speakingPage: next.page));
    _updateNotification(isPlaying: true);
    await _playNextSentence(run);
  }

  void _onSentenceComplete() {
    if (_currentSentenceCompleter != null &&
        !_currentSentenceCompleter!.isCompleted) {
      _currentSentenceCompleter!.complete();
    }
  }

  /// Pauses mid-playback.
  Future<void> pause() async {
    if (!_status.isSpeaking) return;
    _pauseTimer?.cancel();
    _run++;
    // A piece cut off half-way is read again from its start on resume, so no
    // words are lost.
    if (_pieceInProgress && _currentSentenceIndex > 0) {
      _currentSentenceIndex--;
    }
    _pieceInProgress = false;
    // Mark paused before releasing the sentence wait, so the reading loop sees
    // it and does not start the next sentence.
    _set(_status.copyWith(playback: TtsPlaybackState.paused));
    if (_currentSentenceCompleter != null &&
        !_currentSentenceCompleter!.isCompleted) {
      _currentSentenceCompleter!.complete();
    }
    await engine.pause();
    _updateNotification(isPlaying: false);
  }

  /// Changes the speed. While reading, it takes effect from the next sentence.
  Future<void> setSpeechRate(double rate) async {
    try {
      await engine.setSpeechRate(rate);
    } catch (e) {
      AppLogger.warning('Could not change the speech rate.', error: e);
    }
  }

  /// Resumes playback from pause.
  Future<void> resume() async {
    if (!_status.isPaused) return;
    _set(_status.copyWith(playback: TtsPlaybackState.speaking));
    _updateNotification(isPlaying: true);
    await _playNextSentence(++_run);
  }

  Future<void> stop() async {
    _pauseTimer?.cancel();
    _run++;
    _nextPage = null;
    _pieceInProgress = false;
    _sentenceQueue = [];
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
      title: _activeDocTitle.isNotEmpty ? _activeDocTitle : 'Folio',
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
