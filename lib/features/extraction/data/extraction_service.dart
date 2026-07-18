import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';

/// Dart wrapper service for PDF extraction and page-to-image conversion.
///
/// It interacts with the native [PdfBoxChannel] to execute background operations
/// and exposes file paths under the app's temporary cache directory.
class ExtractionService {
  ExtractionService(this._pdfBoxChannel);

  final PdfBoxChannel _pdfBoxChannel;

  /// Returns the extraction directory in the temporary cache folder.
  Future<Directory> getExtractionDirectory() async {
    final temp = await getTemporaryDirectory();
    final dir = Directory('${temp.path}/extracted');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Clears all files in the extraction directory.
  Future<void> clearExtractionCache() async {
    try {
      final dir = await getExtractionDirectory();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {
      // Ignore directory clear failures
    }
  }

  /// Extracts text from PDF and returns it as a String.
  Future<String> extractText(
    String path, {
    String? password,
    int? startPage,
    int? endPage,
  }) async {
    return _pdfBoxChannel.extractText(
      path,
      password: password,
      startPage: startPage,
      endPage: endPage,
    );
  }

  /// Extracts text from PDF and saves it as a `.txt` file, returning its path.
  Future<String> extractTextToFile(
    String path, {
    String? password,
    int? startPage,
    int? endPage,
  }) async {
    final text = await extractText(
      path,
      password: password,
      startPage: startPage,
      endPage: endPage,
    );

    final dir = await getExtractionDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/extracted_text_$timestamp.txt');

    // Heavy string saving runs off the UI isolate if text is large.
    if (text.length > 50000) {
      await compute(_writeTextIsolate, _WriteTextArgs(file.path, text));
    } else {
      await file.writeAsString(text);
    }

    return file.path;
  }

  /// Extracts embedded images and returns the list of saved image paths.
  Future<List<String>> extractImages(
    String path, {
    String? password,
    int? startPage,
    int? endPage,
  }) async {
    final dir = await getExtractionDirectory();
    return _pdfBoxChannel.extractImages(
      path,
      dir.path,
      password: password,
      startPage: startPage,
      endPage: endPage,
    );
  }

  /// Reads AcroForm fields from the PDF.
  Future<List<Map<String, dynamic>>> readFormFields(
    String path, {
    String? password,
  }) async {
    return _pdfBoxChannel.readFormFields(path, password: password);
  }

  /// Reads AcroForm fields and saves them as a `.json` file, returning the file path.
  Future<String> readFormFieldsToFile(String path, {String? password}) async {
    final fields = await readFormFields(path, password: password);
    final dir = await getExtractionDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/form_fields_$timestamp.json');

    // Heavy serialization runs off the UI isolate.
    final jsonStr = await compute(jsonEncode, fields);
    await file.writeAsString(jsonStr);

    return file.path;
  }

  /// Renders PDF pages to raster images and returns the list of saved image paths.
  Future<List<String>> renderPagesToImages(
    String path, {
    String? password,
    int? startPage,
    int? endPage,
    String format = 'png',
    int dpi = 150,
  }) async {
    final dir = await getExtractionDirectory();
    return _pdfBoxChannel.renderPagesToImages(
      path,
      dir.path,
      password: password,
      startPage: startPage,
      endPage: endPage,
      format: format,
      dpi: dpi,
    );
  }
}

class _WriteTextArgs {
  _WriteTextArgs(this.path, this.text);
  final String path;
  final String text;
}

void _writeTextIsolate(_WriteTextArgs args) {
  File(args.path).writeAsStringSync(args.text);
}

final extractionServiceProvider = Provider<ExtractionService>(
  (ref) => ExtractionService(ref.watch(pdfBoxChannelProvider)),
);
