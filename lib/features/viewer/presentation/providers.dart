import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/features/viewer/data/pdf_repository.dart';
import 'package:pdfapp/features/viewer/data/reading_position_dao.dart';
import 'package:pdfapp/features/viewer/data/recent_files_dao.dart';
import 'package:pdfapp/features/viewer/domain/recent_file.dart';

/// Native scoped-storage open bridge.
final openDocumentChannelProvider = Provider<OpenDocumentChannel>(
  (ref) => OpenDocumentChannel(),
);

final recentFilesDaoProvider = Provider<RecentFilesDao>(
  (ref) => RecentFilesDao(ref.watch(appDatabaseProvider).database),
);

final readingPositionDaoProvider = Provider<ReadingPositionDao>(
  (ref) => ReadingPositionDao(ref.watch(appDatabaseProvider).database),
);

/// The one surface the UI uses to open PDFs and remember them.
final pdfRepositoryProvider = Provider<PdfRepository>(
  (ref) => PdfRepository(
    channel: ref.watch(openDocumentChannelProvider),
    recentFilesDao: ref.watch(recentFilesDaoProvider),
    readingPositionDao: ref.watch(readingPositionDaoProvider),
  ),
);

/// The recent-files list shown on Home. Refreshes after opening or removing.
final recentFilesProvider =
    AsyncNotifierProvider<RecentFilesNotifier, List<RecentFile>>(
      RecentFilesNotifier.new,
    );

class RecentFilesNotifier extends AsyncNotifier<List<RecentFile>> {
  @override
  Future<List<RecentFile>> build() =>
      ref.watch(pdfRepositoryProvider).recents();

  /// Reload from the database (call after a file is opened).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(ref.read(pdfRepositoryProvider).recents);
  }

  /// Remove one entry and refresh the list.
  Future<void> remove(String fingerprint) async {
    await ref.read(pdfRepositoryProvider).removeRecent(fingerprint);
    await refresh();
  }
}
