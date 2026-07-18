import 'package:flutter/material.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// A dismissible banner telling the user that overlay marks live only inside
/// this app until they are exported. Shown once, the first time a mark is added.
class AnnotationOverlayNotice extends StatelessWidget {
  const AnnotationOverlayNotice({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 20,
              color: scheme.onSecondaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.annotationOverlayNotice,
                style: TextStyle(color: scheme.onSecondaryContainer),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: l10n.cancelAction,
              color: scheme.onSecondaryContainer,
              onPressed: onDismiss,
            ),
          ],
        ),
      ),
    );
  }
}
