import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/reading/data/tts_engine.dart';
import 'package:pdfapp/features/reading/data/tts_service.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';
import 'package:pdfapp/features/reading/presentation/widgets/tts_install_sheet.dart';
import 'package:pdfapp/features/settings/presentation/settings_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeTtsEngine implements TtsEngine {
  List<String> languages = ['en-us', 'ml-in'];
  bool mlInstalled = false;
  bool enInstalled = true;

  @override
  Future<List<String>> availableLanguages() async => languages;

  @override
  Future<bool> isLanguageInstalled(String languageCode) async {
    if (languageCode == 'en-US') return enInstalled;
    if (languageCode == 'ml-IN') return mlInstalled;
    return false;
  }

  @override
  Future<void> setLanguage(String languageCode) async {}

  @override
  Future<void> speak(String text) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<bool> pause() async => true;

  @override
  set onComplete(void Function() handler) {}

  @override
  set onError(void Function(String message) handler) {}
}

void main() {
  late SharedPreferences prefs;
  late _FakeTtsEngine engine;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    engine = _FakeTtsEngine();
  });

  Future<void> pumpSettings(WidgetTester tester) async {
    final ttsService = TtsService(
      engine: engine,
      malayalamEnabled: prefs.getBool(AppConstants.prefMalayalamTts) ?? false,
      saveMalayalamEnabled: ({required enabled}) async {
        await prefs.setBool(AppConstants.prefMalayalamTts, enabled);
      },
    );
    await ttsService.refreshVoices();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          ttsServiceProvider.overrideWith((ref) => ttsService),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders all sections and theme radio choices', (tester) async {
    await pumpSettings(tester);

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Sepia'), findsOneWidget);

    expect(find.text('Read aloud'), findsOneWidget);
    expect(find.text('Malayalam voice'), findsOneWidget);
  });

  testWidgets('changing the theme updates notifier and settings', (
    tester,
  ) async {
    await pumpSettings(tester);

    // Default theme is system. Tap Light.
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    expect(prefs.getString(AppConstants.prefThemeMode), 'light');
  });

  testWidgets(
    'toggling Malayalam voice on triggers guided install sheet if missing',
    (tester) async {
      engine.mlInstalled = false; // missing
      await pumpSettings(tester);

      // Initial subtitle is "off"
      expect(
        find.text('Malayalam text is read with the English voice.'),
        findsOneWidget,
      );

      // Tap switch to turn on
      await tester.tap(find.byType(Switch));
      await tester.pump(); // Start toggle animation / action
      await tester.pumpAndSettle();

      // Verify it saved to preferences
      expect(prefs.getBool(AppConstants.prefMalayalamTts), isTrue);

      // Verify install sheet pops up because voice is missing
      expect(find.byType(TtsInstallSheet), findsOneWidget);
      expect(find.text('Get the Malayalam voice'), findsOneWidget);
    },
  );

  testWidgets(
    'toggling Malayalam voice on does not trigger sheet if voice is ready',
    (tester) async {
      engine.mlInstalled = true; // ready
      await pumpSettings(tester);

      // Tap switch to turn on
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Verify it saved to preferences
      expect(prefs.getBool(AppConstants.prefMalayalamTts), isTrue);

      // No install sheet should pop up
      expect(find.byType(TtsInstallSheet), findsNothing);
    },
  );
}
