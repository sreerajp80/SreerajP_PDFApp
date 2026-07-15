import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/reading/domain/text_quality.dart';
import 'package:pdfapp/features/reading/presentation/widgets/text_quality_notice.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

void main() {
  Future<void> pumpNotice(
    WidgetTester tester,
    TextQuality quality, {
    VoidCallback? onDismiss,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TextQualityNotice(
            quality: quality,
            onDismiss: onDismiss ?? () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a scanned PDF is explained, and OCR is ruled out honestly', (
    tester,
  ) async {
    await pumpNotice(tester, TextQuality.none);

    expect(find.text('No selectable text'), findsOneWidget);
    expect(find.textContaining('looks scanned'), findsOneWidget);
    expect(
      find.textContaining('does not read text from pictures'),
      findsOneWidget,
    );
  });

  testWidgets(
    'a garbled PDF says search would be wrong, not that it is empty',
    (tester) async {
      await pumpNotice(tester, TextQuality.garbled);

      expect(find.text('Text cannot be read properly'), findsOneWidget);
      expect(find.textContaining('wrong results'), findsOneWidget);
      // It must still say the reader can read the pages.
      expect(
        find.textContaining('Reading the pages still works'),
        findsOneWidget,
      );
    },
  );

  testWidgets('a healthy PDF shows nothing at all', (tester) async {
    await pumpNotice(tester, TextQuality.good);

    expect(find.byType(MaterialBanner), findsNothing);
  });

  testWidgets('the notice can be dismissed', (tester) async {
    var dismissed = 0;
    await pumpNotice(tester, TextQuality.none, onDismiss: () => dismissed++);

    await tester.tap(find.text('Got it'));

    expect(dismissed, 1);
  });
}
