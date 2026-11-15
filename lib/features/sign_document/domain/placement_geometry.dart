import 'dart:math' as math;
import 'dart:ui';

/// Pure math for placing a signature box on a page. No widgets, no I/O.
///
/// All rects are normalized (0–1 of the page width / height, top-left origin).
/// Because the page is usually not square, a box that keeps the picture's
/// shape has a normalized height of `width * pageAspect / imageAspect`, where
/// each aspect is width divided by height.
abstract final class PlacementGeometry {
  /// Smallest box width, as a fraction of the page width.
  static const double minWidth = 0.05;

  /// Starting box width, as a fraction of the page width.
  static const double startWidth = 0.35;

  /// A new box can be at most this tall, as a fraction of the page height.
  static const double maxStartHeight = 0.5;

  /// The normalized height that keeps the picture's shape for [width].
  static double heightFor(
    double width, {
    required double imageAspect,
    required double pageAspect,
  }) => width * _safe(pageAspect) / _safe(imageAspect);

  /// The normalized width that keeps the picture's shape for [height].
  static double widthFor(
    double height, {
    required double imageAspect,
    required double pageAspect,
  }) => height * _safe(imageAspect) / _safe(pageAspect);

  /// A new box in the middle of the page, at a comfortable size.
  static Rect initialRect({
    required double imageAspect,
    required double pageAspect,
  }) {
    var w = startWidth;
    var h = heightFor(w, imageAspect: imageAspect, pageAspect: pageAspect);
    if (h > maxStartHeight) {
      h = maxStartHeight;
      w = widthFor(h, imageAspect: imageAspect, pageAspect: pageAspect);
    }
    return Rect.fromLTWH((1 - w) / 2, (1 - h) / 2, w, h);
  }

  /// Moves [rect] by [delta] (normalized) and keeps it fully on the page.
  static Rect move(Rect rect, Offset delta) => clampInside(rect.shift(delta));

  /// Moves [rect] back onto the page if any part of it is outside. A box larger
  /// than the page is pinned to the top-left.
  static Rect clampInside(Rect rect) {
    final left = rect.left.clamp(0.0, math.max(0.0, 1 - rect.width)).toDouble();
    final top = rect.top.clamp(0.0, math.max(0.0, 1 - rect.height)).toDouble();
    return Rect.fromLTWH(left, top, rect.width, rect.height);
  }

  /// Resizes [rect] to [newWidth] (normalized), keeping the picture's shape and
  /// the top-left corner. The size is limited so the box stays on the page and
  /// never becomes smaller than [minWidth].
  static Rect resize(
    Rect rect,
    double newWidth, {
    required double imageAspect,
    required double pageAspect,
  }) {
    // Largest width that still fits from this top-left corner, both across and
    // down (the height grows with the width).
    final maxByRight = 1 - rect.left;
    final maxByBottom = widthFor(
      1 - rect.top,
      imageAspect: imageAspect,
      pageAspect: pageAspect,
    );
    final maxWidth = math.min(maxByRight, maxByBottom);
    final minW = math.min(minWidth, maxWidth);
    final w = newWidth.clamp(minW, maxWidth);
    final h = heightFor(w, imageAspect: imageAspect, pageAspect: pageAspect);
    return Rect.fromLTWH(rect.left, rect.top, w, h);
  }

  // Guards against a zero or broken aspect ratio from a bad page or picture.
  static double _safe(double aspect) =>
      aspect.isFinite && aspect > 0 ? aspect : 1;
}
