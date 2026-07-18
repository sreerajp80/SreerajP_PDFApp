import 'package:flutter/widgets.dart';
import 'package:pdfrx/pdfrx.dart' hide PdfDocumentRef;

/// Wraps the `pdfrx` [PdfViewer] to provide pinch-to-zoom that works
/// regardless of how far apart the user's fingers are when they touch down.
///
/// ## The problem
///
/// Flutter's [ScaleGestureRecognizer] reconfigures silently when a second
/// pointer arrives during an ongoing one-finger pan. The forked
/// `InteractiveViewer` inside pdfrx inherits this: it starts the gesture as
/// "pan" with one finger and resets its initial span when the second finger
/// lands — but does *not* re-fire `onScaleStart`, so its internal reference
/// focal point remains stale. The transition from pan to scale often works
/// only when both fingers land nearly simultaneously at the same spot.
///
/// ## How the wrapper fixes it
///
/// A transparent [Listener] sits on top of the `PdfViewer` and tracks raw
/// pointer events without joining the gesture arena. When it detects two or
/// more active pointers whose distance is changing, it computes a scale
/// factor and applies it by directly manipulating the
/// [PdfViewerController.value] matrix — no animation, instant response.
/// Because [Listener] never claims pointers, pdfrx's own one-finger pan and
/// fling still work unhindered.
///
/// To prevent pdfrx's internal scale handler from double-zooming, pass
/// `scaleEnabled: false` in [PdfViewerParams] when using this wrapper.
class PinchZoomWrapper extends StatefulWidget {
  const PinchZoomWrapper({
    super.key,
    required this.controller,
    required this.child,
    this.maxZoom = 8.0,
    this.minZoom = 0.1,
  });

  /// The same controller passed to [PdfViewer].
  final PdfViewerController controller;

  /// The [PdfViewer] widget tree.
  final Widget child;

  /// Upper zoom bound.
  final double maxZoom;

  /// Lower zoom bound.
  final double minZoom;

  @override
  State<PinchZoomWrapper> createState() => _PinchZoomWrapperState();
}

class _PinchZoomWrapperState extends State<PinchZoomWrapper> {
  /// Active pointer positions keyed by pointer ID.
  final Map<int, Offset> _pointers = {};

  /// The distance between the first two pointers when the pinch began.
  double? _initialSpan;

  /// The zoom level when the pinch began.
  double? _baseZoom;

  /// The document-layout coordinate under the focal point at pinch start.
  /// Computed once from the inverse of the current matrix.
  Offset? _docFocal;

  /// The widget-local focal point when the pinch started.
  Offset? _baseFocalLocal;

  // ------------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------------

  /// Returns the two pointer IDs that are currently tracked.
  List<int> get _twoPointers {
    final keys = _pointers.keys.toList();
    return keys.length >= 2 ? keys.sublist(0, 2) : keys;
  }

  /// Euclidean distance between the two tracked pointers.
  double _currentSpan() {
    final ids = _twoPointers;
    final a = _pointers[ids[0]]!;
    final b = _pointers[ids[1]]!;
    return (a - b).distance;
  }

  /// Midpoint between the two tracked pointers (in widget-local coordinates).
  Offset _currentFocal() {
    final ids = _twoPointers;
    final a = _pointers[ids[0]]!;
    final b = _pointers[ids[1]]!;
    return Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
  }

  // ------------------------------------------------------------------
  // Pointer event callbacks
  // ------------------------------------------------------------------

  void _onPointerDown(PointerDownEvent event) {
    _pointers[event.pointer] = event.localPosition;
    if (_pointers.length == 2) {
      _startPinch();
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_pointers.containsKey(event.pointer)) {
      return;
    }
    _pointers[event.pointer] = event.localPosition;

    if (_pointers.length >= 2 && _initialSpan != null) {
      _updatePinch();
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _pointers.remove(event.pointer);
    if (_pointers.length < 2) {
      _endPinch();
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _pointers.remove(event.pointer);
    if (_pointers.length < 2) {
      _endPinch();
    }
  }

  // ------------------------------------------------------------------
  // Pinch logic
  // ------------------------------------------------------------------

  void _startPinch() {
    if (!widget.controller.isReady) {
      return;
    }
    _initialSpan = _currentSpan();
    _baseZoom = widget.controller.currentZoom;
    _baseFocalLocal = _currentFocal();

    // Compute the document-layout point under the focal midpoint once.
    final invMatrix = Matrix4.inverted(widget.controller.value);
    _docFocal = _applyMatrix(invMatrix, _baseFocalLocal!);
  }

  void _updatePinch() {
    if (_initialSpan == null ||
        _baseZoom == null ||
        _docFocal == null) {
      return;
    }
    if (!widget.controller.isReady) {
      return;
    }

    final span = _currentSpan();
    if (_initialSpan! < 1.0) {
      return; // avoid division by near-zero
    }

    final rawZoom = _baseZoom! * (span / _initialSpan!);
    final clampedZoom = rawZoom.clamp(widget.minZoom, widget.maxZoom);

    // Build a new matrix that zooms around the pinch focal point.
    // The document position under the focal point stays fixed on screen.
    final currentFocal = _currentFocal();
    final m = Matrix4.identity();
    m.setEntry(0, 0, clampedZoom);
    m.setEntry(1, 1, clampedZoom);
    m.setEntry(0, 3, currentFocal.dx - _docFocal!.dx * clampedZoom);
    m.setEntry(1, 3, currentFocal.dy - _docFocal!.dy * clampedZoom);

    widget.controller.value = m;
  }

  void _endPinch() {
    _initialSpan = null;
    _baseZoom = null;
    _docFocal = null;
    _baseFocalLocal = null;
  }

  // ------------------------------------------------------------------
  // Build
  // ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Listener(
      // Listener doesn't join the gesture arena, so pdfrx's pan still works.
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}

/// Transforms [point] through [matrix] using the full perspective division.
Offset _applyMatrix(Matrix4 matrix, Offset point) {
  final s = matrix.storage;
  final w = point.dx * s[3] + point.dy * s[7] + s[15];
  return Offset(
    (point.dx * s[0] + point.dy * s[4] + s[12]) / w,
    (point.dx * s[1] + point.dy * s[5] + s[13]) / w,
  );
}
