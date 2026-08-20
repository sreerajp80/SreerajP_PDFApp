import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/page_ops_result_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

enum WatermarkType { text, image }

/// Dialog for applying custom text or image watermarks onto a new copy of a PDF (Feature 3.4).
class WatermarkDialog extends ConsumerStatefulWidget {
  const WatermarkDialog({
    super.key,
    required this.path,
    required this.pageCount,
  });

  final String path;
  final int pageCount;

  @override
  ConsumerState<WatermarkDialog> createState() => _WatermarkDialogState();
}

class _WatermarkDialogState extends ConsumerState<WatermarkDialog> {
  final WatermarkType _type = WatermarkType.text;
  final _textController = TextEditingController(text: 'CONFIDENTIAL');
  double _opacity = 0.25;
  double _rotation = 45.0;
  double _fontSize = 36.0;
  String _colorHex = '#808080';
  bool _isTiled = false;
  final double _tileSpacing = 150.0;
  String _pageRange = 'all';

  bool _working = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final l10n = AppLocalizations.of(context);
    final text = _textController.text.trim();
    if (_type == WatermarkType.text && text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.watermarkEmptyTextError)));
      return;
    }

    setState(() => _working = true);
    try {
      final service = ref.read(pageOpsServiceProvider);
      final out = await service.applyWatermark(
        widget.path,
        text: _type == WatermarkType.text ? text : null,
        opacity: _opacity,
        rotation: _rotation,
        fontSize: _fontSize,
        colorHex: _colorHex,
        isTiled: _isTiled,
        tileSpacingX: _tileSpacing,
        tileSpacingY: _tileSpacing,
        pageRange: _pageRange,
      );

      if (!mounted) return;
      Navigator.of(context).pop(); // close dialog
      await showDialog<void>(
        context: context,
        builder: (_) => PageOpsResultDialog(
          title: l10n.watermarkDoneTitle,
          outputPaths: [out],
        ),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.watermarkDialogTitle),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: l10n.watermarkTextLabel,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: [
                  for (final preset in [
                    'CONFIDENTIAL',
                    'DRAFT',
                    'COPY',
                    'SAMPLE',
                    'ORIGINAL',
                  ])
                    ActionChip(
                      label: Text(preset, style: const TextStyle(fontSize: 11)),
                      onPressed: () =>
                          setState(() => _textController.text = preset),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Opacity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.watermarkOpacityLabel,
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '${(_opacity * 100).round()}%',
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
              Slider(
                value: _opacity,
                min: 0.05,
                divisions: 19,
                onChanged: (v) => setState(() => _opacity = v),
              ),
              // Rotation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.watermarkRotationLabel,
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '${_rotation.round()}°',
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
              Slider(
                value: _rotation,
                min: -90.0,
                max: 90.0,
                divisions: 36,
                onChanged: (v) => setState(() => _rotation = v),
              ),
              // Font Size
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.watermarkFontSizeLabel,
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '${_fontSize.round()} pt',
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
              Slider(
                value: _fontSize,
                min: 16.0,
                max: 96.0,
                divisions: 16,
                onChanged: (v) => setState(() => _fontSize = v),
              ),
              // Color selection
              Row(
                children: [
                  Text(
                    l10n.watermarkColorLabel,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  for (final entry in {
                    '#808080': Colors.grey,
                    '#D32F2F': Colors.red,
                    '#1976D2': Colors.blue,
                    '#388E3C': Colors.green,
                    '#F57C00': Colors.orange,
                  }.entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () => setState(() => _colorHex = entry.key),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: entry.value,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _colorHex == entry.key
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Tiled switch
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.watermarkTiledLabel),
                subtitle: Text(l10n.watermarkTiledDescription),
                value: _isTiled,
                onChanged: (v) => setState(() => _isTiled = v),
              ),
              // Page Range
              DropdownButtonFormField<String>(
                initialValue: _pageRange,
                decoration: InputDecoration(
                  labelText: l10n.watermarkPageRangeLabel,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'all',
                    child: Text(l10n.watermarkAllPages),
                  ),
                  DropdownMenuItem(
                    value: 'odd',
                    child: Text(l10n.watermarkOddPages),
                  ),
                  DropdownMenuItem(
                    value: 'even',
                    child: Text(l10n.watermarkEvenPages),
                  ),
                ],
                onChanged: (v) => setState(() => _pageRange = v ?? 'all'),
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
        FilledButton(
          onPressed: _working ? null : _apply,
          child: _working
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.watermarkApplyAction),
        ),
      ],
    );
  }
}
