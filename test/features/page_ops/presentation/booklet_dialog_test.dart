import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/booklet_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

class _FakePageOpsService extends PageOpsService {
  _FakePageOpsService({required this.onBooklet})
    : super(
        PdfBoxChannel(method: const MethodChannel('fake/pdfbox')),
        OpenDocumentChannel(method: const MethodChannel('fake/open')),
      );

  final Future<String> Function(
    String path, {
    String? password,
    String binding,
    String sheetSize,
    bool addFoldGuide,
    double gutter,
  })
  onBooklet;

  @override
  Future<void> clearOutputCache() async {}

  @override
  Future<String> generateBooklet(
    String path, {
    String? password,
    String binding = 'ltr',
    String sheetSize = 'auto',
    bool addFoldGuide = true,
    double gutter = 0.0,
  }) {
    return onBooklet(
      path,
      password: password,
      binding: binding,
      sheetSize: sheetSize,
      addFoldGuide: addFoldGuide,
      gutter: gutter,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createSubject({required PageOpsService service, int pageCount = 6}) {
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
                  builder: (_) => BookletDialog(
                    path: '/test/booklet_src.pdf',
                    pageCount: pageCount,
                  ),
                ),
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'BookletDialog displays summary and generates booklet imposition',
    (tester) async {
      var bookletCalled = false;
      final fakeService = _FakePageOpsService(
        onBooklet:
            (
              path, {
              password,
              binding = 'ltr',
              sheetSize = 'auto',
              addFoldGuide = true,
              gutter = 0.0,
            }) async {
              bookletCalled = true;
              expect(path, '/test/booklet_src.pdf');
              expect(binding, 'ltr');
              expect(sheetSize, 'auto');
              expect(addFoldGuide, isTrue);
              return '/tmp/page_ops/booklet_123.pdf';
            },
      );

      await tester.pumpWidget(createSubject(service: fakeService));
      await tester.pumpAndSettle();

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Foldable Booklet (2-Up)'), findsOneWidget);
      expect(find.text('Booklet layout summary'), findsOneWidget);
      expect(find.text('6 original pages -> 8 booklet pages'), findsOneWidget);
      expect(
        find.text('2 physical landscape sheets (4 printable sides)'),
        findsOneWidget,
      );
      expect(find.text('2 blank filler pages added at end'), findsOneWidget);

      expect(find.text('Left to Right (LTR)'), findsOneWidget);
      expect(find.text('Right to Left (RTL)'), findsOneWidget);
      expect(find.text('Match source'), findsOneWidget);
      expect(find.text('Center fold guide'), findsOneWidget);

      // Tap "Create booklet"
      final createButton = find.widgetWithText(FilledButton, 'Create booklet');
      expect(createButton, findsOneWidget);
      await tester.tap(createButton);
      await tester.pumpAndSettle();

      expect(bookletCalled, isTrue);
      // Verifies result dialog is shown
      expect(find.text('Booklet generated'), findsOneWidget);
    },
  );
}
