import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/errors/user_error_message.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/features/nearby_transfer/domain/send_item.dart';
import 'package:pdfapp/features/viewer/domain/pdf_document_ref.dart';
import 'package:pdfapp/features/viewer/domain/recent_file.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Home: open a PDF (system picker) and reopen from the recent-files list.
///
/// Also the landing point for "Open with" / share intents: the launch intent is
/// consumed once on start, and shared files that arrive while running are
/// handled through the incoming stream. A shared PDF opens in the viewer;
/// shared pictures or text go to the Import screen to become a new PDF
/// (Phase 6).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  StreamSubscription<IncomingContent>? _incomingSub;
  bool _busy = false;

  /// Re-checks which recent files are reachable when the app comes back: a
  /// file may have been deleted in another app meanwhile.
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    onResume: () => ref.invalidate(recentFileAvailabilityProvider),
  );

  /// Recent files picked for sending (by fingerprint). Not empty means Home is
  /// in selection mode: a long-press starts it, taps add or remove files.
  final Set<String> _selected = {};

  void _toggleSelected(RecentFile file) {
    setState(() {
      if (!_selected.remove(file.fingerprint)) _selected.add(file.fingerprint);
    });
  }

  void _clearSelection() => setState(_selected.clear);

  /// Opens the Send screen with the selected recent files.
  void _sendSelected(List<RecentFile> files) {
    final items = [
      for (final f in files)
        if (_selected.contains(f.fingerprint))
          SendItem(name: f.displayName, uri: f.uri),
    ];
    _clearSelection();
    if (items.isEmpty) return;
    context.pushNamed(AppRoute.sendFiles.name, extra: items);
  }

  @override
  void initState() {
    super.initState();
    _lifecycle; // Start listening (the field is lazy).
    // After the first frame so navigation/context is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleLaunchIntent();
      _listenForIncoming();
    });
  }

  @override
  void dispose() {
    _incomingSub?.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _handleLaunchIntent() async {
    final repo = ref.read(pdfRepositoryProvider);
    final content = await repo.launchIntent();
    if (content == null || !mounted) return;
    await _handleIncoming(content);
  }

  void _listenForIncoming() {
    final repo = ref.read(pdfRepositoryProvider);
    _incomingSub = repo.incoming.listen((content) {
      if (mounted) _handleIncoming(content);
    });
  }

  /// Sends shared content where it belongs: a PDF to the viewer, pictures or
  /// text to the Import screen that turns them into a new PDF.
  Future<void> _handleIncoming(IncomingContent content) async {
    switch (content) {
      case IncomingPdf(:final document):
        await _guardedOpen(
          () => ref.read(pdfRepositoryProvider).openFromIntent(document),
        );
      case IncomingImages():
      case IncomingText():
        await context.pushNamed(AppRoute.import.name, extra: content);
    }
  }

  Future<void> _openWithPicker() async {
    await _guardedOpen(() => ref.read(pdfRepositoryProvider).openWithPicker());
  }

  /// Reopens a recent file. If that fails (most often because short "Open
  /// with" access ended when the app closed), offers to find the file again
  /// or remove it, instead of a dead end.
  Future<void> _openRecent(RecentFile recent) async {
    final repo = ref.read(pdfRepositoryProvider);
    final opened = await _guardedOpen(
      () => repo.openFromRecent(recent),
      showErrors: false,
    );
    if (opened || !mounted) return;

    final choice = await showDialog<_ReopenChoice>(
      context: context,
      builder: (context) => _ReopenFailedDialog(fileName: recent.displayName),
    );
    if (!mounted) return;
    switch (choice) {
      case _ReopenChoice.find:
        await _guardedOpen(
          () => repo.relocateRecent(recent),
          onError: (l10n) => l10n.errorReopenFailed,
        );
      case _ReopenChoice.remove:
        await ref.read(recentFilesProvider.notifier).remove(recent.fingerprint);
      case null:
        break;
    }
  }

  /// Runs an open action with a busy guard, error handling, navigation, and a
  /// recents refresh. [open] returns null when the user cancelled the picker.
  ///
  /// Returns false only when opening failed. Errors are shown as a snack bar
  /// unless [showErrors] is false (the caller then handles the failure).
  Future<bool> _guardedOpen(
    Future<PdfDocumentRef?> Function() open, {
    String Function(AppLocalizations l10n)? onError,
    bool showErrors = true,
  }) async {
    if (_busy) return true;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    try {
      final ref0 = await open();
      if (ref0 == null || !mounted) return true;
      await ref.read(recentFilesProvider.notifier).refresh();
      if (!mounted) return true;
      await context.pushNamed(AppRoute.viewer.name, extra: ref0);
      // Timestamp changed on reopen — refresh ordering when we come back.
      if (mounted) await ref.read(recentFilesProvider.notifier).refresh();
      return true;
    } on AppException catch (e) {
      if (mounted && showErrors) {
        final message =
            onError?.call(l10n) ??
            userErrorMessage(l10n, e, fallback: l10n.errorOpenFailed);
        _showError(message);
      }
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final recents = ref.watch(recentFilesProvider);
    // Keeps the last answer while a new check runs, so rows do not flicker.
    final availability =
        ref.watch(recentFileAvailabilityProvider).value ??
        const <String, bool>{};
    final selecting = _selected.isNotEmpty;

    return PopScope(
      // Back first leaves selection mode, then leaves Home as usual.
      canPop: !selecting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && selecting) _clearSelection();
      },
      child: Scaffold(
        appBar: selecting
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: l10n.tooltipCancelSelection,
                  onPressed: _clearSelection,
                ),
                title: Text(l10n.labelSelectedCount(_selected.length)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.send_to_mobile_outlined),
                    tooltip: l10n.actionSendNearby,
                    onPressed: () =>
                        _sendSelected(recents.value ?? const <RecentFile>[]),
                  ),
                ],
              )
            : AppBar(
                title: Text(l10n.titleHome),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: l10n.labelOpenSettings,
                    onPressed: () => context.pushNamed(AppRoute.settings.name),
                  ),
                ],
              ),
        floatingActionButton: selecting
            ? null
            : FloatingActionButton.extended(
                onPressed: _busy ? null : _openWithPicker,
                icon: const Icon(Icons.file_open_outlined),
                label: Text(l10n.labelOpenPdf),
              ),
        body: Column(
          children: [
            if (_busy) const LinearProgressIndicator(),
            Expanded(
              child: recents.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => _EmptyRecents(message: l10n.emptyRecentFiles),
                data: (files) => files.isEmpty
                    ? _EmptyRecents(message: l10n.emptyRecentFiles)
                    : _RecentsList(
                        files: files,
                        availability: availability,
                        selected: _selected,
                        onOpen: (f) =>
                            selecting ? _toggleSelected(f) : _openRecent(f),
                        onLongPress: _toggleSelected,
                        onRemove: (f) => ref
                            .read(recentFilesProvider.notifier)
                            .remove(f.fingerprint),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ReopenChoice { find, remove }

/// Shown when a recent file cannot be reopened. Explains why and offers a way
/// forward, so the recents row is never a dead button.
class _ReopenFailedDialog extends StatelessWidget {
  const _ReopenFailedDialog({required this.fileName});

  final String fileName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.titleReopenFailed),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(fileName, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          Text(l10n.helpReopenFailed),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_ReopenChoice.remove),
          child: Text(l10n.labelRemoveFromRecents),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_ReopenChoice.find),
          child: Text(l10n.labelFindFileAgain),
        ),
      ],
    );
  }
}

