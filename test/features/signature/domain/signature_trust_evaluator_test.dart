import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/signature/domain/pdf_signature.dart';
import 'package:pdfapp/features/signature/domain/signature_status.dart';
import 'package:pdfapp/features/signature/domain/signature_trust_evaluator.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';

/// These tests are the safety net for the one rule that matters in Phase 7:
/// **a green tick must be earned**. The cryptography itself runs in Kotlin and
/// cannot be tested here, which is exactly why the judgement was put in Dart —
/// so every way a signature could wrongly go green is pinned down by a test.
void main() {
  const evaluator = SignatureTrustEvaluator();

  CertificateInfo cert({String sha256 = 'aa', String subject = 'CN=Jane'}) =>
      CertificateInfo(
        sha256: sha256,
        subject: subject,
        issuer: 'CN=Example CA',
        serial: '01',
        notBefore: DateTime(2020),
        notAfter: DateTime(2030),
        der: 'ZGVy',
      );

  /// A signature that should come back trusted. Each test spoils exactly one
  /// thing, so a failure names the rule that broke.
  PdfSignature good({
    SignatureIntegrity integrity = SignatureIntegrity.valid,
    bool coversWholeFile = true,
    bool chainTrusted = true,
    bool revoked = false,
    bool revocationChecked = true,
    bool certExpiredAtSigning = false,
  }) => PdfSignature(
    integrity: integrity,
    coversWholeFile: coversWholeFile,
    chainTrusted: chainTrusted,
    revoked: revoked,
    revocationChecked: revocationChecked,
    certExpiredAtSigning: certExpiredAtSigning,
    name: 'Jane',
    signedAt: DateTime(2024),
    chain: [cert()],
  );

  group('status', () {
    test('all three conditions met -> trusted (the only green tick)', () {
      expect(evaluator.evaluate(good()).status, SignatureStatus.trusted);
    });

    test('valid crypto but untrusted chain -> valid, not trusted', () {
      expect(
        evaluator.evaluate(good(chainTrusted: false)).status,
        SignatureStatus.validNotTrusted,
      );
    });

    test('broken crypto -> invalid', () {
      expect(
        evaluator.evaluate(good(integrity: SignatureIntegrity.invalid)).status,
        SignatureStatus.invalid,
      );
    });

    test('unreadable signature -> unknown, never invalid', () {
      // "We could not read it" must not become an accusation against a document
      // that may be perfectly fine.
      expect(
        evaluator.evaluate(good(integrity: SignatureIntegrity.unknown)).status,
        SignatureStatus.unknown,
      );
    });

    test('partial coverage can never be trusted, even with a trusted chain', () {
      // The classic PDF signature attack: sign a small file, append content.
      // The crypto still verifies, so a checker that stops there shows a green
      // tick on a document that grew after signing.
      final verdict = evaluator.evaluate(good(coversWholeFile: false));

      expect(verdict.status, isNot(SignatureStatus.trusted));
      expect(verdict.status, SignatureStatus.validNotTrusted);
      expect(verdict.hasNote(SignatureNote.partialCoverage), isTrue);
    });

    test('a revoked certificate is invalid, even with valid crypto', () {
      // Revocation is the issuer saying "do not trust this any more". That
      // outranks the maths still checking out.
      final verdict = evaluator.evaluate(good(revoked: true));

      expect(verdict.status, SignatureStatus.invalid);
      expect(verdict.hasNote(SignatureNote.revoked), isTrue);
    });

    test('revoked outranks trust even when the user trusts the chain', () {
      // `good()` already has a trusted chain, so this is the worst case: every
      // condition for a green tick is met except the revocation.
      expect(
        evaluator.evaluate(good(revoked: true)).status,
        SignatureStatus.invalid,
      );
    });
  });

  group('notes', () {
    test('a trusted signature still reports an unchecked revocation', () {
      // The tick is earned, but the caveat is not hidden behind it.
      final verdict = evaluator.evaluate(good(revocationChecked: false));

      expect(verdict.status, SignatureStatus.trusted);
      expect(verdict.hasNote(SignatureNote.revocationNotChecked), isTrue);
    });

    test('a checked, unrevoked certificate carries no revocation note', () {
      final verdict = evaluator.evaluate(good());

      expect(verdict.hasNote(SignatureNote.revocationNotChecked), isFalse);
      expect(verdict.hasNote(SignatureNote.revoked), isFalse);
    });

    test('revoked reports the revoked note, not the not-checked note', () {
      final verdict = evaluator.evaluate(good(revoked: true));

      expect(verdict.hasNote(SignatureNote.revoked), isTrue);
      expect(verdict.hasNote(SignatureNote.revocationNotChecked), isFalse);
    });

    test('expired-at-signing is reported, never silently allowed', () {
      final verdict = evaluator.evaluate(good(certExpiredAtSigning: true));

      expect(verdict.hasNote(SignatureNote.certExpiredAtSigning), isTrue);
    });

    test('a signing time from outside the signed bytes is marked a claim', () {
      // The dictionary's date is not covered by the signature, so anyone could
      // have set it. Showing it as fact would be a small, quiet lie.
      // Built by hand: `good()` always supplies a signedAt, and this case needs
      // its absence.
      final verdict = evaluator.evaluate(
        PdfSignature(
          integrity: SignatureIntegrity.valid,
          coversWholeFile: true,
          chainTrusted: true,
          revocationChecked: true,
          claimedSignedAt: DateTime(2024),
          chain: [cert()],
        ),
      );

      expect(verdict.hasNote(SignatureNote.unverifiedSigningTime), isTrue);
      expect(verdict.signature.signingTimeIsClaimOnly, isTrue);
    });

    test('a signed-attribute time is not marked a claim', () {
      // `good()` carries a signedAt, which comes from inside the signed bytes.
      expect(
        evaluator.evaluate(good()).hasNote(SignatureNote.unverifiedSigningTime),
        isFalse,
      );
    });

    test('an unreadable signature invents no notes', () {
      // With nothing parsed, every other field is meaningless; stacking guesses
      // onto "unknown" would report detail we do not have.
      final verdict = evaluator.evaluate(
        good(
          integrity: SignatureIntegrity.unknown,
          coversWholeFile: false,
          revocationChecked: false,
        ),
      );

      expect(verdict.notes, isEmpty);
    });
  });

  group('canOfferTrust', () {
    test('offered for a valid signature from an unknown signer', () {
      expect(
        evaluator.canOfferTrust(evaluator.evaluate(good(chainTrusted: false))),
        isTrue,
      );
    });

    test('never offered for a broken signature', () {
      // Otherwise one tap on "trust this certificate" would turn a tampered
      // document green.
      expect(
        evaluator.canOfferTrust(
          evaluator.evaluate(
            good(integrity: SignatureIntegrity.invalid, chainTrusted: false),
          ),
        ),
        isFalse,
      );
    });

    test('never offered when the signature covers only part of the file', () {
      expect(
        evaluator.canOfferTrust(
          evaluator.evaluate(good(coversWholeFile: false, chainTrusted: false)),
        ),
        isFalse,
      );
    });

    test('never offered for a revoked certificate', () {
      expect(
        evaluator.canOfferTrust(
          evaluator.evaluate(good(revoked: true, chainTrusted: false)),
        ),
        isFalse,
      );
    });

    test('not offered when the signer is already trusted', () {
      expect(evaluator.canOfferTrust(evaluator.evaluate(good())), isFalse);
    });

    test('not offered when the signature carries no certificate', () {
      final noCert = PdfSignature(
        integrity: SignatureIntegrity.valid,
        coversWholeFile: true,
        signedAt: DateTime(2024),
      );

      expect(evaluator.canOfferTrust(evaluator.evaluate(noCert)), isFalse);
    });
  });

  group('summaryOf', () {
    test('one broken signature drags the whole document down', () {
      // A file is only as good as its worst signature; reporting the best of
      // them would be the friendliest possible lie.
      final verdicts = evaluator.evaluateAll([
        good(),
        good(integrity: SignatureIntegrity.invalid),
      ]);

      expect(evaluator.summaryOf(verdicts), SignatureStatus.invalid);
    });

    test('unknown outranks valid-not-trusted', () {
      final verdicts = evaluator.evaluateAll([
        good(chainTrusted: false),
        good(integrity: SignatureIntegrity.unknown),
      ]);

      expect(evaluator.summaryOf(verdicts), SignatureStatus.unknown);
    });

    test('all trusted -> trusted', () {
      expect(
        evaluator.summaryOf(evaluator.evaluateAll([good(), good()])),
        SignatureStatus.trusted,
      );
    });

    test('no signatures -> unknown, not trusted', () {
      expect(evaluator.summaryOf(const []), SignatureStatus.unknown);
    });
  });
}
