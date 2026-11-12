import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/core/format/display_format.dart';
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.descPrinterCacheCleared)));
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
        : DisplayFormat.bytes(
            _cacheSizeBytes,
            Localizations.localeOf(context).toString(),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.titlePrinterSettings),
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
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 48),
          children: [
            _sectionHeader(context, l10n.titlePrinterSettings, accent),
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
                  l10n.titlePrinterEnable,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  l10n.descPrinterEnableSubtitle,
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                value: printerEnabled,
                onChanged: (val) =>
                    ref.read(pdfPrinterEnabledProvider.notifier).set(val),
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.titleDefaultPaperSize, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _optionTile(
                    title: l10n.labelPaperA4,
                    subtitle: l10n.descPaperA4,
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
                    title: l10n.labelPaperLetter,
                    subtitle: l10n.descPaperLetter,
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
                    title: l10n.labelPaperLegal,
                    subtitle: l10n.descPaperLegal,
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
            _sectionHeader(context, l10n.titleDefaultColorMode, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _optionTile(
                    title: l10n.labelColorModeColor,
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
                    title: l10n.labelColorModeGrayscale,
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
                    title: l10n.descColorModeMonochrome,
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
            _sectionHeader(context, l10n.titleDefaultOrientation, accent),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _optionTile(
                    title: l10n.labelOrientationAuto,
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
                    title: l10n.labelOrientationPortrait,
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
                    title: l10n.labelOrientationLandscape,
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
            _sectionHeader(context, l10n.titleClearPrinterCache, accent),
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
                  l10n.titleClearPrinterCache,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  l10n.descClearPrinterCacheSubtitle(cacheSizeFormatted),
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                trailing: OutlinedButton(
                  onPressed: _cacheSizeBytes > 0 ? _clearCache : null,
                  child: Text(l10n.labelAnnotationEraser),
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
    String? subtitle,
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
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: selected ? Icon(Icons.check_circle, color: accent) : null,
      onTap: onTap,
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
