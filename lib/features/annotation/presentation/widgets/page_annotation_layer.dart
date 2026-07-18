import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/features/annotation/domain/annotation.dart';
import 'package:pdfapp/features/annotation/domain/annotation_geometry.dart';
import 'package:pdfapp/features/annotation/presentation/annotation_controller.dart';
import 'package:pdfapp/features/annotation/presentation/widgets/note_editor_dialog.dart';

/// The per-page interactive layer, returned from pdfrx's `pageOverlaysBuilder`.
///
/// It sits exactly over one page. Depending on the active tool it:
/// - **ink** — captures a freehand stroke and commits it;
/// - **highlight/underline/strikethrough** — drags a box over text, works out
///   which characters it covers (using the page's own character rectangles) and
///   commits one line-quad markup;
/// - **note** — places a sticky note where tapped;
/// - **eraser** — deletes the mark under a tap.
///
/// Sticky-note markers are always shown as small tappable icons.
class PageAnnotationLayer extends StatefulWidget {
  const PageAnnotationLayer({
    super.key,
    required this.controller,
    required this.page,
    required this.pageRect,
  });

  final AnnotationController controller;
  final PdfPage page;

  /// The page's rectangle in the viewer's coordinate space. Local (0,0) of this
  /// widget is [pageRect].topLeft, so local == screen − pageRect.topLeft.
  final Rect pageRect;

  @override
  State<PageAnnotationLayer> createState() => _PageAnnotationLayerState();
}

class _PageAnnotationLayerState extends State<PageAnnotationLayer> {
  Size get _size => widget.pageRect.size;

  // Live freehand stroke, in local (widget) coordinates.
  final List<Offset> _inkPoints = [];

  // Live text-markup drag box, in local coordinates.
  Rect? _markupBox;

  // Page text is loaded lazily the first time text markup is used, then cached.
  PdfPageText? _pageText;
  bool _loadingText = false;

  Offset _toUnit(Offset local) => Offset(
    AnnotationGeometry.clampUnit(local.dx / _size.width),
    AnnotationGeometry.clampUnit(local.dy / _size.height),
  );

