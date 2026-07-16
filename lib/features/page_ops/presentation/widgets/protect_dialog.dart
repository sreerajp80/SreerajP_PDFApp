import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/page_ops_result_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Collects a password and writes a protected copy of the PDF.
///
/// Passwords stay in memory for the single operation only — never logged,
/// never stored (§11).
class ProtectDialog extends ConsumerStatefulWidget {
  const ProtectDialog({super.key, required this.path});

  final String path;

  @override
  ConsumerState<ProtectDialog> createState() => _ProtectDialogState();
}

class _ProtectDialogState extends ConsumerState<ProtectDialog> {
  final _userController = TextEditingController();
  final _ownerController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _userController.dispose();
    _ownerController.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    final l10n = AppLocalizations.of(context);
    final userPass = _userController.text;
    if (userPass.isEmpty) {
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
      final owner = _ownerController.text;
      final out = await service.protect(
        widget.path,
        userPassword: userPass,
        ownerPassword: owner.isEmpty ? null : owner,
      );
      if (mounted) {
        Navigator.of(context).pop();
        showDialog<void>(
          context: context,
          builder: (context) => PageOpsResultDialog(
            title: l10n.protectDoneTitle,
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
      title: Text(l10n.protectTitle),
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
            controller: _userController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: l10n.userPasswordLabel,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ownerController,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: l10n.ownerPasswordLabel,
              helperText: l10n.ownerPasswordHelp,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelAction),
        ),
        FilledButton(onPressed: _run, child: Text(l10n.protectAction)),
      ],
    );
  }
}
