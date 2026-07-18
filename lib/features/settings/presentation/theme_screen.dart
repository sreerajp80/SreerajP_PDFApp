import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Theme picker. Reached from the Theme card on the Settings page; it lets the
/// user choose between the app's theme modes.
class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(themeModeProvider);

    String label(AppThemeMode m) => switch (m) {
      AppThemeMode.system => l10n.themeSystem,
      AppThemeMode.light => l10n.themeLight,
      AppThemeMode.dark => l10n.themeDark,
      AppThemeMode.sepia => l10n.themeSepia,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsThemeLabel)),
      body: RadioGroup<AppThemeMode>(
        groupValue: mode,
        onChanged: (value) {
          if (value != null) {
            ref.read(themeModeProvider.notifier).set(value);
          }
        },
        child: ListView(
          children: [
            for (final m in AppThemeMode.values)
              RadioListTile<AppThemeMode>(title: Text(label(m)), value: m),
          ],
        ),
      ),
    );
  }
}
