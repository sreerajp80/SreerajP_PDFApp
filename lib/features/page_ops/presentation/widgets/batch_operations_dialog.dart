import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/features/page_ops/data/page_ops_service.dart';
import 'package:pdfapp/features/page_ops/presentation/widgets/page_ops_result_dialog.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Modal dialog for batch PDF operations across multiple files (Feature 3.4).
class BatchOperationsDialog extends ConsumerStatefulWidget {
  const BatchOperationsDialog({super.key, this.initialDocuments = const []});

  final List<OpenedDocument> initialDocuments;

  @override
  ConsumerState<BatchOperationsDialog> createState() =>
      _BatchOperationsDialogState();
}

class _BatchOperationsDialogState extends ConsumerState<BatchOperationsDialog> {
  late List<OpenedDocument> _documents;
  BatchOpType _opType = BatchOpType.encrypt;
  final _passwordController = TextEditingController();

  bool _processing = false;
  int _currentStep = 0;
  int _totalSteps = 0;
  String _currentFileName = '';

  @override
  void initState() {
    super.initState();
    _documents = List.from(widget.initialDocuments);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickMore() async {
    final channel = ref.read(openDocumentChannelProvider);
    final picked = await channel.pickPdfs();
    if (picked.isNotEmpty) {
      setState(() {
        for (final doc in picked) {
          if (!_documents.any((d) => d.uri == doc.uri)) {
            _documents.add(doc);
          }
        }
      });
    }
  }

  Future<void> _runBatch() async {
    final l10n = AppLocalizations.of(context);
    if (_documents.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.batchNoFilesSelected)));
      return;
    }
    if (_opType == BatchOpType.encrypt &&
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.passwordRequiredError)));
      return;
    }

    setState(() {
      _processing = true;
      _currentStep = 0;
      _totalSteps = _documents.length;
      _currentFileName = _documents.first.displayName;
    });

    final service = ref.read(pageOpsServiceProvider);
    await service.clearOutputCache();

    final result = await service.runBatchOperation(
      documents: _documents,
      type: _opType,
      userPassword: _passwordController.text.trim(),
      onProgress: (current, total, docName) {
        if (mounted) {
          setState(() {
            _currentStep = current;
            _totalSteps = total;
            _currentFileName = docName;
          });
        }
      },
    );

    if (!mounted) return;
    Navigator.of(context).pop(); // close batch dialog

    final outputs = result.outputPaths;
    if (outputs.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.batchFailedAll)));
      return;
    }

    final note = l10n.batchDoneSummary(
      result.successCount,
      result.totalProcessed,
    );

    await showDialog<void>(
      context: context,
      builder: (_) => PageOpsResultDialog(
        title: l10n.batchOperationsTitle,
        outputPaths: outputs,
        note: note,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.batchOperationsTitle),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Operation Type Selector
              DropdownButtonFormField<BatchOpType>(
                initialValue: _opType,
                decoration: InputDecoration(
                  labelText: l10n.batchOperationLabel,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: BatchOpType.encrypt,
                    child: Text(l10n.batchOpEncrypt),
                  ),
                  DropdownMenuItem(
                    value: BatchOpType.merge,
                    child: Text(l10n.batchOpMerge),
                  ),
                  DropdownMenuItem(
                    value: BatchOpType.extractText,
                    child: Text(l10n.batchOpExtractText),
                  ),
                  DropdownMenuItem(
                    value: BatchOpType.trimMargins,
                    child: Text(l10n.batchOpTrimMargins),
                  ),
                  DropdownMenuItem(
                    value: BatchOpType.compress,
                    child: Text(l10n.batchOpCompress),
                  ),
                ],
                onChanged: _processing
                    ? null
                    : (val) =>
                          setState(() => _opType = val ?? BatchOpType.encrypt),
              ),
              const SizedBox(height: 12),
              if (_opType == BatchOpType.encrypt) ...[
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  enabled: !_processing,
                  decoration: InputDecoration(
                    labelText: l10n.userPasswordLabel,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              // Files Header & Add button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.batchSelectedFilesCount(_documents.length),
                    style: theme.textTheme.titleSmall,
                  ),
                  TextButton.icon(
                    onPressed: _processing ? null : _pickMore,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.batchAddFilesAction),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Document list
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _documents.isEmpty
                    ? Center(
                        child: Text(
                          l10n.batchNoFilesSelected,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _documents.length,
                        itemBuilder: (context, index) {
                          final doc = _documents[index];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.picture_as_pdf, size: 20),
                            title: Text(
                              doc.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: _processing
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.close, size: 16),
                                    onPressed: () => setState(
                                      () => _documents.removeAt(index),
                                    ),
                                  ),
                          );
                        },
                      ),
              ),
              if (_processing) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _totalSteps > 0 ? _currentStep / _totalSteps : null,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.batchProgressLabel(
                    _currentStep,
                    _totalSteps,
                    _currentFileName,
                  ),
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _processing ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancelAction),
        ),
        FilledButton(
          onPressed: _processing || _documents.isEmpty ? null : _runBatch,
          child: _processing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.batchStartAction),
        ),
      ],
    );
  }
}
