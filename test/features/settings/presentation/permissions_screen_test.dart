import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/settings/presentation/permissions_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

void main() {
  testWidgets('renders all explicit and implicit capability items', (
    tester,
  ) async {
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
        home: PermissionsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Permissions'), findsOneWidget);
    expect(find.text('CAPABILITIES'), findsOneWidget);
    expect(find.text('Scoped Storage (SAF)'), findsOneWidget);
    expect(find.text('Virtual Print Service'), findsOneWidget);
    expect(find.text('PRIVACY & SYSTEM DECLARATIONS'), findsOneWidget);
    expect(find.text('Text-to-Speech Engine'), findsOneWidget);
    expect(find.text('Voice Data Installer'), findsOneWidget);
    expect(find.text('Process Text Action'), findsOneWidget);
  });
}
