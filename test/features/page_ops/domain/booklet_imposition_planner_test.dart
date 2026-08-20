import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/page_ops/domain/booklet_imposition_planner.dart';

void main() {
  group('BookletImpositionPlanner', () {
    test('handles 0 or negative pages gracefully', () {
      final zeroPlan = BookletImpositionPlanner.plan(totalPages: 0);
      expect(zeroPlan.totalPages, 0);
      expect(zeroPlan.paddedPages, 0);
      expect(zeroPlan.totalSheets, 0);
      expect(zeroPlan.faces, isEmpty);

      final negPlan = BookletImpositionPlanner.plan(totalPages: -5);
      expect(negPlan.totalPages, 0);
      expect(negPlan.paddedPages, 0);
      expect(negPlan.totalSheets, 0);
      expect(negPlan.faces, isEmpty);
    });

    test('imposes a 1-page document padded to 4 pages', () {
      final plan = BookletImpositionPlanner.plan(totalPages: 1);
      expect(plan.totalPages, 1);
      expect(plan.paddedPages, 4);
      expect(plan.totalSheets, 1);
      expect(plan.blankPageCount, 3);
      expect(plan.faces.length, 2);

      // Sheet 1 Front: [4 (blank), 1]
      final front = plan.faces[0];
      expect(front.sheetIndex, 0);
      expect(front.isFront, isTrue);
      expect(front.leftPage.isBlank, isTrue);
      expect(front.rightPage.pageNumber, 1);

      // Sheet 1 Back: [2 (blank), 3 (blank)]
      final back = plan.faces[1];
      expect(back.sheetIndex, 0);
      expect(back.isFront, isFalse);
      expect(back.leftPage.isBlank, isTrue);
      expect(back.rightPage.isBlank, isTrue);
    });

    test('imposes a 4-page document into 1 sheet (LTR)', () {
      final plan = BookletImpositionPlanner.plan(totalPages: 4);
      expect(plan.totalPages, 4);
      expect(plan.paddedPages, 4);
      expect(plan.totalSheets, 1);
      expect(plan.blankPageCount, 0);
      expect(plan.faces.length, 2);

      // Sheet 1 Front: [4, 1]
      final front = plan.faces[0];
      expect(front.leftPage.pageNumber, 4);
      expect(front.rightPage.pageNumber, 1);

      // Sheet 1 Back: [2, 3]
      final back = plan.faces[1];
      expect(back.leftPage.pageNumber, 2);
      expect(back.rightPage.pageNumber, 3);
    });

    test('imposes an 8-page document into 2 sheets (LTR)', () {
      final plan = BookletImpositionPlanner.plan(totalPages: 8);
      expect(plan.totalPages, 8);
      expect(plan.paddedPages, 8);
      expect(plan.totalSheets, 2);
      expect(plan.blankPageCount, 0);
      expect(plan.faces.length, 4);

      // Sheet 1 (Outer) Front: [8, 1]
      expect(plan.faces[0].sheetIndex, 0);
      expect(plan.faces[0].isFront, isTrue);
      expect(plan.faces[0].leftPage.pageNumber, 8);
      expect(plan.faces[0].rightPage.pageNumber, 1);

      // Sheet 1 (Outer) Back: [2, 7]
      expect(plan.faces[1].sheetIndex, 0);
      expect(plan.faces[1].isFront, isFalse);
      expect(plan.faces[1].leftPage.pageNumber, 2);
      expect(plan.faces[1].rightPage.pageNumber, 7);

      // Sheet 2 (Inner) Front: [6, 3]
      expect(plan.faces[2].sheetIndex, 1);
      expect(plan.faces[2].isFront, isTrue);
      expect(plan.faces[2].leftPage.pageNumber, 6);
      expect(plan.faces[2].rightPage.pageNumber, 3);

      // Sheet 2 (Inner) Back: [4, 5] (Center fold)
      expect(plan.faces[3].sheetIndex, 1);
      expect(plan.faces[3].isFront, isFalse);
      expect(plan.faces[3].leftPage.pageNumber, 4);
      expect(plan.faces[3].rightPage.pageNumber, 5);
    });

    test('imposes a 6-page document padded to 8 pages with 2 blanks', () {
      final plan = BookletImpositionPlanner.plan(totalPages: 6);
      expect(plan.totalPages, 6);
      expect(plan.paddedPages, 8);
      expect(plan.totalSheets, 2);
      expect(plan.blankPageCount, 2);

      // Sheet 1 Front: [8 (blank), 1]
      expect(plan.faces[0].leftPage.isBlank, isTrue);
      expect(plan.faces[0].rightPage.pageNumber, 1);

      // Sheet 1 Back: [2, 7 (blank)]
      expect(plan.faces[1].leftPage.pageNumber, 2);
      expect(plan.faces[1].rightPage.isBlank, isTrue);

      // Sheet 2 Front: [6, 3]
      expect(plan.faces[2].leftPage.pageNumber, 6);
      expect(plan.faces[2].rightPage.pageNumber, 3);

      // Sheet 2 Back: [4, 5]
      expect(plan.faces[3].leftPage.pageNumber, 4);
      expect(plan.faces[3].rightPage.pageNumber, 5);
    });

    test('imposes an 8-page document with RTL binding', () {
      final plan = BookletImpositionPlanner.plan(
        totalPages: 8,
        binding: BookletBinding.rtl,
      );
      expect(plan.binding, BookletBinding.rtl);

      // Sheet 1 Front (RTL): Left = 1, Right = 8
      expect(plan.faces[0].leftPage.pageNumber, 1);
      expect(plan.faces[0].rightPage.pageNumber, 8);

      // Sheet 1 Back (RTL): Left = 7, Right = 2
      expect(plan.faces[1].leftPage.pageNumber, 7);
      expect(plan.faces[1].rightPage.pageNumber, 2);

      // Sheet 2 Front (RTL): Left = 3, Right = 6
      expect(plan.faces[2].leftPage.pageNumber, 3);
      expect(plan.faces[2].rightPage.pageNumber, 6);

      // Sheet 2 Back (RTL): Left = 5, Right = 4
      expect(plan.faces[3].leftPage.pageNumber, 5);
      expect(plan.faces[3].rightPage.pageNumber, 4);
    });

    test('equality and toString for domain models', () {
      const ref1 = BookletPageRef(1);
      const ref2 = BookletPageRef(1);
      const refBlank = BookletPageRef(null);

      expect(ref1, equals(ref2));
      expect(ref1.hashCode, equals(ref2.hashCode));
      expect(ref1.toString(), 'Page 1');
      expect(refBlank.toString(), '[Blank]');

      const face1 = BookletSheetFace(
        sheetIndex: 0,
        isFront: true,
        leftPage: refBlank,
        rightPage: ref1,
      );
      const face2 = BookletSheetFace(
        sheetIndex: 0,
        isFront: true,
        leftPage: refBlank,
        rightPage: ref1,
      );
      expect(face1, equals(face2));
      expect(face1.hashCode, equals(face2.hashCode));
      expect(face1.toString(), contains('Sheet 1 (Front)'));

      const options = MarginTrimOptions(padding: 8.0, symmetric: false);
      expect(options.padding, 8.0);
      expect(options.symmetric, isFalse);

      const bookletOpts = BookletOptions(
        binding: BookletBinding.rtl,
        sheetSize: 'a4',
        addFoldGuide: false,
        gutter: 10.0,
      );
      expect(bookletOpts.binding, BookletBinding.rtl);
      expect(bookletOpts.sheetSize, 'a4');
      expect(bookletOpts.addFoldGuide, isFalse);
      expect(bookletOpts.gutter, 10.0);
    });
  });
}
