import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/providers.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/sync_texts.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/sync_widgets.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Shows a code for the other phone to scan.
///
/// "QR only" puts the settings inside the code (no network). "WiFi" starts a
/// short local session; it ends when the screen closes, when the app goes to
/// the background, or after a few minutes.
class ShareSettingsScreen extends ConsumerStatefulWidget {
  const ShareSettingsScreen({super.key});

  @override
  ConsumerState<ShareSettingsScreen> createState() =>
      _ShareSettingsScreenState();
}

class _ShareSettingsScreenState extends ConsumerState<ShareSettingsScreen> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onHide: () => unawaited(
        ref.read(shareSettingsControllerProvider.notifier).stopForBackground(),
      ),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(shareSettingsControllerProvider);
    final controller = ref.read(shareSettingsControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.titleShareSettings)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 48),
          children: [
            SegmentedButton<ShareMode>(
              segments: [
                ButtonSegment(
                  value: ShareMode.qrOnly,
                  icon: const Icon(Icons.qr_code_2_outlined),
                  label: Text(l10n.labelSyncModeQr),
                ),
                ButtonSegment(
                  value: ShareMode.wifi,
                  icon: const Icon(Icons.wifi),
                  label: Text(l10n.labelSyncModeWifi),
                ),
              ],
              selected: {state.mode},
              onSelectionChanged: (s) => unawaited(controller.select(s.first)),
            ),
            const SizedBox(height: 12),
            Text(
              state.mode == ShareMode.qrOnly
                  ? l10n.descSyncModeQrHelp
                  : l10n.descSyncModeWifiHelp,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            _body(context, l10n, state, controller),
          ],
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    AppLocalizations l10n,
    ShareState state,
    ShareSettingsController controller,
  ) {
    Widget again() => FilledButton.tonal(
      onPressed: () => unawaited(controller.select(ShareMode.wifi)),
      child: Text(l10n.actionTryAgain),
    );
    return switch (state) {
      SharePreparing() => const Center(child: CircularProgressIndicator()),
      ShareShowingCode(:final qrText, :final expiresAt) => PairingCodeView(
        key: ValueKey(qrText),
        qrText: qrText,
        expiresAt: expiresAt,
      ),
      ShareNoNetwork() => SyncMessage(
        icon: Icons.wifi_off_outlined,
        text: l10n.errorNoLanAddress,
        action: again(),
      ),
      ShareGuestConnected(:final address) => SyncMessage(
        icon: Icons.phonelink_outlined,
        text: l10n.descWifiGuestConnected(address),
        busy: true,
      ),
      ShareFinished(:final accepted) => SyncMessage(
        icon: accepted ? Icons.check_circle_outline : Icons.cancel_outlined,
        text: accepted
            ? l10n.descWifiShareAccepted
            : l10n.descWifiShareDeclined,
      ),
      ShareFailed(:final reason) => SyncMessage(
        icon: Icons.error_outline,
        text: transferFailureMessage(l10n, reason),
        action: again(),
      ),
      ShareStopped() => SyncMessage(
        icon: Icons.pause_circle_outline,
        text: l10n.descWifiSessionEnded,
        action: again(),
      ),
    };
  }
}
