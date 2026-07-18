import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';

/// Turns shared content into a brand-new PDF (Phase 6, step 1).
///
/// Everything lands in the app's `printer/` cache folder first; the user then
/// saves it wherever they like through the system save dialog. Incoming content
/// is only ever read (copy-on-write).
class PdfBuilderService {
  PdfBuilderService(this._pdfBox, this._openChannel);

  final PdfBoxChannel _pdfBox;
  final OpenDocumentChannel _openChannel;

  /// Returns (and creates) the printer output folder in the cache.
  Future<Directory> _outputDir() async {
    final temp = await getTemporaryDirectory();
    final dir = Directory('${temp.path}/${AppConstants.printerCacheDir}');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Deletes files left over from earlier jobs.
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

  Future<String> outputPath(String prefix) async {
    final dir = await _outputDir();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/${_safeName(prefix)}_$ts.pdf';
  }

  /// Strips anything that would be awkward in a file name.
  String _safeName(String name) {
    final cleaned = name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    return cleaned.isEmpty ? 'document' : cleaned;
  }

  /// Builds a PDF with one page per picture. Returns the new file path.
  ///
  /// More than [AppConstants.maxImportImages] pictures are cut to that many: a
  /// share that big is a mistake far more often than an intent, and building it
  /// would look like a hang.
  Future<String> fromImages(IncomingImages images) async {
    final paths = images.paths.length > AppConstants.maxImportImages
        ? images.paths.sublist(0, AppConstants.maxImportImages)
        : images.paths;
    final out = await outputPath(images.suggestedName);
    return _pdfBox.imagesToPdf(paths, out);
  }

  /// Builds a PDF from shared text. Returns the new file path.
  /// Throws [PdfUnsupportedTextException] for letters the built-in fonts lack.
  Future<String> fromText(IncomingText text) async {
    final out = await outputPath(text.suggestedName);
    return _pdfBox.textToPdf(text.text, out);
  }

  /// True when [text] can be written into a PDF at all.
  Future<bool> canWriteText(String text) => _pdfBox.canWriteTextToPdf(text);

  /// Saves [sourcePath] to a user-chosen location. Returns the saved name, or
  /// null if the user cancelled.
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