  @override
  Widget build(BuildContext context) {
    final tool = widget.controller.tool;
    final notes = widget.controller
        .onPage(widget.page.pageNumber)
        .whereType<NoteAnnotation>()
        .toList();

    return SizedBox(
      width: _size.width,
      height: _size.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Gesture surface for the active tool.
          if (tool == AnnotationTool.ink)
            _inkGestures()
          else if (tool.isTextMarkup)
            _markupGestures(tool)
          else if (tool == AnnotationTool.note)
            _noteGestures()
          else if (tool == AnnotationTool.eraser)
            _eraserGestures(),

          // Live ink preview.
          if (_inkPoints.isNotEmpty)
            IgnorePointer(
              child: CustomPaint(
                size: _size,
                painter: _LiveInkPainter(
                  points: _inkPoints,
                  color: Color(widget.controller.color),
                  strokeWidth: (kInkStrokeWidth * _size.width).clamp(1.0, 40.0),
                ),
              ),
            ),

          // Live markup selection box.
          if (_markupBox != null)
            Positioned.fromRect(
              rect: _markupBox!,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(
                      widget.controller.color,
                    ).withValues(alpha: 0.25),
                    border: Border.all(color: Color(widget.controller.color)),
                  ),
                ),
              ),
            ),

          // Sticky-note markers (always tappable).
          for (final note in notes) _noteMarker(note),
        ],
      ),
    );
  }

  // --- Ink ---

  Widget _inkGestures() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (d) => setState(() {
        _inkPoints
          ..clear()
          ..add(d.localPosition);
      }),
      onPanUpdate: (d) => setState(() => _inkPoints.add(d.localPosition)),
      onPanEnd: (_) => _commitInk(),
    );
  }

  void _commitInk() {
    if (_inkPoints.length < 2) {
      setState(() => _inkPoints.clear());
      return;
    }
    final unit = _inkPoints.map(_toUnit).toList();
    widget.controller.addInkStroke(page: widget.page.pageNumber, points: unit);
    setState(() => _inkPoints.clear());
  }

  // --- Text markup ---

  Widget _markupGestures(AnnotationTool tool) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (d) => setState(
        () => _markupBox = Rect.fromPoints(d.localPosition, d.localPosition),
      ),
      onPanUpdate: (d) {
        final box = _markupBox;
        if (box == null) return;
        setState(
          () => _markupBox = Rect.fromPoints(box.topLeft, d.localPosition),
        );
      },
      onPanEnd: (_) => _commitMarkup(tool),
    );
  }

  Future<void> _commitMarkup(AnnotationTool tool) async {
    final box = _markupBox;
    final markupType = tool.creates;
    if (box == null || markupType == null) {
      setState(() => _markupBox = null);
      return;
    }
    // The drag box in viewer/screen space (char rects come back in that space).
    final screenBox = box.shift(widget.pageRect.topLeft);

    final text = await _ensureText();
    if (!mounted) return;

    final covered = <Rect>[];
    if (text != null) {
      for (final fragment in text.fragments) {
        for (final charRect in fragment.charRects) {
          final r = charRect.toRectInPageRect(
            page: widget.page,
            pageRect: widget.pageRect,
          );
          if (r.overlaps(screenBox)) {
            // Normalize to unit space (top-left origin, fraction of page).
            covered.add(AnnotationGeometry.normalizeRect(r, widget.pageRect));
          }
        }
      }
    }

    setState(() => _markupBox = null);
    if (covered.isEmpty) return;

    final quads = AnnotationGeometry.mergeIntoLineQuads(covered);
    await widget.controller.addMarkup(
      page: widget.page.pageNumber,
      markupType: markupType,
      quads: quads,
    );
  }

  Future<PdfPageText?> _ensureText() async {
    if (_pageText != null || _loadingText) return _pageText;
    _loadingText = true;
    try {
      _pageText = await widget.page.loadText();
    } catch (_) {
      _pageText = null;
    } finally {
      _loadingText = false;
    }
    return _pageText;
  }

  // --- Notes ---

  Widget _noteGestures() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (d) => _placeNote(d.localPosition),
    );
  }

  Future<void> _placeNote(Offset local) async {
    final result = await showNoteEditor(context);
    if (result == null || result.text.isEmpty) return;
    await widget.controller.addNote(
      page: widget.page.pageNumber,
      anchor: _toUnit(local),
      text: result.text,
    );
  }

  Widget _noteMarker(NoteAnnotation note) {
    final pos = Offset(
      note.anchor.dx * _size.width,
      note.anchor.dy * _size.height,
    );
    const markerSize = 28.0;
    return Positioned(
      left: pos.dx,
      top: pos.dy - markerSize,
      child: GestureDetector(
        onTap: () => _onNoteTapped(note),
        child: Tooltip(
          message: note.text,
          child: Container(
            width: markerSize,
            height: markerSize,
            decoration: BoxDecoration(
              color: Color(note.color ?? kNoteColor),
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: const Icon(
              Icons.sticky_note_2,
              size: 18,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onNoteTapped(NoteAnnotation note) async {
    // In eraser mode a tap deletes; otherwise it opens the editor.
    if (widget.controller.tool == AnnotationTool.eraser) {
      await widget.controller.delete(note);
      return;
    }
    final result = await showNoteEditor(
      context,
      initialText: note.text,
      isExisting: true,
    );
    if (result == null) return;
    if (result.deleted) {
      await widget.controller.delete(note);
    } else {
      await widget.controller.updateNoteText(note, result.text);
    }
  }

  // --- Eraser (markup and ink; notes handled by their marker) ---

  Widget _eraserGestures() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (d) => _eraseAt(d.localPosition),
    );
  }

  Future<void> _eraseAt(Offset local) async {
    final unit = _toUnit(local);
    // Search topmost-first so the most recent mark under the tap goes.
    final onPage = widget.controller.onPage(widget.page.pageNumber).reversed;
    for (final a in onPage) {
      if (_hits(a, unit)) {
        await widget.controller.delete(a);
        return;
      }
    }
  }

  bool _hits(Annotation a, Offset unit) {
    switch (a) {
      case MarkupAnnotation():
        return a.quads.any((q) => q.inflate(0.01).contains(unit));
      case InkAnnotation():
        for (final stroke in a.strokes) {
          for (final p in stroke.points) {
            if ((p - unit).distance < 0.02) return true;
          }
        }
        return false;
      case NoteAnnotation():
        return (a.anchor - unit).distance < 0.03;
      case BookmarkAnnotation():
        return false;
    }
  }
}

/// Paints the in-progress freehand stroke while the finger is down.
class _LiveInkPainter extends CustomPainter {
  _LiveInkPainter({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LiveInkPainter old) => old.points != points;
}
