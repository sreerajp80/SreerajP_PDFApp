import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/storage/app_data_purge_service.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';

/// "Delete all data" (Settings → Storage).
final appDataPurgeServiceProvider = Provider<AppDataPurgeService>(
  (ref) => AppDataPurgeService(
    database: ref.watch(appDatabaseProvider),
    prefs: ref.watch(sharedPreferencesProvider),
    releaseFileAccess: ref.watch(openDocumentChannelProvider).releaseAllAccess,
  ),
);
