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
