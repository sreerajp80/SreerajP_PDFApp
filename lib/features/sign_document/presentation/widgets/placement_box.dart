import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

/// One placed signature on the page preview: drag the box to move it, drag the
/// corner handle to resize it, tap × to remove it.
///
/// [rect] is the box in **pixels** of the page preview. The widget covers the
/// box grown by [handleRadius] on every side, so its corner handles stay
/// inside its own area and always receive touches.
class PlacementBox extends StatelessWidget {
  const PlacementBox({
    super.key,
    required this.rect,
    required this.png,
    required this.selected,
    required this.onSelect,
    required this.onMove,
    required this.onResize,
    required this.onRemove,
    required this.removeTooltip,
    required this.resizeTooltip,
    required this.semanticLabel,
  });

  static const double handleRadius = 16;

  final Rect rect;
  final Uint8List png;
  final bool selected;
  final VoidCallback onSelect;

  /// Called with the finger's movement in pixels.
  final ValueChanged<Offset> onMove;
  final ValueChanged<Offset> onResize;
  final VoidCallback onRemove;
  final String removeTooltip;
  final String resizeTooltip;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const r = handleRadius;
    return Positioned(
      left: rect.left - r,
      top: rect.top - r,
      width: rect.width + r * 2,
      height: rect.height + r * 2,
      child: Stack(
        children: [
          Positioned.fill(
            left: r,
            top: r,
            right: r,
            bottom: r,
            child: Semantics(
              label: semanticLabel,
              selected: selected,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onSelect,
                onPanStart: (_) => onSelect(),
                onPanUpdate: (d) => onMove(d.delta),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selected ? scheme.primary : scheme.outline,
                      width: selected ? 2 : 1,
                    ),
                    color: selected
                        ? scheme.primary.withValues(alpha: 0.06)
                        : null,
                  ),
                  child: Image.memory(
                    png,
                    fit: BoxFit.fill,
                    gaplessPlayback: true,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
          ),
          if (selected) ...[
            Positioned(
              right: 0,
              top: 0,
              child: _Handle(
                icon: Icons.close,
                tooltip: removeTooltip,
                color: scheme.error,
                onColor: scheme.onError,
                onTap: onRemove,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: _Handle(
                icon: Icons.open_in_full,
                tooltip: resizeTooltip,
                color: scheme.primary,
                onColor: scheme.onPrimary,
                onPanUpdate: (d) => onResize(d.delta),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onColor,
    this.onTap,
    this.onPanUpdate,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final Color onColor;
  final VoidCallback? onTap;
  final GestureDragUpdateCallback? onPanUpdate;

  @override
  Widget build(BuildContext context) {
    const size = PlacementBox.handleRadius * 2;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          onPanUpdate: onPanUpdate,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: onColor),
          ),
        ),
      ),
    );
  }
}
