import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:pdfapp/features/sign_document/presentation/my_signatures_sheet.dart';
import 'package:pdfapp/features/sign_document/presentation/providers.dart';
import 'package:pdfapp/features/sign_document/presentation/signature_pad_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfapp/l10n/sa_material_localizations.dart';

import '../../../helpers/tooltip_checks.dart';

// A valid 1 x 1 see-through PNG.
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
);

LoadedSignature _loaded(int id) => LoadedSignature(
  signature: SavedSignature(
    id: id,
    fileName: 'sig_$id.png',
    widthPx: 1,
    heightPx: 1,
    source: SignatureSource.drawn,
    createdAt: DateTime(2026),
  ),
  png: _png,
);

class _FakeSignatures extends MySignaturesNotifier {
  _FakeSignatures(this.items);

  final List<LoadedSignature> items;

  @override
  Future<List<LoadedSignature>> build() async => items;
}

Widget _app(
  Locale locale,
  Widget home, {
  List<LoadedSignature> items = const [],
}) {
  return ProviderScope(
    overrides: [
      mySignaturesProvider.overrideWith(() => _FakeSignatures(items)),
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        SaMaterialLocalizationsDelegate(),
        SaCupertinoLocalizationsDelegate(),
        SaWidgetsLocalizationsDelegate(),
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> phoneSize(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 740));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  for (final code in ['en', 'ml', 'sa']) {
    final locale = Locale(code);
    final l10n = lookupAppLocalizations(locale);

    testWidgets('My signatures sheet lists saved signatures ($code)', (
      tester,
    ) async {
      await phoneSize(tester);
      SignFlowChoice? picked;
      await tester.pumpWidget(
        _app(
          locale,
          Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async {
                    picked = await showModalBottomSheet<SignFlowChoice>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const MySignaturesSheet(),
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
          items: [_loaded(1), _loaded(2)],
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text(l10n.titleMySignatures), findsOneWidget);
      expect(find.text(l10n.descSignNotDigital), findsOneWidget);
      expect(find.text(l10n.actionDrawSignature), findsOneWidget);
      expect(find.text(l10n.actionImportSignature), findsOneWidget);
      expect(find.byTooltip(l10n.tooltipDeleteSignature), findsNWidgets(2));
      expectAllIconButtonsHaveTooltips(tester);

      await tester.tap(find.bySemanticsLabel(l10n.descSavedSignature).first);
      await tester.pumpAndSettle();
      expect(picked, isA<UseSavedSignature>());
      expect((picked! as UseSavedSignature).signature.signature.id, 1);
    });

    testWidgets('My signatures sheet shows the empty text ($code)', (
      tester,
    ) async {
      await phoneSize(tester);
      await tester.pumpWidget(
        _app(locale, const Scaffold(body: MySignaturesSheet())),
      );
      await tester.pumpAndSettle();
      expect(find.text(l10n.emptyMySignatures), findsOneWidget);
    });

    testWidgets('Signature pad enables Save only after drawing ($code)', (
      tester,
    ) async {
      await phoneSize(tester);
      await tester.pumpWidget(_app(locale, const SignaturePadScreen()));
      await tester.pumpAndSettle();

      FilledButton save() => tester.widget<FilledButton>(
        find.ancestor(
          of: find.text(l10n.actionSave),
          matching: find.byWidgetPredicate((w) => w is FilledButton),
        ),
      );

      expect(find.text(l10n.titleDrawSignature), findsOneWidget);
      expect(find.text(l10n.labelPenThin), findsOneWidget);
      expect(save().onPressed, isNull);
      expectAllIconButtonsHaveTooltips(tester);

      // Draw one stroke across the pad.
      final pad = find.bySemanticsLabel(l10n.descSignHere);
      final centre = tester.getCenter(pad);
      await tester.dragFrom(centre, const Offset(80, 10));
      await tester.pump();
      expect(save().onPressed, isNotNull);

      await tester.tap(find.byTooltip(l10n.actionUndo));
      await tester.pump();
      expect(save().onPressed, isNull);
    });
  }
}
