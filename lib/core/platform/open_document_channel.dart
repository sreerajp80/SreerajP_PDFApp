import 'package:flutter/services.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/logging/app_logger.dart';

/// A PDF that native code has copied into the app cache and made ready to open.
///
/// [uri] is the durable identity (persistable `content://` URI) used to reopen
/// from recents. [cachePath] is a throwaway copy pdfium can read; it may be
/// deleted by the OS, so never store it as identity.
class OpenedDocument {
  const OpenedDocument({
    required this.uri,
    required this.displayName,
    required this.sizeBytes,
    required this.cachePath,
    this.hasLastingAccess = false,
  });

  final String uri;
  final String displayName;
  final int sizeBytes;
  final String cachePath;

  /// True when the app can still read [uri] after it restarts. Files picked
  /// with "Open PDF" have it; most "Open with" files do not.
  final bool hasLastingAccess;

  static OpenedDocument fromMap(Map<Object?, Object?> map) => OpenedDocument(
    uri: map['uri']! as String,
    displayName: map['name']! as String,
    sizeBytes: (map['size']! as num).toInt(),
    cachePath: map['path']! as String,
    hasLastingAccess: map['persisted'] as bool? ?? false,
  );
}

/// Something another app sent us through "Open with" or share.
///
/// A PDF goes to the viewer. Pictures and text go to the Phase 6 import screen, which turns
/// them into a new PDF. The `kind` tag on the native payload decides which.
sealed class IncomingContent {
  const IncomingContent();

  /// Reads a native intent payload. Returns null for a shape we do not know — a strange
  /// share must be ignored, never crash the app.
  static IncomingContent? fromMap(Map<Object?, Object?> map) {
    // Payloads written before Phase 6 carry no kind; they were always PDFs.
    final kind = map['kind'] as String? ?? 'pdf';
    try {
      switch (kind) {
        case 'pdf':
          return IncomingPdf(OpenedDocument.fromMap(map));
        case 'images':
          final paths = (map['paths']! as List<Object?>).cast<String>();
          if (paths.isEmpty) return null;
          return IncomingImages(
            paths: paths,
            suggestedName: map['name'] as String? ?? 'images',
          );
        case 'text':
          final text = map['text']! as String;
          if (text.trim().isEmpty) return null;
          return IncomingText(
            text: text,
            suggestedName: map['name'] as String? ?? 'text',
          );
        default:
          return null;
      }
    } catch (e) {
      AppLogger.warning('Ignored a share we could not read.', error: e);
      return null;
    }
  }
}

/// A PDF to open in the viewer.
class IncomingPdf extends IncomingContent {
  const IncomingPdf(this.document);

  final OpenedDocument document;
}

/// One or more pictures to turn into a PDF. [paths] are cache copies.
class IncomingImages extends IncomingContent {
  const IncomingImages({required this.paths, required this.suggestedName});

  final List<String> paths;
  final String suggestedName;
}

/// Text to turn into a PDF.
class IncomingText extends IncomingContent {
  const IncomingText({required this.text, required this.suggestedName});

  final String text;
  final String suggestedName;
}

/// Dart side of the scoped-storage open bridge (Phase 1).
///
/// Wraps the native SAF picker, the reopen-from-recents copy, and the stream of
/// incoming "Open with" / share documents. All storage access goes through here
/// — the app never browses the file system itself.
class OpenDocumentChannel {
  OpenDocumentChannel({MethodChannel? method, EventChannel? events})
    : _method = method ?? const MethodChannel(AppConstants.channelOpenDocument),
      _events = events ?? const EventChannel(AppConstants.eventOpenDocument);

  final MethodChannel _method;
  final EventChannel _events;

  /// Opens the system picker. Returns the chosen PDF, or null if the user
  /// cancelled. Throws [StorageException] on a platform failure.
  ///
  /// [initialUri] is a hint to start in that file's folder (used to find a
  /// recent file again). The picker may ignore it.
  Future<OpenedDocument?> pickPdf({String? initialUri}) async {
    try {
      final result = await _method.invokeMethod<Map<Object?, Object?>>(
        'pickPdf',
        {'initialUri': initialUri},
      );
      if (result == null) return null;
      return OpenedDocument.fromMap(result);
    } on PlatformException catch (e) {
      throw StorageException('Could not open the file picker.', cause: e);
    }
  }

