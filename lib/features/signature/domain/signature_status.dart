/// What the app is willing to say about a signature (Phase 7).
///
/// Only four answers are possible, and they are deliberately blunt. The guiding
/// rule from `docs/security-rules.md` is **never fake trust**: a green tick that
/// was not earned is worse than an honest question mark, because the user will
/// believe it.
enum SignatureStatus {
  /// The cryptography checks out, the signature covers the whole file, and the
  /// certificate chain reaches something the user trusts. Only this shows green.
  trusted,

  /// The cryptography checks out, but we do not know the signer. The document is
  /// intact; we simply cannot vouch for who signed it. Neutral, not green.
  validNotTrusted,

  /// The signature does not verify — the bytes changed after signing, or the
  /// signature is not what it claims to be. Red.
  invalid,

  /// We could not read or make sense of the signature. Grey. This is not a
  /// failure of the document and not a pass either; it is "we don't know".
  unknown,
}

/// A caveat carried alongside a [SignatureStatus].
///
/// These exist because a signature is rarely simply good or bad: it can verify
/// perfectly and still deserve a warning. Keeping them separate from the status
/// means the UI can show a truthful headline *and* the fine print, instead of
/// flattening the two into one misleading answer.
enum SignatureNote {
  /// The signature covers only part of the file — content was added after
  /// signing, and the signature says nothing about it. This is a real attack,
  /// so a signature with this note can never be [SignatureStatus.trusted].
  partialCoverage,

  /// The signing certificate was outside its validity dates when it signed.
  certExpiredAtSigning,

  /// We could not check whether the certificate had been cancelled (revoked).
  /// Checking normally needs the internet, which this app never uses; the PDF
  /// carried no embedded proof either. Reported, never silently ignored.
  revocationNotChecked,

  /// The certificate was cancelled (revoked) by whoever issued it.
  revoked,

  /// The signing time comes from the document dictionary, which sits outside the
  /// signed bytes and could have been edited by anyone. Treat it as a claim.
  unverifiedSigningTime,
}
