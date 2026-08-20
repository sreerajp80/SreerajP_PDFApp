import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdfapp/core/logging/app_logger.dart';

/// The speech engine, behind a seam.
///
/// `flutter_tts` talks straight to the platform, so [TtsService] would need a
/// device to test. This interface keeps the decisions — which voice, what state,
/// when to auto-disable — in plain Dart that a fake can drive.
abstract class TtsEngine {
  /// Language tags the engine can speak, lower-cased (e.g. `en-us`, `ml-in`).
  Future<List<String>> availableLanguages();

  /// Whether [languageCode] is installed and ready to speak right now.
  Future<bool> isLanguageInstalled(String languageCode);

  Future<void> setLanguage(String languageCode);

  /// Sets speech rate (0.5 to 2.0).
  Future<void> setSpeechRate(double rate);

  /// Sets voice pitch (0.5 to 2.0).
  Future<void> setPitch(double pitch);

  /// Speaks [text]. Completes when the words have been handed to the engine,
  /// not when they finish being spoken — [onComplete] reports that.
  Future<void> speak(String text);

  Future<void> stop();

  /// Pauses mid-sentence. Not every engine supports this; returns false when it
  /// could not.
  Future<bool> pause();

  /// Called when the engine finishes speaking what it was given.
  set onComplete(void Function() handler);

  /// Called when the engine fails. The reader must be told, not left staring at
  /// a control that did nothing.
  set onError(void Function(String message) handler);
}

/// The real engine, on `flutter_tts`.
class FlutterTtsEngine implements TtsEngine {
  FlutterTtsEngine([FlutterTts? tts]) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;

  @override
  Future<List<String>> availableLanguages() async {
    try {
      final languages = await _tts.getLanguages as List<Object?>?;
      return [
        for (final language in languages ?? const [])
          language.toString().toLowerCase(),
      ];
    } catch (e) {
      // A device with no speech engine at all throws here. That is an answer,
      // not a crash: nothing is available.
      AppLogger.warning('Could not list speech languages.', error: e);
      return const [];
    }
  }

  @override
  Future<bool> isLanguageInstalled(String languageCode) async {
    try {
      // Android answers this properly; it is how we tell "needs downloading"
      // from "the engine has never heard of this language".
      final installed = await _tts.isLanguageInstalled(languageCode);
      return installed == true;
    } catch (e) {
      AppLogger.warning('Could not check the $languageCode voice.', error: e);
      return false;
    }
  }

  @override
  Future<void> setLanguage(String languageCode) =>
      _tts.setLanguage(languageCode);

  @override
  Future<void> setSpeechRate(double rate) => _tts.setSpeechRate(rate);

  @override
  Future<void> setPitch(double pitch) => _tts.setPitch(pitch);

  @override
  Future<void> speak(String text) => _tts.speak(text);

  @override
  Future<void> stop() => _tts.stop();

  @override
  Future<bool> pause() async {
    try {
      // Some engines have no pause; flutter_tts returns 0 when it did nothing.
      final result = await _tts.pause();
      return result == 1;
    } catch (e) {
      AppLogger.warning('This speech engine cannot pause.', error: e);
      return false;
    }
  }

  @override
  set onComplete(void Function() handler) => _tts.setCompletionHandler(handler);

  @override
  set onError(void Function(String message) handler) =>
      _tts.setErrorHandler((message) => handler(message.toString()));
}
