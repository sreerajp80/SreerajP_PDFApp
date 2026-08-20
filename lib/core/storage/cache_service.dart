import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/logging/app_logger.dart';

/// Helper service for monitoring and purging temporary cache files
/// (e.g. PDF print spool copies, image-to-PDF builds, extracted files).
class CacheService {
  const CacheService();

  /// Computes the total byte size of all files in the system temporary directory.
  Future<int> getCacheSizeBytes() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (!tempDir.existsSync()) return 0;
      return await _dirSize(tempDir);
    } catch (e) {
      AppLogger.warning('Failed to calculate cache size', error: e);
      return 0;
    }
  }

  /// Computes the size of the printer cache folder specifically.
  Future<int> getPrinterCacheSizeBytes() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final printerDir = Directory(
        p.join(tempDir.path, AppConstants.printerCacheDir),
      );
      if (!printerDir.existsSync()) return 0;
      return await _dirSize(printerDir);
    } catch (e) {
      AppLogger.warning('Failed to calculate printer cache size', error: e);
      return 0;
    }
  }

  /// Purges all files in the system temporary directory.
  Future<void> clearTempCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (!tempDir.existsSync()) return;
      final entities = tempDir.listSync();
      for (final entity in entities) {
        try {
          if (entity is File) {
            entity.deleteSync();
          } else if (entity is Directory) {
            entity.deleteSync(recursive: true);
          }
        } catch (e) {
          // Ignore individual locked file deletion errors.
        }
      }
    } catch (e) {
      AppLogger.warning('Failed to clear temp cache', error: e);
    }
  }

  /// Clears specifically the printer cache directory.
  Future<void> clearPrinterCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final printerDir = Directory(
        p.join(tempDir.path, AppConstants.printerCacheDir),
      );
      if (printerDir.existsSync()) {
        printerDir.deleteSync(recursive: true);
      }
    } catch (e) {
      AppLogger.warning('Failed to clear printer cache', error: e);
    }
  }

  Future<int> _dirSize(Directory dir) async {
    int total = 0;
    try {
      final entities = dir.listSync(recursive: true, followLinks: false);
      for (final entity in entities) {
        if (entity is File) {
          total += entity.lengthSync();
        }
      }
    } catch (_) {}
    return total;
  }

  /// Formats byte count into human-readable string (e.g. "2.4 MB", "450 KB", "0 B").
  static String formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
