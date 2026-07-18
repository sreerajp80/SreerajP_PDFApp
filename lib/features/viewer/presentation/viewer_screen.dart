import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// Hide pdfrx's PdfDocumentRef — this app has its own domain type of that name.
import 'package:pdfrx/pdfrx.dart' hide PdfDocumentRef;
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/features/signature/presentation/providers.dart';
import 'package:pdfapp/features/reading/data/pdf_text_source.dart';
import 'package:pdfapp/features/reading/data/tts_service.dart';
import 'package:pdfapp/features/reading/domain/text_quality.dart';
import 'package:pdfapp/features/reading/presentation/pdf_search_controller.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';
import 'package:pdfapp/features/reading/presentation/widgets/metadata_sheet.dart';
import 'package:pdfapp/features/reading/presentation/widgets/reader_search_bar.dart';
import 'package:pdfapp/features/reading/presentation/widgets/search_highlight_painter.dart';
import 'package:pdfapp/features/reading/presentation/widgets/text_quality_notice.dart';
import 'package:pdfapp/features/viewer/data/pdf_repository.dart';
import 'package:pdfapp/features/viewer/domain/pdf_document_ref.dart';
import 'package:pdfapp/features/viewer/domain/view_mode.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';
import 'package:pdfapp/features/viewer/presentation/widgets/outline_drawer.dart';
import 'package:pdfapp/features/viewer/presentation/widgets/page_jump_sheet.dart';
import 'package:pdfapp/features/viewer/presentation/widgets/page_layouts.dart';
import 'package:pdfapp/features/viewer/presentation/widgets/password_prompt.dart';
import 'package:pdfapp/features/viewer/presentation/widgets/thumbnail_grid.dart';
import 'package:pdfapp/features/viewer/presentation/widgets/pinch_zoom_wrapper.dart';
import 'package:pdfapp/features/viewer/presentation/widgets/viewer_error_view.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfapp/features/extraction/presentation/widgets/extraction_dialog.dart';
import 'package:pdfapp/features/page_ops/presentation/page_ops_sheet.dart';
import 'package:pdfapp/features/printer/presentation/widgets/print_sheet.dart';
import 'package:pdfapp/features/annotation/presentation/annotation_controller.dart';
import 'package:pdfapp/features/annotation/presentation/annotation_painter.dart';
import 'package:pdfapp/features/annotation/presentation/providers.dart';
import 'package:pdfapp/features/annotation/presentation/widgets/annotation_overlay_notice.dart';
import 'package:pdfapp/features/annotation/presentation/widgets/annotation_toolbar.dart';
import 'package:pdfapp/features/annotation/presentation/widgets/bookmarks_panel.dart';
import 'package:pdfapp/features/annotation/presentation/widgets/page_annotation_layer.dart';
import 'package:pdfapp/features/signature/domain/pdf_signature.dart';
import 'package:pdfapp/features/signature/domain/signature_status.dart';

/// Inverts page colors for night reading (project rule: comfortable dark read).
const ColorFilter _invertFilter = ColorFilter.matrix(<double>[
  -1, 0, 0, 0, 255, //
  0, -1, 0, 0, 255, //
  0, 0, -1, 0, 255, //
  0, 0, 0, 1, 0, //
]);

/// Identity color matrix (does nothing, keeps colors original).
const ColorFilter _identityFilter = ColorFilter.matrix(<double>[
  1, 0, 0, 0, 0, //
  0, 1, 0, 0, 0, //
  0, 0, 1, 0, 0, //
  0, 0, 0, 1, 0, //
]);

/// The PDF reader. Opens a [PdfDocumentRef] with `pdfrx`, restores the last-read
/// page, and offers view modes, zoom/fit, night colors, contents, thumbnails,
/// and page jump. Broken / empty / encrypted files show a friendly state and
/// never crash.
class ViewerScreen extends ConsumerStatefulWidget {
  const ViewerScreen({super.key, required this.docRef});

  final PdfDocumentRef docRef;

  @override
  ConsumerState<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends ConsumerState<ViewerScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = PdfViewerController();
  final _viewerKey = GlobalKey();

  // Captured once so dispose() can save without touching a disposed ref.
  late final PdfRepository _repo = ref.read(pdfRepositoryProvider);

  late PdfViewMode _viewMode;
  bool _invert = false;
  bool _positionLoaded = false;
  int _initialPage = 1;

  PdfDocument? _document;
  int _currentPage = 1;
  int _pageCount = 0;

  ViewerErrorKind? _error;
  int _reloadKey = 0; // bump to force a fresh PdfViewer (retry).
  Timer? _saveTimer;
  bool _largeWarningShown = false;

