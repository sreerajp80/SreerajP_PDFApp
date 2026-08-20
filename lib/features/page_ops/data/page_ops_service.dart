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

  /// Writes a copy with blank margins cropped. Returns the new file path.
  Future<String> trimMargins(
    String path, {
    String? password,
    double padding = 12.0,
    bool symmetric = true,
  }) async {
    final out = await _outputPath('trimmed');
    return _pdfBox.trimPdfMargins(
      path,
      out,
      password: password,
      padding: padding,
      symmetric: symmetric,
    );
  }

  /// Writes a 2-Up foldable booklet imposition PDF. Returns the new file path.
  Future<String> generateBooklet(
    String path, {
    String? password,
    String binding = 'ltr',
    String sheetSize = 'auto',
    bool addFoldGuide = true,
    double gutter = 0.0,
  }) async {
    final out = await _outputPath('booklet');
    return _pdfBox.generateBooklet(
      path,
      out,
      password: password,
      binding: binding,
      sheetSize: sheetSize,
      addFoldGuide: addFoldGuide,
      gutter: gutter,
    );
  }

  /// Applies a custom watermark onto a new copy of the PDF. Returns the new file path.
  Future<String> applyWatermark(
    String path, {
    String? password,
    String? text,
    String? imagePath,
    double opacity = 0.3,
    double rotation = 45.0,
    double fontSize = 36.0,
    String? colorHex,
    bool isTiled = false,
    double tileSpacingX = 150.0,
    double tileSpacingY = 150.0,
    String? pageRange,
  }) async {
    final out = await _outputPath('watermarked');
    return _pdfBox.applyWatermark(
      path,
      out,
      password: password,
      text: text,
      imagePath: imagePath,
      opacity: opacity,
      rotation: rotation,
      fontSize: fontSize,
      colorHex: colorHex,
      isTiled: isTiled,
      tileSpacingX: tileSpacingX,
      tileSpacingY: tileSpacingY,
      pageRange: pageRange,
    );
  }

  /// Writes an N-Up multi-page grid PDF (2-in-1, 4-in-1, 6-in-1, 9-in-1). Returns the new file path.
  Future<String> generateNUp(
    String path, {
    String? password,
    int gridCount = 4,
    String sheetSize = 'a4',
    String orientation = 'auto',
    bool addBorders = true,
    double margin = 12.0,
  }) async {
    final out = await _outputPath('nup');
    return _pdfBox.generateNUpPdf(
      path,
      out,
      password: password,
      gridCount: gridCount,
      sheetSize: sheetSize,
      orientation: orientation,
      addBorders: addBorders,
      margin: margin,
    );
  }

  /// Runs batch operations across multiple PDF documents with progress callbacks.
  Future<BatchSummaryResult> runBatchOperation({
    required List<OpenedDocument> documents,
    required BatchOpType type,
    String? userPassword,
    String? ownerPassword,
    void Function(int current, int total, String currentDocName)? onProgress,
  }) async {
    final items = <BatchItemResult>[];
    final dir = await _outputDir();

    if (type == BatchOpType.merge) {
      // Special case: combine all documents into one single merged PDF
      try {
        final paths = documents.map((d) => d.cachePath).toList();
        final out = await merge(paths);
        items.add(
          BatchItemResult(
            inputPath: documents.first.cachePath,
            displayName: 'Merged (${documents.length} files)',
            outputPath: out,
          ),
        );
      } catch (e) {
        items.add(
          BatchItemResult(
            inputPath: documents.first.cachePath,
            displayName: 'Merged (${documents.length} files)',
            isSuccess: false,
            errorMessage: e.toString(),
          ),
        );
      }
      return BatchSummaryResult(
        type: type,
        items: items,
        totalProcessed: documents.length,
        successCount: items.where((i) => i.isSuccess).length,
        failureCount: items.where((i) => !i.isSuccess).length,
      );
    }

    // Process file-by-file with error isolation
    for (var i = 0; i < documents.length; i++) {
      final doc = documents[i];
      onProgress?.call(i + 1, documents.length, doc.displayName);

      try {
        String? outPath;
        switch (type) {
          case BatchOpType.encrypt:
            if (userPassword != null && userPassword.isNotEmpty) {
              outPath = await protect(
                doc.cachePath,
                userPassword: userPassword,
                ownerPassword: ownerPassword,
              );
            }
            break;
          case BatchOpType.trimMargins:
            outPath = await trimMargins(doc.cachePath);
            break;
          case BatchOpType.compress:
            outPath = await compress(doc.cachePath);
            break;
          case BatchOpType.extractText:
            final text = await _pdfBox.extractText(doc.cachePath);
            final ts = DateTime.now().millisecondsSinceEpoch;
            final txtFile = File(
              '${dir.path}/extracted_${doc.displayName}_$ts.txt',
            );
            await txtFile.writeAsString(text);
            outPath = txtFile.path;
            break;
          case BatchOpType.merge:
            break;
        }

        items.add(
          BatchItemResult(
            inputPath: doc.cachePath,
            displayName: doc.displayName,
            outputPath: outPath,
            isSuccess: outPath != null,
          ),
        );
      } catch (e) {
        items.add(
          BatchItemResult(
            inputPath: doc.cachePath,
            displayName: doc.displayName,
            isSuccess: false,
            errorMessage: e.toString(),
          ),
        );
      }
    }

    return BatchSummaryResult(
      type: type,
      items: items,
      totalProcessed: documents.length,
      successCount: items.where((i) => i.isSuccess).length,
      failureCount: items.where((i) => !i.isSuccess).length,
    );
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

enum BatchOpType { encrypt, merge, extractText, trimMargins, compress }

class BatchItemResult {
  const BatchItemResult({
    required this.inputPath,
    required this.displayName,
    this.outputPath,
    this.isSuccess = true,
    this.errorMessage,
  });

  final String inputPath;
  final String displayName;
  final String? outputPath;
  final bool isSuccess;
  final String? errorMessage;
}

class BatchSummaryResult {
  const BatchSummaryResult({
    required this.type,
    required this.items,
    required this.totalProcessed,
    required this.successCount,
    required this.failureCount,
  });

  final BatchOpType type;
  final List<BatchItemResult> items;
  final int totalProcessed;
  final int successCount;
  final int failureCount;

  List<String> get outputPaths => items
      .where((i) => i.outputPath != null)
      .map((i) => i.outputPath!)
      .toList();
}

final pageOpsServiceProvider = Provider<PageOpsService>(
  (ref) => PageOpsService(
    ref.watch(pdfBoxChannelProvider),
    ref.watch(openDocumentChannelProvider),
  ),
);
