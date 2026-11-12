import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/app.dart';
import 'package:pdfapp/app/app_restart_scope.dart';
import 'package:pdfapp/app/config/providers.dart';
import 'package:pdfapp/core/config/app_config.dart';
import 'package:pdfapp/core/config/config_service.dart';
import 'package:pdfapp/core/errors/safe_error_fallback.dart';
import 'package:pdfapp/core/lifecycle/app_lifecycle_service.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App entry point. Thin by design (engineering standard §3.2, §4.5): set up
/// logging and error boundaries, then infrastructure in order, then `runApp`.
/// Each step handles its own failure so release builds surface a safe state
/// instead of crashing.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Logging (§4.5 step 2). AppLogger never throws, even before this runs.
  AppLogger.init();
  AppLogger.info('Starting Folio.');

  // 2. Global error boundaries (§11.1) — installed before anything else can
  //    fail, so every later failure is logged rather than lost.
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.error(
      'Flutter framework error',
      error: details.exception,
      stackTrace: details.stack,
    );
    if (!kReleaseMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    AppLogger.error('Uncaught async error', error: error, stackTrace: stack);
    return true;
  };
  if (kReleaseMode) {
    ErrorWidget.builder = (details) => const SafeErrorFallback();
  }

  // 3. Database open + migrate.
  final database = AppDatabase();
  await database.open();

  // 4. App config load (non-secret settings + About values).
  final prefs = await SharedPreferences.getInstance();
  final AppConfig config = await ConfigService().loadAndVerify();

  // 5. PDF engine (pdfrx 2.x). Must be ready before any code opens a
  //    document directly, not only through the viewer widget. A failure here
  //    is logged; the viewer then shows its own friendly error.
  try {
    await pdfrxFlutterInitialize();
  } catch (e, st) {
    AppLogger.error('PDF engine init failed', error: e, stackTrace: st);
  }

  // 6. Lifecycle observer, and removal of stale temp files from an earlier
  //    session (before any document opens — §9.3).
  final lifecycle = AppLifecycleService(database: database)..init();
  await lifecycle.cleanUpPreviousSession();

  runApp(
    AppRestartScope(
      child: ProviderScope(
        // Riverpod 3 retries failed providers by default. Turn that off so a
        // failure (bad file, lost access) shows its message straight away.
        retry: (retryCount, error) => null,
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          appConfigProvider.overrideWithValue(config),
          appDatabaseProvider.overrideWithValue(database),
        ],
        child: const PdfApp(),
      ),
    ),
  );
}
