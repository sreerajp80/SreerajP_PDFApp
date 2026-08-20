import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/smart_trim_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

class _FakePageOpsService extends PageOpsService {
  _FakePageOpsService({required this.onTrim})
    : super(
        PdfBoxChannel(method: const MethodChannel('fake/pdfbox')),
        OpenDocumentChannel(method: const MethodChannel('fake/open')),
      );

  final Future<String> Function(
    String path, {
    String? password,
    double padding,
    bool symmetric,
  })
  onTrim;

  @override
  Future<void> clearOutputCache() async {}

  @override
  Future<String> trimMargins(
    String path, {
    String? password,
    double padding = 12.0,
    bool symmetric = true,
  }) {
    return onTrim(
      path,
      password: password,
      padding: padding,
      symmetric: symmetric,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createSubject({required PageOpsService service}) {
    return ProviderScope(
      overrides: [pageOpsServiceProvider.overrideWithValue(service)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) =>
                      const SmartTrimDialog(path: '/test/document.pdf'),
                ),
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('SmartTrimDialog renders options and triggers trim operation', (
    tester,
  ) async {
    var trimCalled = false;
    final fakeService = _FakePageOpsService(
      onTrim: (path, {password, padding = 12.0, symmetric = true}) async {
        trimCalled = true;
        expect(path, '/test/document.pdf');
        expect(padding, 12.0);
        expect(symmetric, isTrue);
        return '/tmp/page_ops/trimmed_123.pdf';
      },
    );

    await tester.pumpWidget(createSubject(service: fakeService));
    await tester.pumpAndSettle();

    // Open dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Smart Margin Trim'), findsOneWidget);
    expect(find.text('Tight (4 pt)'), findsOneWidget);
    expect(find.text('Standard (12 pt)'), findsOneWidget);
    expect(find.text('Comfortable (24 pt)'), findsOneWidget);
    expect(find.text('Symmetric margins'), findsOneWidget);

    // Tap "Trim margins" action button
    final trimButton = find.widgetWithText(FilledButton, 'Trim margins');
    expect(trimButton, findsOneWidget);
    await tester.tap(trimButton);
    await tester.pumpAndSettle();

    expect(trimCalled, isTrue);
    // Verifies result dialog is shown
    expect(find.text('Margins trimmed'), findsOneWidget);
  });
}
