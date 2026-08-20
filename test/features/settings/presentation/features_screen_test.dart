import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/settings/presentation/features_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

void main() {
  testWidgets('FeaturesScreen renders header card and all 9 feature categories', (tester) async {
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

    // Verify AppBar
    expect(find.text('Features'), findsOneWidget);

    // Verify Header
    expect(find.text('SreerajP PDF App Features'), findsOneWidget);

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
  });
}
