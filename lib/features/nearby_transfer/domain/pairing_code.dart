import 'dart:convert';
import 'dart:typed_data';

import 'package:pdfapp/features/nearby_transfer/domain/settings_snapshot.dart';

/// What a WiFi pairing QR code holds: where the other phone listens and the
/// one-time key for this session (plan §3.2).
///
/// The key is a secret for the few minutes the session lives. It is held in
/// memory only and must never be logged; [toString] leaves it out.
class WifiPairing {
  const WifiPairing({
    required this.host,
    required this.port,
    required this.sessionId,
    required this.key,
  });

  /// Text at the start of a WiFi pairing QR code.
  static const String qrPrefix = 'folio-sync:';

  /// The current pairing format. Bump only for a change older apps cannot read.
  static const int formatVersion = 1;

  static const int keyLength = 32; // AES-256
  static const int sessionIdLength = 8;

  final String host;
  final int port;
  final Uint8List sessionId;
  final Uint8List key;

  String toQrText() {
    String b64(Uint8List bytes) => base64Url.encode(bytes).replaceAll('=', '');
    return '$qrPrefix$formatVersion;$host:$port;${b64(sessionId)};${b64(key)}';
  }

  @override
  String toString() => 'WifiPairing($host:$port)';
}

/// The result of reading a scanned QR code.
sealed class ScannedCode {
  const ScannedCode();

  /// Works out what [text] is. Anything Folio cannot use safely becomes a
  /// [RejectedCode] with the reason, never an exception (Hard Rule 4).
  ///
  /// [allowLoopback] exists for tests only: the app itself never accepts a
  /// loopback address, so a code can never point the app at itself.
  static ScannedCode parse(String text, {bool allowLoopback = false}) {
    final trimmed = text.trim();
    if (trimmed.startsWith(SettingsSnapshot.qrPrefix)) {
      final snapshot = SettingsSnapshot.fromQrText(trimmed);
      return snapshot == null
          ? const RejectedCode(RejectReason.damaged)
          : SettingsCode(snapshot);
    }
    if (trimmed.startsWith(WifiPairing.qrPrefix)) {
      return _parseWifi(
        trimmed.substring(WifiPairing.qrPrefix.length),
        allowLoopback: allowLoopback,
      );
    }
    return const RejectedCode(RejectReason.notFolio);
  }

  static ScannedCode _parseWifi(String body, {required bool allowLoopback}) {
    final parts = body.split(';');
    if (parts.length != 4) return const RejectedCode(RejectReason.damaged);
    final version = int.tryParse(parts[0]);
    if (version == null || version < 1) {
      return const RejectedCode(RejectReason.damaged);
    }
    if (version > WifiPairing.formatVersion) {
      return const RejectedCode(RejectReason.newerVersion);
    }
    final address = parts[1];
    final colon = address.lastIndexOf(':');
    if (colon <= 0) return const RejectedCode(RejectReason.damaged);
    final host = address.substring(0, colon);
    final port = int.tryParse(address.substring(colon + 1));
    if (port == null || port < 1 || port > 65535) {
      return const RejectedCode(RejectReason.damaged);
    }
    final hostAllowed =
        isPrivateLanIPv4(host) || (allowLoopback && host == '127.0.0.1');
    if (!hostAllowed) return const RejectedCode(RejectReason.unsafeAddress);
    final sessionId = _decode(parts[2]);
    final key = _decode(parts[3]);
    if (sessionId == null ||
        sessionId.length != WifiPairing.sessionIdLength ||
        key == null ||
        key.length != WifiPairing.keyLength) {
      return const RejectedCode(RejectReason.damaged);
    }
    return WifiCode(
      WifiPairing(host: host, port: port, sessionId: sessionId, key: key),
    );
  }

  static Uint8List? _decode(String text) {
    try {
      return base64Url.decode(base64Url.normalize(text));
    } on FormatException {
      return null;
    }
  }
}

/// A settings QR code: the settings travel inside the code itself (no network).
final class SettingsCode extends ScannedCode {
  const SettingsCode(this.snapshot);
  final SettingsSnapshot snapshot;
}

/// A WiFi pairing QR code: connect to the other phone to get the data.
final class WifiCode extends ScannedCode {
  const WifiCode(this.pairing);
  final WifiPairing pairing;
}

enum RejectReason {
  /// Not a Folio code at all (another app's QR code).
  notFolio,

  /// Looks like a Folio code but is damaged or incomplete.
  damaged,

  /// Made by a newer version of Folio.
  newerVersion,

  /// Points at an address outside the local network. Refused so that a code
  /// can never make the app contact the internet.
  unsafeAddress,
}

/// A code Folio will not use, and why.
final class RejectedCode extends ScannedCode {
  const RejectedCode(this.reason);
  final RejectReason reason;
}

/// Whether [host] is a dotted IPv4 address in a private home/office network
/// range (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16). Hostnames, public
/// addresses, loopback and IPv6 are all refused.
bool isPrivateLanIPv4(String host) {
  final parts = host.split('.');
  if (parts.length != 4) return false;
  final bytes = <int>[];
  for (final p in parts) {
    if (p.isEmpty || p.length > 3 || !RegExp(r'^\d+$').hasMatch(p)) {
      return false;
    }
    final n = int.parse(p);
    if (n > 255) return false;
    bytes.add(n);
  }
  final a = bytes[0];
  final b = bytes[1];
  if (a == 10) return true;
  if (a == 172 && b >= 16 && b <= 31) return true;
  if (a == 192 && b == 168) return true;
  return false;
}