  /// Opens the system picker in multi-select mode (for merge). Returns the chosen
  /// PDFs, or an empty list if the user cancelled.
  Future<List<OpenedDocument>> pickPdfs() async {
    try {
      final result = await _method.invokeListMethod<Object?>('pickPdfs');
      if (result == null) return const [];
      return result
          .map((item) => OpenedDocument.fromMap(item as Map<Object?, Object?>))
          .toList();
    } on PlatformException catch (e) {
      throw StorageException('Could not open the file picker.', cause: e);
    }
  }

  /// Opens the system picker for a certificate file (Phase 7). Returns the cache
  /// path of the picked file, or null if the user cancelled.
  ///
  /// Unlike [pickPdf] this takes no persistable URI permission: the certificate
  /// is read once, parsed, and stored in the trust store as bytes. There is
  /// nothing to reopen later, so asking for lasting access to the user's file
  /// would be access we do not need.
  Future<String?> pickCertificate() async {
    try {
      return await _method.invokeMethod<String>('pickCertificate');
    } on PlatformException catch (e) {
      throw StorageException('Could not open the file picker.', cause: e);
    }
  }

  /// Saves the cache file at [sourcePath] to a user-chosen location through the
  /// Android "create document" dialog. Returns the saved file name, or null if
  /// the user cancelled.
  Future<String?> saveToDevice(
    String sourcePath,
    String suggestedName, {
    String mimeType = 'application/pdf',
  }) async {
    try {
      return await _method.invokeMethod<String>('saveToDevice', {
        'sourcePath': sourcePath,
        'suggestedName': suggestedName,
        'mimeType': mimeType,
      });
    } on PlatformException catch (e) {
      throw StorageException('Could not save the file.', cause: e);
    }
  }

  /// Re-copies a previously opened [uri] (from recents) into a fresh cache file.
  /// Throws [StorageException] if the file is gone or access was revoked.
  Future<OpenedDocument> resolveToCache(String uri) async {
    try {
      final result = await _method.invokeMethod<Map<Object?, Object?>>(
        'resolveToCache',
        {'uri': uri},
      );
      if (result == null) {
        throw const StorageException('The file could not be reopened.');
      }
      return OpenedDocument.fromMap(result);
    } on PlatformException catch (e) {
      throw StorageException('This file could not be reopened.', cause: e);
    }
  }

  /// Whether the app still holds read access to [uri] that survives a restart.
  /// Returns false on any platform failure.
  Future<bool> hasLastingAccess(String uri) async {
    try {
      return await _method.invokeMethod<bool>('hasLastingAccess', {
            'uri': uri,
          }) ??
          false;
    } on PlatformException catch (e) {
      AppLogger.warning('Could not check file access.', error: e);
      return false;
    }
  }

  /// Checks, without opening them, whether the stored [uris] can still be
  /// reached. Returns URI -> reachable. A URI missing from the map is
  /// "unknown"; on any platform failure the map is empty (never a crash and
  /// never a wrong "unavailable" mark).
  Future<Map<String, bool>> checkAvailable(List<String> uris) async {
    if (uris.isEmpty) return const {};
    try {
      final result = await _method.invokeMapMethod<String, bool>(
        'checkAvailable',
        {'uris': uris},
      );
      return result ?? const {};
    } on PlatformException catch (e) {
      AppLogger.warning('Could not check recent files.', error: e);
      return const {};
    } on MissingPluginException catch (e) {
      AppLogger.warning('Recent file check not available.', error: e);
      return const {};
    }
  }

  /// Gives back every lasting file permission the app holds, so no file stays
  /// reachable after "Delete all data". A failure is logged, not thrown: the
  /// rest of the purge must still run.
  Future<void> releaseAllAccess() async {
    try {
      await _method.invokeMethod<int>('releaseAllAccess');
    } on PlatformException catch (e) {
      AppLogger.warning('Could not release file access.', error: e);
    } on MissingPluginException catch (e) {
      AppLogger.warning('File access release not available.', error: e);
    }
  }

  // --- Device sync: the folder received PDFs are saved into ---

