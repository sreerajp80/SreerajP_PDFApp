import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/constants/build_date.g.dart';
import 'package:pdfapp/core/widgets/made_with_love.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Maps a config detail key to its translated label, falling back to the raw key.
String aboutDetailLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'author':
      return l10n.aboutDetailAuthor;
    case 'email':
      return l10n.aboutDetailEmail;
    case 'license':
      return l10n.aboutDetailLicense;
    case 'aiUsed':
      return l10n.aboutDetailAiUsed;
    case 'ideUsed':
      return l10n.aboutDetailIdeUsed;
    default:
      return key;
  }
}

/// About screen — data-driven from `ConfigService`/`AppConfig` (guideline.md §1.6).
/// It loops over `details` and renders one row per entry; no field name is
/// hard-coded, so editing `app_config.json` is the only change ever needed.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
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
                  Text(
                    config.appName.resolve(lang),
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    config.description.resolve(lang),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(l10n.aboutVersionLabel),
              subtitle: Text(
                l10n.aboutVersionBuild(config.version, config.build),
              ),
            ),
            ListTile(
              title: Text(l10n.aboutBuildDateLabel),
              subtitle: const Text(kBuildDate),
            ),
            const Divider(),
            for (final entry in config.details.entries)
              if (entry.key.trim().isNotEmpty &&
                  entry.value.resolve(lang).trim().isNotEmpty)
                ListTile(
                  title: Text(aboutDetailLabel(l10n, entry.key)),
                  subtitle: Text(entry.value.resolve(lang)),
                ),
            const MadeWithLove(),
          ],
        ),
      ),
    );
  }
}
