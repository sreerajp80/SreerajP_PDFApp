import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/errors/user_error_message.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:pdfapp/features/sign_document/domain/signature_image_tools.dart';
import 'package:pdfapp/features/sign_document/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// A full-screen pad to draw a signature with a finger or stylus.
///
/// Pops with the new [LoadedSignature] after **Save**, or null on back. Only the
/// strokes are saved — the pad's white paper, hint and line are not — so the
/// picture has a see-through background.
class SignaturePadScreen extends ConsumerStatefulWidget {
  const SignaturePadScreen({super.key});

  @override
  ConsumerState<SignaturePadScreen> createState() => _SignaturePadScreenState();
}

/// One finished or in-progress stroke on the pad (pad pixels).
class PadStroke {
  PadStroke({required this.color, required this.width});

  final Color color;
  final double width;
  final List<Offset> points = [];
}

class _SignaturePadScreenState extends ConsumerState<SignaturePadScreen> {
  // Dark inks only: the signature must stay readable on white paper.
  static const List<Color> _inks = [
    Color(0xFF000000),
    Color(0xFF0D3B9E),
    Color(0xFF9E1B1B),
  ];
  static const double _thin = 2;
  static const double _medium = 3.5;
  static const double _thick = 5.5;

  final List<PadStroke> _strokes = [];
  Color _ink = _inks.first;
  double _width = _medium;
  bool _saving = false;

  void _start(Offset p) {
    setState(
      () => _strokes.add(PadStroke(color: _ink, width: _width)..points.add(p)),
    );
  }

