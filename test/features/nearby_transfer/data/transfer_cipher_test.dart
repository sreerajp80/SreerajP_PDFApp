import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_cipher.dart';

void main() {
  final key = TransferCipher.randomBytes(32);
  final session = TransferCipher.randomBytes(8);

  TransferCipher host() =>
      TransferCipher(key: key, sessionId: session, isHost: true);
  TransferCipher guest() =>
      TransferCipher(key: key, sessionId: session, isHost: false);

  Matcher failsWith(TransferFailure reason) => throwsA(
    isA<TransferException>().having((e) => e.reason, 'reason', reason),
  );

  test('random bytes are the asked length and not all equal', () {
    final a = TransferCipher.randomBytes(32);
    final b = TransferCipher.randomBytes(32);
    expect(a.length, 32);
    expect(a, isNot(b));
  });

  test('messages round-trip in both directions, in order', () async {
    final h = host();
    final g = guest();
    for (var i = 0; i < 3; i++) {
      final sealed = await g.seal(utf8.encode('to host $i'));
      expect(utf8.decode(await h.open(sealed)), 'to host $i');
      final back = await h.seal(utf8.encode('to guest $i'));
      expect(utf8.decode(await g.open(back)), 'to guest $i');
    }
  });

  test('the same text never seals to the same bytes twice', () async {
    final g = guest();
    final a = await g.seal(utf8.encode('same'));
    final b = await g.seal(utf8.encode('same'));
    expect(a, isNot(b));
  });

  test('a wrong key fails the check', () async {
    final other = TransferCipher(
      key: TransferCipher.randomBytes(32),
      sessionId: session,
      isHost: true,
    );
    final sealed = await guest().seal(utf8.encode('hi'));
    expect(() => other.open(sealed), failsWith(TransferFailure.wrongCode));
  });

  test('another session id fails the check', () async {
    final other = TransferCipher(
      key: key,
      sessionId: TransferCipher.randomBytes(8),
      isHost: true,
    );
    final sealed = await guest().seal(utf8.encode('hi'));
    expect(() => other.open(sealed), failsWith(TransferFailure.wrongCode));
  });

  test('a changed byte fails the check', () async {
    final sealed = await guest().seal(utf8.encode('hello there'));
    sealed[2] ^= 0x01;
    expect(() => host().open(sealed), failsWith(TransferFailure.wrongCode));
  });

  test('a replayed or reordered message fails', () async {
    final g = guest();
    final h = host();
    final first = await g.seal(utf8.encode('1'));
    final second = await g.seal(utf8.encode('2'));
    expect(() => h.open(second), failsWith(TransferFailure.wrongCode));
    await h.open(first);
    expect(() => h.open(first), failsWith(TransferFailure.wrongCode));
  });

  test('a message bounced back to its sender fails', () async {
    final g = guest();
    final sealed = await g.seal(utf8.encode('mine'));
    expect(() => g.open(sealed), failsWith(TransferFailure.wrongCode));
  });

  test('a message shorter than the check value is bad data', () {
    expect(() => host().open([1, 2, 3]), failsWith(TransferFailure.badData));
  });
}
