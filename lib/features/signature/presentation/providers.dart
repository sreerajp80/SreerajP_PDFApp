import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/platform/signature_channel.dart';
import 'package:pdfapp/features/signature/data/eutl_trust_list.dart';
import 'package:pdfapp/features/signature/data/signature_repository.dart';
import 'package:pdfapp/features/signature/data/trust_store_dao.dart';
import 'package:pdfapp/features/signature/domain/pdf_signature.dart';
import 'package:pdfapp/features/signature/domain/trusted_certificate.dart';

/// Providers for the Phase 7 signature feature.

final signatureChannelProvider = Provider<SignatureChannel>(
  (ref) => SignatureChannel(),
);

final trustStoreDaoProvider = Provider<TrustStoreDao>(
  (ref) => TrustStoreDao(ref.watch(appDatabaseProvider).database),
);

final eutlTrustListProvider = Provider<EutlTrustList>((ref) => EutlTrustList());

final signatureRepositoryProvider = Provider<SignatureRepository>(
  (ref) => SignatureRepository(
    channel: ref.watch(signatureChannelProvider),
    trustStore: ref.watch(trustStoreDaoProvider),
    bundledList: ref.watch(eutlTrustListProvider),
  ),
);

/// Whether a document has signatures at all — drives the viewer menu entry, so
/// it is never a dead button (project rule 6).
final hasSignaturesProvider = FutureProvider.family<bool, String>(
  (ref, path) => ref.watch(signatureRepositoryProvider).hasSignatures(path),
);

/// The verdicts for one document. Re-runs when the trust store changes, which is
/// what makes a signature turn green the moment the user trusts its certificate.
final signatureVerdictsProvider =
    AsyncNotifierProvider.family<
      SignatureVerdictsNotifier,
      List<SignatureVerdict>,
      String
    >(SignatureVerdictsNotifier.new);

class SignatureVerdictsNotifier
    extends FamilyAsyncNotifier<List<SignatureVerdict>, String> {
  @override
  Future<List<SignatureVerdict>> build(String path) =>
      ref.watch(signatureRepositoryProvider).verify(path);

  /// Re-checks the document. Called after the user trusts a certificate: the
  /// facts are unchanged, but the *answer* may now be different, and it must be
  /// recomputed rather than patched by hand.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(signatureRepositoryProvider).verify(arg),
    );
  }
}

/// The certificates the user has trusted, for the manage screen.
final trustedCertificatesProvider =
    AsyncNotifierProvider<TrustedCertificatesNotifier, List<CertificateInfo>>(
      TrustedCertificatesNotifier.new,
    );

class TrustedCertificatesNotifier extends AsyncNotifier<List<CertificateInfo>> {
  @override
  Future<List<CertificateInfo>> build() =>
      ref.watch(signatureRepositoryProvider).trustedCertificates();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      ref.read(signatureRepositoryProvider).trustedCertificates,
    );
  }

  Future<void> remove(String sha256) async {
    await ref.read(signatureRepositoryProvider).untrust(sha256);
    await refresh();
  }
}
