import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/sign_document/domain/signature_image_tools.dart';

/// Turns picture files into [RgbaImage]s and back into PNG bytes, using the
/// engine's own image decoder.
///
/// A picked file is **untrusted input**: it may be damaged, not a picture at
/// all, or huge. Every failure becomes an [ImageReadException] with a plain
/// message; nothing is thrown raw.
class SignatureImageCodec {
  const SignatureImageCodec();

  /// Files larger than this are refused before they are read.
  static const int maxFileBytes = 25 * 1024 * 1024;

  /// Pictures with more pixels than this are refused before decoding.
  static const int maxSourcePixels = 50 * 1000 * 1000;

  /// Reads and decodes the picture at [path], scaled down so its longest side
  /// is at most [SignatureImageTools.maxSide].
  Future<RgbaImage> decodeFile(String path) async {
    final Uint8List bytes;
    try {
      final file = File(path);
      final length = await file.length();
      if (length == 0) {
        throw const ImageReadException('The picture is empty.');
      }
      if (length > maxFileBytes) {
        throw const ImageReadException('The picture is too large.');
      }
      bytes = await file.readAsBytes();
    } on FileSystemException catch (e) {
      throw ImageReadException('The picture could not be read.', cause: e);
    }
    return decodeBytes(bytes);
  }

  /// Decodes encoded picture [bytes] (PNG, JPEG, WebP, ...).
  Future<RgbaImage> decodeBytes(Uint8List bytes) async {
    ui.ImmutableBuffer? buffer;
    ui.ImageDescriptor? descriptor;
    ui.Codec? codec;
    ui.Image? image;
    try {
      buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      descriptor = await ui.ImageDescriptor.encoded(buffer);
      final w = descriptor.width;
      final h = descriptor.height;
      if (w <= 0 || h <= 0) {
        throw const ImageReadException('The picture has no size.');
      }
      if (w * h > maxSourcePixels) {
        throw const ImageReadException('The picture is too large.');
      }
      final target = SignatureImageTools.fitSize(w, h);
      codec = await descriptor.instantiateCodec(
        targetWidth: target.width,
        targetHeight: target.height,
      );
      final frame = await codec.getNextFrame();
      image = frame.image;
      return await fromImage(image);
    } on ImageReadException {
      rethrow;
    } catch (e) {
      throw ImageReadException(
        'This file is not a picture we can read.',
        cause: e,
      );
    } finally {
      image?.dispose();
      codec?.dispose();
      descriptor?.dispose();
      buffer?.dispose();
    }
  }

  /// Copies the pixels of an engine [image] into an [RgbaImage] (straight,
  /// not premultiplied, alpha). The caller still owns (and disposes) [image].
  Future<RgbaImage> fromImage(ui.Image image) async {
    final data = await image.toByteData(
      format: ui.ImageByteFormat.rawStraightRgba,
    );
    if (data == null) {
      throw const ImageReadException('The picture could not be read.');
    }
    return RgbaImage(
      rgba: data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      width: image.width,
      height: image.height,
    );
  }

  /// Encodes [image] as a PNG (keeps the see-through background).
  ///
  /// The engine reads raw `rgba8888` pixels as **premultiplied**, while
  /// [RgbaImage] holds straight alpha, so the pixels are converted first.
  /// Without this, the soft pen edges would get light halos.
  Future<Uint8List> encodePng(RgbaImage image) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(
      SignatureImageTools.premultiplied(image.rgba),
    );
    final descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: image.width,
      height: image.height,
      pixelFormat: ui.PixelFormat.rgba8888,
    );
    final codec = await descriptor.instantiateCodec();
    ui.Image? frameImage;
    try {
      final frame = await codec.getNextFrame();
      frameImage = frame.image;
      final png = await frameImage.toByteData(format: ui.ImageByteFormat.png);
      if (png == null) {
        throw const ImageReadException('The picture could not be saved.');
      }
      return png.buffer.asUint8List(png.offsetInBytes, png.lengthInBytes);
    } finally {
      frameImage?.dispose();
      codec.dispose();
      descriptor.dispose();
      buffer.dispose();
    }
  }
}
