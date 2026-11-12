import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfapp/core/storage/cache_service.dart';

/// Observes app lifecycle events — engineering standard §9.
///
/// Registered in the `main()` init sequence. It closes the database when the
/// app is torn down (§9.3) and clears the image cache on memory pressure (§9.2).
/// Leftover temp files from an earlier session are removed by
/// [cleanUpPreviousSession], called once at startup before any document opens.
class AppLifecycleService with WidgetsBindingObserver {
  AppLifecycleService({
    required this._database,
    this._cache = const CacheService(),
  });

  final AppDatabase _database;
  final CacheService _cache;
  bool _registered = false;

  void init() {
    if (_registered) return;
    WidgetsBinding.instance.addObserver(this);
    _registered = true;
  }

  void dispose() {
    if (!_registered) return;
    WidgetsBinding.instance.removeObserver(this);
    _registered = false;
  }

  /// Removes stale working files the app left in its private cache during an
  /// earlier session (for example one that ended in a crash). Runs at startup
  /// only, so nothing the current session uses can be touched (§9.3).
  Future<void> cleanUpPreviousSession() => _cache.clearStaleWorkingFiles();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppLogger.debug('Lifecycle: $state');
    if (state == AppLifecycleState.detached) {
      // The app is losing its last view: finish with the database cleanly
      // (§9.3).
      _closedOnDetach = true;
      unawaited(_guard('Database close failed', _database.close));
    } else if (_closedOnDetach) {
      // The same engine got a view back (rare on Android): reopen so the
      // repositories keep working.
      _closedOnDetach = false;
      unawaited(_guard('Database reopen failed', _database.open));
    }
  }

  bool _closedOnDetach = false;

  static Future<void> _guard(String what, Future<Object?> Function() op) async {
    try {
      await op();
    } catch (e, st) {
      AppLogger.error(what, error: e, stackTrace: st);
    }
  }

  @override
  void didHaveMemoryPressure() {
    AppLogger.info('Memory pressure — clearing image cache.');
    PaintingBinding.instance.imageCache
      ..clear()
      ..clearLiveImages();
  }
}
