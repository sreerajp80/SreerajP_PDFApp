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
}
