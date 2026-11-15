import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/errors/user_error_message.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/page_ops_result_dialog.dart';
import 'package:pdfapp/features/sign_document/domain/placement_geometry.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:pdfapp/features/sign_document/domain/signature_placement.dart';
import 'package:pdfapp/features/sign_document/presentation/providers.dart';
import 'package:pdfapp/features/sign_document/presentation/widgets/placement_box.dart';
import 'package:pdfapp/features/signature/presentation/providers.dart';
import 'package:pdfapp/features/viewer/presentation/widgets/password_prompt.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfrx/pdfrx.dart';

/// What the placement screen needs: the open PDF and the chosen signature.
class SignRequest {
  const SignRequest({
    required this.path,
    required this.displayName,
    required this.document,
    required this.initialPage,
    required this.signature,
  });

  /// The cache path of the open PDF (the source; never changed).
  final String path;

  /// The original document's name, used to name the signed copy.
  final String displayName;
  final PdfDocument document;
  final int initialPage;
  final LoadedSignature signature;
}

/// Lets the user put the signature anywhere on any page, then writes a new
/// signed PDF (copy-on-write) and shows the usual Open / Save / Share result.
class SignPlacementScreen extends ConsumerStatefulWidget {
  const SignPlacementScreen({super.key, required this.request});

  final SignRequest request;

  @override
  ConsumerState<SignPlacementScreen> createState() =>
      _SignPlacementScreenState();
}

class _SignPlacementScreenState extends ConsumerState<SignPlacementScreen> {
  late int _page;
  final List<SignaturePlacement> _placements = [];
  int? _selected;
  bool _working = false;

  PdfDocument get _doc => widget.request.document;
  int get _pageCount => _doc.pages.length;
  double get _imageAspect => widget.request.signature.signature.aspectRatio;

  double _pageAspect(int page) {
    final p = _doc.pages[page - 1];
    return p.height > 0 ? p.width / p.height : 1;
  }

  @override
  void initState() {
    super.initState();
    _page = widget.request.initialPage.clamp(1, math.max(1, _pageCount));
    _addHere();
  }

  void _addHere() {
    var rect = PlacementGeometry.initialRect(
      imageAspect: _imageAspect,
      pageAspect: _pageAspect(_page),
    );
    // Step a new box down-right while it would sit exactly on another one, so
    // it is visible as a separate box.
    while (_placements.any((p) => p.page == _page && p.rect == rect)) {
      final moved = PlacementGeometry.move(rect, const Offset(0.03, 0.03));
      if (moved == rect) break;
      rect = moved;
    }
    _placements.add(SignaturePlacement(page: _page, rect: rect));
    _selected = _placements.length - 1;
  }

  void _goTo(int page) {
    if (page < 1 || page > _pageCount) return;
    setState(() {
      _page = page;
      _selected = null;
    });
  }

  void _update(int index, Rect rect) {
    setState(
      () => _placements[index] = _placements[index].copyWith(rect: rect),
    );
  }

  void _remove(int index) {
    setState(() {
      _placements.removeAt(index);
      _selected = null;
    });
  }

  Future<bool> _hasDigitalSignatures() async {
    try {
      return await ref
          .read(signatureRepositoryProvider)
          .hasSignatures(widget.request.path);
    } catch (_) {
      // If the check itself fails we cannot know; do not block signing.
      return false;
    }
  }

  Future<void> _done() async {
    if (_placements.isEmpty || _working) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _working = true);

