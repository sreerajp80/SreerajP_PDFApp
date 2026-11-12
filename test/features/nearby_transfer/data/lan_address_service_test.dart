import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/features/nearby_transfer/data/lan_address_service.dart';

void main() {
  InternetAddress a(String s) => InternetAddress(s);

  test('prefers the WiFi interface over others', () {
    final picked = LanAddressService.pickLanAddress({
      'rmnet0': [a('10.12.0.5')],
      'wlan0': [a('192.168.1.40')],
    });
    expect(picked?.address, '192.168.1.40');
  });

  test('finds a hotspot address', () {
    final picked = LanAddressService.pickLanAddress({
      'rmnet_data0': [a('100.70.1.2')],
      'ap0': [a('192.168.43.1')],
    });
    expect(picked?.address, '192.168.43.1');
  });

  test('returns null with only public or mobile addresses', () {
    expect(
      LanAddressService.pickLanAddress({
        'rmnet0': [a('100.70.1.2')],
        'wlan0': [a('8.8.4.4')],
      }),
      isNull,
    );
    expect(LanAddressService.pickLanAddress({}), isNull);
  });
}
