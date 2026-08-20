import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Help hub screen listing user guides and help topics grouped into intuitive categories.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
          children: [
            _buildHeaderCard(context, l10n, colors),
            const SizedBox(height: 20),

            _buildSectionHeader(context, l10n.helpSectionPrinting, Icons.print_outlined, colors),
            const SizedBox(height: 10),
            _HelpTopicCard(
              icon: Icons.print_outlined,
              title: l10n.helpPdfPrinterTitle,
              subtitle: l10n.helpPdfPrinterSubtitle,
              onTap: () => context.pushNamed(AppRoute.helpPdfPrinter.name),
            ),
            const SizedBox(height: 10),
            _HelpTopicCard(
              icon: Icons.language_outlined,
              title: l10n.helpUnicodePrintingTitle,
              subtitle: l10n.helpUnicodePrintingSubtitle,
              onTap: () => context.pushNamed(AppRoute.helpUnicodePrinting.name),
            ),
            const SizedBox(height: 22),

            _buildSectionHeader(context, l10n.helpSectionReading, Icons.auto_stories_outlined, colors),
            const SizedBox(height: 10),
            _HelpTopicCard(
              icon: Icons.record_voice_over_outlined,
              title: l10n.helpTtsTitle,
              subtitle: l10n.helpTtsSubtitle,
              onTap: () => context.pushNamed(AppRoute.helpTts.name),
            ),
            const SizedBox(height: 22),

            _buildSectionHeader(context, l10n.helpSectionPageOps, Icons.dashboard_customize_outlined, colors),
            const SizedBox(height: 10),
            _HelpTopicCard(
              icon: Icons.dashboard_customize_outlined,
              title: l10n.helpPageOpsTitle,
              subtitle: l10n.helpPageOpsSubtitle,
              onTap: () => context.pushNamed(AppRoute.helpPageOps.name),
            ),
            const SizedBox(height: 22),

            _buildSectionHeader(context, l10n.helpSectionSecurity, Icons.security_outlined, colors),
            const SizedBox(height: 10),
            _HelpTopicCard(
              icon: Icons.verified_user_outlined,
              title: l10n.helpSignaturesTitle,
              subtitle: l10n.helpSignaturesSubtitle,
              onTap: () => context.pushNamed(AppRoute.helpSignatures.name),
            ),
            const SizedBox(height: 10),
            _HelpTopicCard(
              icon: Icons.security_outlined,
              title: l10n.helpPrivacyStorageTitle,
              subtitle: l10n.helpPrivacyStorageSubtitle,
              onTap: () => context.pushNamed(AppRoute.helpPrivacyStorage.name),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    AppLocalizations l10n,
    AppColors? colors,
  ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final gradient = colors?.brandGradient ??
        LinearGradient(
          colors: [primary, secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    final gradientStart = colors?.gradientStart ?? primary;
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;

    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              primary.withValues(alpha: 0.12),
              secondary.withValues(alpha: 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: gradientStart.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.help_center_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.helpHeaderTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.helpHeaderSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: muted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    AppColors? colors,
  ) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpTopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpTopicCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final accent = theme.colorScheme.primary;
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: muted),
            ],
          ),
        ),
      ),
    );
  }
}
