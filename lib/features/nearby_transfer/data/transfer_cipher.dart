import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:pdfapp/core/errors/app_exception.dart';

/// Encrypts and checks every message of one Device sync session with
/// AES-256-GCM (plan §3.3).
///
/// - The key is the one-time key from the pairing QR code.
/// - Each message gets a fresh 12-byte nonce (a number used only once):
///   one byte for the direction (host → guest or guest → host) and an 8-byte
///   counter. Each side counts its own messages, so a message that is
///   replayed, dropped or reordered fails the check.
/// - The session id is bound in as extra authenticated data, so a message
///   from another session never passes.
///
/// The key is never logged and never leaves this object.
class TransferCipher {
  TransferCipher({
    required List<int> key,
    required List<int> sessionId,
    required bool isHost,
  }) : _key = SecretKey(List<int>.unmodifiable(key)),
       _aad = List<int>.unmodifiable(sessionId),
       _sendDirection = isHost ? _hostDirection : _guestDirection,
       _receiveDirection = isHost ? _guestDirection : _hostDirection;

  static const int macLength = 16;
  static const int _hostDirection = 0x48; // 'H'
  static const int _guestDirection = 0x47; // 'G'

  static final AesGcm _algorithm = AesGcm.with256bits();

  final SecretKey _key;
  final List<int> _aad;
  final int _sendDirection;
  final int _receiveDirection;
  int _sendCounter = 0;
  int _receiveCounter = 0;

  /// Random bytes from the platform's secure random source.
  static Uint8List randomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(length, (_) => random.nextInt(256)),
    );
  }

  /// Encrypts [plain]. The result is the cipher text followed by the
  /// 16-byte check value (MAC).
  Future<Uint8List> seal(List<int> plain) async {
    final nonce = _nonce(_sendDirection, _sendCounter++);
    final box = await _algorithm.encrypt(
      plain,
      secretKey: _key,
      nonce: nonce,
      aad: _aad,
    );
    return Uint8List.fromList([...box.cipherText, ...box.mac.bytes]);
  }

  /// Checks and decrypts a message made by the other side's [seal].
  ///
  /// Throws [TransferException] ([TransferFailure.wrongCode]) when the check
  /// fails: wrong key, changed bytes, or a message out of order.
  Future<Uint8List> open(List<int> sealed) async {
    if (sealed.length < macLength) {
      throw const TransferException(
        TransferFailure.badData,
        'Message too short.',
      );
    }
    final split = sealed.length - macLength;
    final nonce = _nonce(_receiveDirection, _receiveCounter);
    try {
      final plain = await _algorithm.decrypt(
        SecretBox(
          sealed.sublist(0, split),
          nonce: nonce,
          mac: Mac(sealed.sublist(split)),
        ),
        secretKey: _key,
        aad: _aad,
      );
      _receiveCounter++;
      return Uint8List.fromList(plain);
    } on SecretBoxAuthenticationError catch (e) {
      throw TransferException(
        TransferFailure.wrongCode,
        'Message failed the check.',
        cause: e.runtimeType,
      );
    }
  }

  static List<int> _nonce(int direction, int counter) {
    final nonce = Uint8List(12);
    nonce[0] = direction;
    ByteData.sublistView(nonce).setUint64(4, counter);
    return nonce;
  }
}
