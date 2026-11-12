import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/watermark_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfapp/l10n/sa_material_localizations.dart';

class _FakePageOpsService extends PageOpsService {
  _FakePageOpsService()
    : super(
        PdfBoxChannel(method: const MethodChannel('fake/pdfbox')),
        OpenDocumentChannel(method: const MethodChannel('fake/open')),
      );

  @override
  Future<void> clearOutputCache() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createSubject(Locale locale) {
    return ProviderScope(
      overrides: [
        pageOpsServiceProvider.overrideWithValue(_FakePageOpsService()),
      ],
      child: MaterialApp(
        locale: locale,
        // Same delegates as the real app (lib/app/app.dart).
        localizationsDelegates: const [
          AppLocalizations.delegate,
          SaMaterialLocalizationsDelegate(),
          SaCupertinoLocalizationsDelegate(),
          SaWidgetsLocalizationsDelegate(),
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const WatermarkDialog(
                    path: '/test/watermark_src.pdf',
                    pageCount: 3,
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

  for (final code in ['en', 'ml', 'sa']) {
    testWidgets('WatermarkDialog default text and presets are localized '
        '($code)', (tester) async {
      final locale = Locale(code);
      final l10n = lookupAppLocalizations(locale);

      await tester.pumpWidget(createSubject(locale));
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // The text field starts with the localized default.
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, l10n.labelWatermarkConfidential);

      // Every preset chip shows the localized word.
      for (final preset in [
        l10n.labelWatermarkConfidential,
        l10n.labelWatermarkDraft,
        l10n.labelWatermarkCopy,
        l10n.labelWatermarkSample,
        l10n.labelWatermarkOriginal,
      ]) {
        expect(find.widgetWithText(ActionChip, preset), findsOneWidget);
      }

      // Tapping a preset puts its word in the field.
      await tester.tap(
        find.widgetWithText(ActionChip, l10n.labelWatermarkDraft),
      );
      await tester.pump();
      expect(field.controller!.text, l10n.labelWatermarkDraft);
    });
  }
}
