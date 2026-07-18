import 'package:flutter/material.dart';
import 'package:pdfapp/core/format/display_format.dart';
import 'package:pdfapp/features/signature/domain/pdf_signature.dart';
import 'package:pdfapp/features/signature/domain/signature_status.dart';
import 'package:pdfapp/features/signature/presentation/widgets/certificate_details.dart';
import 'package:pdfapp/features/signature/presentation/widgets/signature_badge.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// One signature, told honestly (Phase 7).
///
/// The layout follows the order the user needs: the verdict first, then who and
/// when, then the caveats, then the certificate. The caveats are **not** hidden
/// behind the expander — a signature can be trusted and still carry a warning,
/// and burying that would be the quiet kind of dishonesty this phase exists to
/// avoid.
class SignatureCard extends StatelessWidget {
  const SignatureCard({
    required this.verdict,
    this.canTrust = false,
    this.onTrust,
    super.key,
  });

  final SignatureVerdict verdict;

  final bool canTrust;
  final VoidCallback? onTrust;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final signature = verdict.signature;
    final signedAt = signature.bestSignedAt;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SignatureBadge(status: verdict.status),
            const SizedBox(height: 12.0),
            Text(
              SignatureBadge.detailFor(verdict.status, l10n),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            _fact(
              context,
              l10n.signatureSignerLabel,
              signature.name?.trim().isNotEmpty == true
                  ? signature.name!
                  : (signature.signerCertificate?.commonName ??
                        l10n.signatureSignerUnknown),
            ),
            if (signedAt != null)
              _fact(
                context,
                l10n.signatureSignedAtLabel,
                DisplayFormat.dateTime(signedAt, locale),
              ),
            if (signature.reason?.trim().isNotEmpty == true)
              _fact(context, l10n.signatureReasonLabel, signature.reason!),
            if (signature.location?.trim().isNotEmpty == true)
              _fact(context, l10n.signatureLocationLabel, signature.location!),

            if (verdict.notes.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              for (final note in verdict.notes) _noteRow(context, note, l10n),
            ],

            if (signature.signerCertificate != null) ...[
              const SizedBox(height: 8.0),
              Theme(
                // The default divider lines make an ExpansionTile look like a
                // separate section; inside a card it should read as part of it.
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    l10n.signatureCertificateTitle,
                    style: theme.textTheme.titleSmall,
                  ),
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(bottom: 8.0),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CertificateDetails(
                      certificate: signature.signerCertificate!,
                    ),
                  ],
                ),
              ),
            ],

            if (canTrust && onTrust != null) ...[
              const SizedBox(height: 8.0),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FilledButton.tonalIcon(
                  onPressed: onTrust,
                  icon: const Icon(Icons.add_moderator_outlined),
                  label: Text(l10n.signatureTrustAction),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _fact(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96.0,
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }

  /// A caveat, with its own icon and words.
  ///
  /// [SignatureNote.revoked] and [SignatureNote.partialCoverage] are the two
  /// that mean the document cannot be relied on, so they are the two that get
  /// the error colour. The rest are things we could not check — worth saying,
  /// but not an accusation.
  Widget _noteRow(
    BuildContext context,
    SignatureNote note,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final serious =
        note == SignatureNote.revoked || note == SignatureNote.partialCoverage;
    final color = serious
        ? theme.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;

    final (title, detail) = switch (note) {
      SignatureNote.partialCoverage => (
        l10n.signatureNotePartialCoverage,
        l10n.signatureNotePartialCoverageDetail,
      ),
      SignatureNote.revoked => (
        l10n.signatureNoteRevoked,
        l10n.signatureNoteRevokedDetail,
      ),
      SignatureNote.revocationNotChecked => (
        l10n.signatureNoteRevocationNotChecked,
        l10n.signatureNoteRevocationNotCheckedDetail,
      ),
      SignatureNote.certExpiredAtSigning => (
        l10n.signatureNoteCertExpired,
        l10n.signatureNoteCertExpiredDetail,
      ),
      SignatureNote.unverifiedSigningTime => (
        l10n.signatureNoteUnverifiedTime,
        l10n.signatureNoteUnverifiedTimeDetail,
      ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            serious ? Icons.error_outline : Icons.info_outline,
            size: 18.0,
            color: color,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  detail,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
