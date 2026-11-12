import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/features/extraction/data/share_service.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Dialog to preview extracted plain text, allowing copying to clipboard,
/// sharing as raw text, or sharing as a `.txt` file.
class TextPreviewDialog extends ConsumerWidget {
  const TextPreviewDialog({
    super.key,
    required this.text,
    required this.filePath,
  });

  final String text;
  final String filePath;

  void _copyToClipboard(BuildContext context, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.labelCopySuccess)));
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final shareService = ref.read(shareServiceProvider);

    return AlertDialog(
      title: Text(l10n.titlePreviewText),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: SelectableText(
                text.isEmpty ? l10n.emptyExtractedText : text,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionDismiss),
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          tooltip: l10n.actionCopyClipboard,
          onPressed: () => _copyToClipboard(context, l10n),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: l10n.actionShare,
          onPressed: text.isEmpty ? null : () => shareService.shareText(text),
        ),
        IconButton(
          icon: const Icon(Icons.insert_drive_file),
          tooltip: l10n.actionShareFile,
          onPressed: filePath.isEmpty
              ? null
              : () =>
                    shareService.shareFiles([filePath], mimeType: 'text/plain'),
        ),
      ],
    );
  }
}