class _EmptyRecents extends StatelessWidget {
  const _EmptyRecents({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.picture_as_pdf_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _RecentsList extends StatelessWidget {
  const _RecentsList({
    required this.files,
    required this.availability,
    required this.selected,
    required this.onOpen,
    required this.onLongPress,
    required this.onRemove,
  });

  final List<RecentFile> files;

  /// Fingerprint -> reachable. Only `false` marks a row; unknown looks normal.
  final Map<String, bool> availability;

  /// Fingerprints of the selected files. Not empty means selection mode.
  final Set<String> selected;
  final ValueChanged<RecentFile> onOpen;
  final ValueChanged<RecentFile> onLongPress;
  final ValueChanged<RecentFile> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
          child: Text(
            l10n.titleRecentFiles,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              final pages = file.pageCount;
              final isSelected = selected.contains(file.fingerprint);
              final unavailable = availability[file.fingerprint] == false;
              final colors = Theme.of(context).colorScheme;
              return ListTile(
                selected: isSelected,
                leading: selected.isNotEmpty
                    ? Icon(
                        isSelected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                      )
                    : unavailable
                    ? Icon(Icons.report_outlined, color: colors.error)
                    : const Icon(Icons.picture_as_pdf_outlined),
                title: Text(
                  file.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: unavailable
                      ? TextStyle(color: colors.onSurfaceVariant)
                      : null,
                ),
                subtitle: unavailable
                    ? Text(
                        l10n.descFileUnavailable,
                        style: TextStyle(color: colors.error),
                      )
                    : pages == null
                    ? null
                    : Text(l10n.descPageCount(pages)),
                trailing: selected.isEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: l10n.labelRemoveFromRecents,
                        onPressed: () => onRemove(file),
                      )
                    : null,
                onTap: () => onOpen(file),
                onLongPress: () => onLongPress(file),
              );
            },
          ),
        ),
      ],
    );
  }
}
