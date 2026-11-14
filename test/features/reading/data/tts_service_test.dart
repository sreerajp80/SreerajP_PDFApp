import 'dart:async';

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

  /// When false, a sentence only ends when the test calls [completeHandler],
  /// like a real engine that is still talking.
  bool autoComplete = true;
  final List<String> spoken = [];
  double? lastRate;

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
  Future<void> setSpeechRate(double rate) async {
    lastRate = rate;
  }

  @override
  Future<void> setPitch(double pitch) async {}

  @override
  Future<void> speak(String text) async {
    lastSpoken = text;
    spoken.add(text);
    isSpeaking = true;
    isPaused = false;
    if (autoComplete) completeHandler?.call();
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

  test('pause does not start the next sentence', () async {
    final service = createService();
    await service.refreshVoices();
    engine.autoComplete = false;

    await service.speak('One. Two. Three.', page: 1, sentencePauseSeconds: 0);
    await Future<void>.delayed(Duration.zero);
    expect(engine.spoken, ['One.']);

    await service.pause();
    await Future<void>.delayed(Duration.zero);

    expect(service.status.isPaused, isTrue);
    expect(engine.spoken, ['One.']);
  });

  test('setSpeechRate passes the new speed to the engine', () async {
    final service = createService();
    await service.setSpeechRate(1.25);
    expect(engine.lastRate, 1.25);
  });

  test('the Android plugin gets half the rate, so 1.0 is normal speed', () {
    expect(FlutterTtsEngine.pluginRateFor(1.0), 0.5);
    expect(FlutterTtsEngine.pluginRateFor(2.0), 1.0);
    expect(FlutterTtsEngine.pluginRateFor(0.5), 0.25);
  });

  group('voice check, with no fallback to English', () {
    test('Malayalam page with the voice switched off', () async {
      engine.mlInstalled = true;
      final service = createService();
      await service.refreshVoices();

      final problem = await service.speak('ഹലോ ലോകം', page: 1);
      expect(problem, TtsVoiceProblem.malayalamOff);
      expect(engine.spoken, isEmpty);
      expect(service.status.isIdle, isTrue);
    });

    test('Malayalam page with the voice not installed', () async {
      final service = createService(malayalamEnabled: true);
      await service.refreshVoices(); // ml-in known but not installed

      final problem = await service.speak('ഹലോ ലോകം', page: 1);
      expect(problem, TtsVoiceProblem.malayalamNotInstalled);
      expect(engine.spoken, isEmpty);
    });

    test('Sanskrit (Devanagari) page has no voice', () async {
      final service = createService();
      await service.refreshVoices();

      final problem = await service.speak('धर्मक्षेत्रे कुरुक्षेत्रे', page: 1);
      expect(problem, TtsVoiceProblem.noSanskritVoice);
      expect(engine.spoken, isEmpty);
    });

    test('English page with no English voice', () async {
      engine.enInstalled = false;
      final service = createService();
      await service.refreshVoices();

      expect(service.voiceProblemFor('Hello'), TtsVoiceProblem.noVoice);
      expect(await service.speak('Hello'), TtsVoiceProblem.noVoice);
      expect(engine.spoken, isEmpty);
    });

    test('ready voices report no problem', () async {
      engine.mlInstalled = true;
      final service = createService(malayalamEnabled: true);
      await service.refreshVoices();

      expect(service.voiceProblemFor('Hello'), TtsVoiceProblem.none);
      expect(service.voiceProblemFor('ഹലോ ലോകം'), TtsVoiceProblem.none);
    });
  });

  test('Malayalam verse with no punctuation is read in short pieces', () async {
    engine.mlInstalled = true;
    final service = createService(malayalamEnabled: true);
    await service.refreshVoices();
    engine.autoComplete = false;

    final verse = List.filled(30, 'ശ്രീമാതാ ശ്രീമഹാരാജ്ഞീ (1)\n').join();
    await service.speak(verse, page: 1, sentencePauseSeconds: 0);
    await Future<void>.delayed(Duration.zero);

    expect(engine.spoken, hasLength(1));
    expect(engine.spoken.single.length, lessThanOrEqualTo(100));
    expect(engine.spoken.single.length, lessThan(verse.length));
  });

  test('English text with no marks still uses the longer limit', () async {
    final service = createService();
    await service.refreshVoices();
    engine.autoComplete = false;

    final words = List.filled(60, 'word').join(' '); // 299 characters
    await service.speak(words, page: 1, sentencePauseSeconds: 0);
    await Future<void>.delayed(Duration.zero);

    expect(engine.spoken.single.length, greaterThan(100));
    expect(engine.spoken.single.length, lessThanOrEqualTo(200));
  });

  group('whole-document reading', () {
    Future<void> settle() async {
      for (var i = 0; i < 20; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    TtsNextPage pagesFrom(Map<int, String> pages) => (finished) async {
      final next = finished + 1;
      final text = pages[next];
      return text == null ? null : TtsPageText(page: next, text: text);
    };

    test('goes on to the next pages, then reports the end', () async {
      final service = createService();
      await service.refreshVoices();
      final pagesSeen = <int?>[];
      service.addListener(() => pagesSeen.add(service.status.speakingPage));

      await service.speak(
        'One.',
        page: 1,
        sentencePauseSeconds: 0,
        nextPage: pagesFrom({2: 'Two.', 3: 'Three.'}),
      );
      await settle();

      expect(engine.spoken, ['One.', 'Two.', 'Three.']);
      expect(pagesSeen, containsAllInOrder([1, 2, 3]));
      expect(service.status.isIdle, isTrue);
      expect(service.takeDocumentFinished(), isTrue);
      expect(service.takeDocumentFinished(), isFalse);
    });

    test('without a next-page callback, one page is read', () async {
      final service = createService();
      await service.refreshVoices();

      await service.speak('One.', page: 1, sentencePauseSeconds: 0);
      await settle();

      expect(engine.spoken, ['One.']);
      expect(service.status.isIdle, isTrue);
      expect(service.takeDocumentFinished(), isFalse);
    });

    test('stops on a page with no voice and says why', () async {
      final service = createService();
      await service.refreshVoices();

      await service.speak(
        'One.',
        page: 1,
        sentencePauseSeconds: 0,
        nextPage: pagesFrom({2: 'ഇത് മലയാളം ആണ്.'}),
      );
      await settle();

      expect(engine.spoken, ['One.']);
      expect(service.status.isIdle, isTrue);
      expect(service.takeStopProblem(), TtsVoiceProblem.malayalamNotInstalled);
      expect(service.takeDocumentFinished(), isFalse);
    });

    test('stop while reading does not go on to the next page', () async {
      final service = createService();
      await service.refreshVoices();
      engine.autoComplete = false;

      await service.speak(
        'One.',
        page: 1,
        sentencePauseSeconds: 0,
        nextPage: pagesFrom({2: 'Two.'}),
      );
      await settle();
      await service.stop();
      engine.completeHandler?.call();
      await settle();

      expect(engine.spoken, ['One.']);
      expect(service.takeDocumentFinished(), isFalse);
    });
  });

  test('resume repeats the piece cut by pause, not the whole page', () async {
    final service = createService();
    await service.refreshVoices();
    engine.autoComplete = false;

    await service.speak('One. Two.', page: 1, sentencePauseSeconds: 0);
    await Future<void>.delayed(Duration.zero);
    expect(engine.spoken, ['One.']);

    await service.pause();
    unawaited(service.resume());
    await Future<void>.delayed(Duration.zero);
    expect(engine.spoken, ['One.', 'One.']);

    engine.completeHandler?.call();
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(engine.spoken, ['One.', 'One.', 'Two.']);
  });
}
