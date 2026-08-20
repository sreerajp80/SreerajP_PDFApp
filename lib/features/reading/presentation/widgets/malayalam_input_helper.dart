import 'package:flutter/material.dart';
import 'package:pdfapp/core/search/malayalam_transliteration.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// On-screen Malayalam transliteration suggestion bar and virtual keypad.
///
/// Gives users without an Indic keyboard full access to Malayalam search,
/// bookmarks, and note entry.
class MalayalamInputHelper extends StatefulWidget {
  const MalayalamInputHelper({
    super.key,
    required this.currentText,
    required this.onInsertText,
    required this.onReplaceText,
    required this.onClose,
  });

  final String currentText;
  final ValueChanged<String> onInsertText;
  final ValueChanged<String> onReplaceText;
  final VoidCallback onClose;

  @override
  State<MalayalamInputHelper> createState() => _MalayalamInputHelperState();
}

class _MalayalamInputHelperState extends State<MalayalamInputHelper>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _showKeypad = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final suggestions = MalayalamTransliteration.suggestionsFor(
      widget.currentText,
    );

    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      elevation: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Suggestions row & keypad toggle
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _showKeypad
                        ? Icons.keyboard_hide_outlined
                        : Icons.keyboard_outlined,
                    size: 20,
                  ),
                  tooltip: l10n.malayalamHelperTooltip,
                  onPressed: () => setState(() => _showKeypad = !_showKeypad),
                ),
                Expanded(
                  child: suggestions.isEmpty
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.currentText.isEmpty
                                ? l10n.malayalamHelperTooltip
                                : widget.currentText,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggestions.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 6),
                          itemBuilder: (context, index) {
                            final suggestion = suggestions[index];
                            return ActionChip(
                              label: Text(
                                suggestion,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              onPressed: () => widget.onReplaceText(suggestion),
                            );
                          },
                        ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),

          // Expandable Malayalam character keypad
          if (_showKeypad) ...[
            const Divider(height: 1),
            TabBar(
              controller: _tabController,
              labelPadding: const EdgeInsets.symmetric(vertical: 4),
              tabs: [
                Tab(text: l10n.malayalamKeypadTabVowels),
                Tab(text: l10n.malayalamKeypadTabConsonants),
                Tab(text: l10n.malayalamKeypadTabSigns),
              ],
            ),
            SizedBox(
              height: 160,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGrid(MalayalamTransliteration.keypadVowels),
                  _buildGrid(MalayalamTransliteration.keypadConsonants),
                  _buildGrid(MalayalamTransliteration.keypadSignsAndChillu),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGrid(List<String> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(6),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 52,
        childAspectRatio: 1.1,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final char = items[index];
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => widget.onInsertText(char),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              char,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}
