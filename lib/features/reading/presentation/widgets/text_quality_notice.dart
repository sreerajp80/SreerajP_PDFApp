import 'package:flutter/material.dart';
import 'package:pdfapp/features/reading/domain/text_quality.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Tells the reader, once, why search / copy / read-aloud are not on offer.
///
/// Shown for a scanned PDF (no text layer) and for one whose text does not
/// decode. Both are honest dead ends rather than bugs, so the notice explains
/// the reason and can be dismissed — the reader can still read the pages.
class TextQualityNotice extends StatelessWidget {
  const TextQualityNotice({
    super.key,
    required this.quality,
    required this.onDismiss,
  });

  final TextQuality quality;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final (title, body) = switch (quality) {
      TextQuality.none => (l10n.noTextTitle, l10n.noTextBody),
      TextQuality.garbled => (l10n.garbledTextTitle, l10n.garbledTextBody),
      // Nothing to say about a healthy PDF.
      TextQuality.good => (null, null),
    };
    if (title == null || body == null) return const SizedBox.shrink();

    return MaterialBanner(
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      leading: Icon(
        quality == TextQuality.none
            ? Icons.image_outlined
            : Icons.font_download_off_outlined,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(body, style: theme.textTheme.bodySmall),
        ],
      ),
      actions: [
        TextButton(onPressed: onDismiss, child: Text(l10n.dismissAction)),
      ],
    );
  }
}
