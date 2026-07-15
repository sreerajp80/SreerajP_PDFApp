import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// A grid of page thumbnails. Tapping a page jumps to it.
///
/// Uses `ListView`/`GridView.builder` so only visible thumbnails render — this
/// keeps memory bounded even for long documents.
class ThumbnailGrid extends StatelessWidget {
  const ThumbnailGrid({
    super.key,
    required this.document,
    required this.currentPage,
    required this.onSelect,
  });

  final PdfDocument document;
  final int currentPage;

  /// Called with the chosen 1-based page number.
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final pageCount = document.pages.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l10n.thumbnailsTitle, style: theme.textTheme.titleLarge),
        ),
        const Divider(height: 1),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: pageCount,
            itemBuilder: (context, index) {
              final pageNumber = index + 1;
              final selected = pageNumber == currentPage;
              return InkWell(
                onTap: () => onSelect(pageNumber),
                child: Column(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selected
                                ? theme.colorScheme.primary
                                : theme.dividerColor,
                            width: selected ? 2 : 1,
                          ),
                          color: Colors.white,
                        ),
                        child: PdfPageView(
                          document: document,
                          pageNumber: pageNumber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('$pageNumber', style: theme.textTheme.labelSmall),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
