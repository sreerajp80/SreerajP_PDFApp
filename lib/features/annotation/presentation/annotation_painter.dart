import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/features/annotation/domain/annotation.dart';
import 'package:pdfapp/features/annotation/domain/annotation_geometry.dart';
import 'package:pdfapp/features/annotation/domain/annotation_type.dart';

/// Draws stored overlay annotations straight onto the rendered page.
///
/// Like the search highlighter, pdfrx hands each page's paint callback a canvas
/// and the rectangle the page occupies on screen. Our marks are stored in a
/// normalized (0–1, top-left) space, so they map to the given [pageRect] the
/// same way at any zoom or view mode. Notes are **not** drawn here — they are
/// tappable widgets in the page overlay layer.
class AnnotationPainter {
  const AnnotationPainter({required this.annotations});

  final List<Annotation> annotations;

  /// Give this to `PdfViewerParams.pagePaintCallbacks`.
  void paint(ui.Canvas canvas, Rect pageRect, PdfPage page) {
    for (final a in annotations) {
      if (a.page != page.pageNumber) continue;
      switch (a) {
        case MarkupAnnotation():
          _paintMarkup(canvas, pageRect, a);
        case InkAnnotation():
          _paintInk(canvas, pageRect, a);
        case NoteAnnotation():
        case BookmarkAnnotation():
          break; // notes are widgets; bookmarks are not on-page
      }
    }
  }

  void _paintMarkup(ui.Canvas canvas, Rect pageRect, MarkupAnnotation a) {
    final color = Color(a.color ?? 0xFFFFEB3B);
    for (final quadUnit in a.quads) {
      final r = AnnotationGeometry.denormalizeRect(quadUnit, pageRect);
      switch (a.markupType) {
        case AnnotationType.highlight:
          canvas.drawRect(r, Paint()..color = color.withValues(alpha: 0.35));
        case AnnotationType.underline:
          final y = r.bottom - r.height * 0.08;
          canvas.drawLine(
            Offset(r.left, y),
            Offset(r.right, y),
            _linePaint(color, r.height),
          );
        case AnnotationType.strikethrough:
          final y = r.center.dy;
          canvas.drawLine(
            Offset(r.left, y),
            Offset(r.right, y),
            _linePaint(color, r.height),
          );
        default:
          break;
      }
    }
  }

  Paint _linePaint(Color color, double lineHeight) => Paint()
    ..color = color
    ..strokeWidth = (lineHeight * 0.06).clamp(1.0, 4.0)
    ..strokeCap = StrokeCap.round;

  void _paintInk(ui.Canvas canvas, Rect pageRect, InkAnnotation a) {
    final color = Color(a.color ?? 0xFF1E88E5);
    for (final stroke in a.strokes) {
      if (stroke.points.isEmpty) continue;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = (stroke.width * pageRect.width).clamp(1.0, 40.0)
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final path = Path();
      final first = AnnotationGeometry.denormalizePoint(
        stroke.points.first,
        pageRect,
      );
      path.moveTo(first.dx, first.dy);
      for (final p in stroke.points.skip(1)) {
        final o = AnnotationGeometry.denormalizePoint(p, pageRect);
        path.lineTo(o.dx, o.dy);
      }
      canvas.drawPath(path, paint);
    }
  }
}
