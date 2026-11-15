import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';
import 'package:pdfapp/features/sign_document/data/saved_signature_dao.dart';
import 'package:pdfapp/features/sign_document/data/saved_signature_repository.dart';
import 'package:pdfapp/features/sign_document/data/sign_document_service.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';

/// Data-access object for the `saved_signatures` table (schema v5).
final savedSignatureDaoProvider = Provider<SavedSignatureDao>(
  (ref) => SavedSignatureDao(ref.watch(appDatabaseProvider).database),
);

/// The user's saved signature pictures (private storage + table).
final savedSignatureRepositoryProvider = Provider<SavedSignatureRepository>(
  (ref) => SavedSignatureRepository(dao: ref.watch(savedSignatureDaoProvider)),
);

/// Signs PDFs and imports signature pictures.
final signDocumentServiceProvider = Provider<SignDocumentService>(
  (ref) => SignDocumentService(
    pdfBox: ref.watch(pdfBoxChannelProvider),
    openChannel: ref.watch(openDocumentChannelProvider),
    repository: ref.watch(savedSignatureRepositoryProvider),
  ),
);

/// The "My signatures" list, newest first.
final mySignaturesProvider =
    AsyncNotifierProvider<MySignaturesNotifier, List<LoadedSignature>>(
      MySignaturesNotifier.new,
    );

class MySignaturesNotifier extends AsyncNotifier<List<LoadedSignature>> {
  @override
  Future<List<LoadedSignature>> build() =>
      ref.watch(savedSignatureRepositoryProvider).loadAll();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      ref.read(savedSignatureRepositoryProvider).loadAll,
    );
  }

  Future<void> remove(SavedSignature signature) async {
    await ref.read(savedSignatureRepositoryProvider).delete(signature);
    await refresh();
  }
}
