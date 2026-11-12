import 'package:logger/logger.dart';
import 'package:pdfapp/app/config/app_flavor_config.dart';

/// Named logger abstraction with a fixed level taxonomy — engineering standard §14.
///
/// Rules: never log secrets, passwords, tokens, or decrypted content (§14.3).
/// `trace`/`debug` never produce output in prod (gated by the flavor).
class AppLogger {
  AppLogger._();

  static Level get _level =>
      AppFlavorConfig.instance.isDev ? Level.trace : Level.info;

  /// Console-only logger used until [init] runs, so a log call made before
  /// startup finishes (for example from a global error handler) never throws
  /// (§14.2).
  static Logger _logger = Logger(level: _level, printer: SimplePrinter());

  /// Call once at step 2 of the `main()` init sequence (§4.5). Swaps in the
  /// full logger.
  static void init() {
    final isDev = AppFlavorConfig.instance.isDev;
    _logger = Logger(
      level: _level,
      printer: PrettyPrinter(
        colors: isDev,
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  static void trace(String message) => _logger.t(message);
  static void debug(String message) => _logger.d(message);
  static void info(String message) => _logger.i(message);
  static void warning(String message, {Object? error}) =>
      _logger.w(message, error: error);
  static void error(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
  static void fatal(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.f(message, error: error, stackTrace: stackTrace);
}
