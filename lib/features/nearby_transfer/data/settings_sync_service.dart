import 'package:pdfapp/features/nearby_transfer/domain/settings_snapshot.dart';
import 'package:pdfapp/features/nearby_transfer/domain/synced_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reads and writes the allow-listed settings for Device sync.
///
/// Only [SyncedSetting] values are touched. Values are checked again here
/// before writing, so even a snapshot built in code can never store a value
/// the app's own screens could not produce.
class SettingsSyncService {
  const SettingsSyncService(this._prefs);

  final SharedPreferences _prefs;

  /// This phone's settings right now. A stored value of the wrong type or out
  /// of range is treated as "not set".
  SettingsSnapshot readCurrent() =>
      SettingsSnapshot({for (final s in SyncedSetting.values) s: _read(s)});

  Object? _read(SyncedSetting setting) {
    final Object? value = _prefs.get(setting.prefKey);
    final typeOk = switch (setting.type) {
      SettingValueType.boolean => value is bool,
      SettingValueType.integer => value is int,
      SettingValueType.decimal => value is double,
      SettingValueType.text => value is String,
    };
    return typeOk && setting.accepts(value) ? value : null;
  }

  /// Writes every entry of [snapshot]. `null` removes the setting so the app
  /// default applies. Entries that fail the check are skipped.
  ///
  /// Returns the settings that were written. The caller must refresh the
  /// settings providers so the app shows the new values at once.
  Future<List<SyncedSetting>> apply(SettingsSnapshot snapshot) async {
    final written = <SyncedSetting>[];
    for (final entry in snapshot.values.entries) {
      final setting = entry.key;
      final value = entry.value;
      if (!setting.accepts(value)) continue;
      if (value == null) {
        await _prefs.remove(setting.prefKey);
      } else {
        switch (setting.type) {
          case SettingValueType.boolean:
            await _prefs.setBool(setting.prefKey, value as bool);
          case SettingValueType.integer:
            await _prefs.setInt(setting.prefKey, value as int);
          case SettingValueType.decimal:
            await _prefs.setDouble(setting.prefKey, (value as num).toDouble());
          case SettingValueType.text:
            await _prefs.setString(setting.prefKey, value as String);
        }
      }
      written.add(setting);
    }
    return written;
  }
}
