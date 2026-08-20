import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/features/settings/presentation/widgets/app_section_card.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Font family and text size choices matching sreerajp_todo.
class TypographyScreen extends ConsumerWidget {
  const TypographyScreen({super.key});

  static String fontLabel(AppLocalizations l10n, AppFont font) =>
      switch (font) {
        AppFont.system => l10n.fontSystemDefault,
        AppFont.manjari => l10n.fontManjari,
        AppFont.anekMalayalam => l10n.fontAnekMalayalam,
        AppFont.notoSansMalayalam => l10n.fontNotoSansMalayalam,
      };

  static String textScaleLabel(AppLocalizations l10n, AppTextScale scale) =>
      switch (scale) {
        AppTextScale.small => l10n.textSizeSmall,
        AppTextScale.normal => l10n.textSizeDefault,
        AppTextScale.large => l10n.textSizeLarge,
        AppTextScale.larger => l10n.textSizeLarger,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentFont = ref.watch(appFontProvider);
    final currentScale = ref.watch(appTextScaleProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.typographyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppSectionCard(
            title: l10n.typographyFontLabel,
            child: Column(
              children: [
                for (final font in AppFont.values) ...[
                  if (font != AppFont.values.first) const SizedBox(height: 10),
                  _FontTile(
                    label: fontLabel(l10n, font),
                    fontFamily: font.family,
                    selected: currentFont == font,
                    onTap: () => ref.read(appFontProvider.notifier).set(font),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppSectionCard(
            title: l10n.typographyTextSizeLabel,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<AppTextScale>(
                showSelectedIcon: false,
                segments: [
                  for (final scale in AppTextScale.values)
                    ButtonSegment(
                      value: scale,
                      label: Text(textScaleLabel(l10n, scale)),
                    ),
                ],
                selected: {currentScale},
                onSelectionChanged: (selection) => ref
                    .read(appTextScaleProvider.notifier)
                    .set(selection.first),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One font row with a live preview in that font.
class _FontTile extends StatelessWidget {
  const _FontTile({
    required this.label,
    required this.fontFamily,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String? fontFamily;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.typographySampleLatin,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: fontFamily,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.typographySampleMalayalam,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: fontFamily,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
