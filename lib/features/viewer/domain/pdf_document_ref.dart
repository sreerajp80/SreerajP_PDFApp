import 'package:pdfapp/core/constants/app_constants.dart';

/// An open (or about-to-open) PDF, identified by its content [fingerprint].
///
/// This is the value the viewer works with: the durable [uri] to reopen it, the
/// throwaway [cachePath] pdfium reads, and display info. [pageCount] is filled
/// in once the document is opened.
class PdfDocumentRef {
  const PdfDocumentRef({
    required this.fingerprint,
    required this.uri,
    required this.displayName,
    required this.sizeBytes,
    required this.cachePath,
    this.pageCount,
  });

  final String fingerprint;
  final String uri;
  final String displayName;
  final int sizeBytes;
  final String cachePath;
  final int? pageCount;

  /// True when the file is over the "large PDF" threshold and should open in
  /// the degraded (single-page) mode with a warning.
  bool get isLarge => sizeBytes > AppConstants.largePdfThresholdBytes;

  PdfDocumentRef copyWith({int? pageCount}) => PdfDocumentRef(
    fingerprint: fingerprint,
    uri: uri,
    displayName: displayName,
    sizeBytes: sizeBytes,
    cachePath: cachePath,
    pageCount: pageCount ?? this.pageCount,
  );
}
