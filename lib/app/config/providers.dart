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
