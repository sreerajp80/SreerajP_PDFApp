import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/features/reading/data/tts_service.dart';
import 'package:pdfapp/features/reading/domain/tts_state.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';
import 'package:pdfapp/features/reading/presentation/widgets/tts_install_sheet.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Settings. Phase 0 exposes the theme choice; the Malayalam TTS toggle is wired
/// in Phase 2.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(themeModeProvider);
    final ttsService = ref.watch(ttsServiceProvider);
    final ttsStatus = ttsService.status;

    ref.listen<TtsService>(ttsServiceProvider, (previous, next) {
      if (next.takeVoiceLostNotice()) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.ttsVoiceLostNotice)));
      }
    });

    String label(AppThemeMode m) => switch (m) {
      AppThemeMode.system => l10n.themeSystem,
      AppThemeMode.light => l10n.themeLight,
      AppThemeMode.dark => l10n.themeDark,
      AppThemeMode.sepia => l10n.themeSepia,
    };

    final currentThemeLabel = label(mode);

    final String ttsSubtitle;
    if (!ttsStatus.malayalamEnabled) {
      ttsSubtitle = l10n.settingsMalayalamVoiceOff;
    } else {
      ttsSubtitle = switch (ttsStatus.malayalam) {
        TtsVoiceState.unknown => l10n.settingsMalayalamVoiceChecking,
        TtsVoiceState.ready => l10n.settingsMalayalamVoiceReady,
        TtsVoiceState.needsInstall => l10n.settingsMalayalamVoiceNeedsInstall,
        TtsVoiceState.unavailable => l10n.settingsMalayalamVoiceUnavailable,
      };
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: Text(l10n.settingsThemeLabel),
              subtitle: Text(currentThemeLabel),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoute.theme.name),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              l10n.settingsReadAloudLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SwitchListTile(
            title: Text(l10n.settingsMalayalamVoice),
            subtitle: Text(ttsSubtitle),
            value: ttsStatus.malayalamEnabled,
            onChanged: (enabled) async {
              final state = await ref
                  .read(ttsServiceProvider)
                  .setMalayalamEnabled(enabled: enabled);
              if (!context.mounted) return;
              if (enabled && state == TtsVoiceState.needsInstall) {
                await showTtsInstallSheet(context);
                await ref.read(ttsServiceProvider).refreshVoices();
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: Text(l10n.trustStoreTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed(AppRoute.trustStore.name),
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.aboutTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoute.about.name),
            ),
          ),
        ],
      ),
    );
  }
}