  /// Opens the system folder picker and keeps lasting read + write access to
  /// the chosen folder. Returns `(uri, name)`, or null if the user cancelled.
  Future<({String uri, String name})?> pickFolder() async {
    try {
      final result = await _method.invokeMethod<Map<Object?, Object?>>(
        'pickFolder',
      );
      if (result == null) return null;
      return (
        uri: result['uri']! as String,
        name: result['name'] as String? ?? '',
      );
    } on PlatformException catch (e) {
      throw StorageException('Could not open the folder picker.', cause: e);
    }
  }

  /// The display name of a remembered folder, or null when the app no longer
  /// has access to it or it is gone. Never throws.
  Future<String?> folderName(String uri) async {
    try {
      return await _method.invokeMethod<String>('folderStatus', {'uri': uri});
    } on PlatformException catch (e) {
      AppLogger.warning('Could not check the receive folder.', error: e);
      return null;
    }
  }

  /// Gives back lasting access to a folder. Never throws.
  Future<void> releaseFolder(String uri) async {
    try {
      await _method.invokeMethod<void>('releaseFolder', {'uri': uri});
    } on PlatformException catch (e) {
      AppLogger.warning('Could not release the receive folder.', error: e);
    }
  }

  /// Copies each cache file into the folder [treeUri] as a new PDF. Returns
  /// one result per file, in order: the saved name and its document URI, or
  /// `uri == null` when that file could not be saved.
  Future<List<({String name, String? uri})>> saveFilesToFolder(
    String treeUri,
    List<({String path, String name})> files,
  ) async {
    try {
      final result = await _method.invokeListMethod<Object?>(
        'saveFilesToFolder',
        {
          'uri': treeUri,
          'files': [
            for (final f in files) {'path': f.path, 'name': f.name},
          ],
        },
      );
      return [
        for (final item
            in (result ?? const <Object?>[]).whereType<Map<Object?, Object?>>())
          (name: item['name'] as String? ?? '', uri: item['uri'] as String?),
      ];
    } on PlatformException catch (e) {
      throw StorageException('Could not save into the folder.', cause: e);
    }
  }

  /// The content that launched the app via "Open with" / share, if any (consumed once).
  Future<IncomingContent?> initialIntent() async {
    try {
      final result = await _method.invokeMethod<Map<Object?, Object?>>(
        'getInitialIntent',
      );
      if (result == null) return null;
      return IncomingContent.fromMap(result);
    } on PlatformException catch (e) {
      AppLogger.warning('Could not read the launch intent.', error: e);
      return null;
    }
  }

  /// Content shared to the app while it is running ("Open with" / share).
  /// Shares we cannot make sense of are dropped rather than surfaced.
  Stream<IncomingContent> get incoming => _events
      .receiveBroadcastStream()
      .map((event) => IncomingContent.fromMap(event as Map<Object?, Object?>))
      .where((content) => content != null)
      .cast<IncomingContent>();

  /// Shares one or more files in [paths] via Android's native share sheet.
  /// [mimeType] is the type of content being shared (e.g. "image/png", "text/plain").
  Future<void> shareFiles(List<String> paths, {String? mimeType}) async {
    try {
      await _method.invokeMethod<void>('shareFiles', {
        'paths': paths,
        'mimeType': mimeType,
      });
    } on PlatformException catch (e) {
      throw StorageException('Could not share files.', cause: e);
    }
  }

  /// Shares a text string using Android's native share sheet.
  Future<void> shareText(String text) async {
    try {
      await _method.invokeMethod<void>('shareText', {'text': text});
    } on PlatformException catch (e) {
      throw StorageException('Could not share text.', cause: e);
    }
  }

  /// Opens the system application details settings page for the app.
  Future<void> openAppSettings() async {
    try {
      await _method.invokeMethod<void>('openAppSettings');
    } on PlatformException catch (e) {
      AppLogger.warning('Could not open app settings.', error: e);
    }
  }

  /// Opens the system printing settings page on Android.
  Future<void> openPrintSettings() async {
    try {
      await _method.invokeMethod<void>('openPrintSettings');
    } on PlatformException catch (e) {
      AppLogger.warning('Could not open print settings.', error: e);
    }
  }
}
