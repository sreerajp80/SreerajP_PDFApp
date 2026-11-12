import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/format/display_format.dart';
import 'package:pdfapp/features/nearby_transfer/domain/pairing_code.dart';
import 'package:pdfapp/features/nearby_transfer/domain/send_item.dart';
import 'package:pdfapp/features/nearby_transfer/domain/transfer_offer.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/providers.dart';
import 'package:pdfapp/features/nearby_transfer/presentation/sync_texts.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Receives what the other phone offers, after the user confirms.
///
/// - Settings: lists what will change; nothing changes until Apply.
/// - PDFs: lists the files and the folder they go to (remembered, with a
///   Change button); nothing is received until Accept.
class ReceiveScreen extends ConsumerStatefulWidget {
  const ReceiveScreen({required this.code, super.key});

  final ScannedCode code;

  @override
  ConsumerState<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ConsumerState<ReceiveScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(
        ref.read(receiveControllerProvider.notifier).begin(widget.code),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(receiveControllerProvider);
    final controller = ref.read(receiveControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.titleReceive)),
      body: SafeArea(
        top: false,
        child: switch (state) {
          ReceiveConnecting() => _Centered(
            busy: true,
            text: l10n.descReceiveConnecting,
          ),
          ReceiveApplying() => const _Centered(busy: true),
          ReceiveReviewing(:final snapshot, :final changes) => _Review(
            changes: changes.map((s) => syncedSettingName(l10n, s)).toList(),
            skippedSome: snapshot.skipped > 0,
            onApply: () => unawaited(controller.apply()),
            onCancel: () async {
              await controller.decline();
              if (context.mounted) Navigator.of(context).maybePop();
            },
          ),
          ReceiveDone(:final applied) => _Centered(
            icon: applied ? Icons.check_circle_outline : Icons.cancel_outlined,
            text: applied
                ? l10n.descSettingsApplied
                : l10n.descSettingsNotApplied,
            action: FilledButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(l10n.actionClose),
            ),
          ),
          ReceiveReviewingFiles() => _FileReview(
            state: state,
            onChangeFolder: () => unawaited(controller.chooseFolder()),
            onAccept: () => unawaited(controller.acceptFiles()),
            onCancel: () async {
              await controller.decline();
              if (context.mounted) Navigator.of(context).maybePop();
            },
          ),
          ReceiveTransferring(:final receivedBytes, :final totalBytes) =>
            _Progress(
              text: l10n.descReceiveTransferring(
                _size(context, receivedBytes),
                _size(context, totalBytes),
              ),
              value: totalBytes == 0 ? null : receivedBytes / totalBytes,
            ),
          ReceiveSaving() => _Centered(
            busy: true,
            text: l10n.descReceiveSaving,
          ),
          ReceiveFilesDone(:final saved, :final failed, :final folderName) =>
            _Centered(
              icon: failed.isEmpty
                  ? Icons.check_circle_outline
                  : Icons.warning_amber_outlined,
              text: [
                l10n.descReceiveFilesSaved(saved.length, folderName),
                if (failed.isNotEmpty)
                  l10n.descReceiveFilesFailed(failed.join(', ')),
              ].join('\n\n'),
              action: FilledButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(l10n.actionClose),
              ),
            ),
          ReceiveFailed(:final reason) => _Centered(
            icon: Icons.error_outline,
            text: transferFailureMessage(l10n, reason),
            action: FilledButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(l10n.actionClose),
            ),
          ),
        },
      ),
    );
  }
}

String _size(BuildContext context, int bytes) =>
    DisplayFormat.bytes(bytes, Localizations.localeOf(context).languageCode);

class _FileReview extends StatelessWidget {
  const _FileReview({
    required this.state,
    required this.onChangeFolder,
    required this.onAccept,
    required this.onCancel,
  });

  final ReceiveReviewingFiles state;
  final VoidCallback onChangeFolder;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final FileOffer offer = state.offer;
    final ReceiveFolder? folder = state.folder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            children: [
              Text(
                l10n.descReceiveFilesHeader(offer.files.length),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.descReceiveFilesTotal(_size(context, offer.totalBytes)),
                style: TextStyle(color: muted),
              ),
              const SizedBox(height: 8),
              for (final f in offer.files)
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.picture_as_pdf_outlined),
                  title: Text(
                    safePdfFileName(f.name),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(_size(context, f.sizeBytes)),
                ),
              const Divider(height: 24),
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.folder_outlined),
                  title: Text(
                    folder != null
                        ? l10n.descSavingTo(folder.name)
                        : state.folderLost
                        ? l10n.errorFolderLost
                        : l10n.descNoFolderYet,
                  ),
                  trailing: TextButton(
                    onPressed: state.choosingFolder ? null : onChangeFolder,
                    child: Text(
                      folder != null
                          ? l10n.actionChangeFolder
                          : l10n.actionChooseFolder,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: Text(l10n.actionCancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: state.choosingFolder ? null : onAccept,
                  child: Text(l10n.actionAcceptFiles),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.text, this.value});

  final String text;
  final double? value;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(value: value),
            const SizedBox(height: 16),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _Review extends StatelessWidget {
  const _Review({
    required this.changes,
    required this.skippedSome,
    required this.onApply,
    required this.onCancel,
  });

  final List<String> changes;
  final bool skippedSome;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final nothingToDo = changes.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            children: [
              Text(
                nothingToDo
                    ? l10n.descReviewSettingsSame
                    : l10n.descReviewSettingsChanges(changes.length),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              for (final name in changes)
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.tune_outlined),
                  title: Text(name),
                ),
              if (skippedSome) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.descReviewSettingsSkipped,
                  style: TextStyle(color: muted),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: nothingToDo
              ? FilledButton(onPressed: onApply, child: Text(l10n.actionClose))
              : Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        child: Text(l10n.actionCancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: onApply,
                        child: Text(l10n.actionApplySettings),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({this.icon, this.text, this.action, this.busy = false});

  final IconData? icon;
  final String? text;
  final Widget? action;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (busy) const CircularProgressIndicator(),
            if (icon != null)
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            if (text != null) ...[
              const SizedBox(height: 16),
              Text(text!, textAlign: TextAlign.center),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
