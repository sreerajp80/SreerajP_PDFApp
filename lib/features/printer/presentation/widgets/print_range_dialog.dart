import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// The pages a user chose to print (1-based, inclusive).
class PrintRange {
  const PrintRange(this.from, this.to);

  final int from;
  final int to;
}

/// Asks which pages to print. Returns null if the user backed out.
class PrintRangeDialog extends StatefulWidget {
  const PrintRangeDialog({super.key, required this.pageCount});

  final int pageCount;

  @override
  State<PrintRangeDialog> createState() => _PrintRangeDialogState();
}

class _PrintRangeDialogState extends State<PrintRangeDialog> {
  late final TextEditingController _from = TextEditingController(text: '1');
  late final TextEditingController _to = TextEditingController(
    text: '${widget.pageCount}',
  );
  String? _error;

  @override
  void dispose() {
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context);
    final from = int.tryParse(_from.text.trim());
    final to = int.tryParse(_to.text.trim());
    final valid =
        from != null &&
        to != null &&
        from >= 1 &&
        to <= widget.pageCount &&
        from <= to;
    if (!valid) {
      setState(() => _error = l10n.printRangeInvalid(widget.pageCount));
      return;
    }
    Navigator.of(context).pop(PrintRange(from, to));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.printRangeTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: _field(_from, l10n.printFromLabel)),
              const SizedBox(width: 12),
              Expanded(child: _field(_to, l10n.printToLabel)),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelAction),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.printAction)),
      ],
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: label),
      onSubmitted: (_) => _submit(),
    );
  }
}
