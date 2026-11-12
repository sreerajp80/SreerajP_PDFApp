import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/core/format/display_format.dart';
import 'package:pdfapp/core/platform/pdfbox_channel.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';
import 'package:pdfapp/features/viewer/domain/pdf_document_ref.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Shows file facts and the PDF's own document-information fields.
///
/// File facts always render (we know them without parsing). The PDF fields come
/// from PdfBox and may fail — a locked or damaged file shows a short notice in
/// that section only, and never blanks the sheet (project rule: never crash on
/// bad input).
Future<void> showMetadataSheet(BuildContext context, PdfDocumentRef docRef) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.85,
      child: MetadataSheet(docRef: docRef),
    ),
  );
}

class MetadataSheet extends ConsumerWidget {
  const MetadataSheet({super.key, required this.docRef});

  final PdfDocumentRef docRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final metadata = ref.watch(pdfMetadataProvider(docRef.cachePath));

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      children: [
        Text(l10n.titleMetadata, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _SectionHeader(l10n.labelMetadataFileSection),
        _Row(label: l10n.labelMetadataFileName, value: docRef.displayName),
        _Row(
          label: l10n.labelMetadataFileSize,
          value: DisplayFormat.bytes(docRef.sizeBytes),
        ),
        const SizedBox(height: 16),
        _SectionHeader(l10n.labelMetadataPdfSection),
        ...metadata.when(
          loading: () => const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
          error: (error, _) => [
            _Unavailable(message: l10n.errorMetadataUnavailable),
          ],
          data: (data) => _pdfRows(l10n, context, data),
        ),
      ],
    );
  }

  List<Widget> _pdfRows(
    AppLocalizations l10n,
    BuildContext context,
    PdfMetadata data,
  ) {
    final locale = Localizations.localeOf(context).toString();
    String? date(DateTime? value) =>
        value == null ? null : DisplayFormat.dateTime(value, locale);

    final rows = <Widget>[
      _Row(label: l10n.labelMetadataTitleField, value: data.title),
      _Row(label: l10n.labelMetadataAuthor, value: data.author),
      _Row(label: l10n.labelMetadataSubject, value: data.subject),
      _Row(label: l10n.labelMetadataKeywords, value: data.keywords),
      _Row(label: l10n.labelMetadataCreator, value: data.creator),
      _Row(label: l10n.labelMetadataProducer, value: data.producer),
      _Row(label: l10n.labelMetadataCreated, value: date(data.creationDate)),
      _Row(
        label: l10n.labelMetadataModified,
        value: date(data.modificationDate),
      ),
      _Row(
        label: l10n.labelMetadataPages,
        value: data.pageCount?.toString() ?? docRef.pageCount?.toString(),
      ),
      _Row(label: l10n.labelMetadataPdfVersion, value: data.pdfVersion),
      if (data.encrypted)
        _Row(label: l10n.labelMetadataProtected, value: l10n.labelYes),
    ];
    // Many PDFs carry no descriptive fields at all; say so once rather than
    // showing a wall of dashes.
    if (data.isEmpty) {
      return [
        _Unavailable(message: l10n.descMetadataNoFields),
        ...rows.where((row) => row is _Row && row.value != null),
      ];
    }
    return rows;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

/// One label/value line. A null or blank [value] shows an em dash so the layout
/// stays steady and the reader can see the field simply is not set.
class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SelectableText(
              value?.isNotEmpty == true ? value! : '—',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
