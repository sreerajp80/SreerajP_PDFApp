import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
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

  @override
  void initState() {
    super.initState();
    // After the first frame so navigation/context is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleLaunchIntent();
      _listenForIncoming();
    });
  }

  @override
  void dispose() {
    _incomingSub?.cancel();
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

  Future<void> _openRecent(RecentFile recent) async {
    await _guardedOpen(
      () => ref.read(pdfRepositoryProvider).openFromRecent(recent),
      onError: (l10n) => l10n.reopenFailed,
    );
  }

  /// Runs an open action with a busy guard, error handling, navigation, and a
  /// recents refresh. [open] returns null when the user cancelled the picker.
  Future<void> _guardedOpen(
    Future<PdfDocumentRef?> Function() open, {
    String Function(AppLocalizations l10n)? onError,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    try {
      final ref0 = await open();
      if (ref0 == null || !mounted) return;
      await ref.read(recentFilesProvider.notifier).refresh();
      if (!mounted) return;
      await context.pushNamed(AppRoute.viewer.name, extra: ref0);
      // Timestamp changed on reopen — refresh ordering when we come back.
      if (mounted) await ref.read(recentFilesProvider.notifier).refresh();
    } on AppException catch (e) {
      if (mounted) {
        final message = onError?.call(l10n) ?? e.message;
        _showError(message);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final recents = ref.watch(recentFilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.openSettings,
            onPressed: () => context.pushNamed(AppRoute.settings.name),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy ? null : _openWithPicker,
        icon: const Icon(Icons.file_open_outlined),
        label: Text(l10n.openPdf),
      ),
      body: Column(
        children: [
          if (_busy) const LinearProgressIndicator(),
          Expanded(
            child: recents.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => _EmptyRecents(message: l10n.noRecentFiles),
              data: (files) => files.isEmpty
                  ? _EmptyRecents(message: l10n.noRecentFiles)
                  : _RecentsList(
                      files: files,
                      onOpen: _openRecent,
                      onRemove: (f) => ref
                          .read(recentFilesProvider.notifier)
                          .remove(f.fingerprint),
                    ),
            ),
          ),
        ],
      ),
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
    required this.onOpen,
    required this.onRemove,
  });

  final List<RecentFile> files;
  final ValueChanged<RecentFile> onOpen;
  final ValueChanged<RecentFile> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.recentFilesTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              final pages = file.pageCount;
              return ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: Text(file.displayName, overflow: TextOverflow.ellipsis),
                subtitle: pages == null ? null : Text(l10n.pagesLabel(pages)),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: l10n.removeFromRecents,
                  onPressed: () => onRemove(file),
                ),
                onTap: () => onOpen(file),
              );
            },
          ),
        ),
      ],
    );
  }
}
