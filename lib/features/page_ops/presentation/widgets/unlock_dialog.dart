import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/page_ops_result_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Collects the current password and writes an unprotected copy of the PDF.
///
/// The password stays in memory for the single operation only — never logged,
/// never stored (§11).
class UnlockDialog extends ConsumerStatefulWidget {
  const UnlockDialog({super.key, required this.path});

  final String path;

  @override
  ConsumerState<UnlockDialog> createState() => _UnlockDialogState();
}

class _UnlockDialogState extends ConsumerState<UnlockDialog> {
  final _controller = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    final l10n = AppLocalizations.of(context);
    final password = _controller.text;
    if (password.isEmpty) {
      setState(() => _error = l10n.passwordRequiredError);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final service = ref.read(pageOpsServiceProvider);
      await service.clearOutputCache();
      final out = await service.unlock(widget.path, password: password);
      if (mounted) {
        Navigator.of(context).pop();
        showDialog<void>(
          context: context,
          builder: (context) => PageOpsResultDialog(
            title: l10n.unlockDoneTitle,
            outputPaths: [out],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = '${l10n.opFailed}: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (_loading) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.workingProgress),
          ],
        ),
      );
    }

    return AlertDialog(
      title: Text(l10n.unlockTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_error != null) ...[
            Text(
              _error!,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 13),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _controller,
            obscureText: _obscure,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.currentPasswordLabel,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelAction),
        ),
        FilledButton(onPressed: _run, child: Text(l10n.unlockAction)),
      ],
    );
  }
}
