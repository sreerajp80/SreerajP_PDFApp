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
}
