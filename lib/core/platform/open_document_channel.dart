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
  });

  final String uri;
  final String displayName;
  final int sizeBytes;
  final String cachePath;

  static OpenedDocument fromMap(Map<Object?, Object?> map) => OpenedDocument(
    uri: map['uri']! as String,
    displayName: map['name']! as String,
    sizeBytes: (map['size']! as num).toInt(),
    cachePath: map['path']! as String,
  );
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
  Future<OpenedDocument?> pickPdf() async {
    try {
      final result = await _method.invokeMethod<Map<Object?, Object?>>(
        'pickPdf',
      );
      if (result == null) return null;
      return OpenedDocument.fromMap(result);
    } on PlatformException catch (e) {
      throw StorageException('Could not open the file picker.', cause: e);
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

  /// The "Open with" document that launched the app, if any (consumed once).
  Future<OpenedDocument?> initialIntent() async {
    try {
      final result = await _method.invokeMethod<Map<Object?, Object?>>(
        'getInitialIntent',
      );
      if (result == null) return null;
      return OpenedDocument.fromMap(result);
    } on PlatformException catch (e) {
      AppLogger.warning('Could not read the launch intent.', error: e);
      return null;
    }
  }

  /// Documents shared to the app while it is running ("Open with" / share).
  Stream<OpenedDocument> get incoming => _events.receiveBroadcastStream().map(
    (event) => OpenedDocument.fromMap(event as Map<Object?, Object?>),
  );
}
