import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/features/extraction/data/extraction_service.dart';
import 'package:pdfapp/features/extraction/data/share_service.dart';
import 'package:pdfapp/features/extraction/presentation/widgets/form_fields_dialog.dart';
import 'package:pdfapp/features/extraction/presentation/widgets/text_preview_dialog.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

enum ExtractionType {
  text,
  embeddedImages,
  pageImages,
  formFields,
}

enum RangeType {
  all,
  current,
  custom,
}

class ExtractionDialog extends ConsumerStatefulWidget {
  const ExtractionDialog({
    super.key,
    required this.path,
    this.password,
    required this.currentPage,
    required this.totalPages,
  });

  final String path;
  final String? password;
  final int currentPage;
  final int totalPages;

  @override
  ConsumerState<ExtractionDialog> createState() => _ExtractionDialogState();
}

class _ExtractionDialogState extends ConsumerState<ExtractionDialog> {
  ExtractionType _type = ExtractionType.text;
  RangeType _range = RangeType.current;

  // Render settings
  String _imageFormat = 'png';
  int _dpi = 150;

  // Custom range text controllers
  late final TextEditingController _startController;
  late final TextEditingController _endController;

  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(text: widget.currentPage.toString());
    _endController = TextEditingController(text: widget.currentPage.toString());
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _runExtraction() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    // Validate page range
    int start = 1;
    int end = widget.totalPages;

    if (_type != ExtractionType.formFields) {
      if (_range == RangeType.current) {
        start = widget.currentPage;
        end = widget.currentPage;
      } else if (_range == RangeType.custom) {
        final startVal = int.tryParse(_startController.text) ?? 1;
        final endVal = int.tryParse(_endController.text) ?? widget.totalPages;

        if (startVal < 1 || endVal < startVal || endVal > widget.totalPages) {
          setState(() {
            _loading = false;
            _errorMessage = l10n.invalidPageRange;
          });
          return;
        }
        start = startVal;
        end = endVal;
      }
    }

    try {
      final extService = ref.read(extractionServiceProvider);
      final shareService = ref.read(shareServiceProvider);

      // Clear old extracted temp files
      await extService.clearExtractionCache();

      switch (_type) {
        case ExtractionType.text:
          final text = await extService.extractText(
            widget.path,
            password: widget.password,
            startPage: start,
            endPage: end,
          );
          final filePath = await extService.extractTextToFile(
            widget.path,
            password: widget.password,
            startPage: start,
            endPage: end,
          );
          if (mounted) {
            Navigator.of(context).pop(); // Close this dialog
            showDialog<void>(
              context: context,
              builder: (context) => TextPreviewDialog(
                text: text,
                filePath: filePath,
              ),
            );
          }
          break;

        case ExtractionType.embeddedImages:
          final imagePaths = await extService.extractImages(
            widget.path,
            password: widget.password,
            startPage: start,
            endPage: end,
          );
          if (mounted) {
            Navigator.of(context).pop(); // Close dialog
            if (imagePaths.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.noImagesFound)),
              );
            } else {
              // Trigger share chooser
              await shareService.shareFiles(imagePaths, mimeType: 'image/png');
            }
          }
          break;

        case ExtractionType.pageImages:
          final imagePaths = await extService.renderPagesToImages(
            widget.path,
            password: widget.password,
            startPage: start,
            endPage: end,
            format: _imageFormat,
            dpi: _dpi,
          );
          if (mounted) {
            Navigator.of(context).pop(); // Close dialog
            if (imagePaths.isNotEmpty) {
              final mime = _imageFormat == 'png' ? 'image/png' : 'image/jpeg';
              await shareService.shareFiles(imagePaths, mimeType: mime);
            }
          }
          break;

        case ExtractionType.formFields:
          final fields = await extService.readFormFields(
            widget.path,
            password: widget.password,
          );
          final filePath = await extService.readFormFieldsToFile(
            widget.path,
            password: widget.password,
          );
          if (mounted) {
            Navigator.of(context).pop(); // Close dialog
            showDialog<void>(
              context: context,
              builder: (context) => FormFieldsDialog(
                fields: fields,
                filePath: filePath,
              ),
            );
          }
          break;
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMessage = '${l10n.extractionFailed}: $e';
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
            Text(l10n.extractingProgress, style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    return AlertDialog(
      title: Text(l10n.extractAndConvert),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: TextStyle(color: theme.colorScheme.error, fontSize: 13),
              ),
              const SizedBox(height: 12),
            ],
            // Extraction type
            Text(
              'Select operation:',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ExtractionType>(
              initialValue: _type,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                DropdownMenuItem(
                  value: ExtractionType.text,
                  child: Text(l10n.extractTextAction),
                ),
                DropdownMenuItem(
                  value: ExtractionType.embeddedImages,
                  child: Text(l10n.extractImagesAction),
                ),
                DropdownMenuItem(
                  value: ExtractionType.pageImages,
                  child: Text(l10n.convertPdfAction),
                ),
                DropdownMenuItem(
                  value: ExtractionType.formFields,
                  child: Text(l10n.formFieldsAction),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _type = val;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Page range selectors (disabled for Form Fields since it's document-wide)
            if (_type != ExtractionType.formFields) ...[
              Text(
                'Page range:',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<RangeType>(
                segments: [
                  ButtonSegment(
                    value: RangeType.current,
                    label: Text(l10n.rangeCurrent(widget.currentPage)),
                  ),
                  ButtonSegment(
                    value: RangeType.all,
                    label: Text(l10n.rangeAll),
                  ),
                  ButtonSegment(
                    value: RangeType.custom,
                    label: Text(l10n.rangeCustom),
                  ),
                ],
                selected: {_range},
                onSelectionChanged: (set) {
                  setState(() {
                    _range = set.first;
                  });
                },
              ),
              const SizedBox(height: 12),
              if (_range == RangeType.custom) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _startController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.startPageLabel,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _endController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.endPageLabel,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ],

            // Custom settings for Page Images
            if (_type == ExtractionType.pageImages) ...[
              const Divider(),
              const SizedBox(height: 8),
              Text(
                l10n.imageFormatLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'png', label: Text('PNG (Lossless)')),
                  ButtonSegment(value: 'jpeg', label: Text('JPEG')),
                ],
                selected: {_imageFormat},
                onSelectionChanged: (set) {
                  setState(() {
                    _imageFormat = set.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.resolutionLabel(_dpi)),
                  Text(
                    _dpi <= 150 ? 'Standard' : 'High Quality',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _dpi <= 150 ? theme.hintColor : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _dpi.toDouble(),
                min: 100,
                max: 300,
                divisions: 4,
                label: '$_dpi DPI',
                onChanged: (val) {
                  setState(() {
                    _dpi = val.round();
                  });
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelAction),
        ),
        ElevatedButton(
          onPressed: _runExtraction,
          child: Text(l10n.goAction),
        ),
      ],
    );
  }
}
