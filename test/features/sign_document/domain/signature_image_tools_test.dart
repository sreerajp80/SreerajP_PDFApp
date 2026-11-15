import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/sign_document/domain/signature_image_tools.dart';

/// A [w] x [h] picture filled with one RGBA colour.
RgbaImage solid(int w, int h, List<int> rgba) {
  final px = Uint8List(w * h * 4);
  for (var i = 0; i < px.length; i += 4) {
    px.setRange(i, i + 4, rgba);
  }
  return RgbaImage(rgba: px, width: w, height: h);
}

void setPixel(RgbaImage img, int x, int y, List<int> rgba) {
  final i = (y * img.width + x) * 4;
  img.rgba.setRange(i, i + 4, rgba);
}

List<int> pixel(RgbaImage img, int x, int y) {
  final i = (y * img.width + x) * 4;
  return img.rgba.sublist(i, i + 4);
}

void main() {
  group('removeLightBackground', () {
    test('white paper becomes see-through, dark ink stays solid', () {
      final img = solid(3, 1, [255, 255, 255, 255]);
      setPixel(img, 1, 0, [10, 20, 80, 255]); // dark blue ink
      final out = SignatureImageTools.removeLightBackground(img);
      expect(pixel(out, 0, 0)[3], 0);
      expect(pixel(out, 1, 0), [10, 20, 80, 255]);
      // The input is not changed.
      expect(pixel(img, 0, 0)[3], 255);
    });

    test('mid-grey pen edges fade instead of a hard cut', () {
      final img = solid(1, 1, [180, 180, 180, 255]);
      final a = pixel(SignatureImageTools.removeLightBackground(img), 0, 0)[3];
      expect(a, greaterThan(0));
      expect(a, lessThan(255));
    });

    test('keeps pixels that were already see-through', () {
      final img = solid(1, 1, [0, 0, 0, 0]);
      expect(pixel(SignatureImageTools.removeLightBackground(img), 0, 0)[3], 0);
    });
  });

  group('opaqueBounds and crop', () {
    test('finds the box around the visible pixels', () {
      final img = solid(10, 8, [0, 0, 0, 0]);
      setPixel(img, 2, 3, [0, 0, 0, 255]);
      setPixel(img, 6, 5, [0, 0, 0, 255]);
      expect(
        SignatureImageTools.opaqueBounds(img),
        const PixelBounds(2, 3, 7, 6),
      );
    });

    test('a fully see-through picture has no bounds', () {
      expect(
        SignatureImageTools.opaqueBounds(solid(4, 4, [0, 0, 0, 0])),
        isNull,
      );
    });

    test('crop copies the right pixels and pads within the edges', () {
      final img = solid(10, 8, [0, 0, 0, 0]);
      setPixel(img, 2, 3, [1, 2, 3, 255]);
      final cut = SignatureImageTools.crop(
        img,
        const PixelBounds(2, 3, 3, 4),
        padding: 1,
      );
      expect(cut.width, 3);
      expect(cut.height, 3);
      expect(pixel(cut, 1, 1), [1, 2, 3, 255]);

      // Padding past the edge is limited to the picture.
      final edge = SignatureImageTools.crop(
        img,
        const PixelBounds(0, 0, 2, 2),
        padding: 5,
      );
      expect(edge.width, 7);
      expect(edge.height, 7);
    });
  });

  group('premultiplied', () {
    test('scales colour by alpha and leaves solid pixels alone', () {
      final px = Uint8List.fromList([200, 100, 50, 128, 9, 8, 7, 255]);
      final out = SignatureImageTools.premultiplied(px);
      expect(out.sublist(0, 4), [100, 50, 25, 128]);
      expect(out.sublist(4, 8), [9, 8, 7, 255]);
      expect(px[0], 200, reason: 'input must not change');
    });
  });

  group('fitSize', () {
    test('keeps a small picture as it is', () {
      expect(SignatureImageTools.fitSize(300, 100), (width: 300, height: 100));
    });

    test('scales a large picture down, keeping its shape', () {
      final s = SignatureImageTools.fitSize(4000, 1000);
      expect(s.width, SignatureImageTools.maxSide);
      expect(s.height, 300);
    });

    test('never returns a zero side', () {
      final s = SignatureImageTools.fitSize(100000, 1);
      expect(s.height, 1);
    });
  });
}
