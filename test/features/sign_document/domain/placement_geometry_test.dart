import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/sign_document/domain/placement_geometry.dart';

void main() {
  // A4 portrait is about 595 x 842 points.
  const a4 = 595 / 842;

  /// The box's shape in real page units (width / height), which must match the
  /// picture's shape for the signature not to look stretched.
  double shownAspect(Rect r, double pageAspect) =>
      (r.width * pageAspect) / r.height;

  group('initialRect', () {
    test('is centred and keeps the picture shape', () {
      final r = PlacementGeometry.initialRect(imageAspect: 3, pageAspect: a4);
      expect(r.width, closeTo(PlacementGeometry.startWidth, 1e-9));
      expect(r.center.dx, closeTo(0.5, 1e-9));
      expect(r.center.dy, closeTo(0.5, 1e-9));
      expect(shownAspect(r, a4), closeTo(3, 1e-9));
    });

    test('a tall picture is limited by height, not width', () {
      final r = PlacementGeometry.initialRect(imageAspect: 0.2, pageAspect: a4);
      expect(r.height, closeTo(PlacementGeometry.maxStartHeight, 1e-9));
      expect(r.width, lessThan(PlacementGeometry.startWidth));
      expect(shownAspect(r, a4), closeTo(0.2, 1e-9));
    });

    test('a broken aspect ratio does not give NaN', () {
      final r = PlacementGeometry.initialRect(imageAspect: 0, pageAspect: 0);
      expect(r.width.isFinite && r.height.isFinite, isTrue);
    });
  });

  group('move', () {
    test('moves by the delta when there is room', () {
      final r = PlacementGeometry.move(
        const Rect.fromLTWH(0.2, 0.2, 0.3, 0.1),
        const Offset(0.1, 0.05),
      );
      expect(r.left, closeTo(0.3, 1e-9));
      expect(r.top, closeTo(0.25, 1e-9));
    });

    test('never leaves the page on any side', () {
      const box = Rect.fromLTWH(0.5, 0.5, 0.3, 0.1);
      final farRight = PlacementGeometry.move(box, const Offset(5, 5));
      expect(farRight.right, closeTo(1, 1e-9));
      expect(farRight.bottom, closeTo(1, 1e-9));
      final farLeft = PlacementGeometry.move(box, const Offset(-5, -5));
      expect(farLeft.left, 0);
      expect(farLeft.top, 0);
      expect(farLeft.width, closeTo(box.width, 1e-9));
      expect(farLeft.height, closeTo(box.height, 1e-9));
    });
  });

  group('resize', () {
    const start = Rect.fromLTWH(0.1, 0.1, 0.3, 0.3 * a4 / 3);

    test('keeps the top-left corner and the picture shape', () {
      final r = PlacementGeometry.resize(
        start,
        0.5,
        imageAspect: 3,
        pageAspect: a4,
      );
      expect(r.topLeft, start.topLeft);
      expect(r.width, closeTo(0.5, 1e-9));
      expect(shownAspect(r, a4), closeTo(3, 1e-9));
    });

    test('cannot grow past the right edge', () {
      final r = PlacementGeometry.resize(
        start,
        2,
        imageAspect: 3,
        pageAspect: a4,
      );
      expect(r.right, closeTo(1, 1e-9));
    });

    test('cannot grow past the bottom edge (tall picture)', () {
      const tall = Rect.fromLTWH(0.1, 0.6, 0.1, 0.2);
      final r = PlacementGeometry.resize(
        tall,
        0.8,
        imageAspect: 0.4,
        pageAspect: a4,
      );
      expect(r.bottom, lessThanOrEqualTo(1 + 1e-9));
      expect(shownAspect(r, a4), closeTo(0.4, 1e-9));
    });

    test('cannot shrink below the minimum width', () {
      final r = PlacementGeometry.resize(
        start,
        0.001,
        imageAspect: 3,
        pageAspect: a4,
      );
      expect(r.width, closeTo(PlacementGeometry.minWidth, 1e-9));
    });
  });
}