  // --- Zoom Preservation ---
  Matrix4? _lastMatrix;
  Size? _lastMatrixViewSize;
  bool _restoringMatrix = false;

  // --- Reading (Phase 2) ---

  /// Built once the document opens; owns text extraction for search and copy.
  PdfTextSource? _textSource;
  PdfSearchController? _search;

  /// Whether this PDF has usable text. Null until the check has run — the
  /// reading controls stay quiet rather than guessing.
  TextQuality? _textQuality;
  bool _noticeDismissed = false;
  bool _searching = false;
  bool _ttsActive = false;

  // --- Annotation (Phase 5) ---

  /// Overlay-annotation state for this file. Built once the document opens.
  AnnotationController? _annotate;

  /// Whether the annotation toolbar is showing. Separate from the active tool
  /// so the strip can be open before a tool is picked.
  bool _annotateMode = false;

  /// Dismissed for this session once the "in-app only" banner is closed.
  bool _annotationNoticeDismissed = false;

  /// Cached signature verdicts (Phase 7).
  List<SignatureVerdict>? _currentVerdicts;

  /// True when search / copy can honestly be offered.
  bool get _textUsable => _textQuality == TextQuality.good;

  @override
  void initState() {
    super.initState();
    // A zero-byte file has nothing to render.
    if (widget.docRef.sizeBytes == 0) {
      _viewMode = PdfViewMode.continuous;
      _positionLoaded = true;
      _error = ViewerErrorKind.empty;
      return;
    }
    _loadPosition();
    _controller.addListener(_onMatrixChanged);
  }

  Future<void> _loadPosition() async {
    final saved = await _repo.positionFor(widget.docRef.fingerprint);
    if (!mounted) return;
    setState(() {
      // Large files open one page at a time unless the user chose otherwise.
      _viewMode =
          saved?.viewMode ??
          (widget.docRef.isLarge ? PdfViewMode.single : PdfViewMode.continuous);
      _initialPage = saved?.lastPage ?? 1;
      _currentPage = _initialPage;
      _positionLoaded = true;
    });
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _flushSave();
    _search
      ?..removeListener(_onSearchChanged)
      ..dispose();
    _annotate
      ?..removeListener(_onAnnotationsChanged)
      ..dispose();
    _controller.removeListener(_onMatrixChanged);
    // Stop speaking when leaving the viewer screen.
    ref.read(ttsServiceProvider).stop();
    super.dispose();
  }

