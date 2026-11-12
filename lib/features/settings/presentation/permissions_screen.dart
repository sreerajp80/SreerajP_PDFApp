import 'package:material_ui/material_ui.dart';
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

    final activeColor = theme.colorScheme.primary;
    final systemColor = theme.colorScheme.secondary;
    final privacyColor = theme.colorScheme.tertiary;

    final explicitItems = <_DetailedPermissionItem>[
      _DetailedPermissionItem(
        title:
            '${l10n.titlePermPrintService} (${l10n.titlePermBindPrintService})',
        category: l10n.labelPermTypeExplicit,
        reason: l10n.descPermBindPrintServiceReason,
        whatItAchieves: l10n.descPermBindPrintServiceWhatItAchieves,
        icon: Icons.print_outlined,
        statusLabel: l10n.labelStatusSystem,
        statusColor: systemColor,
      ),
      _DetailedPermissionItem(
        title: l10n.titlePermScopedStorage,
        category: l10n.labelPermTypeExplicit,
        reason: l10n.descPermScopedStorageReason,
        whatItAchieves: l10n.descPermScopedStorageWhatItAchieves,
        icon: Icons.folder_open_outlined,
        statusLabel: l10n.labelStatusActive,
        statusColor: activeColor,
      ),
      _DetailedPermissionItem(
        title: l10n.titlePermFileProvider,
        category: l10n.labelPermTypeExplicit,
        reason: l10n.descPermFileProviderReason,
        whatItAchieves: l10n.descPermFileProviderWhatItAchieves,
        icon: Icons.share_outlined,
        statusLabel: l10n.labelStatusSystem,
        statusColor: systemColor,
      ),
      _DetailedPermissionItem(
        title: l10n.titlePermCamera,
        category: l10n.labelPermTypeExplicit,
        reason: l10n.descPermCameraReason,
        whatItAchieves: l10n.descPermCameraWhatItAchieves,
        icon: Icons.qr_code_scanner_outlined,
        statusLabel: l10n.labelStatusActive,
        statusColor: activeColor,
      ),
      _DetailedPermissionItem(
        title: l10n.titlePermLocalNetwork,
        category: l10n.labelPermTypeExplicit,
        reason: l10n.descPermLocalNetworkReason,
        whatItAchieves: l10n.descPermLocalNetworkWhatItAchieves,
        icon: Icons.wifi_outlined,
        statusLabel: l10n.labelStatusActive,
        statusColor: activeColor,
      ),
    ];

    final implicitItems = <_DetailedPermissionItem>[
      _DetailedPermissionItem(
        title: l10n.titlePermTts,
        category: l10n.descPermTypeImplicit,
        reason: l10n.descPermTtsReason,
        whatItAchieves: l10n.descPermTtsWhatItAchieves,
        icon: Icons.record_voice_over_outlined,
        statusLabel: l10n.labelStatusSystem,
        statusColor: systemColor,
      ),
      _DetailedPermissionItem(
        title: l10n.titlePermTtsInstall,
        category: l10n.descPermTypeImplicit,
        reason: l10n.descPermTtsInstallReason,
        whatItAchieves: l10n.descPermTtsInstallWhatItAchieves,
        icon: Icons.download_for_offline_outlined,
        statusLabel: l10n.labelStatusSystem,
        statusColor: systemColor,
      ),
      _DetailedPermissionItem(
        title: l10n.titlePermStoreQueries,
        category: l10n.descPermTypeImplicit,
        reason: l10n.descPermStoreQueriesReason,
        whatItAchieves: l10n.descPermStoreQueriesWhatItAchieves,
        icon: Icons.storefront_outlined,
        statusLabel: l10n.labelStatusSystem,
        statusColor: systemColor,
      ),
      _DetailedPermissionItem(
        title: l10n.titlePermProcessText,
        category: l10n.descPermTypeImplicit,
        reason: l10n.descPermProcessTextReason,
        whatItAchieves: l10n.descPermProcessTextWhatItAchieves,
        icon: Icons.text_fields_outlined,
        statusLabel: l10n.labelStatusSystem,
        statusColor: systemColor,
      ),
      _DetailedPermissionItem(
        title: l10n.titlePermViewPdf,
        category: l10n.descPermTypeImplicit,
        reason: l10n.descPermViewPdfReason,
        whatItAchieves: l10n.descPermViewPdfWhatItAchieves,
        icon: Icons.picture_as_pdf_outlined,
        statusLabel: l10n.labelStatusActive,
        statusColor: activeColor,
      ),
      _DetailedPermissionItem(
        title: l10n.titlePermSendShare,
        category: l10n.descPermTypeImplicit,
        reason: l10n.descPermSendShareReason,
        whatItAchieves: l10n.descPermSendShareWhatItAchieves,
        icon: Icons.input_outlined,
        statusLabel: l10n.labelStatusActive,
        statusColor: activeColor,
      ),
      _DetailedPermissionItem(
        title: l10n.titlePermPrintManager,
        category: l10n.descPermTypeImplicit,
        reason: l10n.descPermPrintManagerReason,
        whatItAchieves: l10n.descPermPrintManagerWhatItAchieves,
        icon: Icons.local_printshop_outlined,
        statusLabel: l10n.labelStatusSystem,
        statusColor: systemColor,
      ),
    ];

    final privacyItems = <_DetailedPermissionItem>[
      _DetailedPermissionItem(
        title: l10n.titlePermZeroInternet,
        category: l10n.labelPermTypePrivacy,
        reason: l10n.descPermZeroInternetReason,
        whatItAchieves: l10n.descPermZeroInternetWhatItAchieves,
        icon: Icons.cloud_off_outlined,
        statusLabel: l10n.labelStatusOffline,
        statusColor: privacyColor,
      ),
      _DetailedPermissionItem(
        title: l10n.titlePermNoBroadStorage,
        category: l10n.labelPermTypePrivacy,
        reason: l10n.descPermNoBroadStorageReason,
        whatItAchieves: l10n.descPermNoBroadStorageWhatItAchieves,
        icon: Icons.lock_outline,
        statusLabel: l10n.labelStatusOffline,
        statusColor: privacyColor,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.titlePermissions),
        actions: [
          IconButton(
            tooltip: l10n.labelPermissionsOpenSettings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => OpenDocumentChannel().openAppSettings(),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 48),
          children: [
            _sectionHeader(
              context,
              l10n.labelPermissionsExplicitHeader,
              l10n.descPermissionsExplicitSubtitle,
              primary,
              muted,
            ),
            _groupCard(context, explicitItems, muted, l10n),
            const SizedBox(height: 24),
            _sectionHeader(
              context,
              l10n.descPermissionsImplicitHeader,
              l10n.descPermissionsImplicitSubtitle,
              primary,
              muted,
            ),
            _groupCard(context, implicitItems, muted, l10n),
            const SizedBox(height: 24),
            _sectionHeader(
              context,
              l10n.descPermissionsPrivacyHeader,
              l10n.descPermissionsPrivacySubtitle,
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
      padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 12),
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
                              text: '${l10n.labelPermWhyNeededHeader}: ',
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
                              text: '${l10n.labelPermWhatItAchievesHeader}: ',
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
