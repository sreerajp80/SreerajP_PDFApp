import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/core/platform/open_document_channel.dart';
import 'package:pdfapp/core/storage/cache_service.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Screen for configuring PDF Virtual Printer integration and default print settings.
class PrinterSettingsScreen extends ConsumerStatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  ConsumerState<PrinterSettingsScreen> createState() =>
      _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends ConsumerState<PrinterSettingsScreen> {
  int _cacheSizeBytes = 0;
  bool _loadingSize = true;

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  Future<void> _loadCacheSize() async {
    final size = await const CacheService().getPrinterCacheSizeBytes();
    if (mounted) {
      setState(() {
        _cacheSizeBytes = size;
        _loadingSize = false;
      });
    }
  }

  Future<void> _clearCache() async {
    final l10n = AppLocalizations.of(context);
    await const CacheService().clearPrinterCache();
    await _loadCacheSize();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.printerCacheCleared)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;
    final accent = theme.colorScheme.primary;

    final printerEnabled = ref.watch(pdfPrinterEnabledProvider);
    final paperSize = ref.watch(defaultPaperSizeProvider);
    final colorMode = ref.watch(defaultPrintColorModeProvider);
    final orientation = ref.watch(defaultPrintOrientationProvider);

    final cacheSizeFormatted = _loadingSize
        ? '…'
        : CacheService.formatBytes(_cacheSizeBytes);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.printerSettingsTitle),
        actions: [
          IconButton(
            tooltip: l10n.helpOpenPrintSettings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => OpenDocumentChannel().openPrintSettings(),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
          children: [
            _sectionHeader(context, l10n.printerSettingsTitle, accent),
            Card(
              margin: EdgeInsets.zero,
              child: SwitchListTile(
                secondary: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.print_outlined, color: accent),
                ),
                title: Text(
                  l10n.printerEnableTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  l10n.printerEnableSubtitle,
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                value: printerEnabled,
                onChanged: (val) =>
                    ref.read(pdfPrinterEnabledProvider.notifier).set(val),
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.defaultPaperSizeTitle, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _optionTile(
                    title: 'A4 (210 × 297 mm)',
                    selected: paperSize == 'A4',
                    onTap: () =>
                        ref.read(defaultPaperSizeProvider.notifier).set('A4'),
                    accent: accent,
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  _optionTile(
                    title: 'US Letter (8.5 × 11 in)',
                    selected: paperSize == 'Letter',
                    onTap: () => ref
                        .read(defaultPaperSizeProvider.notifier)
                        .set('Letter'),
                    accent: accent,
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  _optionTile(
                    title: 'Legal (8.5 × 14 in)',
                    selected: paperSize == 'Legal',
                    onTap: () => ref
                        .read(defaultPaperSizeProvider.notifier)
                        .set('Legal'),
                    accent: accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.defaultColorModeTitle, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _optionTile(
                    title: l10n.colorModeColor,
                    selected: colorMode == 'color',
                    onTap: () => ref
                        .read(defaultPrintColorModeProvider.notifier)
                        .set('color'),
                    accent: accent,
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  _optionTile(
                    title: l10n.colorModeGrayscale,
                    selected: colorMode == 'grayscale',
                    onTap: () => ref
                        .read(defaultPrintColorModeProvider.notifier)
                        .set('grayscale'),
                    accent: accent,
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  _optionTile(
                    title: l10n.colorModeMonochrome,
                    selected: colorMode == 'monochrome',
                    onTap: () => ref
                        .read(defaultPrintColorModeProvider.notifier)
                        .set('monochrome'),
                    accent: accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.defaultOrientationTitle, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _optionTile(
                    title: l10n.orientationAuto,
                    selected: orientation == 'auto',
                    onTap: () => ref
                        .read(defaultPrintOrientationProvider.notifier)
                        .set('auto'),
                    accent: accent,
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  _optionTile(
                    title: l10n.orientationPortrait,
                    selected: orientation == 'portrait',
                    onTap: () => ref
                        .read(defaultPrintOrientationProvider.notifier)
                        .set('portrait'),
                    accent: accent,
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  _optionTile(
                    title: l10n.orientationLandscape,
                    selected: orientation == 'landscape',
                    onTap: () => ref
                        .read(defaultPrintOrientationProvider.notifier)
                        .set('landscape'),
                    accent: accent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.clearPrinterCacheTitle, accent),
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.cleaning_services_outlined, color: accent),
                ),
                title: Text(
                  l10n.clearPrinterCacheTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  l10n.clearPrinterCacheSubtitle(cacheSizeFormatted),
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                trailing: OutlinedButton(
                  onPressed: _cacheSizeBytes > 0 ? _clearCache : null,
                  child: Text(l10n.annotationEraser),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionTile({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    required Color accent,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? accent : null,
        ),
      ),
      trailing: selected ? Icon(Icons.check_circle, color: accent) : null,
      onTap: onTap,
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
