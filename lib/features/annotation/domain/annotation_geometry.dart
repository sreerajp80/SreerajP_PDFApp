import 'dart:ui';

/// Pure geometry helpers for overlay annotations (Phase 5).
///
/// Annotations are stored in a **normalized, top-left-origin** space: every
/// coordinate is a fraction (0.0–1.0) of the page width or height. This makes a
/// stored mark independent of zoom and screen size — it maps to any on-screen
/// page rectangle the same way. These functions do the conversions and never
/// touch the database or Flutter widgets, so they are easy to unit-test.
class AnnotationGeometry {
  const AnnotationGeometry._();

  /// Clamps a value to the 0.0–1.0 range. Guards against a drag that runs a
  /// little past the page edge.
  static double clampUnit(double v) => v.clamp(0.0, 1.0);

  /// A screen point inside [pageRect] to a normalized page point.
  static Offset normalizePoint(Offset screen, Rect pageRect) {
    if (pageRect.width == 0 || pageRect.height == 0) return Offset.zero;
    return Offset(
      clampUnit((screen.dx - pageRect.left) / pageRect.width),
      clampUnit((screen.dy - pageRect.top) / pageRect.height),
    );
  }

  /// A normalized page point back to a screen point inside [pageRect].
  static Offset denormalizePoint(Offset unit, Rect pageRect) {
    return Offset(
      pageRect.left + unit.dx * pageRect.width,
      pageRect.top + unit.dy * pageRect.height,
    );
  }

  /// A screen rectangle inside [pageRect] to a normalized rectangle.
  static Rect normalizeRect(Rect screen, Rect pageRect) {
    final tl = normalizePoint(screen.topLeft, pageRect);
    final br = normalizePoint(screen.bottomRight, pageRect);
    return Rect.fromLTRB(tl.dx, tl.dy, br.dx, br.dy);
  }

  /// A normalized rectangle back to a screen rectangle inside [pageRect].
  static Rect denormalizeRect(Rect unit, Rect pageRect) {
    return Rect.fromLTRB(
      pageRect.left + unit.left * pageRect.width,
      pageRect.top + unit.top * pageRect.height,
      pageRect.left + unit.right * pageRect.width,
      pageRect.top + unit.bottom * pageRect.height,
    );
  }

  /// Merges character rectangles (already normalized) into one quad per line,
  /// so a highlight across wrapped text becomes a few clean bars instead of one
  /// box per glyph. Rectangles are grouped when their vertical centers are
  /// close (within [lineTolerance] of the page height).
  ///
  /// Input rects need not be sorted. Output is left-to-right, top-to-bottom.
  static List<Rect> mergeIntoLineQuads(
    List<Rect> normalizedCharRects, {
    double lineTolerance = 0.01,
  }) {
    if (normalizedCharRects.isEmpty) return const [];

    final sorted = [...normalizedCharRects]
      ..sort((a, b) => a.center.dy.compareTo(b.center.dy));

    final lines = <List<Rect>>[];
    for (final rect in sorted) {
      final line = lines.isEmpty ? null : lines.last;
      if (line != null &&
          (rect.center.dy - line.first.center.dy).abs() <= lineTolerance) {
        line.add(rect);
      } else {
        lines.add([rect]);
      }
    }

    final quads = <Rect>[];
    for (final line in lines) {
      var l = double.infinity, t = double.infinity;
      var r = double.negativeInfinity, b = double.negativeInfinity;
      for (final rect in line) {
        if (rect.left < l) l = rect.left;
        if (rect.top < t) t = rect.top;
        if (rect.right > r) r = rect.right;
        if (rect.bottom > b) b = rect.bottom;
      }
      quads.add(Rect.fromLTRB(l, t, r, b));
    }
    return quads;
  }
}
