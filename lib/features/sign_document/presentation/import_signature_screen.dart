import 'dart:typed_data';

import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/errors/user_error_message.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/sign_document/data/sign_document_service.dart';
import 'package:pdfapp/features/sign_document/domain/saved_signature.dart';
import 'package:pdfapp/features/sign_document/domain/signature_image_tools.dart';
import 'package:pdfapp/features/sign_document/presentation/providers.dart';
import 'package:pdfapp/features/sign_document/presentation/widgets/checkerboard.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Shows an imported signature picture and lets the user turn the light paper
/// see-through before saving it. Pops with the new [LoadedSignature], or null.
class ImportSignatureScreen extends ConsumerStatefulWidget {
  const ImportSignatureScreen({super.key, required this.original});

  /// The decoded picture the user picked (already scaled down).
  final RgbaImage original;

  @override
  ConsumerState<ImportSignatureScreen> createState() =>
      _ImportSignatureScreenState();
}

// Runs in a background isolate: the pixel loop would otherwise stutter the UI.
RgbaImage? _prepare((RgbaImage, bool) args) =>
    SignDocumentService.prepareImported(args.$1, removeBackground: args.$2);

class _ImportSignatureScreenState extends ConsumerState<ImportSignatureScreen> {
  bool _removeBackground = true;
  bool _busy = true;
  bool _saving = false;
  RgbaImage? _prepared;
  Uint8List? _previewPng;

  // Bumped on every rebuild request so a slow, older result is dropped.
  int _job = 0;

  @override
  void initState() {
    super.initState();
    _rebuild();
  }

  Future<void> _rebuild() async {
    final job = ++_job;
    setState(() => _busy = true);
    try {
      final prepared = await compute(_prepare, (
        widget.original,
        _removeBackground,
      ));
      final png = prepared == null
          ? null
          : await ref
                .read(signDocumentServiceProvider)
                .codec
                .encodePng(prepared);
      if (!mounted || job != _job) return;
      setState(() {
        _prepared = prepared;
        _previewPng = png;
        _busy = false;
      });
    } catch (e, st) {
      AppLogger.error(
        'import_signature: prepare failed',
        error: e,
        stackTrace: st,
      );
      if (!mounted || job != _job) return;
      setState(() {
        _prepared = null;
        _previewPng = null;
        _busy = false;
      });
    }
  }

  Future<void> _save() async {
    final prepared = _prepared;
    if (prepared == null || _saving) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      final saved = await ref
          .read(signDocumentServiceProvider)
          .saveSignature(prepared, source: SignatureSource.imported);
      if (!mounted) return;
      Navigator.of(context).pop(saved);
    } catch (e, st) {
      AppLogger.error(
        'import_signature: save failed',
        error: e,
        stackTrace: st,
      );
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            userErrorMessage(l10n, e, fallback: l10n.errorSignatureSave),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final png = _previewPng;

    final Widget preview;
    if (_busy) {
      preview = const Center(child: CircularProgressIndicator());
    } else if (png == null) {
      preview = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.errorSignatureEmpty,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ),
      );
    } else {
      preview = Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Image.memory(
            png,
            fit: BoxFit.contain,
            gaplessPlayback: true,
            semanticLabel: l10n.descSignaturePreview,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.titleImportSignature)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  // The checkerboard shows which parts are see-through.
                  child: Checkerboard(child: preview),
                ),
              ),
            ),
            SwitchListTile(
              title: Text(l10n.labelRemoveBackground),
              subtitle: Text(l10n.descRemoveBackground),
              value: _removeBackground,
              onChanged: _saving
                  ? null
                  : (v) {
                      _removeBackground = v;
                      _rebuild();
                    },
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _busy || _saving || _prepared == null
                      ? null
                      : _save,
                  icon: _saving
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(l10n.actionSave),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
