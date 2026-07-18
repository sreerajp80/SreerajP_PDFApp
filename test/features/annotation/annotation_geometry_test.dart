import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/annotation/domain/annotation_geometry.dart';

void main() {
  const pageRect = Rect.fromLTWH(100, 200, 400, 800);

  test('clampUnit keeps values inside 0..1', () {
    expect(AnnotationGeometry.clampUnit(-0.5), 0.0);
    expect(AnnotationGeometry.clampUnit(0.3), 0.3);
    expect(AnnotationGeometry.clampUnit(1.7), 1.0);
  });

  test('point normalize/denormalize round-trips', () {
    const screen = Offset(300, 600); // centre of the page rect
    final unit = AnnotationGeometry.normalizePoint(screen, pageRect);
    expect(unit.dx, closeTo(0.5, 1e-9));
    expect(unit.dy, closeTo(0.5, 1e-9));

    final back = AnnotationGeometry.denormalizePoint(unit, pageRect);
    expect(back.dx, closeTo(screen.dx, 1e-6));
    expect(back.dy, closeTo(screen.dy, 1e-6));
  });

  test('normalizePoint clamps a point outside the page', () {
    final unit = AnnotationGeometry.normalizePoint(
      const Offset(1000, 5000),
      pageRect,
    );
    expect(unit.dx, 1.0);
    expect(unit.dy, 1.0);
  });

  test('rect normalize/denormalize round-trips', () {
    const screen = Rect.fromLTWH(200, 400, 100, 200);
    final unit = AnnotationGeometry.normalizeRect(screen, pageRect);
    final back = AnnotationGeometry.denormalizeRect(unit, pageRect);
    expect(back.left, closeTo(screen.left, 1e-6));
    expect(back.top, closeTo(screen.top, 1e-6));
    expect(back.right, closeTo(screen.right, 1e-6));
    expect(back.bottom, closeTo(screen.bottom, 1e-6));
  });

  test('mergeIntoLineQuads returns empty for no input', () {
    expect(AnnotationGeometry.mergeIntoLineQuads(const []), isEmpty);
  });

  test('mergeIntoLineQuads groups one line into one quad', () {
    // Three char boxes on the same line (same y), left to right.
    final rects = [
      const Rect.fromLTWH(0.10, 0.50, 0.05, 0.02),
      const Rect.fromLTWH(0.15, 0.50, 0.05, 0.02),
      const Rect.fromLTWH(0.20, 0.50, 0.05, 0.02),
    ];
    final quads = AnnotationGeometry.mergeIntoLineQuads(rects);
    expect(quads.length, 1);
    expect(quads.first.left, closeTo(0.10, 1e-9));
    expect(quads.first.right, closeTo(0.25, 1e-9));
  });

  test('mergeIntoLineQuads splits distinct lines', () {
    final rects = [
      const Rect.fromLTWH(0.10, 0.50, 0.05, 0.02),
      const Rect.fromLTWH(0.15, 0.50, 0.05, 0.02),
      // A clearly lower line.
      const Rect.fromLTWH(0.10, 0.70, 0.05, 0.02),
    ];
    final quads = AnnotationGeometry.mergeIntoLineQuads(rects);
    expect(quads.length, 2);
  });
}
