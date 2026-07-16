import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';

/// Dart wrapper for Phase 4 page operations.
///
/// Every operation writes a **new file** in the app's `page_ops/` cache folder,
/// then the caller either saves it to a user-chosen location or shares it. The
/// source PDF is only ever read (copy-on-write).
class PageOpsService {
  PageOpsService(this._pdfBox, this._openChannel);

  final PdfBoxChannel _pdfBox;
  final OpenDocumentChannel _openChannel;

  /// Returns (and creates) the page-ops output directory in the cache folder.
  Future<Directory> _outputDir() async {
    final temp = await getTemporaryDirectory();
    final dir = Directory('${temp.path}/page_ops');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Deletes all files left over from earlier operations.
  Future<void> clearOutputCache() async {
    try {
      final dir = await _outputDir();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {
      // A failed clean-up is harmless; the OS clears the cache anyway.
    }
  }

  Future<String> _outputPath(String prefix) async {
    final dir = await _outputDir();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/${prefix}_$ts.pdf';
  }

  /// Lets the user pick extra PDFs to merge (empty list on cancel).
  Future<List<OpenedDocument>> pickPdfsToMerge() => _openChannel.pickPdfs();

  /// Merges [paths] (in order) into one new PDF. Returns the new file path.
  Future<String> merge(List<String> paths) async {
    final out = await _outputPath('merged');
    return _pdfBox.mergePdfs(paths, out);
  }

  /// Splits [path] into one file per page. Returns the new file paths.
  Future<List<String>> split(String path, {String? password}) async {
    final dir = await _outputDir();
    return _pdfBox.splitPdf(path, dir.path, password: password);
  }

  /// Reorders/rotates/deletes pages into a new PDF. Returns the new file path.
  Future<String> organize(
    String path,
    List<Map<String, int>> pages, {
    String? password,
  }) async {
    final out = await _outputPath('organized');
    return _pdfBox.organizePages(path, out, pages, password: password);
  }

  /// Writes a best-effort compressed copy. Returns the new file path.
  Future<String> compress(String path, {String? password}) async {
    final out = await _outputPath('compressed');
    return _pdfBox.compressPdf(path, out, password: password);
  }

  /// Writes a password-protected copy. Returns the new file path.
  Future<String> protect(
    String path, {
    String? password,
    required String userPassword,
    String? ownerPassword,
  }) async {
    final out = await _outputPath('protected');
    return _pdfBox.encryptPdf(
      path,
      out,
      password: password,
      userPassword: userPassword,
      ownerPassword: ownerPassword,
    );
  }

  /// Writes an unprotected copy using [password]. Returns the new file path.
  Future<String> unlock(String path, {required String password}) async {
    final out = await _outputPath('unlocked');
    return _pdfBox.decryptPdf(path, out, password: password);
  }

  /// Saves [sourcePath] to a user-chosen location. Returns the saved name or null.
  Future<String?> saveToDevice(String sourcePath, String suggestedName) =>
      _openChannel.saveToDevice(sourcePath, suggestedName);

  /// The size in bytes of a produced file, or null if it cannot be read.
  Future<int?> fileSize(String path) async {
    try {
      return await File(path).length();
    } catch (_) {
      return null;
    }
  }
}

final pageOpsServiceProvider = Provider<PageOpsService>(
  (ref) => PageOpsService(
    ref.watch(pdfBoxChannelProvider),
    ref.watch(openDocumentChannelProvider),
  ),
);
