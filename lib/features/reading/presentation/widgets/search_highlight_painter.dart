import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/features/reading/domain/search_hit.dart';

/// Draws search matches straight onto the rendered page.
///
/// pdfrx hands each page's paint callback a canvas and the rectangle the page
/// occupies on screen. Our hits carry PDF page coordinates, so each one is
/// converted to screen coordinates for the page it belongs to. Because the
/// conversion uses the page rect it is given, highlights stay correct at any
/// zoom, in any view mode, and after a rotation.
class SearchHighlightPainter {
  const SearchHighlightPainter({
    required this.hits,
    required this.current,
    required this.matchColor,
    required this.currentMatchColor,
  });

  final List<SearchHit> hits;

  /// The match the reader is standing on, drawn in a stronger colour so it can
  /// be told apart from the rest.
  final SearchHit? current;

  final Color matchColor;
  final Color currentMatchColor;

  /// Give this to `PdfViewerParams.pagePaintCallbacks`.
  void paint(ui.Canvas canvas, Rect pageRect, PdfPage page) {
    if (hits.isEmpty) return;

    final matchPaint = Paint()..color = matchColor;
    final currentPaint = Paint()..color = currentMatchColor;

    for (final hit in hits) {
      // Each page paints only its own matches.
      if (hit.pageNumber != page.pageNumber) continue;

      final paint = identical(hit, current) ? currentPaint : matchPaint;
      for (final rect in hit.rects) {
        canvas.drawRect(
          rect
              .toRect(page: page, scaledPageSize: pageRect.size)
              .translate(pageRect.left, pageRect.top),
          paint,
        );
      }
    }
  }
}
