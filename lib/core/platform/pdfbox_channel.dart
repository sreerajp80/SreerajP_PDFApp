import 'package:flutter/services.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/errors/app_exception.dart';

/// The PDF's own "document information" fields, read by PdfBox-Android.
///
/// Every field is optional: most PDFs fill in only a few, and a blank field is
/// reported as null rather than empty text. [pageCount] and [encrypted] always
/// come back when the document could be parsed at all.
class PdfMetadata {
  const PdfMetadata({
    this.title,
    this.author,
    this.subject,
    this.keywords,
    this.creator,
    this.producer,
    this.creationDate,
    this.modificationDate,
    this.pageCount,
    this.encrypted = false,
    this.pdfVersion,
  });

  final String? title;
  final String? author;
  final String? subject;
  final String? keywords;
  final String? creator;
  final String? producer;
  final DateTime? creationDate;
  final DateTime? modificationDate;
  final int? pageCount;
  final bool encrypted;
  final String? pdfVersion;

  /// True when the PDF carries none of the descriptive fields worth showing.
  bool get isEmpty =>
      title == null &&
      author == null &&
      subject == null &&
      keywords == null &&
      creator == null &&
      producer == null &&
      creationDate == null &&
      modificationDate == null;

  static DateTime? _dateFrom(Object? value) => value == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch((value as num).toInt());

  static PdfMetadata fromMap(Map<Object?, Object?> map) => PdfMetadata(
    title: map['title'] as String?,
    author: map['author'] as String?,
    subject: map['subject'] as String?,
    keywords: map['keywords'] as String?,
    creator: map['creator'] as String?,
    producer: map['producer'] as String?,
    creationDate: _dateFrom(map['creationDate']),
    modificationDate: _dateFrom(map['modificationDate']),
    pageCount: (map['pageCount'] as num?)?.toInt(),
    encrypted: map['encrypted'] as bool? ?? false,
    pdfVersion: map['pdfVersion'] as String?,
  );
}

/// Dart side of the PdfBox-Android bridge (Phase 2).
///
/// PdfBox reads PDF data that the renderer does not expose. Phase 2 uses it for
/// document metadata only; extraction and page operations join in later phases.
/// Text search deliberately does *not* go through here — only pdfrx/pdfium gives
/// the per-character rectangles that highlighting needs.
class PdfBoxChannel {
  PdfBoxChannel({MethodChannel? method})
    : _method = method ?? const MethodChannel(AppConstants.channelPdfBox);

  final MethodChannel _method;

  /// Reads the document information fields of the PDF at [cachePath].
  ///
  /// [password] is only for locked files and is never logged or stored (§11).
  /// Throws [PdfPasswordRequiredException] when the file needs a password we
  /// were not given, or [PdfException] when it cannot be parsed.
  Future<PdfMetadata> readMetadata(String cachePath, {String? password}) async {
    try {
      final result = await _method.invokeMethod<Map<Object?, Object?>>(
        'readMetadata',
        {'path': cachePath, 'password': ?password},
      );
      if (result == null) {
        throw const PdfOpenException('This PDF gave no details.');
      }
      return PdfMetadata.fromMap(result);
    } on PlatformException catch (e) {
      throw switch (e.code) {
        'password_required' => PdfPasswordRequiredException(
          'This PDF is locked, so its details cannot be read.',
          cause: e,
        ),
        _ => PdfOpenException(
          'This PDF\'s details could not be read.',
          cause: e,
        ),
      };
    } on MissingPluginException catch (e) {
      // Host tests / unsupported platform: fail typed, never crash.
      throw PdfOpenException('PDF details are not available here.', cause: e);
    }
  }

  /// Extracts text from the PDF at [cachePath] for the given page range.
  Future<String> extractText(
    String cachePath, {
    String? password,
    int? startPage,
    int? endPage,
  }) async {
    try {
      final result = await _method.invokeMethod<String>('extractText', {
        'path': cachePath,
        'password': password,
        'startPage': startPage,
        'endPage': endPage,
      });
      return result ?? '';
    } on PlatformException catch (e) {
      throw _mapException(e);
    } on MissingPluginException catch (e) {
      throw PdfOpenException(
        'Text extraction is not available here.',
        cause: e,
      );
    }
  }

  /// Extracts embedded images from the PDF at [cachePath] for the given page range
  /// and saves them into [outputDir]. Returns the list of absolute image paths.
  Future<List<String>> extractImages(
    String cachePath,
    String outputDir, {
    String? password,
    int? startPage,
    int? endPage,
  }) async {
    try {
      final result = await _method.invokeListMethod<String>('extractImages', {
        'path': cachePath,
        'password': password,
        'startPage': startPage,
        'endPage': endPage,
        'outputDir': outputDir,
      });
      return result ?? const [];
    } on PlatformException catch (e) {
      throw _mapException(e);
    } on MissingPluginException catch (e) {
      throw PdfOpenException(
        'Image extraction is not available here.',
        cause: e,
      );
    }
  }

  /// Reads AcroForm fields from the PDF at [cachePath].
  Future<List<Map<String, dynamic>>> readFormFields(
    String cachePath, {
    String? password,
  }) async {
    try {
      final result = await _method.invokeListMethod<dynamic>('readFormFields', {
        'path': cachePath,
        'password': password,
      });
      if (result == null) return const [];
      return result.map((item) {
        final map = item as Map<Object?, Object?>;
        return {
          'name': map['name'] as String? ?? '',
          'value': map['value'] as String? ?? '',
          'type': map['type'] as String? ?? '',
          'readOnly': map['readOnly'] as bool? ?? false,
        };
      }).toList();
    } on PlatformException catch (e) {
      throw _mapException(e);
    } on MissingPluginException catch (e) {
      throw PdfOpenException(
        'Form fields reading is not available here.',
        cause: e,
      );
    }
  }

