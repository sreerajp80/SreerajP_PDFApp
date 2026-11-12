import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/storage/fingerprint.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_guest.dart';
import 'package:pdfapp/features/nearby_transfer/domain/send_item.dart';
import 'package:pdfapp/features/nearby_transfer/domain/transfer_offer.dart';
import 'package:pdfapp/features/viewer/data/recent_files_dao.dart';
import 'package:pdfapp/features/viewer/domain/recent_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers the folder received PDFs go into (plan §3.5, "remember the
/// folder"). The app keeps lasting access to that one folder only: choosing a
/// new folder gives back access to the old one.
class ReceiveFolderService {
  const ReceiveFolderService(this._prefs, this._channel);

  final SharedPreferences _prefs;
  final OpenDocumentChannel _channel;

  /// The remembered folder, checked to still be reachable.
  ///
  /// Returns `(folder: null, lost: false)` when none was chosen yet, and
  /// `(folder: null, lost: true)` when one was chosen but can no longer be
  /// used (deleted, SD card removed, or access taken away).
  Future<({ReceiveFolder? folder, bool lost})> current() async {
    final uri = _prefs.getString(AppConstants.prefReceiveFolderUri);
    if (uri == null) return (folder: null, lost: false);
    final name = await _channel.folderName(uri);
    if (name == null) return (folder: null, lost: true);
    return (folder: ReceiveFolder(uri: uri, name: name), lost: false);
  }

  /// Opens the system folder picker. Returns the new folder, or null when the
  /// user cancelled (the old folder then stays).
  Future<ReceiveFolder?> choose() async {
    final picked = await _channel.pickFolder();
    if (picked == null) return null;
    final old = _prefs.getString(AppConstants.prefReceiveFolderUri);
    if (old != null && old != picked.uri) await _channel.releaseFolder(old);
    await _prefs.setString(AppConstants.prefReceiveFolderUri, picked.uri);
    return ReceiveFolder(uri: picked.uri, name: picked.name);
  }
}

/// A PDF ready to offer: what goes on the wire, and the local copy to read.
typedef PreparedFile = ({OfferedFile offered, String path});

/// Prepares the user's chosen PDFs for sending: a readable cache copy, its
/// exact size and its SHA-256.
class OutgoingFilesService {
  const OutgoingFilesService(this._channel);

  final OpenDocumentChannel _channel;

  /// Prepares each item. Items that cannot be read (file moved or access
  /// lost) are returned by name in `skipped`, so the user is told, instead of
  /// failing the whole send. [onProgress] gets (done, total).
  Future<({List<PreparedFile> ready, List<String> skipped})> prepare(
    List<SendItem> items, {
    void Function(int done, int total)? onProgress,
  }) async {
    final ready = <PreparedFile>[];
    final skipped = <String>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      try {
        final path =
            item.cachePath ??
            (await _channel.resolveToCache(item.uri!)).cachePath;
        // "<size>:<sha256 hex>", computed off the UI isolate.
        final fingerprint = await Fingerprint.ofFile(path);
        final split = fingerprint.indexOf(':');
        final size = int.parse(fingerprint.substring(0, split));
        if (size > FileOffer.maxFileBytes) {
          skipped.add(item.name);
        } else {
          ready.add((
            offered: OfferedFile(
              name: item.name,
              sizeBytes: size,
              sha256: fingerprint.substring(split + 1),
            ),
            path: path,
          ));
        }
      } on AppException catch (e) {
        AppLogger.warning(
          'Device sync: a file could not be prepared.',
          error: e,
        );
        skipped.add(item.name);
      }
      onProgress?.call(i + 1, items.length);
    }
    return (ready: ready, skipped: skipped);
  }
}

/// Saves received PDFs from the private cache into the chosen folder, adds
/// them to Recents, and removes the cache copies.
class ReceivedFilesStore {
  const ReceivedFilesStore(this._channel, this._recents, this._prefs);

  final OpenDocumentChannel _channel;
  final RecentFilesDao _recents;
  final SharedPreferences _prefs;

  /// A new, empty private cache folder for one receive session. It lives in
  /// the 'received' working folder, which startup cleanup empties.
  static Future<Directory> newCacheFolder() async {
    final root = await getTemporaryDirectory();
    return Directory(
      p.join(
        root.path,
        'received',
        DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    );
  }

  /// Returns the names that were saved and the names that were not.
  Future<({List<String> saved, List<String> failed})> save(
    ReceiveFolder folder,
    List<ReceivedFile> files,
  ) async {
    final good = files.where((f) => f.ok).toList();
    final failed = [
      for (final f in files)
        if (!f.ok) safePdfFileName(f.offered.name),
    ];
    final saved = <String>[];
    if (good.isNotEmpty) {
      final results = await _channel.saveFilesToFolder(folder.uri, [
        for (final f in good)
          (path: f.path, name: safePdfFileName(f.offered.name)),
      ]);
      final remember =
          _prefs.getBool(AppConstants.prefRememberRecentFiles) ?? true;
      for (var i = 0; i < good.length; i++) {
        final r = i < results.length ? results[i] : null;
        final f = good[i];
        if (r == null || r.uri == null) {
          failed.add(safePdfFileName(f.offered.name));
          continue;
        }
        saved.add(r.name);
        if (remember) {
          await _recents.upsert(
            RecentFile(
              fingerprint: '${f.offered.sizeBytes}:${f.offered.sha256}',
              uri: r.uri!,
              displayName: r.name,
              sizeBytes: f.offered.sizeBytes,
              lastOpenedAt: DateTime.now(),
            ),
          );
        }
      }
    }
    for (final f in files) {
      try {
        final file = File(f.path);
        if (file.existsSync()) await file.delete();
      } on FileSystemException {
        // Startup cleanup removes leftovers from the 'received' cache folder.
      }
    }
    return (saved: saved, failed: failed);
  }
}
