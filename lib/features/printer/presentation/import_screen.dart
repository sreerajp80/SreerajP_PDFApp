import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/features/extraction/data/share_service.dart';
import 'package:pdfapp/features/printer/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// "Save this as a PDF" — the landing screen for content shared into the app
/// (Phase 6, step 1).
///
/// Builds the PDF as soon as it opens, then offers to save or share it. The
/// shared content itself is never changed: the PDF is always a new file.
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key, required this.content});

  final IncomingContent content;

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  /// Null while building; set on success.
  String? _outputPath;
  int? _sizeBytes;

  /// Set when the build failed. Holds a message the user can act on.
  String? _error;

  /// True when the text's letters cannot go into a PDF at all — a different
  /// state from a plain failure, because retrying will never help.
  bool _unsupportedText = false;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _build());
  }

  Future<void> _build() async {
    final builder = ref.read(pdfBuilderServiceProvider);
    await builder.clearOutputCache();
    final content = widget.content;
    try {
      final path = switch (content) {
        IncomingImages() => await builder.fromImages(content),
        IncomingText() => await builder.fromText(content),
        // A PDF never reaches this screen; Home sends it to the viewer.
        IncomingPdf() => throw const PdfOpenException(
          'A PDF does not need to be made into a PDF.',
        ),
      };
      final size = await builder.fileSize(path);
      if (!mounted) return;
      setState(() {
        _outputPath = path;
        _sizeBytes = size;
      });
    } on PdfUnsupportedTextException {
      if (!mounted) return;
      setState(() => _unsupportedText = true);
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    }
  }

  Future<void> _save() async {
    final path = _outputPath;
    if (path == null || _saving) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      final saved = await ref
          .read(pdfBuilderServiceProvider)
          .saveToDevice(path, _suggestedFileName());
      if (!mounted) return;
      if (saved != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.importSaved(saved))));
      }
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _share() async {
    final path = _outputPath;
    if (path == null) return;
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(shareServiceProvider).shareFiles([
        path,
      ], mimeType: 'application/pdf');
    } on AppException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
      }
    }
  }

  String _suggestedFileName() {
    final name = switch (widget.content) {
      IncomingImages(:final suggestedName) => suggestedName,
      IncomingText(:final suggestedName) => suggestedName,
      IncomingPdf() => 'document',
    };
    return '$name.pdf';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.importTitle)),
      body: SafeArea(child: Center(child: _body(l10n))),
    );
  }

  Widget _body(AppLocalizations l10n) {
    if (_unsupportedText) {
      return _message(
        icon: Icons.translate,
        title: l10n.importUnsupportedTextTitle,
        detail: l10n.importUnsupportedTextDetail,
      );
    }
    if (_error != null) {
      return _message(
        icon: Icons.error_outline,
        title: l10n.importFailedTitle,
        detail: _error!,
      );
    }
    if (_outputPath == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(l10n.importBuilding),
        ],
      );
    }
    return _ready(l10n);
  }

  Widget _ready(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final size = _sizeBytes;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.picture_as_pdf,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(l10n.importReadyTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            _summary(l10n),
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (size != null) ...[
            const SizedBox(height: 4),
            Text(
              l10n.importSize(_readableSize(size)),
              style: theme.textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_alt),
            label: Text(l10n.importSaveAction),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _saving ? null : _share,
            icon: const Icon(Icons.share),
            label: Text(l10n.importShareAction),
          ),
        ],
      ),
    );
  }

  String _summary(AppLocalizations l10n) => switch (widget.content) {
    IncomingImages(:final paths) => l10n.importImagesSummary(paths.length),
    IncomingText() => l10n.importTextSummary,
    IncomingPdf() => '',
  };

  Widget _message({
    required IconData icon,
    required String title,
    required String detail,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            detail,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _readableSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
