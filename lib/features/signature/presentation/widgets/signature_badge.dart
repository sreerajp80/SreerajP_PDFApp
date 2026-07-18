import 'package:flutter/material.dart';
import 'package:pdfapp/features/signature/domain/signature_status.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// The visual verdict on a signature (Phase 7).
///
/// The green tick lives here, and it is shown for exactly one status:
/// [SignatureStatus.trusted]. Everything else gets an honest, different mark.
/// Colour alone never carries the message — each state has its own icon and its
/// own words, so the meaning survives colour-blindness, greyscale, and a glance.
class SignatureBadge extends StatelessWidget {
  const SignatureBadge({required this.status, this.compact = false, super.key});

  final SignatureStatus status;

  /// Icon and short label only — for a list row rather than a card header.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final style = _styleFor(status, scheme);
    final label = _labelFor(status, l10n);

    return Semantics(
      // Without this the icon is invisible to TalkBack and the badge would be
      // colour-only — the verdict has to be readable, not just visible.
      label: label,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8.0 : 12.0,
          vertical: compact ? 4.0 : 8.0,
        ),
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(compact ? 8.0 : 12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(
                style.icon,
                size: compact ? 16.0 : 20.0,
                color: style.foreground,
              ),
            ),
            const SizedBox(width: 8.0),
            Flexible(
              child: ExcludeSemantics(
                child: Text(
                  label,
                  style:
                      (compact
                              ? Theme.of(context).textTheme.labelMedium
                              : Theme.of(context).textTheme.titleSmall)
                          ?.copyWith(
                            color: style.foreground,
                            fontWeight: FontWeight.w600,
                          ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _labelFor(SignatureStatus status, AppLocalizations l10n) =>
      switch (status) {
        SignatureStatus.trusted => l10n.signatureStatusTrusted,
        SignatureStatus.validNotTrusted => l10n.signatureStatusValidNotTrusted,
        SignatureStatus.invalid => l10n.signatureStatusInvalid,
        SignatureStatus.unknown => l10n.signatureStatusUnknown,
      };

  /// The detail line under the badge — the state in plain words.
  static String detailFor(SignatureStatus status, AppLocalizations l10n) =>
      switch (status) {
        SignatureStatus.trusted => l10n.signatureStatusTrustedDetail,
        SignatureStatus.validNotTrusted =>
          l10n.signatureStatusValidNotTrustedDetail,
        SignatureStatus.invalid => l10n.signatureStatusInvalidDetail,
        SignatureStatus.unknown => l10n.signatureStatusUnknownDetail,
      };

  static _BadgeStyle _styleFor(SignatureStatus status, ColorScheme scheme) =>
      switch (status) {
        // The one green tick in the app. Nothing else earns this icon.
        SignatureStatus.trusted => _BadgeStyle(
          icon: Icons.verified_user,
          foreground: scheme.onTertiaryContainer,
          background: scheme.tertiaryContainer,
        ),
        // Deliberately neutral, not a warning: the document is intact, we just
        // do not know the signer. Scaring the user here would be as wrong as
        // reassuring them.
        SignatureStatus.validNotTrusted => _BadgeStyle(
          icon: Icons.help_outline,
          foreground: scheme.onSecondaryContainer,
          background: scheme.secondaryContainer,
        ),
        SignatureStatus.invalid => _BadgeStyle(
          icon: Icons.gpp_bad,
          foreground: scheme.onErrorContainer,
          background: scheme.errorContainer,
        ),
        SignatureStatus.unknown => _BadgeStyle(
          icon: Icons.shield_outlined,
          foreground: scheme.onSurfaceVariant,
          background: scheme.surfaceContainerHighest,
        ),
      };
}

class _BadgeStyle {
  const _BadgeStyle({
    required this.icon,
    required this.foreground,
    required this.background,
  });

  final IconData icon;
  final Color foreground;
  final Color background;
}
