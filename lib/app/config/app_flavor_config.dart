/// Build flavor (dev / prod). Two-variable pattern — engineering standard §5.2.
///
/// - `APP_FLAVOR` is passed by desktop builds via `--dart-define=APP_FLAVOR=<value>`.
/// - `FLUTTER_APP_FLAVOR` is auto-injected by the Flutter tool on Android/iOS when
///   `--flavor` is passed. It must never be set via `--dart-define` (the build fails).
enum AppFlavor { dev, prod }

class AppFlavorConfig {
  AppFlavorConfig._(this.flavor);

  static const _appFlavorValue = String.fromEnvironment('APP_FLAVOR');

  static const _frameworkFlavorValue = String.fromEnvironment(
    'FLUTTER_APP_FLAVOR',
    defaultValue: 'prod',
  );

  static String _resolved() =>
      _appFlavorValue.isNotEmpty ? _appFlavorValue : _frameworkFlavorValue;

  static final AppFlavorConfig instance = AppFlavorConfig._(
    _parse(_resolved()),
  );

  final AppFlavor flavor;

  static AppFlavor _parse(String value) {
    switch (value.trim().toLowerCase()) {
      case 'dev':
        return AppFlavor.dev;
      case 'prod':
      default:
        return AppFlavor.prod;
    }
  }

  bool get isDev => flavor == AppFlavor.dev;
  bool get isProd => flavor == AppFlavor.prod;

  String get appName => isDev ? 'SreerajP PDF App Dev' : 'SreerajP PDF App';
  bool get showEnvironmentBanner => isDev;
  bool get enableVerboseLogging => isDev;
}
