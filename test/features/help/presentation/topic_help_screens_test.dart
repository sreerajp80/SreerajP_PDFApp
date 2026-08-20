import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/help/presentation/page_ops_help_screen.dart';
import 'package:pdfapp/features/help/presentation/privacy_storage_help_screen.dart';
import 'package:pdfapp/features/help/presentation/signatures_help_screen.dart';
import 'package:pdfapp/features/help/presentation/tts_help_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

Widget _buildTestApp(Widget home) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}

void main() {
  testWidgets('renders TtsHelpScreen with steps and action button', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildTestApp(const TtsHelpScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Read Aloud (TTS) & Malayalam Voice'), findsOneWidget);
    expect(find.text('How to Use Read Aloud and Install Malayalam Voices'), findsOneWidget);
    expect(find.text('Open TTS Settings'), findsOneWidget);
  });

  testWidgets('renders PageOpsHelpScreen with steps and safety guarantee', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildTestApp(const PageOpsHelpScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Organizing & Modifying Pages'), findsOneWidget);
    expect(find.text('Page Operations & Copy-on-Write Safety'), findsOneWidget);
    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
  });

  testWidgets('renders SignaturesHelpScreen with steps and trust store action', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildTestApp(const SignaturesHelpScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Digital Signatures & Trust Store'), findsOneWidget);
    expect(find.text('Verifying Digital Signatures Offline'), findsOneWidget);
    expect(find.text('Open Trust Store'), findsOneWidget);
  });

  testWidgets('renders PrivacyStorageHelpScreen with steps and storage action', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildTestApp(const PrivacyStorageHelpScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Privacy & Scoped Storage'), findsOneWidget);
    expect(find.text('100% Offline Privacy Guarantee'), findsOneWidget);
    expect(find.text('Open Storage & Privacy Settings'), findsOneWidget);
  });
}
