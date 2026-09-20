import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfapp/l10n/sa_material_localizations.dart';

void main() {
  group('Sanskrit Localizations Delegates', () {
    test('SaMaterialLocalizationsDelegate support checks', () {
      const delegate = SaMaterialLocalizationsDelegate();
      expect(delegate.isSupported(const Locale('sa')), isTrue);
      expect(delegate.isSupported(const Locale('en')), isFalse);
      expect(delegate.shouldReload(delegate), isFalse);
    });

    test('SaCupertinoLocalizationsDelegate support checks', () {
      const delegate = SaCupertinoLocalizationsDelegate();
      expect(delegate.isSupported(const Locale('sa')), isTrue);
      expect(delegate.isSupported(const Locale('ml')), isFalse);
      expect(delegate.shouldReload(delegate), isFalse);
    });

    test('SaWidgetsLocalizationsDelegate support checks', () {
      const delegate = SaWidgetsLocalizationsDelegate();
      expect(delegate.isSupported(const Locale('sa')), isTrue);
      expect(delegate.isSupported(const Locale('hi')), isFalse);
      expect(delegate.shouldReload(delegate), isFalse);
    });

    test('SaMaterialLocalizationsDelegate loads Hindi fallback', () async {
      const delegate = SaMaterialLocalizationsDelegate();
      final localizations = await delegate.load(const Locale('sa'));
      expect(localizations, isNotNull);
    });

    testWidgets('Renders MaterialApp in Locale("sa") without crashing', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('sa'),
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
          home: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              return Scaffold(
                appBar: AppBar(title: Text(l10n.settingsTitle)),
                body: Center(child: Text(l10n.saveAction)),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('विन्यासः'), findsOneWidget);
      expect(find.text('रक्ष्यताम्'), findsOneWidget);
    });
  });
}
