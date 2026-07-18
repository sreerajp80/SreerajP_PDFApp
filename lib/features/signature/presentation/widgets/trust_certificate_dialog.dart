import 'package:flutter/material.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';
import 'package:pdfapp/features/signature/presentation/widgets/certificate_details.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Asks the user to confirm trusting a certificate (Phase 7).
///
/// **This dialog is the gate.** Adding a trust anchor changes what the app will
/// later call trusted, so it may only ever happen through a deliberate, informed
/// "yes" — the certificate is shown in full first, and the consequence is spelled
/// out before the button. Nothing else in the app may write to the trust store.
///
/// Returns true when the user confirmed.
Future<bool> showTrustCertificateDialog(
  BuildContext context, {
  required CertificateInfo certificate,
}) async {
  final l10n = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.signatureTrustTitle),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CertificateDetails(certificate: certificate),
            const SizedBox(height: 16.0),
            Text(
              l10n.signatureTrustExplain,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancelAction),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.signatureTrustConfirm),
        ),
      ],
    ),
  );
  return result ?? false;
}
