import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// About screen — data-driven from `ConfigService`/`AppConfig` (guideline.md §1.6).
/// It loops over `details` and renders one row per entry; no field name is
/// hard-coded, so editing `app_config.json` is the only change ever needed.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final config = ref.watch(appConfigProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(config.appName, style: textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(config.description, style: textTheme.bodyMedium),
                ],
              ),
            ),
            ListTile(
              title: const Text('Version'),
              subtitle: Text('${config.version} (build ${config.build})'),
            ),
            const Divider(),
            for (final entry in config.details.entries)
              if (entry.key.trim().isNotEmpty && entry.value.trim().isNotEmpty)
                ListTile(title: Text(entry.key), subtitle: Text(entry.value)),
          ],
        ),
      ),
    );
  }
}
