import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/signature/domain/pdf_signature.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';
import 'package:pdfapp/features/signature/presentation/providers.dart';
import 'package:pdfapp/features/signature/presentation/widgets/certificate_details.dart';
import 'package:pdfapp/features/signature/presentation/widgets/signature_badge.dart';
import 'package:pdfapp/features/signature/presentation/widgets/trust_certificate_dialog.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Shows detailed inspection of a tapped visual digital signature stamp (Feature 3.6).
void showSignatureDetailSheet(
  BuildContext context, {
  required SignatureVerdict verdict,
  String? documentPath,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) =>
        SignatureDetailSheet(verdict: verdict, documentPath: documentPath),
  );
}

class SignatureDetailSheet extends ConsumerWidget {
  const SignatureDetailSheet({
    super.key,
    required this.verdict,
    this.documentPath,
  });

  final SignatureVerdict verdict;
  final String? documentPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final sig = verdict.signature;
    final cert = sig.signerCertificate;

    final repo = ref.read(signatureRepositoryProvider);
    final canTrust = repo.evaluator.canOfferTrust(verdict);

    final isTrusted = verdict.isTrusted;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sig.name ?? l10n.signatureUnnamed,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        SignatureBadge(status: verdict.status),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24),
              if (sig.reason != null)
                _infoRow(context, l10n.signatureReasonLabel, sig.reason!),
              if (sig.location != null)
                _infoRow(context, l10n.signatureLocationLabel, sig.location!),
              if (sig.bestSignedAt != null)
                _infoRow(
                  context,
                  l10n.signatureTimeLabel,
                  sig.signingTimeIsClaimOnly
                      ? '${_formatDate(sig.bestSignedAt!)} (${l10n.signatureTimeClaimOnly})'
                      : _formatDate(sig.bestSignedAt!),
                ),
              _infoRow(
                context,
                l10n.signatureIntegrityLabel,
                switch (sig.integrity) {
                  SignatureIntegrity.valid => l10n.signatureIntegrityValid,
                  SignatureIntegrity.invalid => l10n.signatureIntegrityInvalid,
                  SignatureIntegrity.unknown => l10n.signatureIntegrityUnknown,
                },
              ),
              _infoRow(
                context,
                l10n.signatureCoverageLabel,
                sig.coversWholeFile
                    ? l10n.signatureCoversWholeFile
                    : l10n.signatureCoversPartialFile,
              ),
              const SizedBox(height: 12),
              if (cert != null) ...[
                Text(
                  l10n.signatureCertificateHeader,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CertificateDetails(certificate: cert),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  if (cert != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(
                          Icons.file_download_outlined,
                          size: 18,
                        ),
                        label: Text(l10n.trustStoreExportAction),
                        onPressed: () => _exportCertificate(context, ref, cert),
                      ),
                    ),
                  if (canTrust && cert != null && !isTrusted) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.verified_user, size: 18),
                        label: Text(l10n.signatureTrustSignerAction),
                        onPressed: () => _trustSigner(context, ref, cert),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _exportCertificate(
    BuildContext context,
    WidgetRef ref,
    CertificateInfo certificate,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final repo = ref.read(signatureRepositoryProvider);
      final exportedPath = await repo.exportCertificate(certificate);
      final saved = await ref
          .read(openDocumentChannelProvider)
          .saveToDevice(
            exportedPath,
            '${certificate.commonName}.crt',
            mimeType: 'application/x-x509-ca-cert',
          );
      if (saved != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.trustStoreExportSuccess(saved))),
        );
      }
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _trustSigner(
    BuildContext context,
    WidgetRef ref,
    CertificateInfo certificate,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showTrustCertificateDialog(
      context,
      certificate: certificate,
    );
    if (!confirmed) return;

    await ref.read(signatureRepositoryProvider).trust(certificate);
    if (documentPath != null) {
      await ref
          .read(signatureVerdictsProvider(documentPath!).notifier)
          .refresh();
    }
    ref.invalidate(trustedCertificatesProvider);

    messenger.showSnackBar(SnackBar(content: Text(l10n.signatureTrustedToast)));
    if (context.mounted) {
      Navigator.of(context).pop(); // close sheet after trusting
    }
  }
}
