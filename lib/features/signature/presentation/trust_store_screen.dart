import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';
import 'package:pdfapp/features/signature/presentation/providers.dart';
import 'package:pdfapp/features/signature/presentation/widgets/trust_certificate_dialog.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Manage the certificates the user has chosen to trust (Phase 7).
///
/// This screen is the honest counterpart to the green tick: whatever makes a
/// signature trusted must be visible here, and removable. Trust the user cannot
/// inspect or withdraw is not trust — it is just a setting they cannot see.
class TrustStoreScreen extends ConsumerWidget {
  const TrustStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final certificates = ref.watch(trustedCertificatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.trustStoreTitle),
        actions: [
          certificates.maybeWhen(
            data: (list) => list.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.file_download_outlined),
                    tooltip: l10n.trustStoreExportAllAction,
                    onPressed: () => _exportAll(context, ref),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addCertificate(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.trustStoreAddAction),
      ),
      body: certificates.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              error is AppException ? error.message : l10n.trustStoreEmpty,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 48.0,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      l10n.trustStoreEmpty,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      l10n.trustStoreEmptyDetail,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return SafeArea(
            top: false,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 88.0),
              itemCount: list.length,
              itemBuilder: (context, i) => _tile(context, ref, list[i]),
            ),
          );
        },
      ),
    );
  }

  Widget _tile(BuildContext context, WidgetRef ref, CertificateInfo cert) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final expired = !cert.isValidAt(DateTime.now());

    return ListTile(
      leading: Icon(
        Icons.workspace_premium_outlined,
        color: expired ? theme.colorScheme.error : theme.colorScheme.primary,
      ),
      title: Text(cert.commonName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cert.issuerCommonName, style: theme.textTheme.bodySmall),
          if (expired)
            Text(
              l10n.trustStoreExpiredWarning,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ),
      isThreeLine: expired,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: l10n.trustStoreExportAction,
            onPressed: () => _exportOne(context, ref, cert),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.trustStoreRemoveAction,
            onPressed: () => _remove(context, ref, cert),
          ),
        ],
      ),
    );
  }

  Future<void> _exportOne(
    BuildContext context,
    WidgetRef ref,
    CertificateInfo cert,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final repo = ref.read(signatureRepositoryProvider);
      final path = await repo.exportCertificate(cert);
      final saved = await ref
          .read(openDocumentChannelProvider)
          .saveToDevice(
            path,
            '${cert.commonName}.crt',
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

  Future<void> _exportAll(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final repo = ref.read(signatureRepositoryProvider);
      final path = await repo.exportAllCertificates();
      final saved = await ref
          .read(openDocumentChannelProvider)
          .saveToDevice(
            path,
            'trusted_certificates_bundle.pem',
            mimeType: 'application/x-pem-file',
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

  Future<void> _addCertificate(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repository = ref.read(signatureRepositoryProvider);

    final picked = await ref
        .read(openDocumentChannelProvider)
        .pickCertificate();
    if (picked == null) return;

    final CertificateInfo certificate;
    try {
      certificate = await repository.readCertificateFile(picked);
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return;
    }

    if (!context.mounted) return;
    final confirmed = await showTrustCertificateDialog(
      context,
      certificate: certificate,
    );
    if (!confirmed) return;

    await repository.trust(certificate);
    await ref.read(trustedCertificatesProvider.notifier).refresh();
    messenger.showSnackBar(SnackBar(content: Text(l10n.signatureTrustedToast)));
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    CertificateInfo cert,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.trustStoreRemoveTitle),
        content: Text('${cert.commonName}\n\n${l10n.trustStoreRemoveExplain}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.trustStoreRemoveAction),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(trustedCertificatesProvider.notifier).remove(cert.sha256);
    }
  }
}