    if (await _hasDigitalSignatures()) {
      if (!mounted) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.titleExistingSignatures),
          content: Text(l10n.bodyExistingSignatures),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.actionSignAnyway),
            ),
          ],
        ),
      );
      if (ok != true) {
        if (mounted) setState(() => _working = false);
        return;
      }
    }

    final service = ref.read(signDocumentServiceProvider);
    String? password;
    String out;
    while (true) {
      try {
        out = await service.sign(
          sourcePath: widget.request.path,
          displayName: widget.request.displayName,
          signature: widget.request.signature.signature,
          placements: List.of(_placements),
          password: password,
        );
        break;
      } on PdfPasswordRequiredException {
        if (!mounted) return;
        // Locked PDF: ask, then try again. Cancel stops without an error.
        password = await showPasswordPrompt(context);
        if (password == null) {
          if (mounted) setState(() => _working = false);
          return;
        }
      } catch (e, st) {
        AppLogger.error(
          'sign_placement: sign failed',
          error: e,
          stackTrace: st,
        );
        if (!mounted) return;
        setState(() => _working = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userErrorMessage(l10n, e, fallback: l10n.errorSignFailed),
            ),
          ),
        );
        return;
      }
    }
    // The password is not needed any more; drop it at once.
    password = null;

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) =>
          PageOpsResultDialog(title: l10n.titleSignedDone, outputPaths: [out]),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final pageAspect = _pageAspect(_page);
    final onPage = [
      for (var i = 0; i < _placements.length; i++)
        if (_placements[i].page == _page) i,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.titlePlaceSignature),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: FilledButton(
              onPressed: _placements.isEmpty || _working ? null : _done,
              child: Text(l10n.actionDone),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    l10n.descPlaceSignatureHelp,
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const pad = PlacementBox.handleRadius;
                      final maxW = constraints.maxWidth - pad * 2;
                      final maxH = constraints.maxHeight - pad * 2;
                      if (maxW <= 0 || maxH <= 0) return const SizedBox();
                      var w = maxW;
                      var h = w / pageAspect;
                      if (h > maxH) {
                        h = maxH;
                        w = h * pageAspect;
                      }
                      return Center(
                        child: SizedBox(
                          width: w + pad * 2,
                          height: h + pad * 2,
                          child: Stack(
                            children: [
                              Positioned(
                                left: pad,
                                top: pad,
                                width: w,
                                height: h,
                                child: GestureDetector(
                                  // Tapping the page itself clears the selection.
                                  onTap: () => setState(() => _selected = null),
                                  child: PdfPageView(
                                    key: ValueKey(_page),
                                    document: _doc,
                                    pageNumber: _page,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              for (final i in onPage)
                                _box(i, pad, w, h, pageAspect, l10n),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _bottomBar(l10n),
              ],
            ),
            if (_working) ...[
              const ModalBarrier(dismissible: false, color: Colors.black26),
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(width: 16),
                        Text(l10n.descSigning),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _box(
    int i,
    double pad,
    double w,
    double h,
    double pageAspect,
    AppLocalizations l10n,
  ) {
    final r = _placements[i].rect;
    return PlacementBox(
      // Keyed by position, not by value: the value changes on every drag
      // step, and a new key would rebuild the box and drop the finger.
      key: ValueKey(i),
      rect: Rect.fromLTWH(
        pad + r.left * w,
        pad + r.top * h,
        r.width * w,
        r.height * h,
      ),
      png: widget.request.signature.png,
      selected: _selected == i,
      onSelect: () => setState(() => _selected = i),
      onMove: (d) => _update(
        i,
        PlacementGeometry.move(_placements[i].rect, Offset(d.dx / w, d.dy / h)),
      ),
      onResize: (d) {
        final cur = _placements[i].rect;
        // Follow whichever way the finger moved more: across or down.
        final byX = cur.width + d.dx / w;
        final byY = PlacementGeometry.widthFor(
          cur.height + d.dy / h,
          imageAspect: _imageAspect,
          pageAspect: pageAspect,
        );
        final next = (byX - cur.width).abs() >= (byY - cur.width).abs()
            ? byX
            : byY;
        _update(
          i,
          PlacementGeometry.resize(
            cur,
            next,
            imageAspect: _imageAspect,
            pageAspect: pageAspect,
          ),
        );
      },
      onRemove: () => _remove(i),
      removeTooltip: l10n.tooltipRemovePlacement,
      resizeTooltip: l10n.tooltipResizeSignature,
      semanticLabel: l10n.descPlacedSignature,
    );
  }

  Widget _bottomBar(AppLocalizations l10n) {
    return Material(
      elevation: 2,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: l10n.tooltipPreviousPage,
              onPressed: _page > 1 && !_working ? () => _goTo(_page - 1) : null,
            ),
            Flexible(
              child: Text(
                l10n.descPageOfPages(_page, _pageCount),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              tooltip: l10n.tooltipNextPage,
              onPressed: _page < _pageCount && !_working
                  ? () => _goTo(_page + 1)
                  : null,
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _working ? null : () => setState(_addHere),
              icon: const Icon(Icons.add),
              label: Text(l10n.actionAddHere),
            ),
          ],
        ),
      ),
    );
  }
}
