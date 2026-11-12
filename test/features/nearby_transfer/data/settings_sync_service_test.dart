import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/nearby_transfer/data/settings_sync_service.dart';
import 'package:pdfapp/features/nearby_transfer/domain/settings_snapshot.dart';
import 'package:pdfapp/features/nearby_transfer/domain/synced_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<SharedPreferences> prefsWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return SharedPreferences.getInstance();
  }

  test('readCurrent has every synced setting, null when not set', () async {
    final prefs = await prefsWith({
      AppConstants.prefThemeMode: 'oled',
      AppConstants.prefTtsPitch: 1.5,
    });
    final snap = SettingsSyncService(prefs).readCurrent();
    expect(snap.values.keys.toSet(), SyncedSetting.values.toSet());
    expect(snap[SyncedSetting.themeMode], 'oled');
    expect(snap[SyncedSetting.ttsPitch], 1.5);
    expect(snap[SyncedSetting.appLocale], isNull);
  });

  test(
    'readCurrent ignores stored values of the wrong type or range',
    () async {
      final prefs = await prefsWith({
        AppConstants.prefThemeMode: 'purple',
        AppConstants.prefAppFont: 'two',
      });
      final snap = SettingsSyncService(prefs).readCurrent();
      expect(snap[SyncedSetting.themeMode], isNull);
      expect(snap[SyncedSetting.appFont], isNull);
    },
  );

  test('readCurrent never includes phone-specific settings', () async {
    final prefs = await prefsWith({
      AppConstants.prefMalayalamTts: true,
      AppConstants.prefPdfPrinterEnabled: false,
    });
    final wire = SettingsSyncService(prefs).readCurrent().toQrText();
    expect(wire, isNot(contains('malayalam')));
    expect(wire, isNot(contains('printer')));
  });

  test('apply writes values and removes nulls; others are untouched', () async {
    final prefs = await prefsWith({
      AppConstants.prefAppLocale: 'ml',
      AppConstants.prefMalayalamTts: true,
      'recent.other': 'keep',
    });
    final written = await SettingsSyncService(prefs).apply(
      const SettingsSnapshot({
        SyncedSetting.themeMode: 'dark',
        SyncedSetting.appLocale: null,
        SyncedSetting.ttsSpeechRate: 1.5,
        SyncedSetting.appFont: 2,
        SyncedSetting.pdfInvertColors: true,
      }),
    );
    expect(written.length, 5);
    expect(prefs.getString(AppConstants.prefThemeMode), 'dark');
    expect(prefs.containsKey(AppConstants.prefAppLocale), isFalse);
    expect(prefs.getDouble(AppConstants.prefTtsSpeechRate), 1.5);
    expect(prefs.getInt(AppConstants.prefAppFont), 2);
    expect(prefs.getBool(AppConstants.prefPdfInvertColors), isTrue);
    expect(prefs.getBool(AppConstants.prefMalayalamTts), isTrue);
    expect(prefs.getString('recent.other'), 'keep');
  });

  test('apply skips values that fail the check', () async {
    final prefs = await prefsWith({AppConstants.prefThemeMode: 'light'});
    final written = await SettingsSyncService(prefs).apply(
      const SettingsSnapshot({
        SyncedSetting.themeMode: 'neon',
        SyncedSetting.ttsPitch: 'loud',
      }),
    );
    expect(written, isEmpty);
    expect(prefs.getString(AppConstants.prefThemeMode), 'light');
    expect(prefs.containsKey(AppConstants.prefTtsPitch), isFalse);
  });

  test('read then apply on another phone makes them the same', () async {
    final a = await prefsWith({
      AppConstants.prefThemeMode: 'sepia',
      AppConstants.prefTextScale: 3,
      AppConstants.prefTtsSentencePause: 0.8,
    });
    final snapshot = SettingsSyncService(a).readCurrent();
    final b = await prefsWith({
      AppConstants.prefThemeMode: 'dark',
      AppConstants.prefAppLocale: 'sa',
    });
    final service = SettingsSyncService(b);
    await service.apply(SettingsSnapshot.fromQrText(snapshot.toQrText())!);
    expect(service.readCurrent().changesFrom(snapshot), isEmpty);
    expect(b.containsKey(AppConstants.prefAppLocale), isFalse);
  });
}
