import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/errors/user_error_message.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/domain/booklet_imposition_planner.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/page_ops_result_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Dialog to configure and generate 2-Up foldable booklet imposition layouts.
class BookletDialog extends ConsumerStatefulWidget {
  const BookletDialog({
    super.key,
    required this.path,
    required this.pageCount,
    this.password,
  });

  final String path;
  final int pageCount;
  final String? password;

  @override
  ConsumerState<BookletDialog> createState() => _BookletDialogState();
}

class _BookletDialogState extends ConsumerState<BookletDialog> {
  BookletBinding _binding = BookletBinding.ltr;
  String _sheetSize = 'auto';
  bool _addFoldGuide = true;
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
      final out = await service.generateBooklet(
        widget.path,
        password: widget.password,
        binding: _binding == BookletBinding.rtl ? 'rtl' : 'ltr',
        sheetSize: _sheetSize,
        addFoldGuide: _addFoldGuide,
      );

      if (mounted) {
        final nav = Navigator.of(context);
        nav.pop();
        showDialog<void>(
          context: nav.context,
          builder: (context) => PageOpsResultDialog(
            title: l10n.titleBookletDone,
            outputPaths: [out],
            note: l10n.descBookletDoneNote,
          ),
        );
      }
    } catch (e, st) {
      AppLogger.error(
        'booklet_dialog: operation failed',
        error: e,
        stackTrace: st,
      );
      if (mounted) {
        setState(() {
          _loading = false;
          _error = userErrorMessage(l10n, e, fallback: l10n.errorOpFailed);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final plan = BookletImpositionPlanner.plan(
      totalPages: widget.pageCount,
      binding: _binding,
    );

    if (_loading) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.descBookletWorking),
          ],
        ),
      );
    }

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.menu_book, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(l10n.titleBooklet)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.descBooklet, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.titleBookletSummary,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.descBookletSummaryPages(
                      widget.pageCount,
                      plan.paddedPages,
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.descBookletSummarySheets(
                      plan.totalSheets,
                      plan.totalSheets * 2,
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                  if (plan.blankPageCount > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      l10n.descBookletSummaryBlanks(plan.blankPageCount),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error, fontSize: 13),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              l10n.labelBookletBinding,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            SegmentedButton<BookletBinding>(
              segments: [
                ButtonSegment<BookletBinding>(
                  value: BookletBinding.ltr,
                  label: Text(l10n.labelBookletBindingLtr),
                  icon: const Icon(Icons.format_textdirection_l_to_r, size: 18),
                ),
                ButtonSegment<BookletBinding>(
                  value: BookletBinding.rtl,
                  label: Text(l10n.labelBookletBindingRtl),
                  icon: const Icon(Icons.format_textdirection_r_to_l, size: 18),
                ),
              ],
              selected: {_binding},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  setState(() => _binding = selection.first);
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              l10n.labelBookletPaperSize,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            SegmentedButton<String>(
              segments: [
                ButtonSegment<String>(
                  value: 'auto',
                  label: Text(l10n.labelBookletPaperAuto),
                ),
                ButtonSegment<String>(
                  value: 'a4',
                  label: Text(l10n.labelBookletPaperA4),
                ),
                ButtonSegment<String>(
                  value: 'letter',
                  label: Text(l10n.labelBookletPaperLetter),
                ),
              ],
              selected: {_sheetSize},
              onSelectionChanged: (selection) {
                if (selection.isNotEmpty) {
                  setState(() => _sheetSize = selection.first);
                }
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.labelBookletFoldGuide),
              subtitle: Text(
                l10n.helpBookletFoldGuide,
                style: theme.textTheme.bodySmall,
              ),
              value: _addFoldGuide,
              onChanged: (val) => setState(() => _addFoldGuide = val),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.menu_book),
          label: Text(l10n.actionBooklet),
          onPressed: _run,
        ),
      ],
    );
  }
}
