import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/app.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/config/app_config.dart';
import 'package:pdfapp/core/config/config_service.dart';
import 'package:pdfapp/core/errors/safe_error_fallback.dart';
import 'package:pdfapp/core/lifecycle/app_lifecycle_service.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App entry point. Thin by design (engineering standard §3.2, §4.5): set up
/// error boundaries and infrastructure in order, then `runApp`. Each step handles
/// its own failure so release builds surface a safe state instead of crashing.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Global error boundaries (engineering standard §11.1) — install first so
  //    any failure below is logged rather than lost.
  FlutterError.onError = (FlutterErrorDetails details) {
    _safeLog('Flutter framework error', details.exception, details.stack);
    if (!kReleaseMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    _safeLog('Uncaught async error', error, stack);
    return true;
  };
  if (kReleaseMode) {
    ErrorWidget.builder = (details) => const SafeErrorFallback();
  }

  // 2. Logging (needs the flavor; independent of DB/config).
  AppLogger.init();
  AppLogger.info('Starting PDF App.');

  // 3. Database open + migrate.
  final database = AppDatabase();
  await database.open();

  // 4. App config load (non-secret settings + About values).
  final prefs = await SharedPreferences.getInstance();
  final AppConfig config = await ConfigService().loadAndVerify();

  // 5. Lifecycle observer.
  AppLifecycleService().init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appConfigProvider.overrideWithValue(config),
        appDatabaseProvider.overrideWithValue(database),
      ],
      child: const PdfApp(),
    ),
  );
}

/// Logs through [AppLogger] when ready, else falls back to `debugPrint` in debug.
void _safeLog(String message, Object error, StackTrace? stack) {
  try {
    AppLogger.error(message, error: error, stackTrace: stack);
  } catch (_) {
    if (!kReleaseMode) {
      debugPrint('$message: $error');
    }
  }
}
