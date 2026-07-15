import 'package:flutter/material.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Which friendly error state the viewer is showing.
enum ViewerErrorKind { corrupt, empty, password, generic }

/// A calm, centered error state for the viewer — the app never crashes on bad
/// input (project rule). Optionally offers a retry (e.g. re-enter a password).
class ViewerErrorView extends StatelessWidget {
  const ViewerErrorView({super.key, required this.kind, this.onRetry});

  final ViewerErrorKind kind;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, title, body) = switch (kind) {
      ViewerErrorKind.corrupt => (
        Icons.broken_image_outlined,
        l10n.errorCorruptTitle,
        l10n.errorCorruptBody,
      ),
      ViewerErrorKind.empty => (
        Icons.description_outlined,
        l10n.errorEmptyTitle,
        l10n.errorEmptyBody,
      ),
      ViewerErrorKind.password => (
        Icons.lock_outline,
        l10n.errorPasswordTitle,
        l10n.errorPasswordBody,
      ),
      ViewerErrorKind.generic => (
        Icons.error_outline,
        l10n.errorGenericTitle,
        l10n.errorGenericBody,
      ),
    };

    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(body, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(
                  kind == ViewerErrorKind.password
                      ? l10n.unlockAction
                      : l10n.tryAgainAction,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
