import 'dart:io';

import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/nearby_transfer/domain/pairing_code.dart';

/// Finds this phone's address on the local WiFi (or its own hotspot), so the
/// host session can listen there and nowhere else.
///
/// Uses `dart:io` only: no extra Android permission is needed to read the
/// phone's own addresses.
class LanAddressService {
  const LanAddressService();

  /// The phone's private WiFi/hotspot IPv4 address, or `null` when it has
  /// none (WiFi off and no hotspot, or mobile data only).
  Future<InternetAddress?> findLanAddress() async {
    final List<NetworkInterface> interfaces;
    try {
      interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
    } on SocketException catch (e) {
      AppLogger.warning('Could not list network interfaces.', error: e);
      return null;
    }
    return pickLanAddress({
      for (final i in interfaces) i.name: [for (final a in i.addresses) a],
    });
  }

  /// Chooses the best address from interface name → addresses. WiFi and
  /// hotspot interfaces (`wlan…`, `swlan…`, `ap…`) come first; mobile data
  /// interfaces only count if they somehow hold a private address.
  static InternetAddress? pickLanAddress(
    Map<String, List<InternetAddress>> byInterface,
  ) {
    bool isWifi(String name) =>
        name.startsWith('wlan') ||
        name.startsWith('swlan') ||
        name.startsWith('ap');
    final names = byInterface.keys.toList()
      ..sort((a, b) => (isWifi(a) ? 0 : 1).compareTo(isWifi(b) ? 0 : 1));
    for (final name in names) {
      for (final address in byInterface[name]!) {
        if (isPrivateLanIPv4(address.address)) return address;
      }
    }
    return null;
  }
}
