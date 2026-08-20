import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfapp/app/theme/app_theme.dart';
import 'package:pdfapp/core/config/app_config.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/core/storage/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Root providers. The three below are **overridden in `main()`** with the values
/// created during the init sequence, so widgets can read them synchronously.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) =>
      throw UnimplementedError('Override sharedPreferencesProvider in main.'),
);

final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('Override appConfigProvider in main.'),
);

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('Override appDatabaseProvider in main.'),
);

/// Selected theme, persisted in shared_preferences (non-secret setting).
final themeModeProvider = NotifierProvider<ThemeModeNotifier, AppThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AppThemeModeX.fromStorage(
      prefs.getString(AppConstants.prefThemeMode),
    );
  }

  Future<void> set(AppThemeMode mode) async {
    state = mode;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppConstants.prefThemeMode, mode.storageValue);
  }
}

/// Light theme accent color override (persisted in shared_preferences).
final lightAccentProvider = NotifierProvider<LightAccentNotifier, Color?>(
  LightAccentNotifier.new,
);

class LightAccentNotifier extends Notifier<Color?> {
  @override
  Color? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final val = prefs.getInt(AppConstants.prefAccentLight);
    return val != null ? Color(val) : null;
  }

  Future<void> set(Color? color) async {
    state = color;
    final prefs = ref.read(sharedPreferencesProvider);
    if (color == null) {
      await prefs.remove(AppConstants.prefAccentLight);
    } else {
      await prefs.setInt(AppConstants.prefAccentLight, color.toARGB32());
    }
  }
}

/// Dark theme accent color override (persisted in shared_preferences).
final darkAccentProvider = NotifierProvider<DarkAccentNotifier, Color?>(
  DarkAccentNotifier.new,
);

class DarkAccentNotifier extends Notifier<Color?> {
  @override
  Color? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final val = prefs.getInt(AppConstants.prefAccentDark);
    return val != null ? Color(val) : null;
  }

  Future<void> set(Color? color) async {
    state = color;
    final prefs = ref.read(sharedPreferencesProvider);
    if (color == null) {
      await prefs.remove(AppConstants.prefAccentDark);
    } else {
      await prefs.setInt(AppConstants.prefAccentDark, color.toARGB32());
    }
  }
}

/// App-wide UI font the user can pick in Settings -> Appearance -> Typography.
enum AppFont {
  system,
  manjari,
  anekMalayalam,
  notoSansMalayalam;

  String? get family => switch (this) {
    AppFont.system => null,
    AppFont.manjari => 'Manjari',
    AppFont.anekMalayalam => 'Anek Malayalam',
    AppFont.notoSansMalayalam => 'Noto Sans Malayalam',
  };
}

/// App-wide text size the user can pick in Settings -> Appearance -> Typography.
enum AppTextScale {
  small,
  normal,
  large,
  larger;

  double get scale => switch (this) {
    AppTextScale.small => 0.85,
    AppTextScale.normal => 1.0,
    AppTextScale.large => 1.15,
    AppTextScale.larger => 1.30,
  };
}

/// Selected font family provider.
final appFontProvider = NotifierProvider<AppFontNotifier, AppFont>(
  AppFontNotifier.new,
);

class AppFontNotifier extends Notifier<AppFont> {
  @override
  AppFont build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final idx = prefs.getInt(AppConstants.prefAppFont);
    if (idx == null || idx < 0 || idx >= AppFont.values.length) {
      return AppFont.system;
    }
    return AppFont.values[idx];
  }

  Future<void> set(AppFont font) async {
    state = font;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(AppConstants.prefAppFont, font.index);
  }
}

/// Text scaling provider.
final appTextScaleProvider =
    NotifierProvider<AppTextScaleNotifier, AppTextScale>(
      AppTextScaleNotifier.new,
    );

class AppTextScaleNotifier extends Notifier<AppTextScale> {
  @override
  AppTextScale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final idx = prefs.getInt(AppConstants.prefTextScale);
    if (idx == null || idx < 0 || idx >= AppTextScale.values.length) {
      return AppTextScale.normal;
    }
    return AppTextScale.values[idx];
  }

  Future<void> set(AppTextScale scale) async {
    state = scale;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(AppConstants.prefTextScale, scale.index);
  }
}

/// Dynamic in-app locale (null = system default, 'en', 'ml').
final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale?>(
  AppLocaleNotifier.new,
);

class AppLocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final code = prefs.getString(AppConstants.prefAppLocale);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> set(Locale? locale) async {
    state = locale;
    final prefs = ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.remove(AppConstants.prefAppLocale);
    } else {
      await prefs.setString(AppConstants.prefAppLocale, locale.languageCode);
    }
  }
}

/// Reader: Save last reading position toggle.
final rememberReadingPositionProvider =
    NotifierProvider<RememberReadingPositionNotifier, bool>(
      RememberReadingPositionNotifier.new,
    );

class RememberReadingPositionNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(AppConstants.prefRememberReadingPosition) ?? true;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.prefRememberReadingPosition, value);
  }
}

/// Reader: Default page layout ('continuous' vs 'single_page').
final defaultPageLayoutProvider =
    NotifierProvider<DefaultPageLayoutNotifier, String>(
      DefaultPageLayoutNotifier.new,
    );

class DefaultPageLayoutNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(AppConstants.prefDefaultPageLayout) ?? 'continuous';
  }

  Future<void> set(String value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppConstants.prefDefaultPageLayout, value);
  }
}

/// Reader: Show page indicator overlay.
final showPageIndicatorProvider =
    NotifierProvider<ShowPageIndicatorNotifier, bool>(
      ShowPageIndicatorNotifier.new,
    );

class ShowPageIndicatorNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(AppConstants.prefShowPageIndicator) ?? true;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.prefShowPageIndicator, value);
  }
}

/// Reader: Invert PDF colors for dark mode reading.
final pdfInvertColorsProvider = NotifierProvider<PdfInvertColorsNotifier, bool>(
  PdfInvertColorsNotifier.new,
);

class PdfInvertColorsNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(AppConstants.prefPdfInvertColors) ?? false;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.prefPdfInvertColors, value);
  }
}

/// Reader: Double-tap zoom behavior ('fit_width' vs 'zoom_200').
final doubleTapZoomProvider = NotifierProvider<DoubleTapZoomNotifier, String>(
  DoubleTapZoomNotifier.new,
);

class DoubleTapZoomNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(AppConstants.prefDoubleTapZoom) ?? 'fit_width';
  }

  Future<void> set(String value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppConstants.prefDoubleTapZoom, value);
  }
}

/// PDF Printer: Enable/disable virtual printer integration.
final pdfPrinterEnabledProvider =
    NotifierProvider<PdfPrinterEnabledNotifier, bool>(
      PdfPrinterEnabledNotifier.new,
    );

class PdfPrinterEnabledNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(AppConstants.prefPdfPrinterEnabled) ?? true;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.prefPdfPrinterEnabled, value);
  }
}

/// PDF Printer: Default paper size ('A4', 'Letter', 'Legal').
final defaultPaperSizeProvider =
    NotifierProvider<DefaultPaperSizeNotifier, String>(
      DefaultPaperSizeNotifier.new,
    );

class DefaultPaperSizeNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(AppConstants.prefDefaultPaperSize) ?? 'A4';
  }

  Future<void> set(String value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppConstants.prefDefaultPaperSize, value);
  }
}

/// PDF Printer: Default print color mode ('color', 'grayscale', 'monochrome').
final defaultPrintColorModeProvider =
    NotifierProvider<DefaultPrintColorModeNotifier, String>(
      DefaultPrintColorModeNotifier.new,
    );

class DefaultPrintColorModeNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(AppConstants.prefDefaultPrintColorMode) ?? 'color';
  }

  Future<void> set(String value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppConstants.prefDefaultPrintColorMode, value);
  }
}

/// PDF Printer: Default print orientation ('auto', 'portrait', 'landscape').
final defaultPrintOrientationProvider =
    NotifierProvider<DefaultPrintOrientationNotifier, String>(
      DefaultPrintOrientationNotifier.new,
    );

class DefaultPrintOrientationNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(AppConstants.prefDefaultPrintOrientation) ?? 'auto';
  }

  Future<void> set(String value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppConstants.prefDefaultPrintOrientation, value);
  }
}

/// TTS: Speech rate (0.5 to 2.0).
final ttsSpeechRateProvider = NotifierProvider<TtsSpeechRateNotifier, double>(
  TtsSpeechRateNotifier.new,
);

class TtsSpeechRateNotifier extends Notifier<double> {
  @override
  double build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getDouble(AppConstants.prefTtsSpeechRate) ?? 1.0;
  }

  Future<void> set(double value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setDouble(AppConstants.prefTtsSpeechRate, value);
  }
}

/// TTS: Pitch (0.5 to 2.0).
final ttsPitchProvider = NotifierProvider<TtsPitchNotifier, double>(
  TtsPitchNotifier.new,
);

class TtsPitchNotifier extends Notifier<double> {
  @override
  double build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getDouble(AppConstants.prefTtsPitch) ?? 1.0;
  }

  Future<void> set(double value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setDouble(AppConstants.prefTtsPitch, value);
  }
}

/// TTS: Sentence-ending pause (0.0 to 2.0 seconds).
final ttsSentencePauseProvider =
    NotifierProvider<TtsSentencePauseNotifier, double>(
      TtsSentencePauseNotifier.new,
    );

class TtsSentencePauseNotifier extends Notifier<double> {
  @override
  double build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getDouble(AppConstants.prefTtsSentencePause) ?? 0.4;
  }

  Future<void> set(double value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setDouble(AppConstants.prefTtsSentencePause, value);
  }
}

/// Reader: Show reading velocity and time estimates overlay.
final showReadingEstimatesProvider =
    NotifierProvider<ShowReadingEstimatesNotifier, bool>(
      ShowReadingEstimatesNotifier.new,
    );

class ShowReadingEstimatesNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(AppConstants.prefShowReadingEstimates) ?? true;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.prefShowReadingEstimates, value);
  }
}

/// TTS: Auto-scroll with spoken sentences.
final ttsAutoScrollProvider = NotifierProvider<TtsAutoScrollNotifier, bool>(
  TtsAutoScrollNotifier.new,
);

class TtsAutoScrollNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(AppConstants.prefTtsAutoScroll) ?? true;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.prefTtsAutoScroll, value);
  }
}

/// Storage: Remember recent files toggle.
final rememberRecentFilesProvider =
    NotifierProvider<RememberRecentFilesNotifier, bool>(
      RememberRecentFilesNotifier.new,
    );

class RememberRecentFilesNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(AppConstants.prefRememberRecentFiles) ?? true;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.prefRememberRecentFiles, value);
  }
}

/// Security: Auto-verify signatures when opening signed PDFs.
final autoVerifySignaturesProvider =
    NotifierProvider<AutoVerifySignaturesNotifier, bool>(
      AutoVerifySignaturesNotifier.new,
    );

class AutoVerifySignaturesNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(AppConstants.prefAutoVerifySignatures) ?? true;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(AppConstants.prefAutoVerifySignatures, value);
  }
}
