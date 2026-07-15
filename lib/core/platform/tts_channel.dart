import 'package:flutter/services.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/logging/app_logger.dart';

/// Opens the system doors that can install a missing speech voice (Phase 2).
///
/// Every call answers true only if the door actually opened, so the caller can
/// try the next one and finally tell the reader the honest truth rather than
/// leaving a button that appears to do nothing.
class TtsChannel {
  TtsChannel({MethodChannel? method})
    : _method = method ?? const MethodChannel(AppConstants.channelTts);

  final MethodChannel _method;

  /// The speech engine's own "download a voice" screen.
  Future<bool> installVoiceData() => _invoke('installVoiceData');

  /// The system text-to-speech settings.
  Future<bool> openTtsSettings() => _invoke('openTtsSettings');

  /// Google's speech engine on the Play Store, for a device with no usable
  /// engine. This leaves the app — the only outward-facing step in the flow,
  /// and only ever on a deliberate tap.
  Future<bool> openPlayStore() => _invoke('openPlayStore');

  Future<bool> _invoke(String method) async {
    try {
      return await _method.invokeMethod<bool>(method) ?? false;
    } on PlatformException catch (e) {
      AppLogger.warning('Could not open $method.', error: e);
      return false;
    } on MissingPluginException {
      // Host tests / unsupported platform: the door simply is not there.
      return false;
    }
  }
}
