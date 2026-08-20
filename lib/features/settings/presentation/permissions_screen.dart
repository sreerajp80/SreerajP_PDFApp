import 'package:flutter/material.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

class _DetailedPermissionItem {
  final String title;
  final String category;
  final String reason;
  final String whatItAchieves;
  final IconData icon;
  final String statusLabel;
  final Color statusColor;

  const _DetailedPermissionItem({
    required this.title,
    required this.category,
    required this.reason,
    required this.whatItAchieves,
    required this.icon,
    required this.statusLabel,
    required this.statusColor,
  });
}

/// Screen listing every system capability, explicit grant, implicit query,
/// and offline privacy guarantee with full rationale and what the app achieves.
class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;
    final primary = theme.colorScheme.primary;

    const greenColor = Color(0xFF10B981);
    const blueColor = Color(0xFF3B82F6);
    const purpleColor = Color(0xFF8B5CF6);

    final explicitItems = <_DetailedPermissionItem>[
      _DetailedPermissionItem(
        title: l10n.permScopedStorageTitle,
        category: l10n.permTypeExplicit,
        reason: l10n.permScopedStorageReason,
        whatItAchieves: l10n.permScopedStorageWhatItAchieves,
        icon: Icons.folder_open_outlined,
        statusLabel: l10n.statusActive,
        statusColor: greenColor,
      ),
      _DetailedPermissionItem(
        title: l10n.permPrintServiceTitle,
        category: l10n.permTypeExplicit,
        reason: l10n.permPrintServiceReason,
        whatItAchieves: l10n.permPrintServiceWhatItAchieves,
        icon: Icons.print_outlined,
        statusLabel: l10n.statusSystem,
        statusColor: blueColor,
      ),
      _DetailedPermissionItem(
        title: l10n.permFileProviderTitle,
        category: l10n.permTypeExplicit,
        reason: l10n.permFileProviderReason,
        whatItAchieves: l10n.permFileProviderWhatItAchieves,
        icon: Icons.share_outlined,
        statusLabel: l10n.statusSystem,
        statusColor: blueColor,
      ),
    ];

    final implicitItems = <_DetailedPermissionItem>[
      _DetailedPermissionItem(
        title: l10n.permTtsTitle,
        category: l10n.permTypeImplicit,
        reason: l10n.permTtsReason,
        whatItAchieves: l10n.permTtsWhatItAchieves,
        icon: Icons.record_voice_over_outlined,
        statusLabel: l10n.statusSystem,
        statusColor: blueColor,
      ),
      _DetailedPermissionItem(
        title: l10n.permTtsInstallTitle,
        category: l10n.permTypeImplicit,
        reason: l10n.permTtsInstallReason,
        whatItAchieves: l10n.permTtsInstallWhatItAchieves,
        icon: Icons.download_for_offline_outlined,
        statusLabel: l10n.statusSystem,
        statusColor: blueColor,
      ),
      _DetailedPermissionItem(
        title: l10n.permProcessTextTitle,
        category: l10n.permTypeImplicit,
        reason: l10n.permProcessTextReason,
        whatItAchieves: l10n.permProcessTextWhatItAchieves,
        icon: Icons.text_fields_outlined,
        statusLabel: l10n.statusSystem,
        statusColor: blueColor,
      ),
      _DetailedPermissionItem(
        title: l10n.permSendShareTitle,
        category: l10n.permTypeImplicit,
        reason: l10n.permSendShareReason,
        whatItAchieves: l10n.permSendShareWhatItAchieves,
        icon: Icons.input_outlined,
        statusLabel: l10n.statusActive,
        statusColor: greenColor,
      ),
    ];

    final privacyItems = <_DetailedPermissionItem>[
      _DetailedPermissionItem(
        title: l10n.permZeroInternetTitle,
        category: l10n.permTypePrivacy,
        reason: l10n.permZeroInternetReason,
        whatItAchieves: l10n.permZeroInternetWhatItAchieves,
        icon: Icons.wifi_off_outlined,
        statusLabel: l10n.statusOffline,
        statusColor: purpleColor,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.permissionsTitle),
        actions: [
          IconButton(
            tooltip: l10n.permissionsOpenSettings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => OpenDocumentChannel().openAppSettings(),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
          children: [
            _sectionHeader(
              context,
              l10n.permissionsExplicitHeader,
              l10n.permissionsExplicitSubtitle,
              primary,
              muted,
            ),
            _groupCard(context, explicitItems, muted, l10n),
            const SizedBox(height: 24),
            _sectionHeader(
              context,
              l10n.permissionsImplicitHeader,
              l10n.permissionsImplicitSubtitle,
              primary,
              muted,
            ),
            _groupCard(context, implicitItems, muted, l10n),
            const SizedBox(height: 24),
            _sectionHeader(
              context,
              l10n.permZeroInternetTitle,
              l10n.permOfflineReason,
              primary,
              muted,
            ),
            _groupCard(context, privacyItems, muted, l10n),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    String title,
    String subtitle,
    Color primary,
    Color muted,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
          ),
        ],
      ),
    );
  }

  Widget _groupCard(
    BuildContext context,
    List<_DetailedPermissionItem> items,
    Color muted,
    AppLocalizations l10n,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: muted.withValues(alpha: 0.18),
              ),
            _detailedPermissionTile(context, items[i], muted, l10n),
          ],
        ],
      ),
    );
  }

  Widget _detailedPermissionTile(
    BuildContext context,
    _DetailedPermissionItem item,
    Color muted,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category,
                      style: TextStyle(
                        color: muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _statusChip(item.statusLabel, item.statusColor),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 13,
                            height: 1.35,
                          ),
                          children: [
                            TextSpan(
                              text: '${l10n.permWhyNeededHeader}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: item.reason),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 13,
                            height: 1.35,
                          ),
                          children: [
                            TextSpan(
                              text: '${l10n.permWhatItAchievesHeader}: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: item.whatItAchieves),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
