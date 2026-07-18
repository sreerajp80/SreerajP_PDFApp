import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/features/signature/presentation/providers.dart';
import 'package:pdfapp/features/signature/presentation/widgets/signature_card.dart';
import 'package:pdfapp/features/signature/presentation/widgets/trust_certificate_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Shows what the app can honestly say about a PDF's signatures (Phase 7).
class SignaturesScreen extends ConsumerWidget {
  const SignaturesScreen({required this.path, super.key});

  /// Cache path of the open document.
  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final verdicts = ref.watch(signatureVerdictsProvider(path));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.signaturesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.verified_user_outlined),
            tooltip: l10n.trustStoreTitle,
            onPressed: () => context.pushNamed(AppRoute.trustStore.name),
          ),
        ],
      ),
      body: verdicts.when(
        loading: () => _Centered(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16.0),
              Text(l10n.signaturesChecking),
            ],
          ),
        ),
        // A failed *check* is not a verdict on the document. The message says so
        // plainly, because "could not check" quietly reading as "bad signature"
        // would be the app accusing a document it never managed to read.
        error: (error, stack) => _Centered(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shield_outlined,
                size: 48.0,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16.0),
              Text(
                l10n.signaturesFailed,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                l10n.signaturesFailedDetail,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (list) {
          if (list.isEmpty) {
            return _Centered(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 48.0,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    l10n.signaturesNone,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          final evaluator = ref.read(signatureRepositoryProvider).evaluator;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final verdict = list[i];
              final canTrust = evaluator.canOfferTrust(verdict);
              return SignatureCard(
                verdict: verdict,
                canTrust: canTrust,
                onTrust: canTrust ? () => _trustSigner(context, ref, i) : null,
              );
            },
          );
        },
      ),
    );
  }

  /// Adds the signer's certificate to the trust store, after the user confirms.
  ///
  /// The certificate is re-read from current state rather than captured earlier,
  /// and the verdicts are recomputed from scratch afterwards — the trust rules
  /// decide the new answer, not this screen.
  Future<void> _trustSigner(BuildContext context, WidgetRef ref, int i) async {
    final verdicts = ref.read(signatureVerdictsProvider(path)).valueOrNull;
    final certificate = verdicts?[i].signature.signerCertificate;
    if (certificate == null) return;

    // Captured before any await: after one, this context may be gone and
    // reading from it is the race that bit Phase 6 (see its change log).
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showTrustCertificateDialog(
      context,
      certificate: certificate,
    );
    if (!confirmed) return;

    await ref.read(signatureRepositoryProvider).trust(certificate);
    await ref.read(signatureVerdictsProvider(path).notifier).refresh();
    ref.invalidate(trustedCertificatesProvider);

    messenger.showSnackBar(SnackBar(content: Text(l10n.signatureTrustedToast)));
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(padding: const EdgeInsets.all(32.0), child: child),
  );
}
