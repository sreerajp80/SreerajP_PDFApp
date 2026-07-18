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
    required OpenDocumentChannel channel,
    required RecentFilesDao recentFilesDao,
    required ReadingPositionDao readingPositionDao,
  }) : _channel = channel,
       _recentFilesDao = recentFilesDao,
       _readingPositionDao = readingPositionDao;

  final OpenDocumentChannel _channel;
  final RecentFilesDao _recentFilesDao;
  final ReadingPositionDao _readingPositionDao;

  /// Opens the system picker. Returns the prepared document, or null if the
  /// user cancelled.
  Future<PdfDocumentRef?> openWithPicker() async {
    final opened = await _channel.pickPdf();
    if (opened == null) return null;
    return _prepare(opened);
  }

  /// Reopens a file from the recents list (re-copies from its stored URI).
  Future<PdfDocumentRef> openFromRecent(RecentFile recent) async {
    final opened = await _channel.resolveToCache(recent.uri);
    return _prepare(opened);
  }

  /// Prepares a document handed to us by an "Open with" / share intent.
  Future<PdfDocumentRef> openFromIntent(OpenedDocument opened) =>
      _prepare(opened);

  /// Fingerprints the cached file, records/refreshes the recent entry, and
  /// returns the ref the viewer opens.
  Future<PdfDocumentRef> _prepare(OpenedDocument opened) async {
    final fingerprint = await Fingerprint.ofFile(opened.cachePath);
    final existing = await _recentFilesDao.byFingerprint(fingerprint);
    await _recentFilesDao.upsert(
      RecentFile(
        fingerprint: fingerprint,
        uri: opened.uri,
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

  Future<List<RecentFile>> recents() => _recentFilesDao.list();

  Future<void> removeRecent(String fingerprint) =>
      _recentFilesDao.remove(fingerprint);

  Future<void> recordPageCount(String fingerprint, int pageCount) =>
      _recentFilesDao.setPageCount(fingerprint, pageCount);

  Future<ReadingPosition?> positionFor(String fingerprint) =>
      _readingPositionDao.byFingerprint(fingerprint);

  Future<void> savePosition({
    required String fingerprint,
    required int lastPage,
    required PdfViewMode viewMode,
  }) => _readingPositionDao.save(
    ReadingPosition(
      fingerprint: fingerprint,
      lastPage: lastPage,
      viewMode: viewMode,
      updatedAt: DateTime.now(),
    ),
  );

  /// The content that launched the app via "Open with" / share, if any. May be
  /// a PDF for the viewer, or pictures/text for the Phase 6 Import screen.
  Future<IncomingContent?> launchIntent() => _channel.initialIntent();

  /// Content shared while the app is running.
  Stream<IncomingContent> get incoming => _channel.incoming;
}
