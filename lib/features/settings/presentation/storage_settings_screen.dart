import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/app_restart_scope.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/app/routing/app_router.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/core/errors/user_error_message.dart';
import 'package:pdfapp/core/format/display_format.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/core/storage/cache_service.dart';
import 'package:pdfapp/features/settings/presentation/providers.dart';
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.descTempCacheCleared)));
    }
  }

  Future<void> _confirmClearRecents() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.titleClearRecentFilesConfirm),
        content: Text(l10n.bodyClearRecentFilesConfirm),
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
            child: Text(l10n.actionClearRecentFiles),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(pdfRepositoryProvider).clearRecents();
      await ref.read(pdfRepositoryProvider).clearReadingPositions();
      ref.invalidate(recentFilesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.descRecentFilesCleared)));
      }
    }
  }

  bool _deleting = false;

  /// "Delete all data" (engineering standard §15.4): confirm with a clearly
  /// destructive button (§6.4), purge, then restart the app from home so
  /// nothing deleted lingers in memory.
  Future<void> _confirmDeleteAllData() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.titleDeleteAllDataConfirm),
        content: Text(l10n.bodyDeleteAllDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.actionDeleteAllData),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await ref.read(appDataPurgeServiceProvider).deleteAll();
      if (!mounted) return;
      GoRouter.of(context).go(AppRoute.home.path);
      AppRestartScope.restart(context);
    } catch (e, st) {
      AppLogger.error('Delete all data failed', error: e, stackTrace: st);
      if (!mounted) return;
      setState(() => _deleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            userErrorMessage(l10n, e, fallback: l10n.errorDeleteAllData),
          ),
          action: SnackBarAction(
            label: l10n.actionTryAgain,
            onPressed: () {
              if (mounted && !_deleting) _confirmDeleteAllData();
            },
          ),
        ),
      );
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
        : DisplayFormat.bytes(
            _cacheSizeBytes,
            Localizations.localeOf(context).toString(),
          );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.titleStorageSettings)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 48),
          children: [
            _sectionHeader(context, l10n.titleStorageSettings, accent),
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
                      l10n.titleRememberRecentFiles,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      l10n.descRememberRecentFilesSubtitle,
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
                      l10n.titleClearRecentFiles,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      l10n.descClearRecentFilesSubtitle,
                      style: TextStyle(color: muted, fontSize: 13),
                    ),
                    onTap: _confirmClearRecents,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.titleClearTempCache, accent),
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
                  l10n.titleClearTempCache,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  l10n.descClearTempCacheSubtitle(cacheFormatted),
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                trailing: OutlinedButton(
                  onPressed: _cacheSizeBytes > 0 ? _clearAllCache : null,
                  child: Text(l10n.actionClear),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _sectionHeader(context, l10n.titleAppData, accent),
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
                    color: theme.colorScheme.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.delete_forever_outlined,
                    color: theme.colorScheme.error,
                  ),
                ),
                title: Text(
                  l10n.actionDeleteAllData,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: theme.colorScheme.error,
                  ),
                ),
                subtitle: Text(
                  l10n.descDeleteAllData,
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                onTap: _deleting ? null : _confirmDeleteAllData,
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
