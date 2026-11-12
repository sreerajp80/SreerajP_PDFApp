import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/organize_pages_screen.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfrx/pdfrx.dart';

/// A loaded A4 page. Drawing it is never needed here: the test only checks
/// how the thumbnail is turned.
class _FakePage extends Fake implements PdfPage {
  _FakePage(this.pageNumber, this.document);

  @override
  final int pageNumber;

  @override
  final PdfDocument document;

  @override
  bool get isLoaded => true;

  @override
  double get width => 595;

  @override
  double get height => 842;

  @override
  PdfPageRotation get rotation => PdfPageRotation.none;

  /// The thumbnail widget asks for a cancel token and a picture; answer with a
  /// dummy token and "no picture", which it handles by drawing nothing.
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #createCancellationToken) return _Token();
    if (invocation.memberName == #render) return Future<PdfImage?>.value();
    return super.noSuchMethod(invocation);
  }
}

class _Token extends Fake implements PdfPageRenderCancellationToken {
  @override
  void cancel() {}
}

class _FakeDocument extends Fake implements PdfDocument {
  _FakeDocument(int count) {
    pages = List.generate(count, (i) => _FakePage(i + 1, this));
  }

  @override
  late final List<PdfPage> pages;

  @override
  Stream<PdfDocumentEvent> get events => const Stream.empty();
}

void main() {
  Widget subject() => ProviderScope(
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: OrganizePagesScreen(document: _FakeDocument(2), path: 'x.pdf'),
    ),
  );

  List<int> quarterTurns(WidgetTester tester) => tester
      .widgetList<RotatedBox>(find.byType(RotatedBox))
      .map((box) => box.quarterTurns)
      .toList();

  testWidgets('a rotated page shows a turned thumbnail', (tester) async {
    await tester.pumpWidget(subject());
    await tester.pump();

    expect(quarterTurns(tester), [0, 0]);

    // Rotate the first page once (the first rotate button belongs to page 1).
    await tester.tap(find.byTooltip('Rotate').first);
    await tester.pump();

    expect(quarterTurns(tester), [1, 0]);
  });
}
