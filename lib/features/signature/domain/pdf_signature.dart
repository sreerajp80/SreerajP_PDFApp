import 'package:pdfapp/features/signature/domain/signature_status.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';

/// Whether the signed bytes still hash to what was signed.
///
/// This is the raw cryptographic outcome reported by the native verifier — a
/// *fact*, not a decision. What the app then shows the user is worked out by
/// `SignatureTrustEvaluator`.
enum SignatureIntegrity {
  /// The bytes verify against the signer's public key.
  valid,

  /// The bytes do not verify — they changed after signing, or the signature is
  /// not what it claims to be.
  invalid,

  /// The signature could not be read or understood (a form we do not parse, a
  /// malformed blob, a missing certificate).
  unknown,
}

/// One signature found in a PDF, as reported by the native verifier (Phase 7).
///
/// Everything on this class is a **fact about the file**. There is deliberately
/// no "is it good?" field: that judgement is made by `SignatureTrustEvaluator`
/// in pure Dart, where every rule can be unit-tested. Native code cannot be
/// tested on the host, so it is kept to reporting only.
class PdfSignature {
  const PdfSignature({
    required this.integrity,
    required this.coversWholeFile,
    this.name,
    this.reason,
    this.location,
    this.subFilter,
    this.signedAt,
    this.claimedSignedAt,
    this.signerCertSha256,
    this.chain = const [],
    this.chainTrusted = false,
    this.chainDetail,
    this.certExpiredAtSigning = false,
    this.revocationChecked = false,
    this.revoked = false,
    this.detail,
    this.position,
  });

  final SignaturePosition? position;

  final SignatureIntegrity integrity;

  /// True when the signed byte ranges span the entire file.
  ///
  /// When false, content was added **after** signing and the signature says
  /// nothing about it. The classic PDF signature attack, and the reason this is
  /// a hard blocker on trust rather than a warning.
  final bool coversWholeFile;

  final String? name;
  final String? reason;
  final String? location;
  final String? subFilter;

  /// Signing time taken from the *signed* attributes — inside the signed bytes,
  /// so it cannot be edited without breaking the signature. Trustworthy.
  final DateTime? signedAt;

  /// Signing time from the document's signature dictionary. This sits **outside**
  /// the signed bytes, so anyone could have changed it. A claim, not a fact.
  final DateTime? claimedSignedAt;

  final String? signerCertSha256;

  /// Signer certificate first, then its issuers as far as they could be found.
  final List<CertificateInfo> chain;

  /// True when the chain validated against a trust anchor the app supplied
  /// (a user-added certificate, or one from the bundled EUTL list).
  final bool chainTrusted;

  /// Why the chain did not validate. For diagnostics — never the headline.
  final String? chainDetail;

  final bool certExpiredAtSigning;

  /// True only when revocation was genuinely checked, using proof embedded in
  /// the PDF. The app never goes online, so this is often false — which the UI
  /// must say plainly rather than treat as "fine".
  final bool revocationChecked;

  /// True when the certificate was found in an embedded revocation list.
  final bool revoked;

  /// Machine-readable reason for an [SignatureIntegrity.unknown] result.
  final String? detail;

  /// The signer's certificate, when the signature carried one.
  CertificateInfo? get signerCertificate => chain.isEmpty ? null : chain.first;

  /// The best signing time we have, and whether it can be trusted.
  ///
  /// Prefers the signed attribute; falls back to the dictionary's claim.
  DateTime? get bestSignedAt => signedAt ?? claimedSignedAt;

  /// True when [bestSignedAt] is only a claim (came from outside the signed
  /// bytes), so the UI can mark it as such instead of presenting it as fact.
  bool get signingTimeIsClaimOnly =>
      signedAt == null && claimedSignedAt != null;

  static SignatureIntegrity _integrityFrom(Object? value) => switch (value) {
    'valid' => SignatureIntegrity.valid,
    'invalid' => SignatureIntegrity.invalid,
    _ => SignatureIntegrity.unknown,
  };

  static DateTime? _dateFrom(Object? value) => value == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch((value as num).toInt());

  static PdfSignature fromMap(Map<Object?, Object?> map) => PdfSignature(
    integrity: _integrityFrom(map['integrity']),
    coversWholeFile: map['coversWholeFile'] as bool? ?? false,
    name: map['name'] as String?,
    reason: map['reason'] as String?,
    location: map['location'] as String?,
    subFilter: map['subFilter'] as String?,
    signedAt: _dateFrom(map['signedAt']),
    claimedSignedAt: _dateFrom(map['claimedSignedAt']),
    signerCertSha256: map['signerCertSha256'] as String?,
    chain: [
      for (final item in (map['chain'] as List<Object?>? ?? const []))
        CertificateInfo.fromMap(item as Map<Object?, Object?>),
    ],
    chainTrusted: map['chainTrusted'] as bool? ?? false,
    chainDetail: map['chainDetail'] as String?,
    certExpiredAtSigning: map['certExpiredAtSigning'] as bool? ?? false,
    revocationChecked: map['revocationChecked'] as bool? ?? false,
    revoked: map['revoked'] as bool? ?? false,
    detail: map['detail'] as String?,
    position: map['position'] == null
        ? null
        : SignaturePosition.fromMap(map['position'] as Map<Object?, Object?>),
  );
}

/// The page index and visual coordinates of a signature field (Phase 7).
class SignaturePosition {
  const SignaturePosition({
    required this.pageIndex,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final int pageIndex;
  final double x;
  final double y;
  final double width;
  final double height;

  factory SignaturePosition.fromMap(Map<Object?, Object?> map) => SignaturePosition(
        pageIndex: map['pageIndex'] as int,
        x: (map['x'] as num).toDouble(),
        y: (map['y'] as num).toDouble(),
        width: (map['width'] as num).toDouble(),
        height: (map['height'] as num).toDouble(),
      );
}

/// A signature plus the app's honest verdict on it.
class SignatureVerdict {
  const SignatureVerdict({
    required this.signature,
    required this.status,
    required this.notes,
  });

  final PdfSignature signature;
  final SignatureStatus status;

  /// Caveats that stand regardless of [status] — see [SignatureNote].
  final List<SignatureNote> notes;

  bool get isTrusted => status == SignatureStatus.trusted;

  bool hasNote(SignatureNote note) => notes.contains(note);
}
