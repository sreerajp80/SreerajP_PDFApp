import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Hide pdfrx's PdfDocumentRef — this app has its own domain type of that name.
import 'package:pdfrx/pdfrx.dart' hide PdfDocumentRef;
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
import 'package:pdfapp/features/viewer/presentation/widgets/viewer_error_view.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfapp/features/extraction/presentation/widgets/extraction_dialog.dart';
import 'package:pdfapp/features/page_ops/presentation/page_ops_sheet.dart';

/// Inverts page colors for night reading (project rule: comfortable dark read).
const ColorFilter _invertFilter = ColorFilter.matrix(<double>[
  -1, 0, 0, 0, 255, //
  0, -1, 0, 0, 255, //
  0, 0, -1, 0, 255, //
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
    setState(() {
      _document = document;
      _textSource = source;
      _search = search;
    });
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

  // --- Search (Phase 2) ---

  /// Repaints the pages when the results change.
  ///
  /// The highlights are drawn by a paint callback inside pdfrx, so a Flutter
  /// rebuild alone does not redraw them — the viewer has to be told the pages
  /// are out of date. This is how pdfrx's own text searcher does it too.
  void _onSearchChanged() {
    if (_controller.isReady) _controller.invalidate();
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
              actions: _error != null ? null : _buildActions(context, l10n),
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
        // Select-and-copy, but only where there is real text to select.
        enableTextSelection: _textUsable,
        pagePaintCallbacks: [if (search != null) _paintMatches],
      ),
    );

    return _invert
        ? ColorFiltered(colorFilter: _invertFilter, child: viewer)
        : viewer;
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

  List<Widget> _buildActions(BuildContext context, AppLocalizations l10n) {
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
        icon: Icon(_invert ? Icons.brightness_5 : Icons.brightness_4_outlined),
        tooltip: l10n.invertColors,
        onPressed: _toggleInvert,
      ),
      IconButton(
        icon: const Icon(Icons.grid_view_outlined),
        tooltip: l10n.thumbnailsTitle,
        onPressed: _document == null ? null : _showThumbnails,
      ),
      IconButton(
        icon: const Icon(Icons.list_alt_outlined),
        tooltip: l10n.contentsTitle,
        onPressed: _document == null
            ? null
            : () => _scaffoldKey.currentState?.openEndDrawer(),
      ),
      PopupMenuButton<_ViewerMenu>(
        onSelected: (item) => switch (item) {
          _ViewerMenu.continuous => _setViewMode(PdfViewMode.continuous),
          _ViewerMenu.single => _setViewMode(PdfViewMode.single),
          _ViewerMenu.book => _setViewMode(PdfViewMode.book),
          _ViewerMenu.fitWidth => _fitWidth(),
          _ViewerMenu.fitPage => _fitPage(),
          _ViewerMenu.details => _showDetails(),
          _ViewerMenu.extract => _showExtractionDialog(),
          _ViewerMenu.pageOps => _showPageOps(),
        },
        itemBuilder: (context) => [
          _checked(
            _ViewerMenu.continuous,
            l10n.viewModeContinuous,
            _viewMode == PdfViewMode.continuous,
          ),
          _checked(
            _ViewerMenu.single,
            l10n.viewModeSingle,
            _viewMode == PdfViewMode.single,
          ),
          _checked(
            _ViewerMenu.book,
            l10n.viewModeBook,
            _viewMode == PdfViewMode.book,
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: _ViewerMenu.fitWidth,
            child: Text(l10n.fitWidth),
          ),
          PopupMenuItem(value: _ViewerMenu.fitPage, child: Text(l10n.fitPage)),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: _ViewerMenu.details,
            child: Text(l10n.metadataAction),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: _ViewerMenu.extract,
            child: Text(l10n.extractAndConvert),
          ),
          PopupMenuItem(
            value: _ViewerMenu.pageOps,
            child: Text(l10n.pageToolsTitle),
          ),
        ],
      ),
    ];
  }

  PopupMenuItem<_ViewerMenu> _checked(
    _ViewerMenu value,
    String label,
    bool selected,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 18,
          ),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
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
  continuous,
  single,
  book,
  fitWidth,
  fitPage,
  details,
  extract,
  pageOps,
}
