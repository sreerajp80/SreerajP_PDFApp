import 'dart:convert';

import 'package:pdfapp/features/nearby_transfer/domain/synced_setting.dart';

/// A copy of every allow-listed setting on one phone, ready to send.
///
/// Every [SyncedSetting] has an entry. A `null` value means "not set on the
/// sending phone, so the app default is in use"; applying it removes the
/// setting on the receiving phone too, so both phones end up the same.
class SettingsSnapshot {
  const SettingsSnapshot(this.values, {this.skipped = 0});

  /// The current wire format. Bump only for a change older apps cannot read.
  static const int formatVersion = 1;

  /// Text at the start of a settings QR code, so it is never mistaken for
  /// another app's code or for a WiFi pairing code.
  static const String qrPrefix = 'folio-settings:';

  final Map<SyncedSetting, Object?> values;

  /// How many entries were dropped while reading (unknown or bad values).
  final int skipped;

  Object? operator [](SyncedSetting setting) => values[setting];

  /// The settings whose value differs from [current]. Decimal values are
  /// compared with a small tolerance, so 1.0 and 1 are the same.
  List<SyncedSetting> changesFrom(SettingsSnapshot current) => [
    for (final s in SyncedSetting.values)
      if (values.containsKey(s) && !_same(values[s], current.values[s])) s,
  ];

  static bool _same(Object? a, Object? b) {
    if (a is num && b is num) return (a - b).abs() < 1e-9;
    return a == b;
  }

  Map<String, Object?> toWire() => {
    'v': formatVersion,
    's': {for (final e in values.entries) e.key.wireId: e.value},
  };

  /// Reads a snapshot from its wire map. Unknown ids and values a setting
  /// cannot hold are skipped (and counted), never applied. Returns `null` when
  /// the map is not a settings snapshot at all, or comes from a newer format.
  static SettingsSnapshot? fromWire(Object? wire) {
    if (wire is! Map) return null;
    final version = wire['v'];
    if (version is! int || version < 1 || version > formatVersion) return null;
    final raw = wire['s'];
    if (raw is! Map) return null;
    final values = <SyncedSetting, Object?>{};
    var skipped = 0;
    for (final entry in raw.entries) {
      final key = entry.key;
      final setting = key is String ? SyncedSetting.byWireId(key) : null;
      if (setting == null || !setting.accepts(entry.value)) {
        skipped++;
        continue;
      }
      values[setting] = _normalise(setting, entry.value);
    }
    return SettingsSnapshot(values, skipped: skipped);
  }

  static Object? _normalise(SyncedSetting setting, Object? value) {
    if (value is num && setting.type == SettingValueType.decimal) {
      return value.toDouble();
    }
    return value;
  }

  /// The text placed in a settings QR code.
  String toQrText() => '$qrPrefix${jsonEncode(toWire())}';

  /// Reads a settings QR code. Returns `null` for anything that is not one.
  static SettingsSnapshot? fromQrText(String text) {
    if (!text.startsWith(qrPrefix)) return null;
    try {
      return fromWire(jsonDecode(text.substring(qrPrefix.length)));
    } on FormatException {
      return null;
    }
  }
}
