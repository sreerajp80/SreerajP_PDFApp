import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/features/settings/presentation/features_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfapp/l10n/sa_material_localizations.dart';

import '../../../helpers/tooltip_checks.dart';

void main() {
  languageTests();
  rtlTest();

  testWidgets(
    'FeaturesScreen renders header card and all 9 feature categories',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: FeaturesScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expectAllIconButtonsHaveTooltips(tester);

      // Verify AppBar
      expect(find.text('Features'), findsOneWidget);

      // Verify Header
      expect(find.text('App features'), findsOneWidget);

      // Verify first categories
      expect(find.text('PDF VIEWING & NAVIGATION ENGINE'), findsOneWidget);
      expect(find.text('High-Performance Rendering'), findsOneWidget);
      expect(find.text('SEARCH, INDIC PHONETICS & SPEECH'), findsOneWidget);
      expect(find.text('ANNOTATION OVERLAY & MARKUPS'), findsOneWidget);

      // Scroll to check further categories
      await tester.scrollUntilVisible(
        find.text('PAGE OPERATIONS & REORGANIZATION'),
        200,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('PAGE OPERATIONS & REORGANIZATION'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('DATA EXTRACTION & UTILITIES'),
        200,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('DATA EXTRACTION & UTILITIES'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('VIRTUAL PRINTER & SHARE HUB'),
        200,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('VIRTUAL PRINTER & SHARE HUB'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('DIGITAL SIGNATURES & TRUST STORE'),
        200,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('DIGITAL SIGNATURES & TRUST STORE'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('THEMES & CUSTOMIZATION'),
        200,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('THEMES & CUSTOMIZATION'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('BUILT-IN USER GUIDES'),
        200,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text('BUILT-IN USER GUIDES'), findsOneWidget);
    },
  );
}

/// Every declared language: the screen renders, shows its own text, and no
/// English feature text leaks through (engineering standard §8.7).
void languageTests() {
  for (final code in ['en', 'ml', 'sa']) {
    testWidgets('FeaturesScreen is fully translated in $code', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            SaMaterialLocalizationsDelegate(),
            SaCupertinoLocalizationsDelegate(),
            SaWidgetsLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(code),
          home: const FeaturesScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final l10n = lookupAppLocalizations(Locale(code));
      expect(find.text(l10n.helpFeatureRenderingTitle), findsOneWidget);
      expect(find.text(l10n.helpFeatureRenderingBody), findsOneWidget);
      if (code != 'en') {
        final en = lookupAppLocalizations(const Locale('en'));
        expect(find.text(en.helpFeatureRenderingTitle), findsNothing);
        expect(find.text(en.helpFeatureRenderingBody), findsNothing);
      }

      // The last category is built lazily; scrolling to it must work too.
      await tester.scrollUntilVisible(
        find.text(l10n.helpFeatureGuidesTitle),
        300,
        scrollable: find.byType(Scrollable),
      );
      expect(find.text(l10n.helpFeatureGuidesTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

/// No declared language is right-to-left, so stay ready by checking the screen
/// lays out under RTL without errors (engineering standard §8.8).
void rtlTest() {
  testWidgets('FeaturesScreen lays out right-to-left', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: FeaturesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expectAllIconButtonsHaveTooltips(tester);
  });
}
