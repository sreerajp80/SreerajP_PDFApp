import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/features/settings/presentation/appearance_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Future<void> pumpAppearance(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AppearanceScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders all 3 appearance cards in English', (tester) async {
    await pumpAppearance(tester);

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Theme Mode'), findsOneWidget);
    expect(find.text('Select Light, Dark, or System'), findsOneWidget);
    expect(find.text('Typography & Text Size'), findsOneWidget);
    expect(find.text('App font family and text size'), findsOneWidget);
    expect(find.text('Accent Color'), findsOneWidget);
    expect(find.text('Presets, color wheel, live preview'), findsOneWidget);
    expect(find.text('App Color'), findsNothing);
  });

  testWidgets('renders all 3 appearance cards in Malayalam', (tester) async {
    await pumpAppearance(tester, locale: const Locale('ml'));

    expect(find.text('രൂപം'), findsOneWidget);
    expect(find.text('തീം മോഡ്'), findsOneWidget);
    expect(
      find.text('ലൈറ്റ്, ഡാർക്ക്, അല്ലെങ്കിൽ സിസ്റ്റം തിരഞ്ഞെടുക്കുക'),
      findsOneWidget,
    );
    expect(find.text('ടൈപോഗ്രാഫിയും ടെക്സ്റ്റ് വലിപ്പവും'), findsOneWidget);
    expect(
      find.text('ആപ്പിന്റെ ഫോണ്ട് കുടുംബവും ടെക്സ്റ്റ് വലിപ്പവും'),
      findsOneWidget,
    );
    expect(find.text('ആക്സന്റ് നിറം'), findsOneWidget);
    expect(find.text('പ്രീസെറ്റുകൾ, കലർ വീൽ, തത്സമയ പ്രിവ്യൂ'), findsOneWidget);
    expect(find.text('ആപ്പിന്റെ നിറം'), findsNothing);
  });
}
