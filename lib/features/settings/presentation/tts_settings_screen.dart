import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/core/format/display_format.dart';
import 'package:pdfapp/features/reading/data/tts_service.dart';
import 'package:pdfapp/features/reading/domain/tts_state.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';
import 'package:pdfapp/features/reading/presentation/widgets/tts_install_sheet.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Screen for Text-to-Speech (Read Aloud) voice and playback settings.
class TtsSettingsScreen extends ConsumerWidget {
  const TtsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;
    final accent = theme.colorScheme.primary;
    final localeName = Localizations.localeOf(context).toString();

    final ttsService = ref.watch(ttsServiceProvider);
    final ttsStatus = ttsService.status;
    final speechRate = ref.watch(ttsSpeechRateProvider);
    final pitch = ref.watch(ttsPitchProvider);
    final sentencePause = ref.watch(ttsSentencePauseProvider);
    final autoScroll = ref.watch(ttsAutoScrollProvider);

    ref.listen<TtsService>(ttsServiceProvider, (previous, next) {
      if (next.takeVoiceLostNotice()) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.descTtsVoiceLostNotice)));
      }
    });

    final String ttsSubtitle;
    if (!ttsStatus.malayalamEnabled) {
      ttsSubtitle = l10n.descSettingsMalayalamVoiceOff;
    } else {
      ttsSubtitle = switch (ttsStatus.malayalam) {
        TtsVoiceState.unknown => l10n.labelSettingsMalayalamVoiceChecking,
        TtsVoiceState.ready => l10n.descSettingsMalayalamVoiceReady,
        TtsVoiceState.needsInstall =>
          l10n.descSettingsMalayalamVoiceNeedsInstall,
        TtsVoiceState.unavailable =>
          l10n.errorSettingsMalayalamVoiceUnavailable,
      };
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.titleTtsSettings)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 48),
          children: [
            _sectionHeader(context, l10n.labelSettingsMalayalamVoice, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.record_voice_over_outlined,
                        color: accent,
                      ),
                    ),
                    title: Text(
                      l10n.labelSettingsMalayalamVoice,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      ttsSubtitle,
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
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
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  SwitchListTile(
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.sync_outlined, color: accent),
                    ),
                    title: Text(
                      l10n.titleTtsAutoScroll,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      l10n.descTtsAutoScrollSubtitle,
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                    value: autoScroll,
                    onChanged: (val) =>
                        ref.read(ttsAutoScrollProvider.notifier).set(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.titleTtsSpeechRate, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.titleTtsSpeechRate,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          l10n.descTtsSpeechRateSubtitle(
                            DisplayFormat.decimal(
                              speechRate,
                              localeName,
                              fractionDigits: 2,
                            ),
                          ),
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: speechRate,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      onChanged: (val) =>
                          ref.read(ttsSpeechRateProvider.notifier).set(val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.titleTtsPitch, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.titleTtsPitch,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          l10n.descTtsPitchSubtitle(
                            DisplayFormat.decimal(
                              pitch,
                              localeName,
                              fractionDigits: 2,
                            ),
                          ),
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: pitch,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      onChanged: (val) =>
                          ref.read(ttsPitchProvider.notifier).set(val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.titleTtsSentencePause, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.titleTtsSentencePause,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          l10n.descTtsSentencePauseSubtitle(
                            DisplayFormat.decimal(
                              sentencePause,
                              localeName,
                              fractionDigits: 1,
                            ),
                          ),
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: sentencePause,
                      max: 2.0,
                      divisions: 20,
                      onChanged: (val) =>
                          ref.read(ttsSentencePauseProvider.notifier).set(val),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, Color accent) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          color: accent,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
