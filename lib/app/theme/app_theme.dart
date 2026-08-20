import 'package:flutter/material.dart';
import 'package:pdfapp/app/theme/tokens.dart';

/// User-selectable theme. `system` follows the device; `sepia` is a reading-comfort
/// mode (a warm light theme) offered alongside light/dark.
enum AppThemeMode { system, light, dark, sepia, oled }

extension AppThemeModeX on AppThemeMode {
  String get storageValue => name;

  static AppThemeMode fromStorage(String? value) {
    return AppThemeMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => AppThemeMode.system,
    );
  }
}

/// Design tokens that aren't part of [ColorScheme] but are shared across the
/// screens and cards.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final bool isDark;
  final Color cardSurface;
  final Color mutedText;
  final Color gradientStart;
  final Color gradientEnd;

  const AppColors({
    required this.isDark,
    required this.cardSurface,
    required this.mutedText,
    required this.gradientStart,
    required this.gradientEnd,
  });

  LinearGradient get brandGradient => LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  AppColors copyWith({
    bool? isDark,
    Color? cardSurface,
    Color? mutedText,
    Color? gradientStart,
    Color? gradientEnd,
  }) {
    return AppColors(
      isDark: isDark ?? this.isDark,
      cardSurface: cardSurface ?? this.cardSurface,
      mutedText: mutedText ?? this.mutedText,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      isDark: t < 0.5 ? isDark : other.isDark,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
    );
  }
}

/// Material 3 themes built from [AppTokens] and user-selected accent colors.
class AppTheme {
  const AppTheme._();

  /// Default accent for the light / sepia theme.
  static const Color defaultLightAccent = Color(0xFF3D5A80);

  /// Default accent for the dark theme.
  static const Color defaultDarkAccent = Color(0xFF7C8AFF);

  /// Preset accents shown as quick picks above the custom wheel.
  static const List<Color> presetAccents = <Color>[
    Color(0xFF3D5A80), // Slate blue
    Color(0xFF0D9488), // Teal
    Color(0xFF3B82F6), // Blue
    Color(0xFF7C8AFF), // Indigo
    Color(0xFF8B5CF6), // Violet
    Color(0xFFEC4899), // Pink
    Color(0xFFF97316), // Orange
    Color(0xFF10B981), // Emerald
    Color(0xFFEF4444), // Red
    Color(0xFF0284C7), // Sky
    Color(0xFFD97706), // Amber
    Color(0xFF64748B), // Steel Slate
  ];

  /// Black or white, whichever reads better on top of [background].
  static Color contrastOn(Color background) =>
      background.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  static ThemeData light({Color? accent, String? fontFamily}) {
    final seed = accent ?? defaultLightAccent;
    final scheme = ColorScheme.fromSeed(seedColor: seed);
    return _fromScheme(
      scheme,
      AppColors(
        isDark: false,
        cardSurface: scheme.surfaceContainerLow,
        mutedText: scheme.onSurfaceVariant,
        gradientStart: scheme.primary,
        gradientEnd: scheme.tertiary,
      ),
      fontFamily: fontFamily,
    );
  }

  static ThemeData dark({Color? accent, String? fontFamily}) {
    final seed = accent ?? defaultDarkAccent;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );
    return _fromScheme(
      scheme,
      AppColors(
        isDark: true,
        cardSurface: scheme.surfaceContainerLow,
        mutedText: scheme.onSurfaceVariant,
        gradientStart: scheme.primary,
        gradientEnd: scheme.tertiary,
      ),
      fontFamily: fontFamily,
    );
  }

  static ThemeData oled({Color? accent, String? fontFamily}) {
    final seed = accent ?? defaultDarkAccent;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ).copyWith(
          surface: Colors.black,
          onSurface: Colors.white,
          surfaceContainerLowest: Colors.black,
          surfaceContainerLow: const Color(0xFF0A0A0A),
          surfaceContainer: const Color(0xFF121212),
          surfaceContainerHigh: const Color(0xFF1A1A1A),
          surfaceContainerHighest: const Color(0xFF222222),
        );
    return _fromScheme(
      scheme,
      AppColors(
        isDark: true,
        cardSurface: const Color(0xFF0E0E0E),
        mutedText: Colors.white70,
        gradientStart: scheme.primary,
        gradientEnd: scheme.tertiary,
      ),
      fontFamily: fontFamily,
    ).copyWith(
      scaffoldBackgroundColor: Colors.black,
      canvasColor: Colors.black,
      dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF121212)),
    );
  }

  static ThemeData sepia({Color? accent, String? fontFamily}) {
    final seed = accent ?? defaultLightAccent;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      surface: AppTokens.sepiaSurface,
      onSurface: AppTokens.sepiaOnSurface,
    ).copyWith(surface: AppTokens.sepiaSurface);

    return _fromScheme(
      scheme,
      AppColors(
        isDark: false,
        cardSurface: AppTokens.sepiaSurface,
        mutedText: AppTokens.sepiaOnSurface.withValues(alpha: 0.75),
        gradientStart: scheme.primary,
        gradientEnd: scheme.tertiary,
      ),
      fontFamily: fontFamily,
    ).copyWith(scaffoldBackgroundColor: AppTokens.sepiaBackground);
  }

  static ThemeData _fromScheme(
    ColorScheme scheme,
    AppColors appColors, {
    String? fontFamily,
  }) {
    return ThemeData(
      fontFamily:
          (fontFamily != null &&
              fontFamily.isNotEmpty &&
              fontFamily != 'system')
          ? fontFamily
          : null,
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(centerTitle: false),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
          side: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
      ),
      extensions: [appColors],
    );
  }
}

/// Maps an [AppThemeMode] and optional accent color onto the `theme` / `darkTheme` / `themeMode`
/// trio that `MaterialApp` expects.
class ResolvedTheme {
  const ResolvedTheme(this.light, this.dark, this.mode);

  final ThemeData light;
  final ThemeData dark;
  final ThemeMode mode;

  factory ResolvedTheme.of(
    AppThemeMode selected, {
    Color? lightAccent,
    Color? darkAccent,
    String? fontFamily,
  }) {
    final lightTheme = AppTheme.light(
      accent: lightAccent,
      fontFamily: fontFamily,
    );
    final darkTheme = AppTheme.dark(accent: darkAccent, fontFamily: fontFamily);
    switch (selected) {
      case AppThemeMode.system:
        return ResolvedTheme(lightTheme, darkTheme, ThemeMode.system);
      case AppThemeMode.light:
        return ResolvedTheme(lightTheme, darkTheme, ThemeMode.light);
      case AppThemeMode.dark:
        return ResolvedTheme(lightTheme, darkTheme, ThemeMode.dark);
      case AppThemeMode.oled:
        final oledTheme = AppTheme.oled(
          accent: darkAccent,
          fontFamily: fontFamily,
        );
        return ResolvedTheme(oledTheme, oledTheme, ThemeMode.dark);
      case AppThemeMode.sepia:
        final sepiaTheme = AppTheme.sepia(
          accent: lightAccent,
          fontFamily: fontFamily,
        );
        return ResolvedTheme(sepiaTheme, sepiaTheme, ThemeMode.light);
    }
  }
}
