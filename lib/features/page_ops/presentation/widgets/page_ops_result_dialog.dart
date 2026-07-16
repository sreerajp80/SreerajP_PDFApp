import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/features/extraction/data/share_service.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Shown after a page operation succeeds. Offers Save (to a user-chosen
/// location) for a single output file, and Share for one or many files.
class PageOpsResultDialog extends ConsumerWidget {
  const PageOpsResultDialog({
    super.key,
    required this.title,
    required this.outputPaths,
    this.note,
  });

  /// A short success title (e.g. "Pages organized").
  final String title;

  /// The new file(s) produced. A single-item list enables Save.
  final List<String> outputPaths;

  /// Optional extra line (e.g. the best-effort compression note).
  final String? note;

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(pageOpsServiceProvider);
    final path = outputPaths.first;
    final suggested = path.split('/').last;
    try {
      final saved = await service.saveToDevice(path, suggested);
      if (context.mounted) {
        Navigator.of(context).pop();
        if (saved != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.savedFileMessage(saved))));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.saveFailed}: $e')));
      }
    }
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final share = ref.read(shareServiceProvider);
    await share.shareFiles(outputPaths, mimeType: 'application/pdf');
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final single = outputPaths.length == 1;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.check_circle, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            single
                ? l10n.resultOneFile(outputPaths.first.split('/').last)
                : l10n.resultManyFiles(outputPaths.length),
          ),
          if (note != null) ...[
            const SizedBox(height: 12),
            Text(
              note!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.dismissAction),
        ),
        TextButton.icon(
          icon: const Icon(Icons.share),
          label: Text(l10n.shareAction),
          onPressed: () => _share(context, ref),
        ),
        if (single)
          FilledButton.icon(
            icon: const Icon(Icons.save_alt),
            label: Text(l10n.saveAction),
            onPressed: () => _save(context, ref),
          ),
      ],
    );
  }
}
