import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/widgets/made_with_love.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

void main() {
  testWidgets('MadeWithLove renders localized text and heart icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: Scaffold(body: MadeWithLove()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MadeWithLove), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.bySemanticsLabel('Made with love from India'), findsOneWidget);
  });

  testWidgets('MadeWithLove renders Malayalam correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('ml'),
        home: Scaffold(body: MadeWithLove()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MadeWithLove), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(
      find.bySemanticsLabel('സ്നേഹത്തോടെ ഇന്ത്യയിൽ നിന്ന്'),
      findsOneWidget,
    );
  });
}
