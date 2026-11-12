import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/errors/user_error_message.dart';
import 'package:pdfapp/core/format/display_format.dart';
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
  bool _cleanWebContent = false;

  @override
  void initState() {
    super.initState();
    // Auto-enable web cleaner if incoming text looks like HTML or contains URLs/tags
    if (widget.content is IncomingText) {
      final t = (widget.content as IncomingText).text;
      if (t.contains('<') && t.contains('>') ||
          t.contains('http://') ||
          t.contains('https://')) {
        _cleanWebContent = true;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _build());
  }

  Future<void> _build() async {
    final builder = ref.read(pdfBuilderServiceProvider);
    await builder.clearOutputCache();
    final content = widget.content;
    try {
      final path = switch (content) {
        IncomingImages() => await builder.fromImages(content),
        IncomingText() => await builder.fromText(
          _cleanWebContent
              ? IncomingText(
                  text: ref.read(webContentCleanerProvider).clean(content.text),
                  suggestedName: content.suggestedName,
                )
              : content,
        ),
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
        _error = null;
        _unsupportedText = false;
      });
    } on PdfUnsupportedTextException {
      if (!mounted) return;
      setState(() => _unsupportedText = true);
    } on AppException catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      setState(
        () =>
            _error = userErrorMessage(l10n, e, fallback: l10n.errorImportBuild),
      );
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
        ).showSnackBar(SnackBar(content: Text(l10n.labelImportSaved(saved))));
      }
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userErrorMessage(l10n, e, fallback: l10n.errorSaveFailed),
            ),
            action: SnackBarAction(
              label: l10n.actionTryAgain,
              onPressed: () {
                if (mounted && !_saving) _save();
              },
            ),
          ),
        );
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.errorShareFailed)));
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
      appBar: AppBar(title: Text(l10n.titleImport)),
      body: SafeArea(child: Center(child: _body(l10n))),
    );
  }

  Widget _body(AppLocalizations l10n) {
    if (_unsupportedText) {
      return _message(
        icon: Icons.translate,
        title: l10n.titleImportUnsupportedText,
        detail: l10n.descImportUnsupportedTextDetail,
      );
    }
    if (_error != null) {
      return _message(
        icon: Icons.error_outline,
        title: l10n.titleImportFailed,
        detail: _error!,
      );
    }
    if (_outputPath == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(l10n.labelImportBuilding),
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
          Text(l10n.titleImportReady, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            _summary(l10n),
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (size != null) ...[
            const SizedBox(height: 4),
            Text(
              l10n.labelImportSize(
                DisplayFormat.bytes(
                  size,
                  Localizations.localeOf(context).toString(),
                ),
              ),
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (widget.content is IncomingText) ...[
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              title: Text(l10n.titleCleanWebContent),
              subtitle: Text(l10n.descCleanWebContentSubtitle),
              value: _cleanWebContent,
              onChanged: (val) {
                setState(() => _cleanWebContent = val);
                _build();
              },
            ),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_alt),
            label: Text(l10n.actionImportSave),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _saving ? null : _share,
            icon: const Icon(Icons.share),
            label: Text(l10n.actionImportShare),
          ),
        ],
      ),
    );
  }

  String _summary(AppLocalizations l10n) => switch (widget.content) {
    IncomingImages(:final paths) => l10n.descImportImagesSummary(paths.length),
    IncomingText() => l10n.descImportTextSummary,
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
}