  // --- Saving the reading position ---

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), _flushSave);
  }

  void _flushSave() {
    if (!_positionLoaded || _error != null || _pageCount == 0) return;
    // Fire-and-forget: leaving the screen must not block on the DB.
    unawaited(
      _repo.savePosition(
        fingerprint: widget.docRef.fingerprint,
        lastPage: _currentPage,
        viewMode: _viewMode,
      ),
    );
  }

  // --- pdfrx callbacks ---

  Future<String?> _passwordProvider() => showPasswordPrompt(context);

  void _onViewerReady(PdfDocument document, PdfViewerController controller) {
    _pageCount = document.pages.length;
    if (_pageCount == 0) {
      setState(() => _error = ViewerErrorKind.empty);
      return;
    }
    final source = PdfTextSource(document);
    final search = PdfSearchController(source: source)
      ..addListener(_onSearchChanged);
    final annotate = AnnotationController(
      repository: ref.read(annotationRepositoryProvider),
      fingerprint: widget.docRef.fingerprint,
      sourcePath: widget.docRef.cachePath,
    )..addListener(_onAnnotationsChanged);
    setState(() {
      _document = document;
      _textSource = source;
      _search = search;
      _annotate = annotate;
    });
    unawaited(annotate.load());
    unawaited(_repo.recordPageCount(widget.docRef.fingerprint, _pageCount));
    unawaited(_checkTextQuality(source));
    if (widget.docRef.isLarge && !_largeWarningShown) {
      _largeWarningShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showLargeWarning());
    }
  }

  /// Works out whether this PDF has usable text, which decides whether search
  /// and copy are offered at all.
  Future<void> _checkTextQuality(PdfTextSource source) async {
    final quality = await source.quality();
    // The reader may have left, or reloaded onto a different document.
    if (!mounted || !identical(_textSource, source)) return;
    setState(() => _textQuality = quality);
  }

  void _onPageChanged(int? pageNumber) {
    if (pageNumber == null) return;
    _currentPage = pageNumber;
    _scheduleSave();
    setState(() {}); // refresh the page indicator
  }

  // 4th param is pdfrx's PdfDocumentRef (hidden here); typed as Object so we
  // don't need to name it. Contravariance makes this assignable to the typedef.
  Widget _errorBanner(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
    Object documentRef,
  ) {
    final kind = _kindFor(error);
    return ViewerErrorView(kind: kind, onRetry: _retry);
  }

  ViewerErrorKind _kindFor(Object error) {
    if (error is PdfPasswordException) return ViewerErrorKind.password;
    final message = error.toString().toLowerCase();
    if (message.contains('empty') || message.contains('no page')) {
      return ViewerErrorKind.empty;
    }
    return ViewerErrorKind.corrupt;
  }

  // --- Actions ---

  void _retry() => setState(() => _reloadKey++);

  void _setViewMode(PdfViewMode mode) {
    setState(() => _viewMode = mode);
    _scheduleSave();
  }

  void _toggleInvert() => setState(() => _invert = !_invert);

  void _fitWidth() {
    if (_controller.isReady) {
      _controller.setZoom(_controller.centerPosition, _controller.coverScale);
    }
  }

  void _fitPage() {
    if (_controller.isReady) {
      _controller.setZoom(
        _controller.centerPosition,
        _controller.alternativeFitScale ?? _controller.coverScale,
      );
    }
  }

  void _resetZoom() {
    if (_controller.isReady) {
      _controller.setZoom(_controller.centerPosition, 1.0);
    }
  }

  Future<void> _jumpToPage() async {
    if (_document == null) return;
    final target = await showPageJumpSheet(
      context,
      pageCount: _pageCount,
      currentPage: _currentPage,
    );
    if (target != null) await _controller.goToPage(pageNumber: target);
  }

  void _showThumbnails() {
    final document = _document;
    if (document == null) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.85,
        child: ThumbnailGrid(
          document: document,
          currentPage: _currentPage,
          onSelect: (page) {
            Navigator.of(context).pop();
            _controller.goToPage(pageNumber: page);
          },
        ),
      ),
    );
  }

  void _showDetails() => unawaited(showMetadataSheet(context, widget.docRef));

  void _showExtractionDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => ExtractionDialog(
        path: widget.docRef.cachePath,
        currentPage: _currentPage,
        totalPages: _pageCount,
      ),
    );
  }

  void _showPageOps() {
    final document = _document;
    if (document == null) return;
    unawaited(
      showPageOpsSheet(
        context,
        path: widget.docRef.cachePath,
        document: document,
      ),
    );
  }

  /// Signature check for the open document (Phase 7).
  void _showSignatures() {
    if (_document == null) return;
    context.pushNamed(AppRoute.signatures.name, extra: widget.docRef.cachePath);
  }

  /// Print options for the open document (Phase 6).
  void _showPrint() {
    if (_document == null) return;
    unawaited(
      showPrintSheet(
        context,
        path: widget.docRef.cachePath,
        jobName: widget.docRef.displayName,
        pageCount: _pageCount,
      ),
    );
  }

  // --- Search (Phase 2) ---

  /// Repaints the pages when the results change.
  ///
  /// The highlights are drawn by a paint callback inside pdfrx, so a Flutter
  /// rebuild alone does not redraw them — the viewer has to be told the pages
  /// are out of date. This is how pdfrx's own text searcher does it too.
  void _onSearchChanged() {
    if (_controller.isReady) _controller.invalidate();
  }

  void _onMatrixChanged() {
    if (!_controller.isReady) return;
    if (_restoringMatrix) return;

    final currentSize = _controller.viewSize;
    if (_lastMatrix != null &&
        _lastMatrixViewSize != null &&
        _lastMatrixViewSize != currentSize) {
      _restoringMatrix = true;
      _controller.goTo(_lastMatrix!, duration: Duration.zero);
      _restoringMatrix = false;
      _lastMatrixViewSize = currentSize;
      return;
    }

    _lastMatrix = _controller.value;
    _lastMatrixViewSize = currentSize;
  }

  // --- Annotation (Phase 5) ---

  /// Repaints the pages when marks change and, the first time a mark is added,
  /// shows the "these marks live only in this app" notice.
  void _onAnnotationsChanged() {
    if (_controller.isReady) _controller.invalidate();
    final annotate = _annotate;
    if (annotate != null &&
        annotate.hasAnnotations &&
        !annotate.noticeShown &&
        !_annotationNoticeDismissed) {
      annotate.markNoticeShown();
    }
    setState(() {});
  }

  void _toggleAnnotateMode() {
    setState(() {
      _annotateMode = !_annotateMode;
      if (!_annotateMode) {
        _annotate?.setTool(AnnotationTool.none);
      }
    });
  }

  void _explainNoTextMarkup() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).annotationTextMarkupUnavailable,
        ),
      ),
    );
  }

  void _showBookmarks() {
    final annotate = _annotate;
    if (annotate == null) return;
    unawaited(
      showBookmarksPanel(
        context,
        controller: annotate,
        currentPage: _currentPage,
        onJump: (page) => _controller.goToPage(pageNumber: page),
      ),
    );
  }

  Future<void> _confirmClearAll() async {
    final annotate = _annotate;
    if (annotate == null) return;
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.annotationClearAllTitle),
        content: Text(l10n.annotationClearAllMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelAction),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.annotationClearAll),
          ),
        ],
      ),
    );
    if (ok == true) await annotate.clearAll();
  }

  Future<void> _exportAnnotations() async {
    final annotate = _annotate;
    if (annotate == null) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (!annotate.hasAnnotations) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.annotationNothingToExport)),
      );
      return;
    }
    messenger.showSnackBar(SnackBar(content: Text(l10n.annotationExporting)));
    try {
      final outPath = await annotate.exportCopy();
      final name =
          'annotated_${widget.docRef.displayName.replaceAll(RegExp(r'\.pdf$'), '')}.pdf';
      final saved = await annotate.saveToDevice(outPath, name);
      if (!mounted) return;
      if (saved != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.savedFileMessage(saved))),
        );
      }
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.annotationExportFailed)),
      );
    }
  }

  /// Draws the stored overlay annotations over the page pdfrx is painting.
  void _paintAnnotations(Canvas canvas, Rect pageRect, PdfPage page) {
    final annotate = _annotate;
    if (annotate == null || annotate.annotations.isEmpty) return;
    AnnotationPainter(
      annotations: annotate.annotations,
    ).paint(canvas, pageRect, page);
  }

  /// Draws validation overlays on top of signature fields to override their static
  /// pre-signed status appearances.
  void _paintSignatureOverlays(Canvas canvas, Rect pageRect, PdfPage page) {
    final list = _currentVerdicts;
    if (list == null || list.isEmpty) return;

    for (final verdict in list) {
      final pos = verdict.signature.position;
      if (pos == null) continue;
      // SignaturePosition holds 0-indexed page indices.
      // PdfPage pageNumber is 1-indexed.
      if (pos.pageIndex != page.pageNumber - 1) continue;

      _drawSignatureOverlay(canvas, pageRect, page, verdict, pos);
    }
  }

  void _drawSignatureOverlay(
    Canvas canvas,
    Rect pageRect,
    PdfPage page,
    SignatureVerdict verdict,
    SignaturePosition pos,
  ) {
    final rect = PdfRect(pos.x, pos.y + pos.height, pos.x + pos.width, pos.y)
        .toRect(page: page, scaledPageSize: pageRect.size)
        .translate(pageRect.left, pageRect.top);

    // 1. Resolve visual state (Always in English for document compliance)
    final String statusText;
    final Color tickColor;
    final bool isTrusted;
    final bool isInvalid;

    switch (verdict.status) {
      case SignatureStatus.trusted:
        statusText = 'Signature valid';
        tickColor = const Color(0xFF00C853).withValues(alpha: 0.65); // Softer green
        isTrusted = true;
        isInvalid = false;
        break;
      case SignatureStatus.validNotTrusted:
        statusText = 'Signature valid, untrusted';
        tickColor = const Color(0xFFFF9100).withValues(alpha: 0.65); // Softer orange
        isTrusted = false;
        isInvalid = false;
        break;
      case SignatureStatus.invalid:
        statusText = 'Signature invalid';
        tickColor = const Color(0xFFFF1744).withValues(alpha: 0.65); // Softer red
        isTrusted = false;
        isInvalid = true;
        break;
      case SignatureStatus.unknown:
        statusText = 'Signature could not be verified';
        tickColor = const Color(0xFF757575).withValues(alpha: 0.65); // Softer grey
        isTrusted = false;
        isInvalid = false;
        break;
    }

    // 2. Draw solid white background to cover the static "Signature Not Verified" and yellow "?"
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, bgPaint);

    // 3. Draw a large, high-fidelity checkmark or cross in the background
    final checkWidth = rect.width;
    final checkHeight = rect.height;
    final minDimension = checkWidth < checkHeight ? checkWidth : checkHeight;

    if (isTrusted || verdict.status == SignatureStatus.validNotTrusted || verdict.status == SignatureStatus.unknown) {
      // Large checkmark in the background
      final path = Path()
        ..moveTo(rect.left + checkWidth * 0.35, rect.top + checkHeight * 0.55)
        ..lineTo(rect.left + checkWidth * 0.48, rect.top + checkHeight * 0.75)
        ..lineTo(rect.left + checkWidth * 0.78, rect.top + checkHeight * 0.25);

      final strokeWidth = (minDimension * 0.08).clamp(2.0, 6.0);

      // Black outline/shadow for high visibility
      final outlinePaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 1.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, outlinePaint);

      // Colored tick
      final checkPaint = Paint()
        ..color = tickColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, checkPaint);
    } else if (isInvalid) {
      // Large red cross in the background
      final strokeWidth = (minDimension * 0.08).clamp(2.0, 6.0);
      final size = checkHeight * 0.25;
      final cx = rect.center.dx;
      final cy = rect.center.dy;

      final outlinePaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 1.5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(cx - size, cy - size), Offset(cx + size, cy + size), outlinePaint);
      canvas.drawLine(Offset(cx - size, cy + size), Offset(cx + size, cy - size), outlinePaint);

      final crossPaint = Paint()
        ..color = tickColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(cx - size, cy - size), Offset(cx + size, cy + size), crossPaint);
      canvas.drawLine(Offset(cx - size, cy + size), Offset(cx + size, cy - size), crossPaint);
    }

    // 4. Draw validation text on top
    const padding = 4.0;
    final textLeft = rect.left + padding;
    final maxTextWidth = rect.width - 2 * padding;

    if (maxTextWidth <= 10.0) return;

    final l10n = AppLocalizations.of(context);
    final signerName = verdict.signature.name?.trim().isNotEmpty == true
        ? verdict.signature.name!
        : (verdict.signature.signerCertificate?.commonName ?? l10n.signatureSignerUnknown);

    final signedAt = verdict.signature.bestSignedAt;

    // Direct Acrobat-style date formatting (e.g. 2026.07.08 20:04:40 IST)
    String formatPdfDate(DateTime dt) {
      final y = dt.year;
      final m = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      final h = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      final sec = dt.second.toString().padLeft(2, '0');
      var tzName = dt.timeZoneName;
      if (tzName == 'Coordinated Universal Time') tzName = 'UTC';
      return '$y.$m.$d $h:$min:$sec $tzName';
    }

    final dateStr = signedAt != null ? formatPdfDate(signedAt.toLocal()) : null;

    // Scale font sizes based on minDimension to fit narrow signature cards perfectly
    final titleSize = (minDimension * 0.11).clamp(5.0, 10.0);
    final bodySize = (minDimension * 0.085).clamp(4.0, 8.0);

    // Title status line
    final line1Painter = TextPainter(
      text: TextSpan(
        text: statusText,
        style: TextStyle(
          color: Colors.black,
          fontSize: titleSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxTextWidth);

    // Signer name line (supports natural word wrapping)
    final line2Painter = TextPainter(
      text: TextSpan(
        text: 'Digitally signed by $signerName',
        style: TextStyle(
          color: Colors.black,
          fontSize: bodySize,
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxTextWidth);

    // Signing date line (supports natural word wrapping)
    TextPainter? line3Painter;
    if (dateStr != null) {
      line3Painter = TextPainter(
        text: TextSpan(
          text: 'Date: $dateStr',
          style: TextStyle(
            color: Colors.black,
            fontSize: bodySize,
            fontWeight: FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: maxTextWidth);
    }

    final totalTextHeight = line1Painter.height + line2Painter.height + (line3Painter?.height ?? 0.0) + (line3Painter != null ? 4.0 : 2.0);
    var currentY = rect.top + (rect.height - totalTextHeight) / 2;

    line1Painter.paint(canvas, Offset(textLeft, currentY));
    currentY += line1Painter.height + 1.0;

    line2Painter.paint(canvas, Offset(textLeft, currentY));
    if (line3Painter != null) {
      currentY += line2Painter.height + 2.0;
      line3Painter.paint(canvas, Offset(textLeft, currentY));
    }
  }

  /// The per-page interactive layer (ink capture, note markers, text markup).
  List<Widget> _annotationOverlays(
    BuildContext context,
    Rect pageRect,
    PdfPage page,
  ) {
    final annotate = _annotate;
    if (annotate == null) return const [];
    return [
      PageAnnotationLayer(controller: annotate, page: page, pageRect: pageRect),
    ];
  }

  void _openSearch() {
    // Never a dead button: if there is no usable text, say why instead of
    // opening a search that could not work.
    if (!_textUsable) {
      _explainNoSearch();
      return;
    }
    setState(() => _searching = true);
  }

  void _explainNoSearch() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _textQuality == TextQuality.garbled
              ? l10n.searchUnavailableGarbled
              : l10n.searchUnavailableNoText,
        ),
      ),
    );
  }

  Future<void> _closeSearch() async {
    setState(() => _searching = false);
    await _search?.clear();
  }

  void _onQueryChanged(String query) {
    // Start from the page in front of the reader, so the nearest match is found
    // first.
    unawaited(_search?.search(query, startPage: _currentPage));
  }

  /// Jumps the viewer to the current match after the reader steps to it.
  void _goToCurrentMatch() {
    final hit = _search?.state.current;
    if (hit == null || !_controller.isReady) return;
    unawaited(_controller.goToPage(pageNumber: hit.pageNumber));
  }

  void _nextMatch() {
    _search?.next();
    _goToCurrentMatch();
  }

  void _previousMatch() {
    _search?.previous();
    _goToCurrentMatch();
  }

  void _showLargeWarning() {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.largeFileWarning)));
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final hasSignatures = ref
            .watch(hasSignaturesProvider(widget.docRef.cachePath))
            .valueOrNull ??
        false;

    ref.listen<TtsService>(ttsServiceProvider, (previous, next) {
      if (next.takeVoiceLostNotice()) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.ttsVoiceLostNotice)));
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: _searching
          ? _buildSearchAppBar()
          : AppBar(
              title: Text(
                widget.docRef.displayName,
                overflow: TextOverflow.ellipsis,
              ),
              actions: _error != null
                  ? null
                  : _buildActions(context, l10n, hasSignatures),
            ),
      endDrawer: _document == null
          ? null
          : OutlineDrawer(
              document: _document!,
              controller: _controller,
              onNavigate: () => Navigator.of(context).pop(),
            ),
      bottomNavigationBar: _error != null ? null : _buildBottomBar(l10n),
      body: Column(
        children: [
          if (_showNotice)
            TextQualityNotice(
              quality: _textQuality!,
              onDismiss: () => setState(() => _noticeDismissed = true),
            ),
          if (_showAnnotationNotice)
            AnnotationOverlayNotice(
              onDismiss: () =>
                  setState(() => _annotationNoticeDismissed = true),
            ),
          if (_annotateMode && _annotate != null)
            AnnotationToolbar(
              controller: _annotate!,
              textMarkupEnabled: _textUsable,
              onExport: () => unawaited(_exportAnnotations()),
              onClearAll: () => unawaited(_confirmClearAll()),
              onTextMarkupBlocked: _explainNoTextMarkup,
            ),
          Expanded(child: _buildBody(theme)),
        ],
      ),
    );
  }

  /// The notice only appears once there is something honest to say, and only
  /// while the reader is not busy searching.
  bool get _showNotice =>
      _error == null &&
      !_noticeDismissed &&
      !_searching &&
      _textQuality != null &&
      _textQuality != TextQuality.good;

  /// The overlay-only annotation banner appears once the file has a mark and
  /// until the reader dismisses it for the session.
  bool get _showAnnotationNotice =>
      _error == null &&
      !_searching &&
      !_annotationNoticeDismissed &&
      (_annotate?.hasAnnotations ?? false);

  /// The search bar takes over the app bar, the way find-in-page normally does.
  PreferredSizeWidget _buildSearchAppBar() {
    final search = _search;
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 104.0,
      title: ListenableBuilder(
        // Rebuilds as results stream in, so the counter keeps up.
        listenable: search!,
        builder: (context, _) => ReaderSearchBar(
          state: search.state,
          options: search.options,
          onQueryChanged: _onQueryChanged,
          onNext: _nextMatch,
          onPrevious: _previousMatch,
          onClose: () => unawaited(_closeSearch()),
          onOptionsChanged: (options) =>
              unawaited(search.setOptions(options, startPage: _currentPage)),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_error != null) {
      // For an up-front error (empty file) offer no retry; corrupt via banner does.
      return ViewerErrorView(kind: _error!);
    }
    if (!_positionLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final verdictsVal = ref.watch(signatureVerdictsProvider(widget.docRef.cachePath));
    _currentVerdicts = verdictsVal.valueOrNull;

    final search = _search;
    final viewer = PdfViewer.file(
      widget.docRef.cachePath,
      key: ValueKey(_reloadKey),
      controller: _controller,
      initialPageNumber: _initialPage,
      passwordProvider: _passwordProvider,
      params: PdfViewerParams(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        layoutPages: layoutFor(_viewMode),
        onViewerReady: _onViewerReady,
        onPageChanged: _onPageChanged,
        errorBannerBuilder: _errorBanner,
        // Disable pdfrx's built-in scale gesture. PinchZoomWrapper handles
        // all pinch-to-zoom using raw pointer events instead — this avoids
        // the Flutter gesture-arena issue where pinching with fingers that
        // start far apart is not detected.
        scaleEnabled: false,
        // Select-and-copy, but only where there is real text to select.
        // Turned off while drawing so a markup drag is not eaten by selection.
        enableTextSelection: _textUsable && !_annotateMode,
        pagePaintCallbacks: [
          if (search != null) _paintMatches,
          if (_annotate != null) _paintAnnotations,
          _paintSignatureOverlays,
        ],
        pageOverlaysBuilder: _annotate == null ? null : _annotationOverlays,
      ),
    );

    // PinchZoomWrapper intercepts two-finger gestures via raw Listener events
    // (outside the gesture arena) and applies zoom directly to the controller's
    // transformation matrix. Single-finger pan/fling still handled by pdfrx.
    final wrapped = PinchZoomWrapper(
      key: _viewerKey,
      controller: _controller,
      child: viewer,
    );

    return ColorFiltered(
      colorFilter: _invert ? _invertFilter : _identityFilter,
      child: wrapped,
    );
  }

  /// Draws the search matches over the page pdfrx is painting.
  void _paintMatches(Canvas canvas, Rect pageRect, PdfPage page) {
    final state = _search?.state;
    if (state == null || state.hits.isEmpty) return;

    final scheme = Theme.of(context).colorScheme;
    SearchHighlightPainter(
      hits: state.hits,
      current: state.current,
      matchColor: scheme.tertiary.withValues(alpha: 0.35),
      currentMatchColor: scheme.primary.withValues(alpha: 0.5),
    ).paint(canvas, pageRect, page);
  }

  List<Widget> _buildActions(
      BuildContext context, AppLocalizations l10n, bool hasSignatures) {
    return [
      IconButton(
        icon: const Icon(Icons.search),
        tooltip: l10n.searchAction,
        // Waits for the text check rather than guessing: pressing it before we
        // know would wrongly claim the PDF has no text. Once known, it either
        // searches or says why it cannot — never a silently dead button.
        onPressed: _document == null || _textQuality == null
            ? null
            : _openSearch,
      ),
      IconButton(
        icon: const Icon(Icons.volume_up),
        tooltip: l10n.ttsReadAloud,
        onPressed: _document == null || _textQuality == null
            ? null
            : () {
                if (!_textUsable) {
                  _explainNoTts();
                } else {
                  setState(() => _ttsActive = !_ttsActive);
                }
              },
      ),
      IconButton(
        icon: Icon(_annotateMode ? Icons.edit : Icons.edit_outlined),
        tooltip: l10n.annotateAction,
        isSelected: _annotateMode,
        onPressed: _document == null ? null : _toggleAnnotateMode,
      ),
      PopupMenuButton<_ViewerMenu>(
        onSelected: (item) => switch (item) {
          _ViewerMenu.invertColors => _toggleInvert(),
          _ViewerMenu.viewMode => _showViewModeDialog(),
          _ViewerMenu.pageFit => _showPageFitDialog(),
          _ViewerMenu.thumbnails => _showThumbnails(),
          _ViewerMenu.contents => _scaffoldKey.currentState?.openEndDrawer(),
          _ViewerMenu.bookmarks => _showBookmarks(),
          _ViewerMenu.details => _showDetails(),
          _ViewerMenu.extract => _showExtractionDialog(),
          _ViewerMenu.pageOps => _showPageOps(),
          _ViewerMenu.print => _showPrint(),
          _ViewerMenu.signatures => _showSignatures(),
          _ViewerMenu.settings => context.pushNamed(AppRoute.settings.name),
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _ViewerMenu.invertColors,
            child: Row(
              children: [
                Icon(
                  _invert ? Icons.brightness_5 : Icons.brightness_4_outlined,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Text(l10n.invertColors),
              ],
            ),
          ),
          PopupMenuItem(
            value: _ViewerMenu.viewMode,
            child: Row(
              children: [
                const Icon(Icons.visibility_outlined, size: 18),
                const SizedBox(width: 12),
                Text(l10n.viewModeTooltip),
              ],
            ),
          ),
          PopupMenuItem(
            value: _ViewerMenu.pageFit,
            child: Row(
              children: [
                const Icon(Icons.fit_screen_outlined, size: 18),
                const SizedBox(width: 12),
                Text(l10n.pageFit),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: _ViewerMenu.thumbnails,
            child: Row(
              children: [
                const Icon(Icons.grid_view_outlined, size: 18),
                const SizedBox(width: 12),
                Text(l10n.thumbnailsTitle),
              ],
            ),
          ),
          PopupMenuItem(
            value: _ViewerMenu.contents,
            child: Row(
              children: [
                const Icon(Icons.list_alt_outlined, size: 18),
                const SizedBox(width: 12),
                Text(l10n.contentsTitle),
              ],
            ),
          ),
          PopupMenuItem(
            value: _ViewerMenu.bookmarks,
            child: Row(
              children: [
                const Icon(Icons.bookmarks_outlined, size: 18),
                const SizedBox(width: 12),
                Text(l10n.bookmarksAction),
              ],
            ),
          ),
          PopupMenuItem(
            value: _ViewerMenu.details,
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18),
                const SizedBox(width: 12),
                Text(l10n.metadataAction),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: _ViewerMenu.extract,
            child: Row(
              children: [
                const Icon(Icons.transform_outlined, size: 18),
                const SizedBox(width: 12),
                Text(l10n.extractAndConvert),
              ],
            ),
          ),
          PopupMenuItem(
            value: _ViewerMenu.pageOps,
            child: Row(
              children: [
                const Icon(Icons.auto_stories_outlined, size: 18),
                const SizedBox(width: 12),
                Text(l10n.pageToolsTitle),
              ],
            ),
          ),
          PopupMenuItem(
            value: _ViewerMenu.print,
            child: Row(
              children: [
                const Icon(Icons.print_outlined, size: 18),
                const SizedBox(width: 12),
                Text(l10n.printAction),
              ],
            ),
          ),
          if (hasSignatures)
            PopupMenuItem(
              value: _ViewerMenu.signatures,
              child: Row(
                children: [
                  const Icon(Icons.draw_outlined, size: 18),
                  const SizedBox(width: 12),
                  Text(l10n.signaturesAction),
                ],
              ),
            ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: _ViewerMenu.settings,
            child: Row(
              children: [
                const Icon(Icons.settings_outlined, size: 18),
                const SizedBox(width: 12),
                Text(l10n.settingsTitle),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  Future<void> _showViewModeDialog() async {
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.viewModeTooltip),
          content: RadioGroup<PdfViewMode>(
            groupValue: _viewMode,
            onChanged: (value) {
              if (value != null) {
                _setViewMode(value);
                Navigator.of(context).pop();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<PdfViewMode>(
                  title: Text(l10n.viewModeContinuous),
                  value: PdfViewMode.continuous,
                ),
                RadioListTile<PdfViewMode>(
                  title: Text(l10n.viewModeSingle),
                  value: PdfViewMode.single,
                ),
                RadioListTile<PdfViewMode>(
                  title: Text(l10n.viewModeBook),
                  value: PdfViewMode.book,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancelAction),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPageFitDialog() async {
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.pageFit),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.swap_horiz_outlined),
                title: Text(l10n.fitWidth),
                onTap: () {
                  _fitWidth();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.fit_screen_outlined),
                title: Text(l10n.fitPage),
                onTap: () {
                  _fitPage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancelAction),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar(AppLocalizations l10n) {
    if (_ttsActive) {
      return _buildTtsBottomBar(l10n);
    }
    final indicator = _pageCount == 0
        ? ''
        : l10n.pageOfPages(_currentPage, _pageCount);
    return BottomAppBar(
      height: 56.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.zoom_out_map),
            tooltip: l10n.resetZoom,
            onPressed: _document == null ? null : _resetZoom,
          ),
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: _document == null ? null : _jumpToPage,
                child: Text(indicator),
              ),
            ),
          ),
          const SizedBox(
            width: 48,
          ), // spacer matching IconButton size to balance centering
        ],
      ),
    );
  }

  void _explainNoTts() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _textQuality == TextQuality.garbled
              ? l10n.ttsUnavailableGarbled
              : l10n.ttsUnavailableNoText,
        ),
      ),
    );
  }

  Future<void> _speakCurrentPage() async {
    final source = _textSource;
    if (source == null) return;

    final tts = ref.read(ttsServiceProvider);

    if (tts.status.isSpeaking && tts.status.speakingPage == _currentPage) {
      await tts.pause();
      return;
    }

    final pageData = await source.page(_currentPage);
    final text = pageData.text;
    if (text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).ttsNothingToRead),
          ),
        );
      }
      return;
    }

    await tts.speak(text, page: _currentPage);
  }

  Widget _buildTtsBottomBar(AppLocalizations l10n) {
    final tts = ref.watch(ttsServiceProvider);
    final status = tts.status;
    final isSpeaking = status.isSpeaking;
    final isPaused = status.isPaused;
    final speakingPage = status.speakingPage;

    return BottomAppBar(
      height: 56.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.cancelAction,
            onPressed: () {
              unawaited(tts.stop());
              setState(() => _ttsActive = false);
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isSpeaking
                  ? 'Reading page $speakingPage...'
                  : (isPaused ? 'Paused' : 'Ready to read page $_currentPage'),
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(isSpeaking ? Icons.pause : Icons.play_arrow),
            tooltip: isSpeaking ? l10n.ttsPause : l10n.ttsReadAloud,
            onPressed: _speakCurrentPage,
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            tooltip: l10n.ttsStop,
            onPressed: () => unawaited(tts.stop()),
          ),
        ],
      ),
    );
  }
}

enum _ViewerMenu {
  invertColors,
  viewMode,
  pageFit,
  thumbnails,
  contents,
  bookmarks,
  details,
  extract,
  pageOps,
  print,
  signatures,
  settings,
}
