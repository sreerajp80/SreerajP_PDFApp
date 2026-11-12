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

  /// Working folders the app itself creates under the temp directory for
  /// short-lived files. The printer spool folder is not listed: it holds the
  /// user's printed documents until they clear it.
  static const List<String> workingDirs = [
    'opened',
    'page_ops',
    'extracted',
    'annotations',
    // Device sync: PDFs received from another phone, before they are saved.
    'received',
  ];

  /// Files older than this in [workingDirs] are left over from an earlier
  /// session and are safe to remove at startup.
  static const Duration staleAfter = Duration(hours: 24);

  /// Deletes files older than [staleAfter] in the app's [workingDirs]
  /// (engineering standard §9.3, §15.4). Call at startup, before any document
  /// opens. [tempDir] and [now] are for tests.
  Future<int> clearStaleWorkingFiles({
    Directory? tempDir,
    DateTime? now,
  }) async {
    var removed = 0;
    try {
      final root = tempDir ?? await getTemporaryDirectory();
      final cutoff = (now ?? DateTime.now()).subtract(staleAfter);
      for (final name in workingDirs) {
        final dir = Directory(p.join(root.path, name));
        if (!dir.existsSync()) continue;
        for (final entity in dir.listSync(
          recursive: true,
          followLinks: false,
        )) {
          if (entity is! File) continue;
          try {
            if (entity.lastModifiedSync().isBefore(cutoff)) {
              entity.deleteSync();
              removed++;
            }
          } catch (e) {
            AppLogger.warning('Could not remove a stale temp file', error: e);
          }
        }
      }
      if (removed > 0) AppLogger.info('Removed $removed stale temp files.');
    } catch (e) {
      AppLogger.warning('Stale temp file cleanup failed', error: e);
    }
    return removed;
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
}
