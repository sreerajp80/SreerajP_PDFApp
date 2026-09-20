import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/printer/presentation/widgets/print_sheet.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Phase 6: the Print sheet. Each option closes the sheet and then does the
/// work — so the work must survive the sheet going away.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const printChannel = MethodChannel('in.sreerajp.pdfapp/print');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(printChannel, null);
  });

  Future<void> pumpSheet(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => showPrintSheet(
                  context,
                  path: '/doc.pdf',
                  jobName: 'report.pdf',
                  pageCount: 10,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('the sheet offers the three print choices', (tester) async {
    messenger.setMockMethodCallHandler(printChannel, (call) async => true);

    await pumpSheet(tester);

    expect(find.text('Whole document'), findsOneWidget);
    expect(find.text('Page range'), findsOneWidget);
    expect(find.text('Text only'), findsOneWidget);
  });

  testWidgets('printing the whole document still runs after the sheet closes', (
    tester,
  ) async {
    final calls = <String>[];
    String? printedPath;
    messenger.setMockMethodCallHandler(printChannel, (call) async {
      calls.add(call.method);
      if (call.method == 'isPrintingAvailable') return true;
      if (call.method == 'printPdf') {
        printedPath = call.arguments['path'] as String;
      }
      return null;
    });

    await pumpSheet(tester);
    await tester.tap(find.text('Whole document'));
    await tester.pumpAndSettle();

    // The sheet is gone, and the print still happened.
    expect(find.text('Whole document'), findsNothing);
    expect(calls, contains('printPdf'));
    expect(printedPath, '/doc.pdf');
  });

  testWidgets('a device that cannot print says so and prints nothing', (
    tester,
  ) async {
    final calls = <String>[];
    messenger.setMockMethodCallHandler(printChannel, (call) async {
      calls.add(call.method);
      if (call.method == 'isPrintingAvailable') return false;
      return null;
    });

    await pumpSheet(tester);
    await tester.tap(find.text('Whole document'));
    await tester.pumpAndSettle();

    expect(find.text('This device cannot print.'), findsOneWidget);
    expect(calls, isNot(contains('printPdf')));
  });

  testWidgets('the page-range dialog rejects a range outside the document', (
    tester,
  ) async {
    messenger.setMockMethodCallHandler(printChannel, (call) async => true);

    await pumpSheet(tester);
    await tester.tap(find.text('Page range'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, '99');
    await tester.tap(find.widgetWithText(FilledButton, 'Print'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a page range inside 1 to 10.'), findsOneWidget);
    // The dialog stays open so the user can fix it.
    expect(find.text('Pages to print'), findsOneWidget);
  });

  testWidgets('the page-range dialog rejects a backwards range', (
    tester,
  ) async {
    messenger.setMockMethodCallHandler(printChannel, (call) async => true);

    await pumpSheet(tester);
    await tester.tap(find.text('Page range'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '8');
    await tester.enterText(find.byType(TextField).last, '3');
    await tester.tap(find.widgetWithText(FilledButton, 'Print'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a page range inside 1 to 10.'), findsOneWidget);
  });
}
