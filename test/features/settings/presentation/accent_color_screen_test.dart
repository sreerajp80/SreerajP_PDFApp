import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/settings/presentation/accent_color_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Future<void> pumpAccentColor(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: AccentColorScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'renders live preview, preset swatches, color wheel, and reset button',
    (tester) async {
      await pumpAccentColor(tester);

      expect(find.text('Accent Color'), findsOneWidget);
      expect(find.text('LIVE PREVIEW'), findsOneWidget);
      expect(find.text('Sample text'), findsOneWidget);
      expect(find.text('PRESETS'), findsOneWidget);
      expect(find.text('CUSTOM COLOR WHEEL'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Reset Light to default'), 100);
      expect(find.text('Reset Light to default'), findsOneWidget);
    },
  );

  testWidgets('tapping a preset swatch updates light accent in preferences', (
    tester,
  ) async {
    await pumpAccentColor(tester);

    // Tap the first preset swatch
    final swatchFinder = find.byType(GestureDetector);
    expect(swatchFinder, findsWidgets);

    await tester.tap(swatchFinder.at(0));
    await tester.pumpAndSettle();

    expect(prefs.getInt(AppConstants.prefAccentLight), isNotNull);
  });
}
