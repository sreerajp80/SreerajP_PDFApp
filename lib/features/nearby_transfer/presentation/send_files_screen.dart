import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/format/display_format.dart';
import 'package:pdfapp/features/nearby_transfer/domain/send_item.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/providers.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/sync_texts.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/sync_widgets.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Sends one or more PDFs to a nearby phone over the local WiFi.
///
/// Shows a code for the other phone to scan, then the progress. Like the
/// settings session, it ends when the screen closes, when the app goes to the
/// background, or after a few minutes with nobody connecting.
class SendFilesScreen extends ConsumerStatefulWidget {
  const SendFilesScreen({required this.items, super.key});

  final List<SendItem> items;

  @override
  ConsumerState<SendFilesScreen> createState() => _SendFilesScreenState();
}

class _SendFilesScreenState extends ConsumerState<SendFilesScreen> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onHide: () => unawaited(
        ref.read(sendFilesControllerProvider.notifier).stopForBackground(),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(
        ref.read(sendFilesControllerProvider.notifier).start(widget.items),
      );
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  String _size(int bytes) =>
      DisplayFormat.bytes(bytes, Localizations.localeOf(context).languageCode);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(sendFilesControllerProvider);
    final controller = ref.read(sendFilesControllerProvider.notifier);
    Widget again() => FilledButton.tonal(
      onPressed: () => unawaited(controller.retry()),
      child: Text(l10n.actionTryAgain),
    );
    Widget close() => FilledButton(
      onPressed: () => Navigator.of(context).maybePop(),
      child: Text(l10n.actionClose),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.titleSendFiles)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 48),
          children: [
            switch (state) {
              SendPreparing(:final done, :final total) => SyncMessage(
                icon: Icons.hourglass_top_outlined,
                text: l10n.descSendPreparing(done, total),
                busy: true,
              ),
              SendNothingToSend() => SyncMessage(
                icon: Icons.error_outline,
                text: l10n.errorSendNothing,
                action: close(),
              ),
              SendNoNetwork() => SyncMessage(
                icon: Icons.wifi_off_outlined,
                text: l10n.errorSendNoNetwork,
                action: again(),
              ),
              SendShowingCode(
                :final qrText,
                :final expiresAt,
                :final fileCount,
                :final skipped,
              ) =>
                Column(
                  children: [
                    Text(
                      l10n.descSendFileCount(fileCount),
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    PairingCodeView(
                      key: ValueKey(qrText),
                      qrText: qrText,
                      expiresAt: expiresAt,
                      prompt: l10n.descSendScanPrompt,
                    ),
                    if (skipped.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        l10n.descSendSkipped(skipped.join(', ')),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              SendGuestConnected(:final address) => SyncMessage(
                icon: Icons.phonelink_outlined,
                text: l10n.descWifiGuestConnected(address),
                busy: true,
              ),
              SendTransferring(:final sentBytes, :final totalBytes) => Column(
                children: [
                  LinearProgressIndicator(
                    value: totalBytes == 0 ? null : sentBytes / totalBytes,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.descSendTransferring(
                      _size(sentBytes),
                      _size(totalBytes),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SendFinished(
                :final accepted,
                :final received,
                :final fileCount,
              ) =>
                SyncMessage(
                  icon: !accepted
                      ? Icons.cancel_outlined
                      : received == fileCount
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_outlined,
                  text: accepted
                      ? l10n.descSendFinished(received, fileCount)
                      : l10n.descSendDeclined,
                  action: close(),
                ),
              SendFailed(:final reason) => SyncMessage(
                icon: Icons.error_outline,
                text: transferFailureMessage(l10n, reason),
                action: again(),
              ),
              SendStopped() => SyncMessage(
                icon: Icons.pause_circle_outline,
                text: l10n.descWifiSessionEnded,
                action: again(),
              ),
            },
          ],
        ),
      ),
    );
  }
}
