import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/storage/fingerprint.dart';
import 'package:pdfapp/features/viewer/data/reading_position_dao.dart';
import 'package:pdfapp/features/viewer/data/recent_files_dao.dart';
import 'package:pdfapp/features/viewer/domain/pdf_document_ref.dart';
import 'package:pdfapp/features/viewer/domain/reading_position.dart';
import 'package:pdfapp/features/viewer/domain/recent_file.dart';
import 'package:pdfapp/features/viewer/domain/view_mode.dart';

/// Coordinates opening PDFs and remembering them.
///
/// It joins the native open channel, the content fingerprint, and the two DAOs
/// so the presentation layer has one simple surface: open a document (picker,
/// recents, or intent), list/remove recents, and load/save reading positions.
class PdfRepository {
  PdfRepository({
    required this.channel,
    required this.recentFilesDao,
    required this.readingPositionDao,
  });

  final OpenDocumentChannel channel;
  final RecentFilesDao recentFilesDao;
  final ReadingPositionDao readingPositionDao;

  /// Opens the system picker. Returns the prepared document, or null if the
  /// user cancelled.
  Future<PdfDocumentRef?> openWithPicker() async {
    final opened = await channel.pickPdf();
    if (opened == null) return null;
    return _prepare(opened);
  }

  /// Reopens a file from the recents list (re-copies from its stored URI).
  Future<PdfDocumentRef> openFromRecent(RecentFile recent) async {
    final opened = await channel.resolveToCache(recent.uri);
    return _prepare(opened);
  }

  /// Lets the user pick a recent file again when it can no longer be reopened
  /// (usually because short "Open with" access ended). The picker starts near
  /// the old file where Android allows it. Picking the same file refreshes the
  /// same recent entry, since entries are keyed by content. Returns null if the
  /// user cancelled.
  Future<PdfDocumentRef?> relocateRecent(RecentFile recent) async {
    final opened = await channel.pickPdf(initialUri: recent.uri);
    if (opened == null) return null;
    return _prepare(opened);
  }

  /// Prepares a document handed to us by an "Open with" / share intent.
  Future<PdfDocumentRef> openFromIntent(OpenedDocument opened) =>
      _prepare(opened);

  /// Fingerprints the cached file, records/refreshes the recent entry, and
  /// returns the ref the viewer opens.
  Future<PdfDocumentRef> _prepare(OpenedDocument opened) async {
    final fingerprint = await Fingerprint.ofFile(opened.cachePath);
    final existing = await recentFilesDao.byFingerprint(fingerprint);
    await recentFilesDao.upsert(
      RecentFile(
        fingerprint: fingerprint,
        uri: await _uriToRemember(opened, existing),
        displayName: opened.displayName,
        sizeBytes: opened.sizeBytes,
        pageCount: existing?.pageCount,
        lastOpenedAt: DateTime.now(),
      ),
    );
    return PdfDocumentRef(
      fingerprint: fingerprint,
      uri: opened.uri,
      displayName: opened.displayName,
      sizeBytes: opened.sizeBytes,
      cachePath: opened.cachePath,
      pageCount: existing?.pageCount,
    );
  }

  /// The link to store for reopening later. A short-lived "Open with" link must
  /// not replace an older link that still works after a restart.
  Future<String> _uriToRemember(
    OpenedDocument opened,
    RecentFile? existing,
  ) async {
    if (opened.hasLastingAccess ||
        existing == null ||
        existing.uri == opened.uri) {
      return opened.uri;
    }
    return await channel.hasLastingAccess(existing.uri)
        ? existing.uri
        : opened.uri;
  }

  Future<List<RecentFile>> recents() => recentFilesDao.list();

  /// Which recent files can still be reached, by fingerprint. Checks details
  /// only, never opens the files. A fingerprint missing from the map is
  /// "unknown" and should look normal.
  Future<Map<String, bool>> availabilityOf(List<RecentFile> files) async {
    if (files.isEmpty) return const {};
    final byUri = await channel.checkAvailable([for (final f in files) f.uri]);
    return {
      for (final f in files)
        if (byUri[f.uri] != null) f.fingerprint: byUri[f.uri]!,
    };
  }

  Future<void> removeRecent(String fingerprint) =>
      recentFilesDao.remove(fingerprint);

  Future<void> clearRecents() => recentFilesDao.clearAll();

  Future<void> clearReadingPositions() => readingPositionDao.clearAll();

  Future<void> recordPageCount(String fingerprint, int pageCount) =>
      recentFilesDao.setPageCount(fingerprint, pageCount);

  Future<ReadingPosition?> positionFor(String fingerprint) =>
      readingPositionDao.byFingerprint(fingerprint);

  Future<void> savePosition({
    required String fingerprint,
    required int lastPage,
    required PdfViewMode viewMode,
  }) => readingPositionDao.save(
    ReadingPosition(
      fingerprint: fingerprint,
      lastPage: lastPage,
      viewMode: viewMode,
      updatedAt: DateTime.now(),
    ),
  );

  /// The content that launched the app via "Open with" / share, if any. May be
  /// a PDF for the viewer, or pictures/text for the Phase 6 Import screen.
  Future<IncomingContent?> launchIntent() => channel.initialIntent();

  /// Content shared while the app is running.
  Stream<IncomingContent> get incoming => channel.incoming;
}
