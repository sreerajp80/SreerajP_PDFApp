import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Screen allowing the user to select the app's interface language.
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;
    final currentLocale = ref.watch(appLocaleProvider);

    final currentCode = currentLocale?.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.titleLanguage)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 48),
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.titleLanguageSelect,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.descLanguageSelectSubtitle,
                    style: TextStyle(color: muted, fontSize: 13),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _LanguageTile(
                    title: l10n.labelLanguageSystem,
                    subtitle: l10n.labelLanguageAuto,
                    selected: currentCode == null,
                    onTap: () => ref.read(appLocaleProvider.notifier).set(null),
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  _LanguageTile(
                    title: l10n.labelLanguageEnglish,
                    subtitle: 'English',
                    selected: currentCode == 'en',
                    onTap: () => ref
                        .read(appLocaleProvider.notifier)
                        .set(const Locale('en')),
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  _LanguageTile(
                    title: l10n.labelLanguageMalayalam,
                    subtitle: 'മലയാളം',
                    selected: currentCode == 'ml',
                    onTap: () => ref
                        .read(appLocaleProvider.notifier)
                        .set(const Locale('ml')),
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  _LanguageTile(
                    title: l10n.labelLanguageSanskrit,
                    subtitle: 'संस्कृतम्',
                    selected: currentCode == 'sa',
                    onTap: () => ref
                        .read(appLocaleProvider.notifier)
                        .set(const Locale('sa')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final colors = theme.extension<AppColors>();
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? accent : null,
        ),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: muted, fontSize: 13)),
      trailing: selected ? Icon(Icons.check_circle, color: accent) : null,
      onTap: onTap,
    );
  }
}
