import 'package:flutter/material.dart';
import 'package:pdfapp/features/annotation/presentation/annotation_controller.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Shows the page-bookmarks panel as a bottom sheet.
///
/// [onJump] navigates the viewer to a page. The current page is offered as an
/// add/remove toggle at the top.
Future<void> showBookmarksPanel(
  BuildContext context, {
  required AnnotationController controller,
  required int currentPage,
  required void Function(int page) onJump,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.7,
      child: _BookmarksPanel(
        controller: controller,
        currentPage: currentPage,
        onJump: onJump,
      ),
    ),
  );
}

class _BookmarksPanel extends StatefulWidget {
  const _BookmarksPanel({
    required this.controller,
    required this.currentPage,
    required this.onJump,
  });

  final AnnotationController controller;
  final int currentPage;
  final void Function(int page) onJump;

  @override
  State<_BookmarksPanel> createState() => _BookmarksPanelState();
}

class _BookmarksPanelState extends State<_BookmarksPanel> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final bookmarks = widget.controller.bookmarks;
        final onCurrent = widget.controller.isBookmarked(widget.currentPage);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.bookmarksTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: l10n.cancelAction,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                onCurrent ? Icons.bookmark : Icons.bookmark_add_outlined,
              ),
              title: Text(
                onCurrent
                    ? l10n.bookmarkRemoveCurrent(widget.currentPage)
                    : l10n.bookmarkAddCurrent(widget.currentPage),
              ),
              onTap: () => widget.controller.toggleBookmark(widget.currentPage),
            ),
            const Divider(height: 1),
            Expanded(
              child: bookmarks.isEmpty
                  ? Center(child: Text(l10n.bookmarksEmpty))
                  : ListView.builder(
                      itemCount: bookmarks.length,
                      itemBuilder: (context, i) {
                        final b = bookmarks[i];
                        return ListTile(
                          leading: const Icon(Icons.bookmark_outline),
                          title: Text(
                            b.label.isEmpty
                                ? l10n.bookmarkPageLabel(b.page)
                                : b.label,
                          ),
                          subtitle: b.label.isEmpty
                              ? null
                              : Text(l10n.bookmarkPageLabel(b.page)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: l10n.deleteAction,
                            onPressed: () => widget.controller.delete(b),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onJump(b.page);
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
