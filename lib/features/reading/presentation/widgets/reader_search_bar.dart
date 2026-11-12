import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/search/search_normalizer.dart';
import 'package:pdfapp/features/reading/domain/search_hit.dart';
import 'package:pdfapp/features/reading/presentation/widgets/malayalam_input_helper.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// The find-in-document bar that replaces the reader's title while searching.
///
/// Named `Reader…` because Material already has a `SearchBar` of its own.
///
/// It reports what the reader typed and lets them step through matches. It owns
/// no search state — that lives in `PdfSearchController`, which the reader screen
/// holds.
class ReaderSearchBar extends StatefulWidget {
  const ReaderSearchBar({
    super.key,
    required this.state,
    required this.options,
    required this.onQueryChanged,
    required this.onNext,
    required this.onPrevious,
    required this.onClose,
    required this.onOptionsChanged,
    this.unreliableText = false,
  });

  final SearchState state;
  final SearchOptions options;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onClose;
  final ValueChanged<SearchOptions> onOptionsChanged;

  /// True when the PDF's text is probably not proper Unicode, so matches may
  /// be missing or wrong. Shows a warning icon next to the match counter.
  final bool unreliableText;

  @override
  State<ReaderSearchBar> createState() => _ReaderSearchBarState();
}

class _ReaderSearchBarState extends State<ReaderSearchBar> {
  final _field = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;
  bool _showMalayalamHelper = false;

  @override
  void initState() {
    super.initState();
    _field.text = widget.state.query;
    // Opening search should put the keyboard up — that is what it is for.
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _field.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Waits for a pause in typing before searching, so a long document is not
  /// searched again on every keystroke.
  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => widget.onQueryChanged(value),
    );
  }

  void _clear() {
    _debounce?.cancel();
    _field.clear();
    widget.onQueryChanged('');
    _focus.requestFocus();
  }

  /// Steps through matches with the keyboard put away, so it does not cover
  /// the page being looked at. Tapping the field brings it back.
  void _step(VoidCallback move) {
    _focus.unfocus();
    move();
  }

  void _insertMalayalamText(String text) {
    final curText = _field.text;
    final selection = _field.selection;
    final start = selection.start >= 0 ? selection.start : curText.length;
    final end = selection.end >= 0 ? selection.end : curText.length;
    final newText = curText.replaceRange(start, end, text);
    _field.text = newText;
    _field.selection = TextSelection.collapsed(offset: start + text.length);
    _onChanged(newText);
  }

  void _replaceWithTransliteration(String transliterated) {
    _field.text = transliterated;
    _field.selection = TextSelection.collapsed(offset: transliterated.length);
    _debounce?.cancel();
    widget.onQueryChanged(transliterated);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: l10n.labelSearchClose,
              onPressed: widget.onClose,
            ),
            Expanded(
              child: TextField(
                controller: _field,
                focusNode: _focus,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: (val) {
                  setState(() {});
                  _onChanged(val);
                },
                // Enter searches at once, without waiting for the pause.
                onSubmitted: (value) {
                  _debounce?.cancel();
                  widget.onQueryChanged(value);
                },
                decoration: InputDecoration(
                  hintText: l10n.labelSearchHint,
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: Icon(
                _showMalayalamHelper
                    ? Icons.keyboard_alt
                    : Icons.keyboard_alt_outlined,
                color: _showMalayalamHelper
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              tooltip: l10n.tooltipMalayalamHelper,
              onPressed: () =>
                  setState(() => _showMalayalamHelper = !_showMalayalamHelper),
            ),
            if (_field.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: l10n.labelSearchClear,
                onPressed: _clear,
              ),
          ],
        ),
        if (_showMalayalamHelper)
          MalayalamInputHelper(
            currentText: _field.text,
            onInsertText: _insertMalayalamText,
            onReplaceText: _replaceWithTransliteration,
            onClose: () => setState(() => _showMalayalamHelper = false),
          ),
        const Divider(height: 1, thickness: 0.5),
        Row(
          children: [
            const SizedBox(width: 16),
            if (widget.unreliableText)
              Tooltip(
                message: l10n.descSearchUnreliable,
                triggerMode: TooltipTriggerMode.tap,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.warning_amber_outlined,
                    size: 18,
                    semanticLabel: l10n.descSearchUnreliable,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            Expanded(child: _Status(state: widget.state)),
            _OptionsMenu(
              options: widget.options,
              onChanged: widget.onOptionsChanged,
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_up),
              tooltip: l10n.labelSearchPreviousMatch,
              // Never a dead button: greyed out with an obvious reason (no results).
              onPressed: widget.state.hits.isEmpty
                  ? null
                  : () => _step(widget.onPrevious),
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              tooltip: l10n.labelSearchNextMatch,
              onPressed: widget.state.hits.isEmpty
                  ? null
                  : () => _step(widget.onNext),
            ),
          ],
        ),
      ],
    );
  }
}

/// The match counter: "3 of 12", "Searching…", or "No matches".
class _Status extends StatelessWidget {
  const _Status({required this.state});

  final SearchState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // "No matches" must wait until the whole document has been looked at,
    // otherwise it flashes up while results are still arriving.
    final String? label;
    if (!state.hasQuery) {
      label = null;
    } else if (state.hits.isNotEmpty) {
      label = l10n.labelSearchMatchOf(
        state.currentIndex + 1,
        state.hits.length,
      );
    } else if (state.running) {
      label = l10n.labelSearchSearching;
    } else if (state.isEmptyResult) {
      label = l10n.labelSearchNoMatches;
    } else {
      label = null;
    }
    if (label == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

enum _Option { strict, ignoreAccents, sandhi, phonetic }

/// The complex-script search switches.
class _OptionsMenu extends StatelessWidget {
  const _OptionsMenu({required this.options, required this.onChanged});

  final SearchOptions options;
  final ValueChanged<SearchOptions> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopupMenuButton<_Option>(
      icon: const Icon(Icons.tune),
      tooltip: l10n.tooltipSearchOptions,
      onSelected: (option) => onChanged(switch (option) {
        _Option.strict => options.copyWith(strict: !options.strict),
        _Option.ignoreAccents => options.copyWith(
          ignoreAccents: !options.ignoreAccents,
        ),
        _Option.sandhi => options.copyWith(sandhi: !options.sandhi),
        _Option.phonetic => options.copyWith(phonetic: !options.phonetic),
      }),
      itemBuilder: (context) => [
        CheckedPopupMenuItem(
          value: _Option.sandhi,
          checked: options.sandhi,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.descSearchOptionSandhi),
            subtitle: Text(l10n.descSearchOptionSandhiNote),
          ),
        ),
        CheckedPopupMenuItem(
          value: _Option.phonetic,
          checked: options.phonetic,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.labelSearchOptionPhonetic),
            subtitle: Text(l10n.descSearchOptionPhoneticNote),
          ),
        ),
        CheckedPopupMenuItem(
          value: _Option.strict,
          checked: options.strict,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.labelSearchOptionStrict),
            subtitle: Text(l10n.descSearchOptionStrictNote),
          ),
        ),
        CheckedPopupMenuItem(
          value: _Option.ignoreAccents,
          checked: options.ignoreAccents,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.labelSearchOptionIgnoreAccents),
            subtitle: Text(l10n.descSearchOptionIgnoreAccentsNote),
          ),
        ),
      ],
    );
  }
}
