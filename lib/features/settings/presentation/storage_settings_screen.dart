import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/core/storage/cache_service.dart';
import 'package:pdfapp/features/viewer/presentation/providers.dart';
import 'package:pdfapp/l10n/app_localizations.dart';

/// Screen for managing recent files history, cache usage, and data privacy.
class StorageSettingsScreen extends ConsumerStatefulWidget {
  const StorageSettingsScreen({super.key});

  @override
  ConsumerState<StorageSettingsScreen> createState() =>
      _StorageSettingsScreenState();
}

class _StorageSettingsScreenState extends ConsumerState<StorageSettingsScreen> {
  int _cacheSizeBytes = 0;
  bool _loadingCache = true;

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  Future<void> _loadCacheSize() async {
    final size = await const CacheService().getCacheSizeBytes();
    if (mounted) {
      setState(() {
        _cacheSizeBytes = size;
        _loadingCache = false;
      });
    }
  }

  Future<void> _clearAllCache() async {
    final l10n = AppLocalizations.of(context);
    await const CacheService().clearTempCache();
    await _loadCacheSize();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.tempCacheCleared)));
    }
  }

  Future<void> _confirmClearRecents() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.clearRecentFilesConfirmTitle),
        content: Text(l10n.clearRecentFilesConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.clearRecentFilesAction),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(pdfRepositoryProvider).clearRecents();
      await ref.read(pdfRepositoryProvider).clearReadingPositions();
      ref.invalidate(recentFilesProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.recentFilesCleared)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    final muted = colors?.mutedText ?? theme.colorScheme.onSurfaceVariant;
    final accent = theme.colorScheme.primary;

    final rememberRecents = ref.watch(rememberRecentFilesProvider);
    final cacheFormatted = _loadingCache
        ? '…'
        : CacheService.formatBytes(_cacheSizeBytes);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.storageSettingsTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
          children: [
            _sectionHeader(context, l10n.storageSettingsTitle, accent),
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
                      child: Icon(Icons.history_outlined, color: accent),
                    ),
                    title: Text(
                      l10n.rememberRecentFilesTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      l10n.rememberRecentFilesSubtitle,
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                    value: rememberRecents,
                    onChanged: (val) =>
                        ref.read(rememberRecentFilesProvider.notifier).set(val),
                  ),
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: muted.withValues(alpha: 0.18),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    title: Text(
                      l10n.clearRecentFilesTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      l10n.clearRecentFilesSubtitle,
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                    onTap: _confirmClearRecents,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.clearTempCacheTitle, accent),
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
                  l10n.clearTempCacheTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  l10n.clearTempCacheSubtitle(cacheFormatted),
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                trailing: OutlinedButton(
                  onPressed: _cacheSizeBytes > 0 ? _clearAllCache : null,
                  child: Text(l10n.annotationEraser),
                ),
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
