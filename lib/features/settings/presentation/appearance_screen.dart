import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/features/settings/presentation/widgets/settings_nav_card.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Appearance hub reached from Settings -> Appearance. Holds links to
/// Theme Mode, Typography, and Accent Color.
class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appearanceTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
          children: [
            SettingsNavCard(
              icon: Icons.brightness_6_outlined,
              title: l10n.themeModeTitle,
              subtitle: l10n.themeModeCardSubtitle,
              onTap: () => context.pushNamed(AppRoute.theme.name),
            ),
            const SizedBox(height: 12),
            SettingsNavCard(
              icon: Icons.text_fields_rounded,
              title: l10n.typographyTitle,
              subtitle: l10n.typographySubtitle,
              onTap: () => context.pushNamed(AppRoute.typography.name),
            ),
            const SizedBox(height: 12),
            SettingsNavCard(
              icon: Icons.color_lens_outlined,
              title: l10n.accentColorTitle,
              subtitle: l10n.accentColorSubtitle,
              onTap: () => context.pushNamed(AppRoute.accentColor.name),
            ),
          ],
        ),
      ),
    );
  }
}
