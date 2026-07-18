import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/settings/presentation/theme_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Future<void> pumpTheme(WidgetTester tester) async {
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
          home: ThemeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders all theme choices', (tester) async {
    await pumpTheme(tester);

    expect(find.text('Theme'), findsOneWidget); // app bar title
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Sepia'), findsOneWidget);
  });

  testWidgets('changing the theme updates notifier and settings', (
    tester,
  ) async {
    await pumpTheme(tester);

    // Default theme is system. Tap Light.
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    expect(prefs.getString(AppConstants.prefThemeMode), 'light');
  });
}
