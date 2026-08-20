import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/page_ops_result_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Dialog to configure and run Smart Margin Trimming on a PDF.
class SmartTrimDialog extends ConsumerStatefulWidget {
  const SmartTrimDialog({super.key, required this.path, this.password});

  final String path;
  final String? password;

  @override
  ConsumerState<SmartTrimDialog> createState() => _SmartTrimDialogState();
}

class _SmartTrimDialogState extends ConsumerState<SmartTrimDialog> {
  double _padding = 12.0;
  bool _symmetric = true;
  bool _loading = false;
  String? _error;

  Future<void> _run() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final service = ref.read(pageOpsServiceProvider);
      await service.clearOutputCache();
      final out = await service.trimMargins(
        widget.path,
        password: widget.password,
        padding: _padding,
        symmetric: _symmetric,
      );

      if (mounted) {
        final nav = Navigator.of(context);
        nav.pop();
        showDialog<void>(
          context: nav.context,
          builder: (context) => PageOpsResultDialog(
            title: l10n.trimMarginsDoneTitle,
            outputPaths: [out],
            note: l10n.trimMarginsDoneNote,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = '${l10n.opFailed}: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (_loading) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.trimMarginsWorking),
          ],
        ),
      );
    }

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.crop, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(l10n.trimMarginsTitle)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.trimMarginsDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (_error != null) ...[
              Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error, fontSize: 13),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              l10n.trimPaddingLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            SegmentedButton<double>(
              segments: [
                ButtonSegment<double>(
                  value: 4.0,
                  label: Text(l10n.trimPaddingTight),
                ),
                ButtonSegment<double>(
                  value: 12.0,
                  label: Text(l10n.trimPaddingStandard),
                ),
                ButtonSegment<double>(
                  value: 24.0,
                  label: Text(l10n.trimPaddingComfortable),
                ),
              ],
              selected: {_padding},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  setState(() => _padding = selection.first);
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.trimSymmetricLabel),
              subtitle: Text(
                l10n.trimSymmetricHelp,
                style: theme.textTheme.bodySmall,
              ),
              value: _symmetric,
              onChanged: (val) => setState(() => _symmetric = val),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelAction),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.crop),
          label: Text(l10n.trimMarginsAction),
          onPressed: _run,
        ),
      ],
    );
  }
}
