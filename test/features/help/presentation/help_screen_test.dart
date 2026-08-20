import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/help/presentation/help_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

void main() {
  testWidgets('renders Help screen with all 6 help topic cards', (tester) async {
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
        home: HelpScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Screen Title
    expect(find.text('Help'), findsOneWidget);

    // Verify Header Card
    expect(find.text('Help Center & Knowledge Base'), findsOneWidget);

    // 1. PDF Printer Setup
    expect(find.text('PDF Printer Setup'), findsOneWidget);
    expect(
      find.text('How to enable and use the virtual print service'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.print_outlined), findsNWidgets(2));

    // 2. Unicode & Malayalam PDF Printing
    expect(find.text('Unicode & Malayalam PDF Printing'), findsOneWidget);
    expect(
      find.text('Printing complex Indic scripts without broken characters'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.language_outlined), findsOneWidget);

    // 3. Read Aloud (TTS)
    expect(find.text('Read Aloud (TTS) & Malayalam Voice'), findsOneWidget);
    expect(
      find.text('Configure speech engine, voice speed, and Malayalam support'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.record_voice_over_outlined), findsOneWidget);

    // 4. Organizing Pages
    expect(find.text('Organizing & Modifying Pages'), findsOneWidget);
    expect(
      find.text('Merge, split, reorder, rotate, booklet, and N-Up layouts'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.dashboard_customize_outlined), findsNWidgets(2));

    // 5. Signatures & Trust Store
    expect(find.text('Digital Signatures & Trust Store'), findsOneWidget);
    expect(
      find.text('Offline cryptographic verification and certificate management'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.verified_user_outlined), findsOneWidget);

    // 6. Privacy & Storage
    expect(find.text('Privacy & Scoped Storage'), findsOneWidget);
    expect(
      find.text('Zero internet permissions and Scoped Storage security'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.security_outlined), findsNWidgets(2));
  });
}
