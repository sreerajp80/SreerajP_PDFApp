import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Asks for a page number to jump to (1..[pageCount]).
///
/// Returns the chosen 1-based page number, or null if cancelled/invalid.
Future<int?> showPageJumpSheet(
  BuildContext context, {
  required int pageCount,
  required int currentPage,
}) {
  return showDialog<int>(
    context: context,
    builder: (context) =>
        _PageJumpDialog(pageCount: pageCount, currentPage: currentPage),
  );
}

class _PageJumpDialog extends StatefulWidget {
  const _PageJumpDialog({required this.pageCount, required this.currentPage});

  final int pageCount;
  final int currentPage;

  @override
  State<_PageJumpDialog> createState() => _PageJumpDialogState();
}

class _PageJumpDialogState extends State<_PageJumpDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.currentPage.toString(),
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_controller.text.trim());
    if (value == null || value < 1 || value > widget.pageCount) {
      setState(() => _error = '1 – ${widget.pageCount}');
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.goToPage),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: l10n.pageNumberHint,
          helperText: '1 – ${widget.pageCount}',
          errorText: _error,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelAction),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.goAction)),
      ],
    );
  }
}
