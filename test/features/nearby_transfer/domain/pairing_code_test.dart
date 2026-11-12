import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/nearby_transfer/domain/pairing_code.dart';
import 'package:pdfapp/features/nearby_transfer/domain/settings_snapshot.dart';
import 'package:pdfapp/features/nearby_transfer/domain/synced_setting.dart';

WifiPairing _pairing({String host = '192.168.1.20', int port = 40123}) =>
    WifiPairing(
      host: host,
      port: port,
      sessionId: Uint8List.fromList(List.generate(8, (i) => i)),
      key: Uint8List.fromList(List.generate(32, (i) => 255 - i)),
    );

void main() {
  group('isPrivateLanIPv4', () {
    test('accepts the three private ranges', () {
      for (final h in [
        '10.0.0.1',
        '10.255.255.255',
        '172.16.0.1',
        '172.31.255.254',
        '192.168.0.1',
        '192.168.43.1',
      ]) {
        expect(isPrivateLanIPv4(h), isTrue, reason: h);
      }
    });

    test('refuses public, loopback, hostnames and junk', () {
      for (final h in [
        '8.8.8.8',
        '172.15.0.1',
        '172.32.0.1',
        '192.169.0.1',
        '127.0.0.1',
        '0.0.0.0',
        'example.com',
        'localhost',
        '192.168.1',
        '192.168.1.256',
        '192.168.1.1.1',
        '::1',
        'fe80::1',
        '',
        '192.168.01.1x',
      ]) {
        expect(isPrivateLanIPv4(h), isFalse, reason: h);
      }
    });
  });

  group('ScannedCode.parse', () {
    test('a WiFi code round-trips', () {
      final code = ScannedCode.parse(_pairing().toQrText());
      expect(code, isA<WifiCode>());
      final p = (code as WifiCode).pairing;
      expect(p.host, '192.168.1.20');
      expect(p.port, 40123);
      expect(p.sessionId, _pairing().sessionId);
      expect(p.key, _pairing().key);
    });

    test('a settings code round-trips', () {
      const snap = SettingsSnapshot({SyncedSetting.themeMode: 'dark'});
      final code = ScannedCode.parse(snap.toQrText());
      expect(code, isA<SettingsCode>());
      expect((code as SettingsCode).snapshot[SyncedSetting.themeMode], 'dark');
    });

    test('a code pointing outside the LAN is refused', () {
      for (final host in ['8.8.8.8', '127.0.0.1', 'evil.example']) {
        final code = ScannedCode.parse(_pairing(host: host).toQrText());
        expect(
          (code as RejectedCode).reason,
          RejectReason.unsafeAddress,
          reason: host,
        );
      }
    });

    test('loopback is allowed only when a test asks for it', () {
      final text = _pairing(host: '127.0.0.1').toQrText();
      expect(ScannedCode.parse(text, allowLoopback: true), isA<WifiCode>());
    });

    test('other apps, damaged and newer codes are refused with a reason', () {
      RejectReason reasonOf(String t) =>
          (ScannedCode.parse(t) as RejectedCode).reason;
      expect(reasonOf('https://example.com'), RejectReason.notFolio);
      expect(reasonOf(''), RejectReason.notFolio);
      expect(reasonOf('folio-sync:1;192.168.1.2:80;AA'), RejectReason.damaged);
      expect(
        reasonOf('folio-sync:1;192.168.1.2:0;AAAAAAAAAAA;AAAA'),
        RejectReason.damaged,
      );
      expect(
        reasonOf('folio-sync:1;192.168.1.2:80;!!;??'),
        RejectReason.damaged,
      );
      final good = _pairing().toQrText();
      expect(
        reasonOf(good.replaceFirst('folio-sync:1;', 'folio-sync:9;')),
        RejectReason.newerVersion,
      );
      // A key of the wrong length.
      expect(
        reasonOf(good.substring(0, good.length - 4)),
        RejectReason.damaged,
      );
      expect(reasonOf('folio-settings:{not json'), RejectReason.damaged);
    });

    test('toString never shows the key', () {
      final p = _pairing();
      expect(p.toString(), isNot(contains(p.toQrText().split(';').last)));
    });
  });
}
