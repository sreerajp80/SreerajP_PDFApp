import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';

/// Service to handle sharing files using the app's native file sharing channel.
class ShareService {
  ShareService(this._openChannel);

  final OpenDocumentChannel _openChannel;

  /// Shares one or more files in [paths] via Android's native share sheet.
  ///
  /// [mimeType] is the optional type of files being shared (e.g. "image/png").
  Future<void> shareFiles(List<String> paths, {String? mimeType}) {
    return _openChannel.shareFiles(paths, mimeType: mimeType);
  }

  /// Shares a text string using Android's native share sheet.
  Future<void> shareText(String text) {
    return _openChannel.shareText(text);
  }
}

final shareServiceProvider = Provider<ShareService>(
  (ref) => ShareService(ref.watch(openDocumentChannelProvider)),
);
