import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/errors/safe_error_fallback.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfapp/l10n/sa_material_localizations.dart';

void main() {
  for (final code in ['en', 'ml', 'sa']) {
    testWidgets('shows the localized message in $code', (tester) async {
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
          home: const SafeErrorFallback(),
        ),
      );
      await tester.pumpAndSettle();

      final expected = lookupAppLocalizations(Locale(code)).errorScreenFallback;
      expect(find.text(expected), findsOneWidget);
    });
  }

  testWidgets('falls back to English outside the app localizations', (
    tester,
  ) async {
    await tester.pumpWidget(const SafeErrorFallback());

    final expected = lookupAppLocalizations(const Locale('en'))
        .errorScreenFallback;
    expect(find.text(expected), findsOneWidget);
  });
}
