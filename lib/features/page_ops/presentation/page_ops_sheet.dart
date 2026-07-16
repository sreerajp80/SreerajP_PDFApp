import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/organize_pages_screen.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/page_ops_result_dialog.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/protect_dialog.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/unlock_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Opens the Phase 4 "Page tools" bottom sheet for the open document.
Future<void> showPageOpsSheet(
  BuildContext context, {
  required String path,
  required PdfDocument document,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => _PageOpsSheet(path: path, document: document),
  );
}

class _PageOpsSheet extends ConsumerWidget {
  const _PageOpsSheet({required this.path, required this.document});

  final String path;
  final PdfDocument document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Text(l10n.pageToolsTitle, style: theme.textTheme.titleLarge),
          ),
          _tile(
            context,
            icon: Icons.merge_type,
            title: l10n.mergeAction,
            subtitle: l10n.mergeDescription,
            onTap: () => _merge(context, ref),
          ),
          _tile(
            context,
            icon: Icons.call_split,
            title: l10n.splitAction,
            subtitle: l10n.splitDescription,
            onTap: () => _split(context, ref),
          ),
          _tile(
            context,
            icon: Icons.reorder,
            title: l10n.organizeAction,
            subtitle: l10n.organizeDescription,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      OrganizePagesScreen(document: document, path: path),
                ),
              );
            },
          ),
          _tile(
            context,
            icon: Icons.compress,
            title: l10n.compressAction,
            subtitle: l10n.compressDescription,
            onTap: () => _compress(context, ref),
          ),
          _tile(
            context,
            icon: Icons.lock_outline,
            title: l10n.protectAction,
            subtitle: l10n.protectDescription,
            onTap: () {
              Navigator.of(context).pop();
              showDialog<void>(
                context: context,
                builder: (_) => ProtectDialog(path: path),
              );
            },
          ),
          _tile(
            context,
            icon: Icons.lock_open,
            title: l10n.unlockAction,
            subtitle: l10n.unlockDescription,
            onTap: () {
              Navigator.of(context).pop();
              showDialog<void>(
                context: context,
                builder: (_) => UnlockDialog(path: path),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  Future<void> _merge(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(pageOpsServiceProvider);
    final picked = await service.pickPdfsToMerge();
    if (picked.isEmpty) return;
    if (!context.mounted) return;
    Navigator.of(context).pop(); // close the sheet

    // The open document goes first, then the picked files in the order chosen.
    final paths = [path, ...picked.map((d) => d.cachePath)];
    await _runWithProgress(
      context,
      ref,
      title: l10n.mergeDoneTitle,
      run: () async => [await service.merge(paths)],
    );
  }

  Future<void> _split(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(pageOpsServiceProvider);
    Navigator.of(context).pop(); // close the sheet
    await _runWithProgress(
      context,
      ref,
      title: l10n.splitDoneTitle,
      run: () => service.split(path),
    );
  }

  Future<void> _compress(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(pageOpsServiceProvider);
    Navigator.of(context).pop(); // close the sheet
    await _runWithProgress(
      context,
      ref,
      title: l10n.compressDoneTitle,
      note: l10n.compressBestEffortNote,
      run: () async => [await service.compress(path)],
    );
  }

  /// Runs [run] behind a blocking progress dialog, then shows the result.
  Future<void> _runWithProgress(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    String? note,
    required Future<List<String>> Function() run,
  }) async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(pageOpsServiceProvider);
    await service.clearOutputCache();
    if (!context.mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.workingProgress),
          ],
        ),
      ),
    );

    try {
      final outputs = await run();
      if (!context.mounted) return;
      Navigator.of(context).pop(); // close progress
      if (outputs.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.opFailed)));
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (_) =>
            PageOpsResultDialog(title: title, outputPaths: outputs, note: note),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // close progress
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${l10n.opFailed}: $e')));
    }
  }
}
