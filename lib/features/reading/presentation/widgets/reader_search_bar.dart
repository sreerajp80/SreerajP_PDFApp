import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdfapp/core/search/search_normalizer.dart';
import 'package:pdfapp/features/reading/domain/search_hit.dart';
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
  });

  final SearchState state;
  final SearchOptions options;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onClose;
  final ValueChanged<SearchOptions> onOptionsChanged;

  @override
  State<ReaderSearchBar> createState() => _ReaderSearchBarState();
}

class _ReaderSearchBarState extends State<ReaderSearchBar> {
  final _field = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;

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
              tooltip: l10n.searchClose,
              onPressed: widget.onClose,
            ),
            Expanded(
              child: TextField(
                controller: _field,
                focusNode: _focus,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: _onChanged,
                // Enter searches at once, without waiting for the pause.
                onSubmitted: (value) {
                  _debounce?.cancel();
                  widget.onQueryChanged(value);
                },
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: theme.textTheme.titleMedium,
              ),
            ),
            if (_field.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: l10n.searchClear,
                onPressed: _clear,
              ),
          ],
        ),
        const Divider(height: 1, thickness: 0.5),
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(child: _Status(state: widget.state)),
            _OptionsMenu(
              options: widget.options,
              onChanged: widget.onOptionsChanged,
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_up),
              tooltip: l10n.searchPreviousMatch,
              // Never a dead button: greyed out with an obvious reason (no results).
              onPressed: widget.state.hits.isEmpty ? null : widget.onPrevious,
            ),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              tooltip: l10n.searchNextMatch,
              onPressed: widget.state.hits.isEmpty ? null : widget.onNext,
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
      label = l10n.searchMatchOf(state.currentIndex + 1, state.hits.length);
    } else if (state.running) {
      label = l10n.searchSearching;
    } else if (state.isEmptyResult) {
      label = l10n.searchNoMatches;
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

enum _Option { strict, ignoreAccents }

/// The two complex-script search switches.
class _OptionsMenu extends StatelessWidget {
  const _OptionsMenu({required this.options, required this.onChanged});

  final SearchOptions options;
  final ValueChanged<SearchOptions> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopupMenuButton<_Option>(
      icon: const Icon(Icons.tune),
      tooltip: l10n.searchOptionsTooltip,
      onSelected: (option) => onChanged(switch (option) {
        _Option.strict => SearchOptions(
          strict: !options.strict,
          ignoreAccents: options.ignoreAccents,
        ),
        _Option.ignoreAccents => SearchOptions(
          strict: options.strict,
          ignoreAccents: !options.ignoreAccents,
        ),
      }),
      itemBuilder: (context) => [
        CheckedPopupMenuItem(
          value: _Option.strict,
          checked: options.strict,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.searchOptionStrict),
            subtitle: Text(l10n.searchOptionStrictNote),
          ),
        ),
        CheckedPopupMenuItem(
          value: _Option.ignoreAccents,
          checked: options.ignoreAccents,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.searchOptionIgnoreAccents),
            subtitle: Text(l10n.searchOptionIgnoreAccentsNote),
          ),
        ),
      ],
    );
  }
}
