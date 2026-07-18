/// Sealed domain exception hierarchy — engineering standard §11.3.
///
/// Services must throw these typed exceptions, never raw `Exception`/`Error`.
/// State layers catch them and translate to UI state. User-facing messages must
/// stay human-readable; internal detail goes to `cause` and the logs.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

/// Storage / database / file-system failure.
final class StorageException extends AppException {
  const StorageException(super.message, {super.cause});
}

/// Invalid input for a named field.
final class ValidationException extends AppException {
  const ValidationException(this.field, String message) : super(message);

  final String field;
}

/// Base for PDF-domain failures (parse, render, page-op).
///
/// `base` (not `final`) so the viewer/page-op/signature phases can add their own
/// typed subtypes. State layers can still catch `PdfException` for a generic
/// "could not read this PDF" state.
base class PdfException extends AppException {
  const PdfException(super.message, {super.cause});
}

/// A PDF could not be opened at all (unknown/generic open failure). Phase 1.
final class PdfOpenException extends PdfException {
  const PdfOpenException(super.message, {super.cause});
}

/// The file is not a valid PDF, or is truncated/damaged. Phase 1.
final class PdfCorruptException extends PdfException {
  const PdfCorruptException(super.message, {super.cause});
}

/// The PDF is encrypted and needs a password (or the password was wrong). The
/// password itself is never carried on the exception (no secrets in logs). Phase 1.
final class PdfPasswordRequiredException extends PdfException {
  const PdfPasswordRequiredException(super.message, {super.cause});
}

/// The file is empty (zero bytes) or has no pages. Phase 1.
final class PdfEmptyException extends PdfException {
  const PdfEmptyException(super.message, {super.cause});
}

/// Text cannot be written into a PDF because the built-in fonts do not cover its
/// letters (Malayalam, Devanagari, and other complex scripts). Phase 6.
///
/// This is a real limit of the open-source PdfBox stack, not a bug: PdfBox ships
/// Latin-1 fonts only and has no shaping engine, so the letters would come out
/// broken. The UI says so plainly instead of saving nonsense.
final class PdfUnsupportedTextException extends PdfException {
  const PdfUnsupportedTextException(super.message, {super.cause});
}

/// Printing could not start (no print support, or the spooler refused). Phase 6.
final class PrintException extends AppException {
  const PrintException(super.message, {super.cause});
}

/// A PDF's signatures could not be read or checked. Phase 7.
///
/// This means the *check* failed — not that the signature is bad. The two must
/// never be confused: "we could not check" has to reach the user as unknown, not
/// as invalid (which would accuse a good document) and certainly not as trusted.
final class SignatureCheckException extends AppException {
  const SignatureCheckException(super.message, {super.cause});
}

/// A file the user picked to trust is not a certificate we can read. Phase 7.
final class InvalidCertificateException extends AppException {
  const InvalidCertificateException(super.message, {super.cause});
}
