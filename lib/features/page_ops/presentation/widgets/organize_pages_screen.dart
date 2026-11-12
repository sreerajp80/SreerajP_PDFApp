import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/errors/user_error_message.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/page_ops_result_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';
import 'package:pdfrx/pdfrx.dart';

/// One page in the organizer: which source page it is and how much extra
/// rotation the user has applied.
class _PageEntry {
  _PageEntry({required this.originalPage});
  final int originalPage;
  int rotation = 0; // 0 / 90 / 180 / 270
}

/// Full-screen editor to reorder, rotate, and delete pages visually (Feature 3.4).
///
/// Provides both a multi-column visual thumbnail grid view and a list view,
/// with multi-selection support, bulk rotate, bulk delete, and drag-and-drop reorder.
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
  final Set<int> _selectedIndices = {};
  bool _isGridView = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _entries = List.generate(
      widget.document.pages.length,
      (i) => _PageEntry(originalPage: i + 1),
    );
  }

  void _rotateSingle(_PageEntry entry) {
    setState(() => entry.rotation = (entry.rotation + 90) % 360);
  }

  void _deleteSingle(int index) {
    final l10n = AppLocalizations.of(context);
    final removed = _entries[index];
    setState(() {
      _entries.removeAt(index);
      _selectedIndices.remove(index);
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.bodyPageDeleted(removed.originalPage)),
          action: SnackBarAction(
            label: l10n.actionUndo,
            onPressed: () => setState(
              () => _entries.insert(index.clamp(0, _entries.length), removed),
            ),
          ),
        ),
      );
  }

  void _onReorderItem(int oldIndex, int newIndex) {
    setState(() {
      final item = _entries.removeAt(oldIndex);
      _entries.insert(newIndex, item);
      _selectedIndices.clear();
    });
  }

  void _toggleSelect(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedIndices.clear();
      _selectedIndices.addAll(List.generate(_entries.length, (i) => i));
    });
  }

  void _deselectAll() {
    setState(() => _selectedIndices.clear());
  }

  void _invertSelection() {
    setState(() {
      final newSelection = <int>{};
      for (var i = 0; i < _entries.length; i++) {
        if (!_selectedIndices.contains(i)) {
          newSelection.add(i);
        }
      }
      _selectedIndices.clear();
      _selectedIndices.addAll(newSelection);
    });
  }

  void _rotateSelected() {
    if (_selectedIndices.isEmpty) return;
    setState(() {
      for (final index in _selectedIndices) {
        if (index < _entries.length) {
          _entries[index].rotation = (_entries[index].rotation + 90) % 360;
        }
      }
    });
  }

  void _deleteSelected() {
    if (_selectedIndices.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    final count = _selectedIndices.length;
    final sorted = _selectedIndices.toList()..sort((a, b) => b.compareTo(a));
    final removed = <_PageEntry>[];

    setState(() {
      for (final idx in sorted) {
        if (idx < _entries.length) {
          removed.add(_entries.removeAt(idx));
        }
      }
      _selectedIndices.clear();
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.descPagesDeletedCount(count))),
      );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (_entries.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorNoPagesLeft)));
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
            title: l10n.titleOrganizeDone,
            outputPaths: [out],
          ),
        );
      }
    } catch (e, st) {
      AppLogger.error(
        'organize_pages_screen: operation failed',
        error: e,
        stackTrace: st,
      );
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userErrorMessage(l10n, e, fallback: l10n.errorOpFailed),
            ),
            action: SnackBarAction(
              label: l10n.actionTryAgain,
              onPressed: () {
                if (mounted && !_saving) _save();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final hasSelection = _selectedIndices.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          hasSelection
              ? l10n.descOrganizeSelectedCount(_selectedIndices.length)
              : l10n.titleOrganize,
        ),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView
                ? l10n.labelViewModeContinuous
                : l10n.titleThumbnails,
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
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
              label: Text(l10n.actionSave),
            ),
        ],
      ),
      bottomNavigationBar: hasSelection
          ? _buildSelectionBottomBar(l10n, theme)
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.helpOrganize,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ),
                if (!hasSelection)
                  TextButton.icon(
                    onPressed: _entries.isEmpty ? null : _selectAll,
                    icon: const Icon(Icons.select_all, size: 18),
                    label: Text(l10n.actionSelectAll),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _entries.isEmpty
                ? Center(child: Text(l10n.errorNoPagesLeft))
                : _isGridView
                ? _buildGridView(l10n, theme)
                : _buildListView(l10n, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionBottomBar(AppLocalizations l10n, ThemeData theme) {
    return BottomAppBar(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton.icon(
            onPressed: _deselectAll,
            icon: const Icon(Icons.close),
            label: Text(l10n.actionDeselectAll),
          ),
          TextButton.icon(
            onPressed: _invertSelection,
            icon: const Icon(Icons.swap_horiz),
            label: Text(l10n.actionInvertSelection),
          ),
          IconButton(
            icon: const Icon(Icons.rotate_right),
            tooltip: l10n.actionRotate,
            onPressed: _rotateSelected,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: l10n.actionDeletePage,
            onPressed: _deleteSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(AppLocalizations l10n, ThemeData theme) {
    final orientation = MediaQuery.of(context).orientation;
    final crossAxisCount = orientation == Orientation.portrait ? 3 : 5;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.72,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        final entry = _entries[index];
        final isSelected = _selectedIndices.contains(index);

        return LongPressDraggable<int>(
          data: index,
          feedback: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 100,
              height: 130,
              child: _buildThumbnailCard(entry, isSelected, theme, l10n, index),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _buildThumbnailCard(entry, isSelected, theme, l10n, index),
          ),
          child: DragTarget<int>(
            onWillAcceptWithDetails: (details) => details.data != index,
            onAcceptWithDetails: (details) =>
                _onReorderItem(details.data, index),
            builder: (context, candidateData, rejectedData) {
              return DecoratedBox(
                decoration: candidateData.isNotEmpty
                    ? BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : const BoxDecoration(),
                child: InkWell(
                  onTap: () => _toggleSelect(index),
                  child: _buildThumbnailCard(
                    entry,
                    isSelected,
                    theme,
                    l10n,
                    index,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// The page picture, turned by the rotation the user added, so the grid and
  /// the list show the page the way it will be saved.
  Widget _thumbnail(_PageEntry entry) => RotatedBox(
    quarterTurns: entry.rotation ~/ 90,
    child: PdfPageView(
      document: widget.document,
      pageNumber: entry.originalPage,
    ),
  );

  Widget _buildThumbnailCard(
    _PageEntry entry,
    bool isSelected,
    ThemeData theme,
    AppLocalizations l10n,
    int index,
  ) {
    return Card(
      elevation: isSelected ? 4 : 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
          width: isSelected ? 2.5 : 1,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Rendered page thumbnail, turned the way it will be saved.
          _thumbnail(entry),
          // Gradient bottom bar for readability
          Positioned.directional(
            textDirection: Directionality.of(context),
            bottom: 0,
            start: 0,
            end: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${entry.originalPage}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (entry.rotation != 0)
                    Text(
                      '${entry.rotation}°',
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Checkbox indicator
          PositionedDirectional(
            top: 4,
            start: 4,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? theme.colorScheme.primary : Colors.black38,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          // Individual rotate button
          PositionedDirectional(
            top: 0,
            end: 0,
            child: IconButton(
              icon: const Icon(Icons.rotate_right, size: 18),
              color: Colors.black87,
              tooltip: l10n.actionRotate,
              onPressed: () => _rotateSingle(entry),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(AppLocalizations l10n, ThemeData theme) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _entries.length,
      onReorderItem: _onReorderItem,
      itemBuilder: (context, index) {
        final entry = _entries[index];
        final isSelected = _selectedIndices.contains(index);
        return _buildRow(context, l10n, theme, entry, index, isSelected);
      },
    );
  }

  Widget _buildRow(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    _PageEntry entry,
    int index,
    bool isSelected,
  ) {
    return Card(
      key: ValueKey(entry),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      shape: isSelected
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: theme.colorScheme.primary, width: 2),
            )
          : null,
      child: InkWell(
        onTap: () => _toggleSelect(index),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleSelect(index),
              ),
              SizedBox(
                width: 56,
                height: 72,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    color: Colors.white,
                  ),
                  child: _thumbnail(entry),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.labelPage(entry.originalPage),
                      style: theme.textTheme.titleMedium,
                    ),
                    if (entry.rotation != 0)
                      Text(
                        l10n.labelRotatedBy(entry.rotation),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.rotate_right),
                tooltip: l10n.actionRotate,
                onPressed: () => _rotateSingle(entry),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: l10n.actionDeletePage,
                onPressed: () => _deleteSingle(index),
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
      ),
    );
  }
}
