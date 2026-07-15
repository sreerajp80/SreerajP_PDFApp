import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/features/reading/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Offers the ways to install a missing speech voice.
///
/// Three doors, because no single one exists on every phone: the engine's own
/// download screen, the system speech settings, and the Play Store. Each says so
/// plainly if this phone cannot open it, rather than appearing to do nothing.
Future<void> showTtsInstallSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => const TtsInstallSheet(),
  );
}

class TtsInstallSheet extends ConsumerWidget {
  const TtsInstallSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    Future<void> open(Future<bool> Function() door) async {
      final opened = await door();
      if (!context.mounted) return;
      Navigator.of(context).pop();
      if (!opened) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.ttsInstallCannotOpen)));
      }
    }

    final channel = ref.watch(ttsChannelProvider);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.ttsInstallTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(l10n.ttsInstallBody, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: Text(l10n.ttsInstallVoiceData),
                onTap: () => open(channel.installVoiceData),
              ),
              ListTile(
                leading: const Icon(Icons.settings_voice_outlined),
                title: Text(l10n.ttsOpenTtsSettings),
                onTap: () => open(channel.openTtsSettings),
              ),
              ListTile(
                leading: const Icon(Icons.shop_outlined),
                title: Text(l10n.ttsOpenPlayStore),
                onTap: () => open(channel.openPlayStore),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.ttsInstallDoneNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
