import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/app/theme/app_theme.dart';

void main() {
  group('AppTheme & AppThemeMode', () {
    test('AppThemeMode storage serialization and parsing', () {
      expect(AppThemeModeX.fromStorage('oled'), AppThemeMode.oled);
      expect(AppThemeModeX.fromStorage('dark'), AppThemeMode.dark);
      expect(AppThemeModeX.fromStorage('light'), AppThemeMode.light);
      expect(AppThemeModeX.fromStorage('sepia'), AppThemeMode.sepia);
      expect(AppThemeModeX.fromStorage('system'), AppThemeMode.system);
      expect(AppThemeModeX.fromStorage('unknown'), AppThemeMode.system);
    });

    test('OLED pitch black theme produces pure black surface and scaffold', () {
      final oled = AppTheme.oled();
      expect(oled.brightness, Brightness.dark);
      expect(oled.scaffoldBackgroundColor, Colors.black);
      expect(oled.colorScheme.surface, Colors.black);
      expect(oled.canvasColor, Colors.black);
    });

    test('ResolvedTheme resolves OLED theme properly', () {
      final resolved = ResolvedTheme.of(AppThemeMode.oled);
      expect(resolved.mode, ThemeMode.dark);
      expect(resolved.dark.scaffoldBackgroundColor, Colors.black);
    });
  });

  test(
    'every theme falls back to the bundled Malayalam and Devanagari fonts',
    () {
      // Language pack section 2: no declared script may render as boxes, even when
      // the user picks a Latin-only or system font.
      final themes = [
        AppTheme.light(),
        AppTheme.dark(),
        AppTheme.oled(),
        AppTheme.sepia(),
        AppTheme.light(fontFamily: 'Manjari'),
      ];
      for (final theme in themes) {
        final fallback = theme.textTheme.bodyMedium?.fontFamilyFallback;
        expect(
          fallback,
          containsAll(['Noto Sans Malayalam', 'Noto Sans Devanagari']),
        );
      }
    },
  );
}
