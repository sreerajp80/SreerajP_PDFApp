import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/settings/presentation/typography_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Future<void> pumpTypography(
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
          home: const TypographyScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders font families and text scale options', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await pumpTypography(tester);

    expect(find.text('Typography & Text Size'), findsOneWidget);
    expect(find.text('Font'), findsOneWidget);
    expect(find.text('Text Size'), findsOneWidget);
    expect(find.text('System Default'), findsOneWidget);
    expect(find.text('Manjari'), findsOneWidget);
    expect(find.text('Anek Malayalam'), findsOneWidget);
    expect(find.text('Noto Sans Malayalam'), findsOneWidget);
    expect(find.text('Small'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Large'), findsOneWidget);
    expect(find.text('Larger'), findsOneWidget);
  });

  testWidgets('selecting font family updates preference', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await pumpTypography(tester);

    await tester.tap(find.text('Manjari'));
    await tester.pumpAndSettle();

    expect(prefs.getInt(AppConstants.prefAppFont), AppFont.manjari.index);
  });

  testWidgets('selecting text scale updates preference', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await pumpTypography(tester);

    await tester.tap(find.text('Large'));
    await tester.pumpAndSettle();

    expect(prefs.getInt(AppConstants.prefTextScale), AppTextScale.large.index);
  });
}
