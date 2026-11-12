import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PairingCodeView extends StatefulWidget {
  const PairingCodeView({
    required this.qrText,
    this.expiresAt,
    this.prompt,
    super.key,
  });

  final String qrText;
  final DateTime? expiresAt;

  /// The instruction under the code. Defaults to the settings prompt.
  final String? prompt;

  @override
  State<PairingCodeView> createState() => _PairingCodeViewState();
}

class _PairingCodeViewState extends State<PairingCodeView> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Redraws the "works for m:ss" countdown, for a WiFi code only.
    if (widget.expiresAt != null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final until = widget.expiresAt;
    String? remaining;
    if (until != null) {
      final left = until.difference(DateTime.now());
      final seconds = left.isNegative ? 0 : left.inSeconds;
      remaining =
          '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
    }
    return Column(
      children: [
        Semantics(
          label: (widget.prompt ?? l10n.descShowCodeScanPrompt),
          image: true,
          child: Container(
            // A white quiet zone keeps the code readable in dark themes.
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: QrImageView(data: widget.qrText, size: 260),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          (widget.prompt ?? l10n.descShowCodeScanPrompt),
          textAlign: TextAlign.center,
        ),
        if (remaining != null) ...[
          const SizedBox(height: 8),
          Text(
            l10n.descWifiCodeExpires(remaining),
            style: TextStyle(color: muted),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class SyncMessage extends StatelessWidget {
  const SyncMessage({
    super.key,
    required this.icon,
    required this.text,
    this.action,
    this.busy = false,
  });

  final IconData icon;
  final String text;
  final Widget? action;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(text, textAlign: TextAlign.center),
        if (busy) ...[
          const SizedBox(height: 16),
          const LinearProgressIndicator(),
        ],
        if (action != null) ...[const SizedBox(height: 16), action!],
      ],
    );
  }
}
