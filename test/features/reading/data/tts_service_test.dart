import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/reading/data/tts_engine.dart';
import 'package:pdfapp/features/reading/data/tts_service.dart';
import 'package:pdfapp/features/reading/domain/tts_state.dart';

class _FakeTtsEngine implements TtsEngine {
  List<String> languages = ['en-us', 'ml-in'];
  bool mlInstalled = false;
  bool enInstalled = true;

  String? lastSpoken;
  String? activeLanguage;
  bool isSpeaking = false;
  bool isPaused = false;

  void Function()? completeHandler;
  void Function(String)? errorHandler;

  @override
  Future<List<String>> availableLanguages() async => languages;

  @override
  Future<bool> isLanguageInstalled(String languageCode) async {
    if (languageCode == 'en-US') return enInstalled;
    if (languageCode == 'ml-IN') return mlInstalled;
    return false;
  }

  @override
  Future<void> setLanguage(String languageCode) async {
    activeLanguage = languageCode;
  }

  @override
  Future<void> speak(String text) async {
    lastSpoken = text;
    isSpeaking = true;
    isPaused = false;
  }

  @override
  Future<void> stop() async {
    isSpeaking = false;
    isPaused = false;
  }

  @override
  Future<bool> pause() async {
    isSpeaking = false;
    isPaused = true;
    return true;
  }

  @override
  set onComplete(void Function() handler) => completeHandler = handler;

  @override
  set onError(void Function(String message) handler) => errorHandler = handler;
}

void main() {
  setUpAll(() {
    AppLogger.init();
  });

  late _FakeTtsEngine engine;
  late List<bool> savedStates;

  setUp(() {
    engine = _FakeTtsEngine();
    savedStates = [];
  });

  TtsService createService({bool malayalamEnabled = false}) {
    return TtsService(
      engine: engine,
      malayalamEnabled: malayalamEnabled,
      saveMalayalamEnabled: ({required enabled}) async {
        savedStates.add(enabled);
      },
    );
  }

  test('initializes with the correct defaults', () async {
    final service = createService();
    expect(service.status.malayalamEnabled, isFalse);
    expect(service.status.english, TtsVoiceState.unknown);
    expect(service.status.malayalam, TtsVoiceState.unknown);
  });

  test(
    'refreshVoices works out language availability and installation states',
    () async {
      final service = createService();
      await service.refreshVoices();

      expect(service.status.english, TtsVoiceState.ready);
      expect(service.status.malayalam, TtsVoiceState.needsInstall);

      // If Malayalam is not supported by the engine at all
      engine.languages = ['en-us'];
      await service.refreshVoices();
      expect(service.status.malayalam, TtsVoiceState.unavailable);
    },
  );

  test(
    'enabling Malayalam triggers install sheet guidance if not ready',
    () async {
      final service = createService();
      await service.refreshVoices();

      final state = await service.setMalayalamEnabled(enabled: true);
      expect(state, TtsVoiceState.needsInstall);
      expect(service.status.malayalamEnabled, isTrue);
      expect(savedStates, [true]);
    },
  );

  test(
    'disappearing voice auto-disables Malayalam setting and triggers notice',
    () async {
      engine.mlInstalled = true;
      final service = createService(malayalamEnabled: true);
      await service.refreshVoices();

      expect(service.status.malayalamEnabled, isTrue);

      // Now Malayalam disappears from the engine
      engine.languages = ['en-us'];
      await service.refreshVoices();

      expect(service.status.malayalamEnabled, isFalse);
      expect(service.status.malayalam, TtsVoiceState.unavailable);
      expect(savedStates, [false]);
      expect(service.takeVoiceLostNotice(), isTrue);
      expect(service.takeVoiceLostNotice(), isFalse); // consumed
    },
  );

  test('speak picks correct language and updates status', () async {
    final service = createService(malayalamEnabled: true);
    engine.mlInstalled = true; // Malayalam is ready now
    await service.refreshVoices();

    await service.speak('ഹലോ ലോകം', page: 3); // Malayalam text
    expect(engine.lastSpoken, 'ഹലോ ലോകം');
    expect(engine.activeLanguage, 'ml-IN');
    expect(service.status.playback, TtsPlaybackState.speaking);
    expect(service.status.speakingPage, 3);

    await service.speak('Hello world', page: 4); // English text
    expect(engine.lastSpoken, 'Hello world');
    expect(engine.activeLanguage, 'en-US');
    expect(service.status.playback, TtsPlaybackState.speaking);
    expect(service.status.speakingPage, 4);
  });

  test('pause and stop work as expected', () async {
    final service = createService();
    await service.refreshVoices();

    await service.speak('Hello', page: 1);
    expect(service.status.isSpeaking, isTrue);

    await service.pause();
    expect(service.status.isPaused, isTrue);
    expect(service.status.speakingPage, 1);

    await service.stop();
    expect(service.status.isIdle, isTrue);
    expect(service.status.speakingPage, isNull);
  });
}
