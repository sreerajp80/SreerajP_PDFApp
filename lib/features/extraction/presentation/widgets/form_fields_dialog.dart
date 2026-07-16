import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/features/extraction/data/share_service.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Dialog to display interactive form fields (AcroForm) and let the user export them.
class FormFieldsDialog extends ConsumerWidget {
  const FormFieldsDialog({
    super.key,
    required this.fields,
    required this.filePath,
  });

  final List<Map<String, dynamic>> fields;
  final String filePath;

  void _copyToClipboard(BuildContext context, AppLocalizations l10n) {
    const encoder = JsonEncoder.withIndent('  ');
    final jsonStr = encoder.convert(fields);
    Clipboard.setData(ClipboardData(text: jsonStr)).then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.copySuccess)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final shareService = ref.read(shareServiceProvider);

    return AlertDialog(
      title: Text(l10n.formFieldsTitle),
      content: SizedBox(
        width: double.maxFinite,
        height: 350,
        child: fields.isEmpty
            ? Center(
                child: Text(
                  l10n.noFormFieldsFound,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.dividerColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.separated(
                        itemCount: fields.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final field = fields[index];
                          final name = field['name'] as String;
                          final value = field['value'] as String;
                          final type = field['type'] as String;
                          final readOnly = field['readOnly'] as bool;

                          return ListTile(
                            title: Text(
                              name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              value.isEmpty ? '(Empty)' : value,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: value.isEmpty ? theme.disabledColor : null,
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  type,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                if (readOnly)
                                  Text(
                                    'Read-only',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.dismissAction),
        ),
        if (fields.isNotEmpty) ...[
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: l10n.copyClipboardAction,
            onPressed: () => _copyToClipboard(context, l10n),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: l10n.shareFileAction,
            onPressed: filePath.isEmpty
                ? null
                : () => shareService.shareFiles([filePath], mimeType: 'application/json'),
          ),
        ]
      ],
    );
  }
}
