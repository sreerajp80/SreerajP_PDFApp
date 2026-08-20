import 'package:flutter/services.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/logging/app_logger.dart';

/// Opens the system doors that can install a missing speech voice and interacts
/// with native background notification player controls.
class TtsChannel {
  TtsChannel({MethodChannel? method})
    : _method = method ?? const MethodChannel(AppConstants.channelTts) {
    _method.setMethodCallHandler(_handleNativeCall);
  }

  final MethodChannel _method;
  void Function(String action)? onActionReceived;

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    if (call.method == 'onNotificationAction') {
      final args = call.arguments as Map<dynamic, dynamic>?;
      final action = args?['action'] as String?;
      if (action != null) {
        onActionReceived?.call(action);
      }
    }
  }

  /// The speech engine's own "download a voice" screen.
  Future<bool> installVoiceData() => _invoke('installVoiceData');

  /// The system text-to-speech settings.
  Future<bool> openTtsSettings() => _invoke('openTtsSettings');

  /// Google's speech engine on the Play Store, for a device with no usable engine.
  Future<bool> openPlayStore() => _invoke('openPlayStore');

  /// Displays persistent background notification with media playback controls.
  Future<bool> showNotification({
    required String title,
    required String content,
    required bool isPlaying,
  }) async {
    try {
      return await _method.invokeMethod<bool>('showNotification', {
            'title': title,
            'content': content,
            'isPlaying': isPlaying,
          }) ??
          false;
    } on PlatformException catch (e) {
      AppLogger.warning('Could not show TTS notification.', error: e);
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  /// Cancels any active TTS notification.
  Future<bool> cancelNotification() async {
    try {
      return await _method.invokeMethod<bool>('cancelNotification') ?? false;
    } on PlatformException catch (e) {
      AppLogger.warning('Could not cancel TTS notification.', error: e);
      return false;
    } on MissingPluginException {
      return false;
    }
  }

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
