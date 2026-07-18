/// An X.509 certificate — either one carried by a signature, or one the user has
/// added to the trust store (Phase 7).
///
/// Certificates are public material. Nothing secret lives here, so this is safe
/// to log or show; the security rules bite on *private* key material, which the
/// app never handles at all (it verifies signatures, it never makes them).
class CertificateInfo {
  const CertificateInfo({
    required this.sha256,
    required this.subject,
    required this.issuer,
    required this.serial,
    required this.notBefore,
    required this.notAfter,
    required this.der,
  });

  /// SHA-256 of the DER bytes. The certificate's identity, and the trust-store
  /// primary key — so trusting the same certificate twice is a no-op.
  final String sha256;

  /// Distinguished name of the holder, e.g. `CN=Jane Doe, O=Example Ltd, C=IN`.
  final String subject;

  /// Distinguished name of whoever issued it. Equal to [subject] when
  /// self-signed.
  final String issuer;
  final String serial;
  final DateTime notBefore;
  final DateTime notAfter;

  /// The full certificate, base64-encoded DER. Kept whole because the native
  /// verifier needs the real bytes — a summary cannot be verified against.
  final String der;

  /// True when self-signed (issued to itself).
  ///
  /// Not a fault: it means nobody else vouches for it, so it is trustworthy only
  /// if the user recognises it. The UI says so rather than implying it is fake.
  bool get isSelfSigned => subject == issuer;

  /// The `CN=` part if there is one, otherwise the whole [subject].
  /// A full DN is unreadable in a list; the common name is what people know.
  String get commonName => _commonNameOf(subject) ?? subject;

  /// The issuer's `CN=` part if there is one, otherwise the whole [issuer].
  String get issuerCommonName => _commonNameOf(issuer) ?? issuer;

  static String? _commonNameOf(String dn) {
    // DN parts are comma-separated, but a value may contain an escaped comma
    // (`\,`), so a plain split would cut a name in half.
    final match = RegExp(r'CN=((?:\\,|[^,])*)').firstMatch(dn);
    final value = match?.group(1)?.replaceAll(r'\,', ',').trim();
    return (value == null || value.isEmpty) ? null : value;
  }

  bool isValidAt(DateTime when) =>
      !when.isBefore(notBefore) && !when.isAfter(notAfter);

  static CertificateInfo fromMap(Map<Object?, Object?> map) => CertificateInfo(
    sha256: map['sha256'] as String? ?? '',
    subject: map['subject'] as String? ?? '',
    issuer: map['issuer'] as String? ?? '',
    serial: map['serial'] as String? ?? '',
    notBefore: DateTime.fromMillisecondsSinceEpoch(
      (map['notBefore'] as num?)?.toInt() ?? 0,
    ),
    notAfter: DateTime.fromMillisecondsSinceEpoch(
      (map['notAfter'] as num?)?.toInt() ?? 0,
    ),
    der: map['der'] as String? ?? '',
  );

  /// A certificate the user has trusted, as stored in the `trust_store` table.
  static CertificateInfo fromRow(Map<String, Object?> row) => CertificateInfo(
    sha256: row['sha256'] as String,
    subject: row['subject'] as String,
    issuer: row['issuer'] as String,
    serial: row['serial'] as String,
    notBefore: DateTime.fromMillisecondsSinceEpoch(row['not_before'] as int),
    notAfter: DateTime.fromMillisecondsSinceEpoch(row['not_after'] as int),
    der: row['der'] as String,
  );

  Map<String, Object?> toRow({required DateTime addedAt}) => {
    'sha256': sha256,
    'subject': subject,
    'issuer': issuer,
    'serial': serial,
    'not_before': notBefore.millisecondsSinceEpoch,
    'not_after': notAfter.millisecondsSinceEpoch,
    'der': der,
    'added_at': addedAt.millisecondsSinceEpoch,
  };
}
