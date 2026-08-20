import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Screen for Reader and PDF Viewer preferences.
class ReaderSettingsScreen extends ConsumerWidget {
  const ReaderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;
    final accent = theme.colorScheme.primary;

    final rememberPos = ref.watch(rememberReadingPositionProvider);
    final layout = ref.watch(defaultPageLayoutProvider);
    final showIndicator = ref.watch(showPageIndicatorProvider);
    final showEstimates = ref.watch(showReadingEstimatesProvider);
    final invertColors = ref.watch(pdfInvertColorsProvider);
    final doubleTapZoom = ref.watch(doubleTapZoomProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.readerSettingsTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
          children: [
            _sectionHeader(context, l10n.readerSettingsTitle, accent),
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
                      child: Icon(Icons.bookmark_outline, color: accent),
                    ),
                    title: Text(
                      l10n.saveLastPositionTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      l10n.saveLastPositionSubtitle,
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                    value: rememberPos,
                    onChanged: (val) => ref
                        .read(rememberReadingPositionProvider.notifier)
                        .set(val),
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
                      child: Icon(Icons.numbers_outlined, color: accent),
                    ),
                    title: Text(
                      l10n.showPageIndicatorTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      l10n.showPageIndicatorSubtitle,
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                    value: showIndicator,
                    onChanged: (val) =>
                        ref.read(showPageIndicatorProvider.notifier).set(val),
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
                      child: Icon(Icons.timer_outlined, color: accent),
                    ),
                    title: Text(
                      l10n.readingTimeEstimatesToggle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      l10n.readingTimeEstimatesToggleSubtitle,
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                    value: showEstimates,
                    onChanged: (val) => ref
                        .read(showReadingEstimatesProvider.notifier)
                        .set(val),
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
                      child: Icon(Icons.invert_colors_outlined, color: accent),
                    ),
                    title: Text(
                      l10n.invertColorsTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      l10n.invertColorsSubtitle,
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                    value: invertColors,
                    onChanged: (val) =>
                        ref.read(pdfInvertColorsProvider.notifier).set(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.defaultPageLayoutTitle, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.devices_outlined,
                      color: layout == 'auto' ? accent : muted,
                    ),
                    title: Text(
                      l10n.viewModeAuto,
                      style: TextStyle(
                        fontWeight: layout == 'auto'
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: layout == 'auto' ? accent : null,
                      ),
                    ),
                    subtitle: Text(
                      l10n.viewModeAutoSubtitle,
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                    trailing: layout == 'auto'
                        ? Icon(Icons.check_circle, color: accent)
                        : null,
                    onTap: () => ref
                        .read(defaultPageLayoutProvider.notifier)
                        .set('auto'),
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.view_agenda_outlined,
                      color: layout == 'continuous' ? accent : muted,
                    ),
                    title: Text(
                      l10n.layoutContinuous,
                      style: TextStyle(
                        fontWeight: layout == 'continuous'
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: layout == 'continuous' ? accent : null,
                      ),
                    ),
                    trailing: layout == 'continuous'
                        ? Icon(Icons.check_circle, color: accent)
                        : null,
                    onTap: () => ref
                        .read(defaultPageLayoutProvider.notifier)
                        .set('continuous'),
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.auto_stories_outlined,
                      color: layout == 'single_page' ? accent : muted,
                    ),
                    title: Text(
                      l10n.layoutSinglePage,
                      style: TextStyle(
                        fontWeight: layout == 'single_page'
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: layout == 'single_page' ? accent : null,
                      ),
                    ),
                    trailing: layout == 'single_page'
                        ? Icon(Icons.check_circle, color: accent)
                        : null,
                    onTap: () => ref
                        .read(defaultPageLayoutProvider.notifier)
                        .set('single_page'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.doubleTapZoomTitle, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.fit_screen_outlined,
                      color: doubleTapZoom == 'fit_width' ? accent : muted,
                    ),
                    title: Text(
                      l10n.zoomFitWidth,
                      style: TextStyle(
                        fontWeight: doubleTapZoom == 'fit_width'
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: doubleTapZoom == 'fit_width' ? accent : null,
                      ),
                    ),
                    trailing: doubleTapZoom == 'fit_width'
                        ? Icon(Icons.check_circle, color: accent)
                        : null,
                    onTap: () => ref
                        .read(doubleTapZoomProvider.notifier)
                        .set('fit_width'),
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.zoom_in_outlined,
                      color: doubleTapZoom == 'zoom_200' ? accent : muted,
                    ),
                    title: Text(
                      l10n.zoom200,
                      style: TextStyle(
                        fontWeight: doubleTapZoom == 'zoom_200'
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: doubleTapZoom == 'zoom_200' ? accent : null,
                      ),
                    ),
                    trailing: doubleTapZoom == 'zoom_200'
                        ? Icon(Icons.check_circle, color: accent)
                        : null,
                    onTap: () => ref
                        .read(doubleTapZoomProvider.notifier)
                        .set('zoom_200'),
                  ),
                ],
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
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
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
