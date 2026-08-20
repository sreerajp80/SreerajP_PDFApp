import 'package:pdfapp/features/signature/domain/pdf_signature.dart';
import 'package:pdfapp/features/signature/domain/signature_status.dart';

/// Turns the facts the native verifier reported into the one thing the user
/// sees: trusted, valid-but-unknown, invalid, or unknown (Phase 7).
///
/// **This class is the only place that can grant a green tick.** It lives in
/// pure Dart — no I/O, no platform calls — for one reason: the cryptography runs
/// in Kotlin and cannot be tested on the host, so the *judgement* was pulled out
/// of Kotlin and put somewhere every rule can be unit-tested. If you change a
/// rule here, change its test.
///
/// The governing rule from `docs/security.md`: **never fake trust**. When
/// the answer is unclear, the honest output is a lesser status plus a note —
/// never a green tick with the doubt hidden.
class SignatureTrustEvaluator {
  const SignatureTrustEvaluator();

  /// The verdict for one signature.
  SignatureVerdict evaluate(PdfSignature signature) {
    return SignatureVerdict(
      signature: signature,
      status: _statusOf(signature),
      notes: notesFor(signature),
    );
  }

  List<SignatureVerdict> evaluateAll(Iterable<PdfSignature> signatures) => [
    for (final s in signatures) evaluate(s),
  ];

  /// All three conditions must hold for a green tick, and each one is load
  /// bearing:
  ///
  /// 1. **The cryptography verifies** — the bytes are the signed bytes.
  /// 2. **It covers the whole file** — nothing was appended after signing. A
  ///    signature over part of a file is a real attack: the visible content can
  ///    be replaced while a valid-looking signature stays attached. Verifying
  ///    the crypto and skipping this check is the classic mistake.
  /// 3. **The chain reaches a trusted certificate** — we know who signed it.
  ///
  /// A revoked certificate is fatal on its own: revocation means whoever issued
  /// the certificate has since said "do not trust this", which outranks the fact
  /// that the maths still checks out.
  SignatureStatus _statusOf(PdfSignature s) {
    if (s.integrity == SignatureIntegrity.unknown) {
      return SignatureStatus.unknown;
    }
    if (s.integrity == SignatureIntegrity.invalid) {
      return SignatureStatus.invalid;
    }

    // From here the cryptography is valid — but valid is not the same as trusted.
    if (s.revoked) {
      return SignatureStatus.invalid;
    }
    if (!s.coversWholeFile) {
      return SignatureStatus.validNotTrusted;
    }
    if (!s.chainTrusted) {
      return SignatureStatus.validNotTrusted;
    }
    return SignatureStatus.trusted;
  }

  /// The fine print. Notes stand on their own and are shown whatever the status
  /// is — a trusted signature can still carry one, and hiding it would be the
  /// same dishonesty as a fake tick.
  List<SignatureNote> notesFor(PdfSignature s) {
    final notes = <SignatureNote>[];

    // Nothing below is meaningful if we could not read the signature at all;
    // stacking guesses onto "unknown" would only invent detail we do not have.
    if (s.integrity == SignatureIntegrity.unknown) {
      return notes;
    }

    if (!s.coversWholeFile) {
      notes.add(SignatureNote.partialCoverage);
    }
    if (s.revoked) {
      notes.add(SignatureNote.revoked);
    } else if (!s.revocationChecked) {
      notes.add(SignatureNote.revocationNotChecked);
    }
    if (s.certExpiredAtSigning) {
      notes.add(SignatureNote.certExpiredAtSigning);
    }
    if (s.signingTimeIsClaimOnly) {
      notes.add(SignatureNote.unverifiedSigningTime);
    }

    return notes;
  }

  /// Whether the UI should offer "trust this certificate" for [verdict].
  ///
  /// Only when the cryptography is sound and the signature covers the whole
  /// file. Trusting the certificate of a signature that is broken or covers
  /// only part of the file would let one click turn a bad document green —
  /// exactly what must not be possible.
  bool canOfferTrust(SignatureVerdict verdict) {
    final s = verdict.signature;
    return s.integrity == SignatureIntegrity.valid &&
        s.coversWholeFile &&
        !s.revoked &&
        !s.chainTrusted &&
        s.signerCertificate != null;
  }

  /// The document-level summary: the weakest verdict wins.
  ///
  /// A file is only as good as its worst signature. One trusted signature
  /// alongside a broken one is not a trusted document, and reporting the best
  /// of them would be the friendliest possible lie.
  SignatureStatus summaryOf(Iterable<SignatureVerdict> verdicts) {
    if (verdicts.isEmpty) return SignatureStatus.unknown;
    const order = [
      SignatureStatus.invalid,
      SignatureStatus.unknown,
      SignatureStatus.validNotTrusted,
      SignatureStatus.trusted,
    ];
    return verdicts
        .map((v) => v.status)
        .reduce((a, b) => order.indexOf(a) <= order.indexOf(b) ? a : b);
  }
}
