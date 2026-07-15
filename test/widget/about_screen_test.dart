import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/config/app_config.dart';
import 'package:pdfapp/features/about/presentation/about_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

void main() {
  testWidgets('About renders details rows dynamically from AppConfig', (
    tester,
  ) async {
    const config = AppConfig(
      appName: 'Test PDF App',
      description: 'desc',
      version: '1.0.0',
      build: '1',
      details: {'Author': 'Sreeraj P', 'License': 'Open source'},
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appConfigProvider.overrideWithValue(config)],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: AboutScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Test PDF App'), findsOneWidget);
    // Each details key/value pair is rendered.
    expect(find.text('Author'), findsOneWidget);
    expect(find.text('Sreeraj P'), findsOneWidget);
    expect(find.text('License'), findsOneWidget);
    expect(find.text('Open source'), findsOneWidget);
  });
}
