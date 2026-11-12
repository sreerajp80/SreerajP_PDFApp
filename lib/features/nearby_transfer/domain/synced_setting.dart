import 'package:pdfapp/core/constants/app_constants.dart';

/// The type a synced setting is stored as in shared_preferences.
enum SettingValueType { boolean, integer, decimal, text }

/// One setting that Device sync may copy to another phone (plan
/// `20261112_104132_device_sync_qr_wifi.md` §3.4).
///
/// This is an **allow-list**: only the settings named here ever leave the
/// phone. Settings that belong to one phone (the Malayalam voice engine choice
/// and the system print service switch) are left out on purpose, and so is
/// everything that is not a setting (recent files, reading positions,
/// annotations, trusted certificates).
///
/// [wireId] is a short, fixed id used in the QR code and on the wire, so the
/// settings QR code stays small enough to scan easily. Never reuse or change an
/// id: phones with an older app version must keep reading it the same way.
enum SyncedSetting {
  themeMode('tm', AppConstants.prefThemeMode, SettingValueType.text),
  accentLight('al', AppConstants.prefAccentLight, SettingValueType.integer),
  accentDark('ad', AppConstants.prefAccentDark, SettingValueType.integer),
  appFont('af', AppConstants.prefAppFont, SettingValueType.integer),
  textScale('ts', AppConstants.prefTextScale, SettingValueType.integer),
  appLocale('lo', AppConstants.prefAppLocale, SettingValueType.text),
  rememberReadingPosition(
    'rp',
    AppConstants.prefRememberReadingPosition,
    SettingValueType.boolean,
  ),
  showReadingEstimates(
    're',
    AppConstants.prefShowReadingEstimates,
    SettingValueType.boolean,
  ),
  defaultPageLayout(
    'pl',
    AppConstants.prefDefaultPageLayout,
    SettingValueType.text,
  ),
  showPageIndicator(
    'pi',
    AppConstants.prefShowPageIndicator,
    SettingValueType.boolean,
  ),
  pdfInvertColors(
    'ic',
    AppConstants.prefPdfInvertColors,
    SettingValueType.boolean,
  ),
  doubleTapZoom('dz', AppConstants.prefDoubleTapZoom, SettingValueType.text),
  defaultPaperSize(
    'ps',
    AppConstants.prefDefaultPaperSize,
    SettingValueType.text,
  ),
  defaultPrintColorMode(
    'cm',
    AppConstants.prefDefaultPrintColorMode,
    SettingValueType.text,
  ),
  defaultPrintOrientation(
    'po',
    AppConstants.prefDefaultPrintOrientation,
    SettingValueType.text,
  ),
  ttsSpeechRate('sr', AppConstants.prefTtsSpeechRate, SettingValueType.decimal),
  ttsPitch('tp', AppConstants.prefTtsPitch, SettingValueType.decimal),
  ttsSentencePause(
    'sp',
    AppConstants.prefTtsSentencePause,
    SettingValueType.decimal,
  ),
  ttsAutoScroll('as', AppConstants.prefTtsAutoScroll, SettingValueType.boolean),
  rememberRecentFiles(
    'rf',
    AppConstants.prefRememberRecentFiles,
    SettingValueType.boolean,
  ),
  autoVerifySignatures(
    'av',
    AppConstants.prefAutoVerifySignatures,
    SettingValueType.boolean,
  );

  const SyncedSetting(this.wireId, this.prefKey, this.type);

  final String wireId;
  final String prefKey;
  final SettingValueType type;

  static SyncedSetting? byWireId(String id) {
    for (final s in values) {
      if (s.wireId == id) return s;
    }
    return null;
  }

  /// Whether [value] is a value this setting can really hold. `null` always
  /// passes: it means "not set, use the app default".
  ///
  /// The ranges match what the settings screens can produce, so a damaged or
  /// hand-made code can never put the app into a state its own screens could
  /// not reach.
  bool accepts(Object? value) {
    if (value == null) return true;
    return switch (this) {
      themeMode => _oneOf(value, const [
        'system',
        'light',
        'dark',
        'sepia',
        'oled',
      ]),
      accentLight || accentDark => _intIn(value, -0x80000000, 0xFFFFFFFF),
      appFont => _intIn(value, 0, 3),
      textScale => _intIn(value, 0, 3),
      appLocale => _oneOf(value, const ['en', 'ml', 'sa']),
      defaultPageLayout => _oneOf(value, const ['continuous', 'single_page']),
      doubleTapZoom => _oneOf(value, const ['fit_width', 'zoom_200']),
      defaultPaperSize => _oneOf(value, const ['A4', 'Letter', 'Legal']),
      defaultPrintColorMode => _oneOf(value, const [
        'color',
        'grayscale',
        'monochrome',
      ]),
      defaultPrintOrientation => _oneOf(value, const [
        'auto',
        'portrait',
        'landscape',
      ]),
      ttsSpeechRate || ttsPitch => _decimalIn(value, 0.5, 2.0),
      ttsSentencePause => _decimalIn(value, 0.0, 2.0),
      rememberReadingPosition ||
      showReadingEstimates ||
      showPageIndicator ||
      pdfInvertColors ||
      ttsAutoScroll ||
      rememberRecentFiles ||
      autoVerifySignatures => value is bool,
    };
  }

  static bool _oneOf(Object value, List<String> allowed) =>
      value is String && allowed.contains(value);

  static bool _intIn(Object value, int min, int max) =>
      value is int && value >= min && value <= max;

  static bool _decimalIn(Object value, double min, double max) =>
      value is num && value.isFinite && value >= min && value <= max;
}
