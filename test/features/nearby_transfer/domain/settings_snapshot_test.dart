import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/constants/app_constants.dart';
import 'package:pdfapp/features/nearby_transfer/domain/settings_snapshot.dart';
import 'package:pdfapp/features/nearby_transfer/domain/synced_setting.dart';

void main() {
  test('wire ids are unique and never empty', () {
    final ids = SyncedSetting.values.map((s) => s.wireId).toList();
    expect(ids.toSet().length, ids.length);
    expect(ids.every((id) => id.isNotEmpty), isTrue);
  });

  test('phone-specific settings are never synced', () {
    final keys = SyncedSetting.values.map((s) => s.prefKey).toSet();
    expect(keys, isNot(contains(AppConstants.prefMalayalamTts)));
    expect(keys, isNot(contains(AppConstants.prefPdfPrinterEnabled)));
  });

  test('a full snapshot round-trips through the QR text', () {
    const snap = SettingsSnapshot({
      SyncedSetting.themeMode: 'sepia',
      SyncedSetting.accentLight: 0xFF336699,
      SyncedSetting.accentDark: null,
      SyncedSetting.appLocale: 'sa',
      SyncedSetting.ttsSpeechRate: 1.25,
      SyncedSetting.pdfInvertColors: true,
      SyncedSetting.defaultPaperSize: 'Legal',
    });
    final back = SettingsSnapshot.fromQrText(snap.toQrText())!;
    expect(back.values, snap.values);
    expect(back.skipped, 0);
  });

  test('the QR text for all settings stays small', () {
    final all = SettingsSnapshot({
      for (final s in SyncedSetting.values)
        s: switch (s.type) {
          SettingValueType.boolean => true,
          SettingValueType.integer => s.accepts(0xFFFFFFFF) ? 0xFFFFFFFF : 3,
          SettingValueType.decimal => 1.75,
          SettingValueType.text => null,
        },
    });
    // Well inside what a phone camera reads easily from a phone screen.
    expect(all.toQrText().length, lessThan(600));
  });

  test('unknown ids and bad values are skipped and counted', () {
    final snap = SettingsSnapshot.fromWire({
      'v': 1,
      's': {
        'tm': 'dark',
        'zz': 1, // unknown id
        'lo': 'hi', // not a declared language
        'sr': 9.0, // out of range
        'af': 7, // no such font
        'ic': 'yes', // wrong type
        'ps': 'A4',
      },
    })!;
    expect(snap.values, {
      SyncedSetting.themeMode: 'dark',
      SyncedSetting.defaultPaperSize: 'A4',
    });
    expect(snap.skipped, 5);
  });

  test('a whole-number decimal from JSON becomes a double', () {
    final snap = SettingsSnapshot.fromWire({
      'v': 1,
      's': {'tp': 1},
    })!;
    expect(snap[SyncedSetting.ttsPitch], isA<double>());
  });

  test('not a snapshot, or a newer format, gives null', () {
    expect(SettingsSnapshot.fromWire(null), isNull);
    expect(SettingsSnapshot.fromWire('x'), isNull);
    expect(SettingsSnapshot.fromWire({'v': 2, 's': {}}), isNull);
    expect(SettingsSnapshot.fromWire({'v': 1}), isNull);
    expect(SettingsSnapshot.fromQrText('folio-settings:[1,2]'), isNull);
    expect(SettingsSnapshot.fromQrText('hello'), isNull);
  });

  test('changesFrom lists only the settings that differ', () {
    const mine = SettingsSnapshot({
      SyncedSetting.themeMode: 'dark',
      SyncedSetting.ttsPitch: 1.0,
      SyncedSetting.appLocale: null,
    });
    const theirs = SettingsSnapshot({
      SyncedSetting.themeMode: 'dark',
      SyncedSetting.ttsPitch: 1.0000000001,
      SyncedSetting.appLocale: 'ml',
    });
    expect(theirs.changesFrom(mine), [SyncedSetting.appLocale]);
  });
}
