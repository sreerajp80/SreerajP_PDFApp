import 'dart:async';

import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/features/nearby_transfer/domain/pairing_code.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/sync_texts.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Scans a Device sync QR code with the camera.
///
/// The camera permission is asked the first time this screen opens (by the
/// camera plugin). If the camera cannot start — permission refused, no
/// camera, or another app holds it — the screen says so and offers the app
/// settings, instead of a black box (Hard Rule 6).
class ScanCodeScreen extends StatefulWidget {
  const ScanCodeScreen({super.key});

  @override
  State<ScanCodeScreen> createState() => _ScanCodeScreenState();
}

class _ScanCodeScreenState extends State<ScanCodeScreen> {
  /// How long to wait for the camera before saying it is not available.
  /// Long enough for the first-time permission prompt to be answered.
  static const _cameraStartLimit = Duration(seconds: 30);

  bool _cameraReady = false;
  bool _cameraFailed = false;
  bool _handled = false;
  int _attempt = 0;
  Timer? _startTimer;

  @override
  void initState() {
    super.initState();
    _armStartTimer();
  }

  void _armStartTimer() {
    _startTimer?.cancel();
    _startTimer = Timer(_cameraStartLimit, () {
      if (mounted && !_cameraReady) setState(() => _cameraFailed = true);
    });
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    super.dispose();
  }

  void _onControllerCreated(CameraController? controller, Exception? error) {
    if (!mounted) return;
    if (controller == null || error != null) {
      AppLogger.warning('Device sync: camera did not start.', error: error);
      setState(() => _cameraFailed = true);
      return;
    }
    _startTimer?.cancel();
    setState(() => _cameraReady = true);
  }

  void _onScan(Code code) {
    final text = code.text;
    if (_handled || !mounted || text == null || text.isEmpty) return;
    final scanned = ScannedCode.parse(text);
    if (scanned is RejectedCode) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(rejectReasonMessage(l10n, scanned.reason))),
        );
      return;
    }
    _handled = true;
    context.pushReplacementNamed(AppRoute.receive.name, extra: scanned);
  }

  void _retry() {
    setState(() {
      _cameraFailed = false;
      _cameraReady = false;
      _attempt++;
    });
    _armStartTimer();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.titleScanCode)),
      body: SafeArea(
        top: false,
        child: _cameraFailed
            ? _CameraProblem(onRetry: _retry)
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.descScanCodeHelp,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: ReaderWidget(
                      key: ValueKey(_attempt),
                      codeFormat: Format.qrCode,
                      onScan: _onScan,
                      onControllerCreated: _onControllerCreated,
                      // Only the camera. No gallery picker, camera switch or
                      // flash buttons: they have no translated labels.
                      showGallery: false,
                      showToggleCamera: false,
                      showFlashlight: false,
                      tryInverted: true,
                      scanDelay: const Duration(milliseconds: 400),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CameraProblem extends StatelessWidget {
  const _CameraProblem({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Icon(
          Icons.no_photography_outlined,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Text(l10n.errorCameraUnavailable, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => unawaited(OpenDocumentChannel().openAppSettings()),
          child: Text(l10n.labelPermissionsOpenSettings),
        ),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: onRetry, child: Text(l10n.actionTryAgain)),
      ],
    );
  }
}
