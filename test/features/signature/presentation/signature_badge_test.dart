import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/signature/domain/signature_status.dart';
import 'package:pdfapp/features/signature/presentation/widgets/signature_badge.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

void main() {
  Future<void> pump(WidgetTester tester, SignatureStatus status) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SignatureBadge(status: status)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('only a trusted signature gets the green tick icon', (
    tester,
  ) async {
    await pump(tester, SignatureStatus.trusted);

    expect(find.byIcon(Icons.verified_user), findsOneWidget);
    expect(find.text('Signed and trusted'), findsOneWidget);
  });

  testWidgets('a valid but untrusted signature never shows the tick', (
    tester,
  ) async {
    await pump(tester, SignatureStatus.validNotTrusted);

    expect(find.byIcon(Icons.verified_user), findsNothing);
    expect(find.text('Signed, but signer unknown'), findsOneWidget);
  });

  testWidgets('an invalid signature never shows the tick', (tester) async {
    await pump(tester, SignatureStatus.invalid);

    expect(find.byIcon(Icons.verified_user), findsNothing);
    expect(find.text('Signature is not valid'), findsOneWidget);
  });

  testWidgets('an unknown signature never shows the tick', (tester) async {
    await pump(tester, SignatureStatus.unknown);

    expect(find.byIcon(Icons.verified_user), findsNothing);
    expect(find.text('Signature could not be read'), findsOneWidget);
  });

  testWidgets('each state has its own icon, so colour is never the only cue', (
    tester,
  ) async {
    // A user who cannot tell green from red must still get the verdict.
    final icons = <IconData>{};
    for (final status in SignatureStatus.values) {
      await pump(tester, status);
      icons.add(tester.widget<Icon>(find.byType(Icon)).icon!);
    }

    expect(icons.length, SignatureStatus.values.length);
  });

  testWidgets('the verdict is announced to screen readers', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, SignatureStatus.trusted);

    expect(
      find.bySemanticsLabel('Signed and trusted'),
      findsOneWidget,
      reason: 'the badge must be readable, not just visible',
    );

    handle.dispose();
  });
}
