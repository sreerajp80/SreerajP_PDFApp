import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// The table of contents (outline) as a navigation drawer.
///
/// Loads the outline from the open document and lets the user jump to a
/// destination. If the PDF has no outline, shows a friendly notice (never a
/// dead/empty panel).
class OutlineDrawer extends StatelessWidget {
  const OutlineDrawer({
    super.key,
    required this.document,
    required this.controller,
    required this.onNavigate,
  });

  final PdfDocument document;
  final PdfViewerController controller;

  /// Called after a destination is chosen (e.g. to close the drawer).
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.contentsTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: FutureBuilder<List<PdfOutlineNode>>(
                future: document.loadOutline(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final nodes = snapshot.data ?? const [];
                  if (nodes.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(l10n.noOutline, textAlign: TextAlign.center),
                    );
                  }
                  return ListView(
                    children: [
                      for (final node in nodes)
                        _OutlineTile(node: node, depth: 0, onTap: _goTo),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goTo(PdfDest? dest) async {
    if (dest != null) await controller.goToDest(dest);
    onNavigate();
  }
}

/// A single outline entry; nested children render as an expandable tile.
class _OutlineTile extends StatelessWidget {
  const _OutlineTile({
    required this.node,
    required this.depth,
    required this.onTap,
  });

  final PdfOutlineNode node;
  final int depth;
  final ValueChanged<PdfDest?> onTap;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.only(left: 16.0 + depth * 16, right: 16);
    if (node.children.isEmpty) {
      return ListTile(
        contentPadding: padding,
        title: Text(node.title),
        onTap: () => onTap(node.dest),
      );
    }
    return ExpansionTile(
      tilePadding: padding,
      title: Text(node.title),
      onExpansionChanged: (_) {},
      childrenPadding: EdgeInsets.zero,
      children: [
        // Tapping the header still navigates to its own destination.
        if (node.dest != null)
          ListTile(
            contentPadding: EdgeInsets.only(left: 16.0 + (depth + 1) * 16),
            dense: true,
            leading: const Icon(Icons.my_location_outlined, size: 18),
            title: Text(node.title),
            onTap: () => onTap(node.dest),
          ),
        for (final child in node.children)
          _OutlineTile(node: child, depth: depth + 1, onTap: onTap),
      ],
    );
  }
}
