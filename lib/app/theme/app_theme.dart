import 'package:flutter/material.dart';
import 'package:pdfapp/app/theme/tokens.dart';

/// User-selectable theme. `system` follows the device; `sepia` is a reading-comfort
/// mode (a warm light theme) offered alongside light/dark.
enum AppThemeMode { system, light, dark, sepia }

extension AppThemeModeX on AppThemeMode {
  String get storageValue => name;

  static AppThemeMode fromStorage(String? value) {
    return AppThemeMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => AppThemeMode.system,
    );
  }
}

/// Material 3 themes built from [AppTokens]. Light and dark are generated from the
/// brand seed; sepia is a hand-tuned warm scheme for comfortable reading.
class AppTheme {
  const AppTheme._();

  static ThemeData get light =>
      _fromScheme(ColorScheme.fromSeed(seedColor: AppTokens.seed));

  static ThemeData get dark => _fromScheme(
    ColorScheme.fromSeed(
      seedColor: AppTokens.seed,
      brightness: Brightness.dark,
    ),
  );

  static ThemeData get sepia => _fromScheme(
    ColorScheme.fromSeed(
      seedColor: AppTokens.seed,
      surface: AppTokens.sepiaSurface,
      onSurface: AppTokens.sepiaOnSurface,
    ).copyWith(surface: AppTokens.sepiaSurface),
  ).copyWith(scaffoldBackgroundColor: AppTokens.sepiaBackground);

  static ThemeData _fromScheme(ColorScheme scheme) {
    return ThemeData(
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}

/// Maps an [AppThemeMode] onto the `theme` / `darkTheme` / `themeMode` trio that
/// `MaterialApp` expects.
class ResolvedTheme {
  const ResolvedTheme(this.light, this.dark, this.mode);

  final ThemeData light;
  final ThemeData dark;
  final ThemeMode mode;

  factory ResolvedTheme.of(AppThemeMode selected) {
    switch (selected) {
      case AppThemeMode.system:
        return ResolvedTheme(AppTheme.light, AppTheme.dark, ThemeMode.system);
      case AppThemeMode.light:
        return ResolvedTheme(AppTheme.light, AppTheme.dark, ThemeMode.light);
      case AppThemeMode.dark:
        return ResolvedTheme(AppTheme.light, AppTheme.dark, ThemeMode.dark);
      case AppThemeMode.sepia:
        // Force the warm light theme regardless of system brightness.
        return ResolvedTheme(AppTheme.sepia, AppTheme.sepia, ThemeMode.light);
    }
  }
}
