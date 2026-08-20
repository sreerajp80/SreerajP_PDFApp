import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/help/presentation/unicode_printing_help_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

void main() {
  testWidgets('renders Unicode Printing guide with header, steps, tip, and action button', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: UnicodePrintingHelpScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Header
    expect(find.text('Unicode & Malayalam PDF Printing'), findsOneWidget);
    expect(
      find.text('Printing Unicode & Malayalam Text Accurately'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Standard Android printing can sometimes garble complex scripts (such as Malayalam, Hindi, or Sanskrit), resulting in broken chillu characters, disconnected conjuncts, or missing fonts. SreerajP PDF App handles complex script shaping and font embedding to generate pristine PDFs.',
      ),
      findsOneWidget,
    );

    // Verify Step numbers
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);

    // Verify Steps text
    expect(
      find.text(
        'Enable the PDF Virtual Printer in Android Settings if you haven\'t already.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'In any app (such as Chrome, WhatsApp, or Office), select Print from the menu.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Select \'SreerajP PDF App\' as the target printer instead of the standard Android \'Save as PDF\'.',
      ),
      findsOneWidget,
    );

    // Verify Tip and Button
    expect(find.byIcon(Icons.tips_and_updates_outlined), findsOneWidget);
    expect(find.text('Open Printer Settings'), findsOneWidget);
  });
}
