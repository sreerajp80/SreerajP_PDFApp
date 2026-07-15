import 'package:logger/logger.dart';
import 'package:pdfapp/app/config/app_flavor_config.dart';

/// Named logger abstraction with a fixed level taxonomy — engineering standard §14.
///
/// Rules: never log secrets, passwords, tokens, or decrypted content (§14.3).
/// `trace`/`debug` never produce output in prod (gated by the flavor).
class AppLogger {
  AppLogger._();

  static Logger? _logger;

  /// Call once during the `main()` init sequence, before any log call.
  static void init() {
    final isDev = AppFlavorConfig.instance.isDev;
    _logger = Logger(
      level: isDev ? Level.trace : Level.info,
      printer: PrettyPrinter(
        colors: isDev,
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  static Logger get _log {
    final logger = _logger;
    if (logger == null) {
      throw StateError('AppLogger.init() must be called before logging.');
    }
    return logger;
  }

  static void trace(String message) => _log.t(message);
  static void debug(String message) => _log.d(message);
  static void info(String message) => _log.i(message);
  static void warning(String message, {Object? error}) =>
      _log.w(message, error: error);
  static void error(String message, {Object? error, StackTrace? stackTrace}) =>
      _log.e(message, error: error, stackTrace: stackTrace);
  static void fatal(String message, {Object? error, StackTrace? stackTrace}) =>
      _log.f(message, error: error, stackTrace: stackTrace);
}
