import 'package:flutter/material.dart';
import 'package:pdfapp/core/format/display_format.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Shows what a certificate actually says (Phase 7).
///
/// Used both on the signatures screen and in the trust dialog, on purpose: the
/// user must see the *same* facts when deciding to trust a certificate as they
/// see afterwards. A trust decision made against a summary is not an informed
/// one.
class CertificateDetails extends StatelessWidget {
  const CertificateDetails({required this.certificate, super.key});

  final CertificateInfo certificate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row(context, l10n.signatureIssuedToLabel, certificate.subject),
        _row(context, l10n.signatureIssuedByLabel, certificate.issuer),
        _row(
          context,
          l10n.signatureValidFromLabel,
          DisplayFormat.dateTime(certificate.notBefore, locale),
        ),
        _row(
          context,
          l10n.signatureValidUntilLabel,
          DisplayFormat.dateTime(certificate.notAfter, locale),
        ),
        if (certificate.isSelfSigned) ...[
          const SizedBox(height: 12.0),
          // Not framed as an error: self-signed is normal and common. It only
          // means nobody else vouches for it, which is a fact the user needs to
          // weigh, not a fault to be alarmed about.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: 18.0,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  l10n.signatureSelfSignedNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2.0),
          // A distinguished name is long and full of punctuation; a monospace-ish
          // body style keeps it readable rather than turning it into a wall.
          SelectableText(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
