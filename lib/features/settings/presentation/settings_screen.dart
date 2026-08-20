import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/features/reading/domain/tts_state.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Settings screen featuring card-based sections for Appearance, Language,
/// Reader preferences, Read Aloud, Virtual Printer, Storage, Trust Store,
/// Permissions, Help, and About.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    final locale = ref.watch(appLocaleProvider);
    final String currentLangSubtitle = switch (locale?.languageCode) {
      'en' => l10n.languageEnglish,
      'ml' => l10n.languageMalayalam,
      _ => l10n.languageSystem,
    };

    final ttsService = ref.watch(ttsServiceProvider);
    final ttsStatus = ttsService.status;
    final String ttsSubtitle = !ttsStatus.malayalamEnabled
        ? l10n.settingsMalayalamVoiceOff
        : switch (ttsStatus.malayalam) {
            TtsVoiceState.unknown => l10n.settingsMalayalamVoiceChecking,
            TtsVoiceState.ready => l10n.settingsMalayalamVoiceReady,
            TtsVoiceState.needsInstall =>
              l10n.settingsMalayalamVoiceNeedsInstall,
            TtsVoiceState.unavailable => l10n.settingsMalayalamVoiceUnavailable,
          };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
          children: [
            _SettingsCard(
              icon: Icons.palette_outlined,
              title: l10n.appearanceTitle,
              subtitle: l10n.appearanceSubtitle,
              trailingWidget: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () => context.pushNamed(AppRoute.appearance.name),
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.stars_outlined,
              title: l10n.featuresTitle,
              subtitle: l10n.featuresSubtitle,
              onTap: () => context.pushNamed(AppRoute.features.name),
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.translate_outlined,
              title: l10n.languageTitle,
              subtitle: currentLangSubtitle,
              onTap: () => context.pushNamed(AppRoute.language.name),
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.chrome_reader_mode_outlined,
              title: l10n.readerSettingsTitle,
              subtitle: l10n.readerSettingsSubtitle,
              onTap: () => context.pushNamed(AppRoute.readerSettings.name),
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.record_voice_over_outlined,
              title: l10n.ttsSettingsTitle,
              subtitle: ttsSubtitle,
              onTap: () => context.pushNamed(AppRoute.ttsSettings.name),
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.print_outlined,
              title: l10n.printerSettingsTitle,
              subtitle: l10n.printerSettingsSubtitle,
              onTap: () => context.pushNamed(AppRoute.printerSettings.name),
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.storage_outlined,
              title: l10n.storageSettingsTitle,
              subtitle: l10n.storageSettingsSubtitle,
              onTap: () => context.pushNamed(AppRoute.storageSettings.name),
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.verified_user_outlined,
              title: l10n.trustStoreTitle,
              subtitle: l10n.trustStoreSubtitle,
              onTap: () => context.pushNamed(AppRoute.trustStore.name),
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.security_outlined,
              title: l10n.permissionsTitle,
              subtitle: l10n.permissionsSubtitle,
              onTap: () => context.pushNamed(AppRoute.permissions.name),
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.help_outline,
              title: l10n.helpTitle,
              subtitle: l10n.helpSubtitle,
              onTap: () => context.pushNamed(AppRoute.help.name),
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              icon: Icons.info_outline,
              title: l10n.aboutTitle,
              subtitle: l10n.aboutSubtitle,
              onTap: () => context.pushNamed(AppRoute.about.name),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailingWidget;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingWidget,
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
              if (trailingWidget != null) ...[
                trailingWidget!,
                const SizedBox(width: 8),
              ],
              Icon(Icons.chevron_right, color: muted),
            ],
          ),
        ),
      ),
    );
  }
}
