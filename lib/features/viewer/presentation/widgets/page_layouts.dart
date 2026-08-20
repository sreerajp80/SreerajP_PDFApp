import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/features/viewer/domain/view_mode.dart';

/// Builds the `pdfrx` page-layout function for a [PdfViewMode].
///
/// - [PdfViewMode.auto] selects dual-page book spreads on wide screens/foldables and
///   vertical continuous stack on phones.
/// - [PdfViewMode.continuous] returns null, so `pdfrx` uses its default vertical
///   stack (lazy, good for normal reading).
/// - [PdfViewMode.single] lays pages left-to-right in one row, so the viewer
///   scrolls horizontally one page at a time (also used as the large-file
///   degraded mode).
/// - [PdfViewMode.book] stacks pages two-across in vertical spreads.
PdfPageLayoutFunction? layoutFor(
  PdfViewMode mode, {
  bool isWideOrFoldable = false,
  double hingeGap = 0,
}) => switch (mode) {
  PdfViewMode.auto =>
    isWideOrFoldable
        ? (pages, params) => _bookSpreads(pages, params, hingeGap: hingeGap)
        : null,
  PdfViewMode.continuous => null,
  PdfViewMode.single => _singleRow,
  PdfViewMode.book => (pages, params) => _bookSpreads(
    pages,
    params,
    hingeGap: hingeGap,
  ),
};

/// Pages in a single horizontal row, each vertically centered.
PdfPageLayout _singleRow(List<PdfPage> pages, PdfViewerParams params) {
  final margin = params.margin;
  final maxHeight = pages.fold(0.0, (h, p) => max(h, p.height));
  final rects = <Rect>[];
  var x = margin;
  for (final page in pages) {
    final y = margin + (maxHeight - page.height) / 2;
    rects.add(Rect.fromLTWH(x, y, page.width, page.height));
    x += page.width + margin;
  }
  return PdfPageLayout(
    pageLayouts: rects,
    documentSize: Size(x, maxHeight + margin * 2),
  );
}

/// Pages arranged two-across in vertical spreads (a book).
PdfPageLayout _bookSpreads(
  List<PdfPage> pages,
  PdfViewerParams params, {
  double hingeGap = 0,
}) {
  final margin = params.margin;
  final effectiveMargin = margin + (hingeGap > 0 ? hingeGap / 2 : 0);
  // Widest possible spread = two widest pages side by side.
  final maxPageWidth = pages.fold(0.0, (w, p) => max(w, p.width));
  final spreadWidth = maxPageWidth * 2 + effectiveMargin * 3;

  final rects = <Rect>[];
  var y = margin;
  for (var i = 0; i < pages.length; i += 2) {
    final left = pages[i];
    final right = (i + 1 < pages.length) ? pages[i + 1] : null;
    final rowHeight = max(left.height, right?.height ?? 0);

    // Center the pair inside the spread width.
    final pairWidth =
        left.width + (right != null ? right.width + effectiveMargin : 0);
    var x = (spreadWidth - pairWidth) / 2;

    rects.add(Rect.fromLTWH(x, y, left.width, left.height));
    if (right != null) {
      x += left.width + effectiveMargin;
      rects.add(Rect.fromLTWH(x, y, right.width, right.height));
    }
    y += rowHeight + margin;
  }
  return PdfPageLayout(pageLayouts: rects, documentSize: Size(spreadWidth, y));
}
