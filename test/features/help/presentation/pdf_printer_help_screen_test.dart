import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/features/help/presentation/pdf_printer_help_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

class _FakeOpenDocumentChannel extends OpenDocumentChannel {
  bool printSettingsOpened = false;

  @override
  Future<void> openPrintSettings() async {
    printSettingsOpened = true;
  }
}

void main() {
  testWidgets('renders PDF Printer guide with header, steps, and action button', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final fakeChannel = _FakeOpenDocumentChannel();

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: PdfPrinterHelpScreen(channel: fakeChannel),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Header
    expect(find.text('PDF Printer Setup'), findsOneWidget);
    expect(
      find.text('1. How to Enable the PDF Printer on Android'),
      findsOneWidget,
    );
    expect(
      find.text(
        'On Android, virtual print services are managed at the system level. To enable SreerajP PDF App as a system-wide printer:',
      ),
      findsOneWidget,
    );

    // Verify Steps
    expect(find.text("Open your Android device's Settings."), findsOneWidget);
    expect(
      find.text(
        'Go to Connected devices → Connection preferences → Printing (or search for "Printing" in your Settings search bar).',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Under Print services, find SreerajP PDF App (or your app\'s name).',
      ),
      findsOneWidget,
    );
    expect(find.text('Tap it and switch the toggle to On.'), findsOneWidget);

    // Verify Step badges (1, 2, 3, 4)
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);

    // Verify and tap Action Button
    final openButton = find.text('Open Print Settings');
    expect(openButton, findsOneWidget);

    await tester.tap(openButton);
    await tester.pumpAndSettle();

    expect(fakeChannel.printSettingsOpened, isTrue);
  });
}
