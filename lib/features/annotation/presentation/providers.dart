import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/features/annotation/data/annotation_dao.dart';
import 'package:pdfapp/features/annotation/data/annotation_repository.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';

/// Data-access object for the `annotations` table (schema v3).
final annotationDaoProvider = Provider<AnnotationDao>(
  (ref) => AnnotationDao(ref.watch(appDatabaseProvider).database),
);

/// The one surface the UI uses to store overlay marks and export them.
final annotationRepositoryProvider = Provider<AnnotationRepository>(
  (ref) => AnnotationRepository(
    dao: ref.watch(annotationDaoProvider),
    pdfBox: ref.watch(pdfBoxChannelProvider),
    openChannel: ref.watch(openDocumentChannelProvider),
  ),
);
