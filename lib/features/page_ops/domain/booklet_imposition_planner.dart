import 'package:flutter/foundation.dart';

/// The binding direction for a foldable booklet.
enum BookletBinding {
  /// Left-to-right binding (standard for English, Malayalam, Latin scripts).
  ltr,

  /// Right-to-left binding (standard for Hebrew, Arabic, and specific Eastern layouts).
  rtl,
}

/// A reference to a single logical page placed on a booklet sheet face.
@immutable
class BookletPageRef {
  const BookletPageRef(this.pageNumber);

  /// 1-based source page number, or null when this slot is a blank filler page.
  final int? pageNumber;

  /// True when this slot is a blank filler page (padded to a multiple of 4).
  bool get isBlank => pageNumber == null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookletPageRef &&
          runtimeType == other.runtimeType &&
          pageNumber == other.pageNumber;

  @override
  int get hashCode => pageNumber.hashCode;

  @override
  String toString() => isBlank ? '[Blank]' : 'Page $pageNumber';
}

/// Represents one printable face (Front or Back) of a physical 2-Up sheet.
@immutable
class BookletSheetFace {
  const BookletSheetFace({
    required this.sheetIndex,
    required this.isFront,
    required this.leftPage,
    required this.rightPage,
  });

  /// 0-based index of the physical sheet (0 to S-1).
  final int sheetIndex;

  /// True for the Front (outer) side of the sheet, false for the Back (inner) side.
  final bool isFront;

  /// Logical page on the left half of the landscape sheet.
  final BookletPageRef leftPage;

  /// Logical page on the right half of the landscape sheet.
  final BookletPageRef rightPage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookletSheetFace &&
          runtimeType == other.runtimeType &&
          sheetIndex == other.sheetIndex &&
          isFront == other.isFront &&
          leftPage == other.leftPage &&
          rightPage == other.rightPage;

  @override
  int get hashCode => Object.hash(sheetIndex, isFront, leftPage, rightPage);

  @override
  String toString() =>
      'Sheet ${sheetIndex + 1} (${isFront ? "Front" : "Back"}): '
      'Left=$leftPage, Right=$rightPage';
}

/// The complete imposition plan for a multi-page PDF document.
@immutable
class BookletPlan {
  const BookletPlan({
    required this.totalPages,
    required this.paddedPages,
    required this.totalSheets,
    required this.binding,
    required this.faces,
  });

  /// Original total number of pages in the source PDF.
  final int totalPages;

  /// Total pages after rounding up to a multiple of 4 ($M = \lceil N/4 \rceil \times 4$).
  final int paddedPages;

  /// Number of physical landscape sheets ($S = M / 4$).
  final int totalSheets;

  /// Binding direction used for imposition.
  final BookletBinding binding;

  /// Ordered list of 2-Up sheet faces to print ($2 \times S$ faces).
  final List<BookletSheetFace> faces;

  /// Number of blank filler pages added at the end.
  int get blankPageCount => paddedPages - totalPages;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookletPlan &&
          runtimeType == other.runtimeType &&
          totalPages == other.totalPages &&
          paddedPages == other.paddedPages &&
          totalSheets == other.totalSheets &&
          binding == other.binding &&
          listEquals(faces, other.faces);

  @override
  int get hashCode => Object.hash(
    totalPages,
    paddedPages,
    totalSheets,
    binding,
    Object.hashAll(faces),
  );
}

/// Pure Dart calculation engine for 2-Up foldable booklet imposition (Feature 2.7).
class BookletImpositionPlanner {
  const BookletImpositionPlanner._();

  /// Calculates the complete 2-Up saddle-stitch booklet imposition layout.
  ///
  /// [totalPages] is the number of pages in the source document.
  /// [binding] selects LTR (default) or RTL page ordering.
  static BookletPlan plan({
    required int totalPages,
    BookletBinding binding = BookletBinding.ltr,
  }) {
    if (totalPages <= 0) {
      return BookletPlan(
        totalPages: 0,
        paddedPages: 0,
        totalSheets: 0,
        binding: binding,
        faces: const [],
      );
    }

    final paddedPages = ((totalPages + 3) ~/ 4) * 4;
    final totalSheets = paddedPages ~/ 4;
    final faces = <BookletSheetFace>[];

    for (var i = 0; i < totalSheets; i++) {
      // Sheet i Front (Side 1)
      final frontLeftNum = switch (binding) {
        BookletBinding.ltr => paddedPages - (2 * i),
        BookletBinding.rtl => 1 + (2 * i),
      };
      final frontRightNum = switch (binding) {
        BookletBinding.ltr => 1 + (2 * i),
        BookletBinding.rtl => paddedPages - (2 * i),
      };

      faces.add(
        BookletSheetFace(
          sheetIndex: i,
          isFront: true,
          leftPage: BookletPageRef(
            frontLeftNum <= totalPages ? frontLeftNum : null,
          ),
          rightPage: BookletPageRef(
            frontRightNum <= totalPages ? frontRightNum : null,
          ),
        ),
      );

      // Sheet i Back (Side 2)
      final backLeftNum = switch (binding) {
        BookletBinding.ltr => 2 + (2 * i),
        BookletBinding.rtl => paddedPages - (2 * i) - 1,
      };
      final backRightNum = switch (binding) {
        BookletBinding.ltr => paddedPages - (2 * i) - 1,
        BookletBinding.rtl => 2 + (2 * i),
      };

      faces.add(
        BookletSheetFace(
          sheetIndex: i,
          isFront: false,
          leftPage: BookletPageRef(
            backLeftNum <= totalPages ? backLeftNum : null,
          ),
          rightPage: BookletPageRef(
            backRightNum <= totalPages ? backRightNum : null,
          ),
        ),
      );
    }

    return BookletPlan(
      totalPages: totalPages,
      paddedPages: paddedPages,
      totalSheets: totalSheets,
      binding: binding,
      faces: List.unmodifiable(faces),
    );
  }
}

/// Options for smart margin trimming.
@immutable
class MarginTrimOptions {
  const MarginTrimOptions({this.padding = 12.0, this.symmetric = true});

  /// Safe padding in PDF points (default 12.0 pt).
  final double padding;

  /// Whether to balance left/right and top/bottom margins symmetrically.
  final bool symmetric;
}

/// Options for booklet imposition generator.
@immutable
class BookletOptions {
  const BookletOptions({
    this.binding = BookletBinding.ltr,
    this.sheetSize = 'auto',
    this.addFoldGuide = true,
    this.gutter = 0.0,
  });

  /// Binding direction.
  final BookletBinding binding;

  /// Paper size ('auto', 'a4', 'letter').
  final String sheetSize;

  /// Whether to render a faint dotted center fold guideline.
  final bool addFoldGuide;

  /// Inner gutter spacing in points between the two paired pages.
  final double gutter;
}
