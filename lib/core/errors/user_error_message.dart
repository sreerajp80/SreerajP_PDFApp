import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Turns a caught error into text a user can read, in the app language
/// (engineering standard §11.2, §8.7).
///
/// The `message` on an [AppException] is English developer text for the logs;
/// it is never shown. Known error types get their own friendly message; any
/// other error gets [fallback], which names the action that failed. Raw
/// exception text (class names, codes, paths) never reaches the screen.
String userErrorMessage(
  AppLocalizations l10n,
  Object error, {
  required String fallback,
}) => switch (error) {
  PdfPasswordRequiredException() => l10n.errorPasswordBody,
  PdfCorruptException() => l10n.errorCorruptBody,
  PdfEmptyException() => l10n.errorEmptyBody,
  PdfUnsupportedTextException() => l10n.descImportUnsupportedTextDetail,
  PrintException() => l10n.errorPrintFailed,
  SignatureCheckException() => l10n.errorSignaturesFailed,
  InvalidCertificateException() => l10n.errorInvalidCertificate,
  _ => fallback,
};
