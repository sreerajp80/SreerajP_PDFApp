import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/page_ops_result_dialog.dart';
import 'package:pdfapp/features/printer/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Modal dialog for generating and printing N-Up multi-page layout grids (Feature 3.5).
class NUpDialog extends ConsumerStatefulWidget {
  const NUpDialog({
    super.key,
    required this.path,
    required this.jobName,
    required this.pageCount,
  });

  final String path;
  final String jobName;
  final int pageCount;

  @override
  ConsumerState<NUpDialog> createState() => _NUpDialogState();
}

class _NUpDialogState extends ConsumerState<NUpDialog> {
  int _gridCount = 4;
  String _sheetSize = 'a4';
  String _orientation = 'auto';
  bool _addBorders = true;
  double _margin = 12.0;
  bool _working = false;

  Future<void> _generateAndSave() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _working = true);

    try {
      final service = ref.read(pageOpsServiceProvider);
      await service.clearOutputCache();
      final out = await service.generateNUp(
        widget.path,
        gridCount: _gridCount,
        sheetSize: _sheetSize,
        orientation: _orientation,
        addBorders: _addBorders,
        margin: _margin,
      );

      if (!mounted) return;
      Navigator.of(context).pop(); // close dialog
      await showDialog<void>(
        context: context,
        builder: (_) =>
            PageOpsResultDialog(title: l10n.nUpDoneTitle, outputPaths: [out]),
      );
    } on AppException catch (e) {
      if (mounted) {
        setState(() => _working = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _working = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.opFailed}: $e')));
      }
    }
  }

  Future<void> _printDirect() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _working = true);

    try {
      final printService = ref.read(printServiceProvider);
      await printService.printNUp(
        widget.path,
        widget.jobName,
        gridCount: _gridCount,
        sheetSize: _sheetSize,
        orientation: _orientation,
        addBorders: _addBorders,
        margin: _margin,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } on AppException catch (e) {
      if (mounted) {
        setState(() => _working = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _working = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.opFailed}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.nUpDialogTitle),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.nUpGridLabel, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 2, label: Text('2-in-1')),
                  ButtonSegment(value: 4, label: Text('4-in-1')),
                  ButtonSegment(value: 6, label: Text('6-in-1')),
                  ButtonSegment(value: 9, label: Text('9-in-1')),
                ],
                selected: {_gridCount},
                onSelectionChanged: (set) =>
                    setState(() => _gridCount = set.first),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _sheetSize,
                decoration: InputDecoration(
                  labelText: l10n.nUpSheetSizeLabel,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(value: 'a4', child: Text(l10n.nUpSheetA4)),
                  DropdownMenuItem(
                    value: 'letter',
                    child: Text(l10n.nUpSheetLetter),
                  ),
                ],
                onChanged: (val) => setState(() => _sheetSize = val ?? 'a4'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _orientation,
                decoration: InputDecoration(
                  labelText: l10n.nUpOrientationLabel,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'auto',
                    child: Text(l10n.nUpOrientationAuto),
                  ),
                  DropdownMenuItem(
                    value: 'portrait',
                    child: Text(l10n.nUpOrientationPortrait),
                  ),
                  DropdownMenuItem(
                    value: 'landscape',
                    child: Text(l10n.nUpOrientationLandscape),
                  ),
                ],
                onChanged: (val) =>
                    setState(() => _orientation = val ?? 'auto'),
              ),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.nUpBordersLabel),
                subtitle: Text(l10n.nUpBordersDescription),
                value: _addBorders,
                onChanged: (val) => setState(() => _addBorders = val),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.nUpMarginLabel, style: theme.textTheme.bodyMedium),
                  Text(
                    '${_margin.round()} pt',
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
              Slider(
                value: _margin,
                max: 36.0,
                divisions: 12,
                onChanged: (val) => setState(() => _margin = val),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _working ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancelAction),
        ),
        OutlinedButton.icon(
          onPressed: _working ? null : _printDirect,
          icon: const Icon(Icons.print, size: 18),
          label: Text(l10n.printAction),
        ),
        FilledButton.icon(
          onPressed: _working ? null : _generateAndSave,
          icon: _working
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_alt, size: 18),
          label: Text(l10n.saveAction),
        ),
      ],
    );
  }
}
