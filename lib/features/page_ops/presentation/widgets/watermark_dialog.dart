import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/app/theme/tokens.dart';
import 'package:pdfapp/core/errors/user_error_message.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
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
  final _textController = TextEditingController();
  bool _defaultTextSet = false;
  double _opacity = 0.25;
  double _rotation = 45.0;
  double _fontSize = 36.0;
  String _colorHex = '#808080';
  bool _isTiled = false;
  final double _tileSpacing = 150.0;
  String _pageRange = 'all';

  bool _working = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The default text is localized, so it can only be read once the
    // localizations are available. Set it once, and never over the user's text.
    if (!_defaultTextSet) {
      _defaultTextSet = true;
      if (_textController.text.isEmpty) {
        _textController.text = AppLocalizations.of(context)
            .labelWatermarkConfidential;
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    final l10n = AppLocalizations.of(context);
    final text = _textController.text.trim();
    if (_type == WatermarkType.text && text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorWatermarkEmptyText)));
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
          title: l10n.titleWatermarkDone,
          outputPaths: [out],
        ),
      );
    } catch (e, st) {
      AppLogger.error(
        'watermark_dialog: _apply failed',
        error: e,
        stackTrace: st,
      );
      if (mounted) {
        setState(() => _working = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userErrorMessage(l10n, e, fallback: l10n.errorOpFailed),
            ),
            action: SnackBarAction(
              label: l10n.actionTryAgain,
              onPressed: () {
                if (mounted && !_working) _apply();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.titleWatermarkDialog),
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
                  labelText: l10n.labelWatermarkText,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: [
                  for (final preset in [
                    l10n.labelWatermarkConfidential,
                    l10n.labelWatermarkDraft,
                    l10n.labelWatermarkCopy,
                    l10n.labelWatermarkSample,
                    l10n.labelWatermarkOriginal,
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
                    l10n.labelWatermarkOpacity,
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
                    l10n.labelWatermarkRotation,
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
                    l10n.labelWatermarkFontSize,
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
              // Color selection: 48 dp targets with a name for each color, and
              // a check mark so the choice is not shown by color alone
              // (engineering standard §7.1, §7.2, §7.8).
              Text(l10n.labelWatermarkColor, style: theme.textTheme.bodyMedium),
              Wrap(
                children: [
                  for (final swatch in _swatches(l10n))
                    _ColorSwatch(
                      color: swatch.color,
                      label: swatch.label,
                      selected: _colorHex == swatch.hex,
                      onTap: () => setState(() => _colorHex = swatch.hex),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Tiled switch
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.labelWatermarkTiled),
                subtitle: Text(l10n.descWatermarkTiled),
                value: _isTiled,
                onChanged: (v) => setState(() => _isTiled = v),
              ),
              // Page Range
              DropdownButtonFormField<String>(
                initialValue: _pageRange,
                decoration: InputDecoration(
                  labelText: l10n.labelWatermarkPageRange,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'all',
                    child: Text(l10n.labelWatermarkAllPages),
                  ),
                  DropdownMenuItem(
                    value: 'odd',
                    child: Text(l10n.labelWatermarkOddPages),
                  ),
                  DropdownMenuItem(
                    value: 'even',
                    child: Text(l10n.labelWatermarkEvenPages),
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
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: _working ? null : _apply,
          child: _working
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.actionWatermarkApply),
        ),
      ],
    );
  }
}

/// The watermark colors offered, by the hex value the service expects.
List<({String hex, Color color, String label})> _swatches(
  AppLocalizations l10n,
) => [
  (hex: '#808080', color: Colors.grey, label: l10n.labelColorGrey),
  (hex: '#D32F2F', color: Colors.red, label: l10n.labelColorRed),
  (hex: '#1976D2', color: Colors.blue, label: l10n.labelColorBlue),
  (hex: '#388E3C', color: Colors.green, label: l10n.labelColorGreen),
  (hex: '#F57C00', color: Colors.orange, label: l10n.labelColorOrange),
];

/// One color choice: a 48 dp target with a tooltip, a screen-reader label,
/// and a check mark when selected.
class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkResponse(
          onTap: onTap,
          radius: AppTokens.minTapTarget / 2,
          child: SizedBox.square(
            dimension: AppTokens.minTapTarget,
            child: Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? scheme.primary : scheme.outlineVariant,
                    width: selected ? 3 : 1,
                  ),
                ),
                child: selected
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: AppTheme.contrastOn(color),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
