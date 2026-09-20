import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/viewer/domain/view_mode.dart';
import 'package:pdfapp/features/viewer/presentation/widgets/page_layouts.dart';

void main() {
  group('Page Layouts & View Mode', () {
    test('PdfViewMode storage serialization and fallback', () {
      expect(PdfViewMode.fromStorage('auto'), PdfViewMode.auto);
      expect(PdfViewMode.fromStorage('continuous'), PdfViewMode.continuous);
      expect(PdfViewMode.fromStorage('single'), PdfViewMode.single);
      expect(PdfViewMode.fromStorage('book'), PdfViewMode.book);
      expect(PdfViewMode.fromStorage('invalid'), PdfViewMode.auto);
    });

    test(
      'layoutFor picks null (continuous) for auto on phones and book for wide/foldables',
      () {
        final phoneLayout = layoutFor(PdfViewMode.auto);
        expect(phoneLayout, isNull);

        final wideLayout = layoutFor(PdfViewMode.auto, isWideOrFoldable: true);
        expect(wideLayout, isNotNull);
      },
    );
  });
}
