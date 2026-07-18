import 'package:flutter/material.dart';
import 'package:pdfapp/features/annotation/presentation/annotation_controller.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// The tool strip shown while annotation mode is on.
///
/// It offers the drawing tools, a color picker (for tools that use color), and
/// buttons to clear all marks and export an annotated copy. It listens to the
/// [controller] so the selected tool and color stay in step.
class AnnotationToolbar extends StatelessWidget {
  const AnnotationToolbar({
    super.key,
    required this.controller,
    required this.textMarkupEnabled,
    required this.onExport,
    required this.onClearAll,
    required this.onTextMarkupBlocked,
  });

  final AnnotationController controller;

  /// False on scanned/garbled PDFs — text markup needs a real text layer.
  final bool textMarkupEnabled;

  final VoidCallback onExport;
  final VoidCallback onClearAll;

  /// Called when a text-markup tool is tapped but there is no usable text.
  final VoidCallback onTextMarkupBlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final tool = controller.tool;
        final showColors =
            tool == AnnotationTool.highlight ||
            tool == AnnotationTool.underline ||
            tool == AnnotationTool.strikethrough ||
            tool == AnnotationTool.ink;
        return Material(
          elevation: 2,
          color: scheme.surfaceContainerHigh,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    _toolButton(
                      context,
                      tool,
                      AnnotationTool.highlight,
                      Icons.border_color_outlined,
                      l10n.annotationHighlight,
                    ),
                    _toolButton(
                      context,
                      tool,
                      AnnotationTool.underline,
                      Icons.format_underlined,
                      l10n.annotationUnderline,
                    ),
                    _toolButton(
                      context,
                      tool,
                      AnnotationTool.strikethrough,
                      Icons.format_strikethrough,
                      l10n.annotationStrikethrough,
                    ),
                    _toolButton(
                      context,
                      tool,
                      AnnotationTool.ink,
                      Icons.gesture,
                      l10n.annotationInk,
                    ),
                    _toolButton(
                      context,
                      tool,
                      AnnotationTool.note,
                      Icons.sticky_note_2_outlined,
                      l10n.annotationNote,
                    ),
                    _toolButton(
                      context,
                      tool,
                      AnnotationTool.eraser,
                      Icons.auto_fix_off,
                      l10n.annotationEraser,
                    ),
                    const VerticalDivider(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_outlined),
                      tooltip: l10n.annotationClearAll,
                      onPressed: controller.hasAnnotations ? onClearAll : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.ios_share),
                      tooltip: l10n.annotationExport,
                      onPressed: controller.hasAnnotations ? onExport : null,
                    ),
                  ],
                ),
              ),
              if (showColors) _colorRow(context),
            ],
          ),
        );
      },
    );
  }

  Widget _toolButton(
    BuildContext context,
    AnnotationTool current,
    AnnotationTool tool,
    IconData icon,
    String tooltip,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final selected = current == tool;
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      isSelected: selected,
      color: selected ? scheme.onPrimaryContainer : null,
      style: selected
          ? IconButton.styleFrom(backgroundColor: scheme.primaryContainer)
          : null,
      onPressed: () {
        // Never a dead button: a text-markup tool on a scanned PDF says why.
        if (tool.isTextMarkup && !textMarkupEnabled) {
          onTextMarkupBlocked();
          return;
        }
        controller.setTool(selected ? AnnotationTool.none : tool);
      },
    );
  }

  Widget _colorRow(BuildContext context) {
    return SizedBox(
      height: 44,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            for (final c in kAnnotationPalette)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _colorDot(context, c),
              ),
          ],
        ),
      ),
    );
  }

  Widget _colorDot(BuildContext context, int color) {
    final selected = controller.color == color;
    final scheme = Theme.of(context).colorScheme;
    final label = _colorName(color);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: () => controller.setColor(color),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Color(color),
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected ? 3 : 1,
            ),
          ),
        ),
      ),
    );
  }

  String _colorName(int color) {
    return switch (color) {
      0xFFFFEB3B => 'Yellow',
      0xFF4CAF50 => 'Green',
      0xFF2196F3 => 'Blue',
      0xFFE53935 => 'Red',
      0xFF9C27B0 => 'Purple',
      0xFFFF9800 => 'Orange',
      0xFF000000 => 'Black',
      _ => 'Custom Color',
    };
  }
}
