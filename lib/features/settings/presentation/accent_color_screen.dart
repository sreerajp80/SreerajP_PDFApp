import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/features/settings/presentation/widgets/app_section_card.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Screen for picking custom accent color, presets, and HSV color wheel matching sreerajp_todo.
class AccentColorScreen extends ConsumerStatefulWidget {
  const AccentColorScreen({super.key});

  @override
  ConsumerState<AccentColorScreen> createState() => _AccentColorScreenState();
}

class _AccentColorScreenState extends ConsumerState<AccentColorScreen> {
  HSVColor? _hsv;
  Brightness? _lastBrightness;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = Theme.of(context).brightness;
    if (brightness == _lastBrightness) return;
    _lastBrightness = brightness;
    _hsv = HSVColor.fromColor(_currentAccent(brightness));
  }

  Color _currentAccent(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return ref.read(darkAccentProvider) ?? AppTheme.defaultDarkAccent;
    } else {
      return ref.read(lightAccentProvider) ?? AppTheme.defaultLightAccent;
    }
  }

  void _apply(HSVColor hsv) {
    setState(() => _hsv = hsv);
    final brightness = Theme.of(context).brightness;
    final color = hsv.toColor();
    if (brightness == Brightness.dark) {
      ref.read(darkAccentProvider.notifier).set(color);
    } else {
      ref.read(lightAccentProvider.notifier).set(color);
    }
  }

  void _reset() {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.dark) {
      ref.read(darkAccentProvider.notifier).set(null);
      setState(() => _hsv = HSVColor.fromColor(AppTheme.defaultDarkAccent));
    } else {
      ref.read(lightAccentProvider.notifier).set(null);
      setState(() => _hsv = HSVColor.fromColor(AppTheme.defaultLightAccent));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hsv = _hsv ?? HSVColor.fromColor(_currentAccent(theme.brightness));
    final selected = hsv.toColor();
    final onAccent = AppTheme.contrastOn(selected);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accentColorTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppSectionCard(
            title: l10n.livePreviewLabel,
            subtitle: isDark
                ? l10n.accentAppliesToDark
                : l10n.accentAppliesToLight,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: selected,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: selected.withValues(alpha: 0.42),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.palette_outlined, color: onAccent, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      l10n.sampleText,
                      style: TextStyle(
                        color: onAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppSectionCard(
            title: l10n.presetsLabel,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                for (final color in AppTheme.presetAccents)
                  _PresetSwatch(
                    color: color,
                    selected: color.toARGB32() == selected.toARGB32(),
                    onTap: () => _apply(HSVColor.fromColor(color)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSectionCard(
            title: l10n.customColorWheelLabel,
            child: Column(
              children: [
                Center(
                  child: _HueWheel(
                    size: 248,
                    hsv: hsv,
                    onChanged: (hue, saturation) =>
                        _apply(hsv.withHue(hue).withSaturation(saturation)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.brightness_6_outlined, size: 20),
                    Expanded(
                      child: Slider(
                        value: hsv.value,
                        onChanged: (value) =>
                            _apply(hsv.withValue(value.clamp(0.05, 1.0))),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.restart_alt),
                    label: Text(
                      isDark
                          ? l10n.resetDarkToDefault
                          : l10n.resetLightToDefault,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.contrastNotice,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetSwatch extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _PresetSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 3,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: selected
            ? Icon(Icons.check, color: AppTheme.contrastOn(color), size: 22)
            : null,
      ),
    );
  }
}

class _HueWheel extends StatelessWidget {
  final double size;
  final HSVColor hsv;
  final void Function(double hue, double saturation) onChanged;

  const _HueWheel({
    required this.size,
    required this.hsv,
    required this.onChanged,
  });

  void _handle(Offset local) {
    final radius = size / 2;
    final center = Offset(radius, radius);
    final v = local - center;
    final dist = v.distance;
    final sat = (dist / radius).clamp(0.0, 1.0);
    var deg = v.direction * 180 / math.pi;
    if (deg < 0) deg += 360;
    onChanged(deg, sat);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (d) => _handle(d.localPosition),
      onPanUpdate: (d) => _handle(d.localPosition),
      child: CustomPaint(size: Size.square(size), painter: _WheelPainter(hsv)),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final HSVColor hsv;
  const _WheelPainter(this.hsv);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    final hueColors = <Color>[
      for (var i = 0; i <= 360; i += 30)
        HSVColor.fromAHSV(1, i % 360.0, 1, 1).toColor(),
    ];
    final sweep = Paint()
      ..shader = SweepGradient(
        colors: hueColors,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, sweep);

    final satPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white, Colors.white.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, satPaint);

    if (hsv.value < 1) {
      final dim = Paint()
        ..color = Colors.black.withValues(alpha: 1 - hsv.value);
      canvas.drawCircle(center, radius, dim);
    }

    final angle = hsv.hue * math.pi / 180;
    final r = hsv.saturation * radius;
    final thumb = center + Offset(math.cos(angle) * r, math.sin(angle) * r);
    canvas.drawCircle(
      thumb,
      11,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(thumb, 8, Paint()..color = hsv.toColor());
  }

  @override
  bool shouldRepaint(_WheelPainter old) => old.hsv != hsv;
}
