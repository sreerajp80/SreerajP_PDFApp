import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Device sync hub: share this phone's settings, or receive settings or PDFs
/// from another phone. Sending PDFs starts from Home or the viewer menu.
///
/// One rule for the user: the phone that has the settings shows a code, the
/// other phone scans it.
class DeviceSyncScreen extends StatelessWidget {
  const DeviceSyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.titleDeviceSync)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 48),
          children: [
            Text(l10n.descDeviceSyncIntro, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.qr_code_2_outlined),
                title: Text(l10n.titleShareSettings),
                subtitle: Text(l10n.descShareSettingsSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed(AppRoute.shareSettings.name),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.qr_code_scanner_outlined),
                title: Text(l10n.titleReceive),
                subtitle: Text(l10n.descReceiveSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed(AppRoute.scanCode.name),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.send_outlined, color: muted, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.descDeviceSyncSendPdfsHint,
                    style: TextStyle(color: muted),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: muted, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.descDeviceSyncWhatIsCopied,
                    style: TextStyle(color: muted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
