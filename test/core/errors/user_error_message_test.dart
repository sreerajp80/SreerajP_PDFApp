import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/errors/user_error_message.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

void main() {
  for (final code in ['en', 'ml', 'sa']) {
    group('userErrorMessage ($code)', () {
      final l10n = lookupAppLocalizations(Locale(code));
      String msg(Object e) => userErrorMessage(l10n, e, fallback: 'FALLBACK');

      test('known errors get their own localized message', () {
        expect(
          msg(const PdfPasswordRequiredException('x')),
          l10n.errorPasswordBody,
        );
        expect(msg(const PdfCorruptException('x')), l10n.errorCorruptBody);
        expect(msg(const PdfEmptyException('x')), l10n.errorEmptyBody);
        expect(
          msg(const PdfUnsupportedTextException('x')),
          l10n.descImportUnsupportedTextDetail,
        );
        expect(msg(const PrintException('x')), l10n.errorPrintFailed);
        expect(
          msg(const SignatureCheckException('x')),
          l10n.errorSignaturesFailed,
        );
        expect(
          msg(const InvalidCertificateException('x')),
          l10n.errorInvalidCertificate,
        );
      });

      test('other errors use the fallback, never the raw text', () {
        const secret = 'FileSystemException: /data/user/0/secret.pdf';
        expect(msg(const StorageException(secret)), 'FALLBACK');
        expect(msg(Exception(secret)), 'FALLBACK');
        expect(msg(StateError(secret)), 'FALLBACK');
      });
    });
  }
}