  /// Renders PDF pages to raster images (PNG/JPEG) saved in [outputDir].
  Future<List<String>> renderPagesToImages(
    String cachePath,
    String outputDir, {
    String? password,
    int? startPage,
    int? endPage,
    String format = 'png',
    int dpi = 150,
  }) async {
    try {
      final result = await _method
          .invokeListMethod<String>('renderPagesToImages', {
            'path': cachePath,
            'password': password,
            'startPage': startPage,
            'endPage': endPage,
            'outputDir': outputDir,
            'format': format,
            'dpi': dpi,
          });
      return result ?? const [];
    } on PlatformException catch (e) {
      throw _mapException(e);
    } on MissingPluginException catch (e) {
      throw PdfOpenException('Page rendering is not available here.', cause: e);
    }
  }

  // --- Page operations (Phase 4). Each returns the new file path(s). ---

  /// Merges the PDFs at [paths] (in order) into one new PDF at [outputPath].
  Future<String> mergePdfs(List<String> paths, String outputPath) async {
    try {
      final result = await _method.invokeMethod<String>('mergePdfs', {
        'paths': paths,
        'outputPath': outputPath,
      });
      return result ?? outputPath;
    } on PlatformException catch (e) {
      throw _mapException(e);
    } on MissingPluginException catch (e) {
      throw PdfOpenException('Merging is not available here.', cause: e);
    }
  }

  /// Splits the PDF at [cachePath] into one file per page inside [outputDir].
  Future<List<String>> splitPdf(
    String cachePath,
    String outputDir, {
    String? password,
  }) async {
    try {
      final result = await _method.invokeListMethod<String>('splitPdf', {
        'path': cachePath,
        'password': password,
        'outputDir': outputDir,
      });
      return result ?? const [];
    } on PlatformException catch (e) {
      throw _mapException(e);
    } on MissingPluginException catch (e) {
      throw PdfOpenException('Splitting is not available here.', cause: e);
    }
  }

  /// Writes a new PDF at [outputPath] from selected pages.
  ///
  /// [pages] is an ordered list of `{'page': 1-based original, 'rotation': 0/90/180/270}`.
  /// Pages left out are dropped, so this one call covers reorder, rotate, and delete.
  Future<String> organizePages(
    String cachePath,
    String outputPath,
    List<Map<String, int>> pages, {
    String? password,
  }) async {
    try {
      final result = await _method.invokeMethod<String>('organizePages', {
        'path': cachePath,
        'password': password,
        'outputPath': outputPath,
        'pages': pages,
      });
      return result ?? outputPath;
    } on PlatformException catch (e) {
      throw _mapException(e);
    } on MissingPluginException catch (e) {
      throw PdfOpenException(
        'Page organizing is not available here.',
        cause: e,
      );
    }
  }

  /// Writes a best-effort compressed copy of [cachePath] at [outputPath].
  Future<String> compressPdf(
    String cachePath,
    String outputPath, {
    String? password,
  }) async {
    try {
      final result = await _method.invokeMethod<String>('compressPdf', {
        'path': cachePath,
        'password': password,
        'outputPath': outputPath,
      });
      return result ?? outputPath;
    } on PlatformException catch (e) {
      throw _mapException(e);
    } on MissingPluginException catch (e) {
      throw PdfOpenException('Compression is not available here.', cause: e);
    }
  }

  /// Writes a password-protected copy of [cachePath] at [outputPath].
  ///
  /// [userPassword] is required to open the file; [ownerPassword] (optional)
  /// controls permissions. Passwords are never logged or stored (§11).
  Future<String> encryptPdf(
    String cachePath,
    String outputPath, {
    String? password,
    required String userPassword,
    String? ownerPassword,
  }) async {
    try {
      final result = await _method.invokeMethod<String>('encryptPdf', {
        'path': cachePath,
        'password': password,
        'outputPath': outputPath,
        'userPassword': userPassword,
        'ownerPassword': ownerPassword,
      });
      return result ?? outputPath;
    } on PlatformException catch (e) {
      throw _mapException(e);
    } on MissingPluginException catch (e) {
      throw PdfOpenException('Protection is not available here.', cause: e);
    }
  }

  /// Writes an unprotected copy of [cachePath] at [outputPath] using [password].
  Future<String> decryptPdf(
    String cachePath,
    String outputPath, {
    required String password,
  }) async {
    try {
      final result = await _method.invokeMethod<String>('decryptPdf', {
        'path': cachePath,
        'password': password,
        'outputPath': outputPath,
      });
      return result ?? outputPath;
    } on PlatformException catch (e) {
      throw _mapException(e);
    } on MissingPluginException catch (e) {
      throw PdfOpenException('Unlocking is not available here.', cause: e);
    }
  }

  AppException _mapException(PlatformException e) {
    return switch (e.code) {
      'password_required' => PdfPasswordRequiredException(
        'This PDF is locked, so its content cannot be read.',
        cause: e,
      ),
      _ => PdfOpenException(
        e.message ?? 'This PDF could not be read.',
        cause: e,
      ),
    };
  }
}
