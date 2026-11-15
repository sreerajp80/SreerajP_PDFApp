import 'dart:math' as math;
import 'dart:typed_data';

/// A decoded picture as raw RGBA bytes: 4 bytes per pixel, rows top to bottom,
/// with **straight** (not premultiplied) alpha.
class RgbaImage {
  RgbaImage({required this.rgba, required this.width, required this.height})
    : assert(rgba.length == width * height * 4, 'RGBA length mismatch');

  final Uint8List rgba;
  final int width;
  final int height;
}

/// A pixel rectangle inside an [RgbaImage] (inclusive left/top, exclusive
/// right/bottom).
class PixelBounds {
  const PixelBounds(this.left, this.top, this.right, this.bottom);

  final int left;
  final int top;
  final int right;
  final int bottom;

  int get width => right - left;
  int get height => bottom - top;

  @override
  bool operator ==(Object other) =>
      other is PixelBounds &&
      other.left == left &&
      other.top == top &&
      other.right == right &&
      other.bottom == bottom;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);

  @override
  String toString() => 'PixelBounds($left, $top, $right, $bottom)';
}

/// Pure pixel work for signature pictures. No `dart:ui`, so it is easy to test
/// and can run in a background isolate.
abstract final class SignatureImageTools {
  /// Longest side, in pixels, of a saved signature picture.
  static const int maxSide = 1200;

  /// Pixels at least this light become fully see-through.
  static const int lightCutoff = 215;

  /// Pixels at least this dark stay fully solid. Between the two, the pixel
  /// fades, which keeps the pen edges smooth.
  static const int darkCutoff = 140;

  /// Turns the light paper in a photo or scan see-through, so only the ink is
  /// left. Returns a new list; [image] is not changed.
  static RgbaImage removeLightBackground(RgbaImage image) {
    final src = image.rgba;
    final out = Uint8List.fromList(src);
    for (var i = 0; i < out.length; i += 4) {
      // Perceived brightness (ITU-R BT.601 weights), 0–255.
      final lum = (src[i] * 299 + src[i + 1] * 587 + src[i + 2] * 114) ~/ 1000;
      int keep;
      if (lum >= lightCutoff) {
        keep = 0;
      } else if (lum <= darkCutoff) {
        keep = 255;
      } else {
        keep = (255 * (lightCutoff - lum)) ~/ (lightCutoff - darkCutoff);
      }
      out[i + 3] = (src[i + 3] * keep) ~/ 255;
    }
    return RgbaImage(rgba: out, width: image.width, height: image.height);
  }

  /// The smallest box that holds every pixel whose alpha is above
  /// [alphaThreshold], or null when the picture is fully see-through.
  static PixelBounds? opaqueBounds(RgbaImage image, {int alphaThreshold = 16}) {
    var left = image.width;
    var top = image.height;
    var right = -1;
    var bottom = -1;
    final px = image.rgba;
    for (var y = 0; y < image.height; y++) {
      final row = y * image.width * 4;
      for (var x = 0; x < image.width; x++) {
        if (px[row + x * 4 + 3] > alphaThreshold) {
          if (x < left) left = x;
          if (x > right) right = x;
          if (y < top) top = y;
          if (y > bottom) bottom = y;
        }
      }
    }
    if (right < 0) return null;
    return PixelBounds(left, top, right + 1, bottom + 1);
  }

  /// Cuts [bounds] out of [image], grown by [padding] pixels on each side
  /// (limited to the picture's edges).
  static RgbaImage crop(
    RgbaImage image,
    PixelBounds bounds, {
    int padding = 0,
  }) {
    final l = math.max(0, bounds.left - padding);
    final t = math.max(0, bounds.top - padding);
    final r = math.min(image.width, bounds.right + padding);
    final b = math.min(image.height, bounds.bottom + padding);
    final w = r - l;
    final h = b - t;
    final out = Uint8List(w * h * 4);
    for (var y = 0; y < h; y++) {
      final from = ((t + y) * image.width + l) * 4;
      out.setRange(y * w * 4, (y + 1) * w * 4, image.rgba, from);
    }
    return RgbaImage(rgba: out, width: w, height: h);
  }

  /// A premultiplied copy of straight-alpha [rgba]: each color is scaled by
  /// its alpha, which is what the engine expects for raw pixels.
  static Uint8List premultiplied(Uint8List rgba) {
    final out = Uint8List.fromList(rgba);
    for (var i = 0; i < out.length; i += 4) {
      final a = out[i + 3];
      if (a == 255) continue;
      out[i] = (out[i] * a + 127) ~/ 255;
      out[i + 1] = (out[i + 1] * a + 127) ~/ 255;
      out[i + 2] = (out[i + 2] * a + 127) ~/ 255;
    }
    return out;
  }

  /// The size that fits inside [limit] on the longest side, keeping the shape.
  /// A picture that already fits keeps its size. Never returns a zero side.
  static ({int width, int height}) fitSize(
    int width,
    int height, {
    int limit = maxSide,
  }) {
    final longest = math.max(width, height);
    if (longest <= limit) return (width: width, height: height);
    final scale = limit / longest;
    return (
      width: math.max(1, (width * scale).round()),
      height: math.max(1, (height * scale).round()),
    );
  }
}
