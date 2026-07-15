import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:pdfapp/core/errors/app_exception.dart';

/// Content fingerprint = file **identity** (master plan §2, project rule).
///
/// It is the byte size joined with the SHA-256 of the whole file, as
/// `"<size>:<hex-sha256>"`. Reading positions and recent-file rows are keyed to
/// it, so a changed file (different bytes -> different hash) is treated as a new
/// document. Two files with the same content share one identity.
class Fingerprint {
  const Fingerprint._();

  /// Computes the fingerprint of the file at [path].
  ///
  /// Hashing runs on a background isolate ([compute]) so a large PDF never
  /// blocks the UI (cross-cutting rule: heavy work off the UI isolate).
  ///
  /// Throws [StorageException] if the file cannot be read.
  static Future<String> ofFile(String path) async {
    try {
      return await compute(_hashFile, path);
    } on AppException {
      rethrow;
    } catch (e) {
      throw StorageException(
        'Could not read the file to identify it.',
        cause: e,
      );
    }
  }
}

/// Streams the file through SHA-256. Runs inside [compute], so it must be a
/// top-level function and may only use the passed-in [path].
Future<String> _hashFile(String path) async {
  final file = File(path);
  if (!file.existsSync()) {
    throw StorageException('The file no longer exists at "$path".');
  }
  final size = await file.length();
  final digestSink = _DigestSink();
  final input = sha256.startChunkedConversion(digestSink);
  await for (final chunk in file.openRead()) {
    input.add(chunk);
  }
  input.close();
  return '$size:${digestSink.value}';
}

/// Captures the single digest emitted by the chunked SHA-256 conversion.
class _DigestSink implements Sink<Digest> {
  String value = '';

  @override
  void add(Digest data) => value = data.toString();

  @override
  void close() {}
}