  void _extend(Offset p) {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.last.points.add(p));
  }

  void _undo() {
    if (_strokes.isEmpty) return;
    setState(_strokes.removeLast);
  }

  void _clear() => setState(_strokes.clear);

  Future<void> _save() async {
    if (_strokes.isEmpty || _saving) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      final image = await _renderStrokes();
      final service = ref.read(signDocumentServiceProvider);
      final saved = await service.saveSignature(
        image,
        source: SignatureSource.drawn,
      );
      if (!mounted) return;
      Navigator.of(context).pop(saved);
    } catch (e, st) {
      AppLogger.error('signature_pad: save failed', error: e, stackTrace: st);
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            userErrorMessage(l10n, e, fallback: l10n.errorSignatureSave),
          ),
        ),
      );
    }
  }

  /// Paints only the strokes into a tight picture, scaled up for sharpness but
  /// never past [SignatureImageTools.maxSide] on the longest side.
  Future<RgbaImage> _renderStrokes() async {
    var bounds = Rect.zero;
    var first = true;
    for (final s in _strokes) {
      for (final p in s.points) {
        final r = Rect.fromCircle(center: p, radius: s.width);
        bounds = first ? r : bounds.expandToInclude(r);
        first = false;
      }
    }
    final longest = math.max(bounds.width, bounds.height);
    final scale = math.min(3.0, SignatureImageTools.maxSide / longest);
    final w = math.max(1, (bounds.width * scale).ceil());
    final h = math.max(1, (bounds.height * scale).ceil());

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)
      ..scale(scale)
      ..translate(-bounds.left, -bounds.top);
    paintStrokes(canvas, _strokes);
    final picture = recorder.endRecording();
    final image = await picture.toImage(w, h);
    try {
      return await ref.read(signDocumentServiceProvider).codec.fromImage(image);
    } finally {
      image.dispose();
      picture.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final inkNames = [
      l10n.labelColorBlack,
      l10n.labelColorBlue,
      l10n.labelColorRed,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.titleDrawSignature),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: l10n.actionUndo,
            onPressed: _strokes.isEmpty || _saving ? null : _undo,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: l10n.actionClear,
            onPressed: _strokes.isEmpty || _saving ? null : _clear,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Material(
                  // Paper stays white in dark mode too: it is what the ink is
                  // drawn against, and the inks are dark.
                  color: Colors.white,
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = constraints.biggest;
                      Offset clampTo(Offset p) => Offset(
                        p.dx.clamp(0.0, size.width),
                        p.dy.clamp(0.0, size.height),
                      );
                      return Semantics(
                        label: l10n.descSignHere,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: _saving
                              ? null
                              : (d) => _start(clampTo(d.localPosition)),
                          onPanUpdate: _saving
                              ? null
                              : (d) => _extend(clampTo(d.localPosition)),
                          child: CustomPaint(
                            size: size,
                            painter: _PadPainter(
                              strokes: _strokes,
                              hint: l10n.descSignHere,
                              hintStyle: theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.black38,
                              ),
                              showHint: _strokes.isEmpty,
                              // Repaint on every change of the stroke list.
                              version: _strokes.fold<int>(
                                _strokes.length,
                                (sum, s) => sum + s.points.length,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < _inks.length; i++)
                        _InkButton(
                          color: _inks[i],
                          selected: _ink == _inks[i],
                          tooltip: inkNames[i],
                          onTap: () => setState(() => _ink = _inks[i]),
                        ),
                    ],
                  ),
                  SegmentedButton<double>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(
                        value: _thin,
                        label: Text(l10n.labelPenThin),
                      ),
                      ButtonSegment(
                        value: _medium,
                        label: Text(l10n.labelPenMedium),
                      ),
                      ButtonSegment(
                        value: _thick,
                        label: Text(l10n.labelPenThick),
                      ),
                    ],
                    selected: {_width},
                    onSelectionChanged: (v) => setState(() => _width = v.first),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _strokes.isEmpty || _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(l10n.actionSave),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints [strokes] as smooth, round-ended lines. Shared by the pad and by the
/// picture export, so the saved signature looks exactly like what was drawn.
void paintStrokes(Canvas canvas, List<PadStroke> strokes) {
  for (final s in strokes) {
    final paint = Paint()
      ..color = s.color
      ..strokeWidth = s.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    final pts = s.points;
    if (pts.length == 1) {
      canvas.drawCircle(
        pts.first,
        s.width / 2,
        Paint()
          ..color = s.color
          ..isAntiAlias = true,
      );
      continue;
    }
    // A curve through the midpoints of each pair of points smooths the jagged
    // corners that raw touch samples make.
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length - 1; i++) {
      final mid = Offset(
        (pts[i].dx + pts[i + 1].dx) / 2,
        (pts[i].dy + pts[i + 1].dy) / 2,
      );
      path.quadraticBezierTo(pts[i].dx, pts[i].dy, mid.dx, mid.dy);
    }
    path.lineTo(pts.last.dx, pts.last.dy);
    canvas.drawPath(path, paint);
  }
}

class _PadPainter extends CustomPainter {
  _PadPainter({
    required this.strokes,
    required this.hint,
    required this.hintStyle,
    required this.showHint,
    required this.version,
  });

  final List<PadStroke> strokes;
  final String hint;
  final TextStyle hintStyle;
  final bool showHint;
  final int version;

  @override
  void paint(Canvas canvas, Size size) {
    // A baseline to sign on, about two thirds down.
    final lineY = size.height * 0.68;
    canvas.drawLine(
      Offset(size.width * 0.08, lineY),
      Offset(size.width * 0.92, lineY),
      Paint()
        ..color = Colors.black26
        ..strokeWidth = 1,
    );
    if (showHint) {
      final tp = TextPainter(
        text: TextSpan(text: hint, style: hintStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width * 0.84);
      tp.paint(canvas, Offset(size.width * 0.08, lineY + 8));
    }
    paintStrokes(canvas, strokes);
  }

  @override
  bool shouldRepaint(_PadPainter old) =>
      old.version != version || old.showHint != showHint || old.hint != hint;
}

class _InkButton extends StatelessWidget {
  const _InkButton({
    required this.color,
    required this.selected,
    required this.tooltip,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        selected: selected,
        label: tooltip,
        child: InkResponse(
          onTap: onTap,
          radius: 24,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? scheme.primary : scheme.outlineVariant,
                  width: selected ? 3 : 1,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
