import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/page_ops_result_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// One page in the organizer: which source page it is and how much extra
/// rotation the user has applied.
class _PageEntry {
  _PageEntry({required this.originalPage});
  final int originalPage;
  int rotation = 0; // 0 / 90 / 180 / 270
}

/// Full-screen editor to reorder, rotate, and delete pages, then save a new PDF.
///
/// This single screen covers three ops at once: drag to reorder, rotate to turn
/// a page, delete to drop it. Nothing is written until Save (copy-on-write).
class OrganizePagesScreen extends ConsumerStatefulWidget {
  const OrganizePagesScreen({
    super.key,
    required this.document,
    required this.path,
  });

  final PdfDocument document;
  final String path;

  @override
  ConsumerState<OrganizePagesScreen> createState() =>
      _OrganizePagesScreenState();
}

class _OrganizePagesScreenState extends ConsumerState<OrganizePagesScreen> {
  late List<_PageEntry> _entries;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _entries = List.generate(
      widget.document.pages.length,
      (i) => _PageEntry(originalPage: i + 1),
    );
  }

  void _rotate(_PageEntry entry) {
    setState(() => entry.rotation = (entry.rotation + 90) % 360);
  }

  void _delete(int index) {
    final l10n = AppLocalizations.of(context);
    final removed = _entries[index];
    setState(() => _entries.removeAt(index));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.pageDeletedMessage(removed.originalPage)),
          action: SnackBarAction(
            label: l10n.undoAction,
            onPressed: () => setState(
              () => _entries.insert(index.clamp(0, _entries.length), removed),
            ),
          ),
        ),
      );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _entries.removeAt(oldIndex);
      _entries.insert(newIndex, item);
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_entries.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.noPagesLeftError)));
      return;
    }
    setState(() => _saving = true);
    try {
      final service = ref.read(pageOpsServiceProvider);
      await service.clearOutputCache();
      final pages = _entries
          .map((e) => {'page': e.originalPage, 'rotation': e.rotation})
          .toList();
      final out = await service.organize(widget.path, pages);
      if (mounted) {
        Navigator.of(context).pop(); // leave the organizer
        showDialog<void>(
          context: context,
          builder: (context) => PageOpsResultDialog(
            title: l10n.organizeDoneTitle,
            outputPaths: [out],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.opFailed}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.organizeTitle),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton.icon(
              onPressed: _entries.isEmpty ? null : _save,
              icon: const Icon(Icons.save_alt),
              label: Text(l10n.saveAction),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              l10n.organizeHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _entries.isEmpty
                ? Center(child: Text(l10n.noPagesLeftError))
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _entries.length,
                    onReorder: _onReorder,
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      return _buildRow(context, l10n, theme, entry, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    _PageEntry entry,
    int index,
  ) {
    return Card(
      key: ValueKey(entry),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              height: 72,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  color: Colors.white,
                ),
                child: PdfPageView(
                  document: widget.document,
                  pageNumber: entry.originalPage,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pageLabel(entry.originalPage),
                    style: theme.textTheme.titleMedium,
                  ),
                  if (entry.rotation != 0)
                    Text(
                      l10n.rotatedBy(entry.rotation),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.rotate_right),
              tooltip: l10n.rotateAction,
              onPressed: () => _rotate(entry),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.deletePageAction,
              onPressed: () => _delete(index),
            ),
            ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.drag_handle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
