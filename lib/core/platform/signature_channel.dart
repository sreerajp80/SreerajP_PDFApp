import 'package:flutter/services.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/signature/domain/pdf_signature.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';

/// Dart side of the signature-verification bridge (Phase 7).
///
/// The native side does the cryptography and reports **facts**; this class just
/// carries them across and maps failures to typed exceptions. No judgement is
/// made here either — that belongs to `SignatureTrustEvaluator`.
///
/// Trust anchors are passed in on every call rather than held natively: the
/// trust store is Dart's, so there is one owner of "what do we trust", and the
/// native verifier stays stateless.
class SignatureChannel {
  SignatureChannel({MethodChannel? method})
    : _method = method ?? const MethodChannel(AppConstants.channelSignature);

  final MethodChannel _method;

  /// How many signatures the PDF at [cachePath] holds.
  ///
  /// Returns 0 rather than throwing when the count cannot be taken: this only
  /// decides whether to *offer* the Signatures screen, and a document that fails
  /// here will fail again inside the screen, where there is room to explain.
  Future<int> countSignatures(String cachePath, {String? password}) async {
    try {
      final result = await _method.invokeMethod<int>('countSignatures', {
        'path': cachePath,
        'password': password,
      });
      return result ?? 0;
    } on PlatformException {
      return 0;
    } on MissingPluginException {
      return 0;
    }
  }

  /// Verifies every signature in the PDF at [cachePath].
  ///
  /// [trustAnchors] are base64 DER certificates — the user's trust store plus
  /// the bundled EUTL list. With none supplied, nothing can come back trusted,
  /// which is correct rather than a bug.
  Future<List<PdfSignature>> verifySignatures(
    String cachePath, {
    String? password,
    List<String> trustAnchors = const [],
  }) async {
    try {
      final result = await _method.invokeListMethod<dynamic>(
        'verifySignatures',
        {'path': cachePath, 'password': password, 'trustAnchors': trustAnchors},
      );
      if (result == null) return const [];
      return [
        for (final item in result)
          PdfSignature.fromMap(item as Map<Object?, Object?>),
      ];
    } on PlatformException catch (e) {
      throw switch (e.code) {
        'password_required' => PdfPasswordRequiredException(
          'This PDF is locked, so its signatures cannot be checked.',
          cause: e,
        ),
        _ => SignatureCheckException(
          'This PDF\'s signatures could not be checked.',
          cause: e,
        ),
      };
    } on MissingPluginException catch (e) {
      throw SignatureCheckException(
        'Signature checking is not available here.',
        cause: e,
      );
    }
  }

  /// Reads the certificate file at [path] so the user can see what they are
  /// about to trust, before it is stored.
  Future<CertificateInfo> readCertificate(String path) async {
    try {
      final result = await _method.invokeMethod<Map<Object?, Object?>>(
        'readCertificate',
        {'path': path},
      );
      if (result == null) {
        throw const InvalidCertificateException(
          'This file is not a certificate.',
        );
      }
      return CertificateInfo.fromMap(result);
    } on PlatformException catch (e) {
      throw InvalidCertificateException(
        'This file is not a certificate the app can read.',
        cause: e,
      );
    } on MissingPluginException catch (e) {
      throw InvalidCertificateException(
        'Reading certificates is not available here.',
        cause: e,
      );
    }
  }
}
