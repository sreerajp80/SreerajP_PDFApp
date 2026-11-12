import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_cipher.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_guest.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_host.dart';
import 'package:pdfapp/features/nearby_transfer/domain/pairing_code.dart';
import 'package:pdfapp/features/nearby_transfer/domain/settings_snapshot.dart';
import 'package:pdfapp/features/nearby_transfer/domain/synced_setting.dart';
import 'package:pdfapp/features/nearby_transfer/domain/transfer_offer.dart';

/// End-to-end host ↔ guest sessions over loopback (tests only: the app itself
/// never accepts a loopback address in a scanned code).
void main() {
  const snapshot = SettingsSnapshot({
    SyncedSetting.themeMode: 'oled',
    SyncedSetting.ttsSpeechRate: 1.25,
    SyncedSetting.appLocale: null,
  });

  Future<TransferHost> startHost({
    Duration pairingTimeout = const Duration(seconds: 20),
    Duration helloTimeout = const Duration(seconds: 5),
    int maxBadAttempts = 5,
  }) => TransferHost.start(
    bindAddress: InternetAddress.loopbackIPv4,
    offer: const SettingsOffer(snapshot),
    pairingTimeout: pairingTimeout,
    helloTimeout: helloTimeout,
    maxBadAttempts: maxBadAttempts,
  );

  WifiPairing scanned(TransferHost host) => (ScannedCode.parse(
    host.pairing.toQrText(),
    allowLoopback: true,
  ) as WifiCode).pairing;

  Matcher failsWith(TransferFailure reason) => throwsA(
    isA<TransferException>().having((e) => e.reason, 'reason', reason),
  );

  test('settings reach the guest and the answer reaches the host', () async {
    final host = await startHost();
    final events = host.events.toList();
    final guest = await TransferGuest.connect(scanned(host));
    final offer = await guest.receiveOffer();
    expect(offer, isA<SettingsOffer>());
    expect((offer as SettingsOffer).snapshot.values, snapshot.values);
    await guest.answer(accepted: true);
    await guest.close();
    final all = await events.timeout(const Duration(seconds: 5));
    expect(all.first, isA<HostGuestConnected>());
    expect(all.last, isA<HostFinished>());
    expect((all.last as HostFinished).accepted, isTrue);
  });

  test('a declined offer is reported as declined', () async {
    final host = await startHost();
    final events = host.events.toList();
    final guest = await TransferGuest.connect(scanned(host));
    await guest.receiveOffer();
    await guest.answer(accepted: false);
    await guest.close();
    final all = await events.timeout(const Duration(seconds: 5));
    expect((all.last as HostFinished).accepted, isFalse);
  });

  test('a guest with the wrong key gets nothing', () async {
    final host = await startHost();
    final good = host.pairing;
    final wrong = WifiPairing(
      host: good.host,
      port: good.port,
      sessionId: good.sessionId,
      key: TransferCipher.randomBytes(32),
    );
    final guest = await TransferGuest.connect(wrong);
    await expectLater(
      guest.receiveOffer(timeout: const Duration(seconds: 5)),
      failsWith(TransferFailure.wrongCode),
    );
    await guest.close();
    // The real guest can still pair after a bad attempt.
    final real = await TransferGuest.connect(scanned(host));
    expect(await real.receiveOffer(), isA<SettingsOffer>());
    await real.answer(accepted: true);
    await real.close();
    await host.close();
  });

  test('after pairing, a second phone cannot connect', () async {
    final host = await startHost();
    final first = await TransferGuest.connect(scanned(host));
    await first.receiveOffer();
    // The listening socket is closed once the first phone paired.
    await expectLater(
      TransferGuest.connect(
        scanned(host),
        timeout: const Duration(seconds: 2),
      ).then((g) => g.receiveOffer(timeout: const Duration(seconds: 2))),
      throwsA(isA<TransferException>()),
    );
    await first.close();
    await host.close();
  });

  test('too many bad attempts end the session', () async {
    final host = await startHost(maxBadAttempts: 2);
    final events = host.events.toList();
    for (var i = 0; i < 2; i++) {
      final s = await Socket.connect(host.pairing.host, host.pairing.port);
      s.add(Uint8List.fromList([0, 0, 0, 4, 1, 2, 3, 4]));
      await s.flush();
      await s.done.timeout(const Duration(seconds: 5), onTimeout: () => s);
      s.destroy();
    }
    final all = await events.timeout(const Duration(seconds: 5));
    expect(all.single, isA<HostFailed>());
    expect((all.single as HostFailed).reason, TransferFailure.wrongCode);
  });

  test('a silent phone is dropped after the hello timeout', () async {
    final host = await startHost(
      helloTimeout: const Duration(milliseconds: 200),
    );
    final s = await Socket.connect(host.pairing.host, host.pairing.port);
    final closed = Completer<void>();
    s.listen(
      (_) {},
      onDone: closed.complete,
      onError: (_) => closed.complete(),
    );
    await closed.future.timeout(const Duration(seconds: 5));
    s.destroy();
    await host.close();
  });

  test('with nobody connecting, the code times out', () async {
    final host = await startHost(
      pairingTimeout: const Duration(milliseconds: 200),
    );
    final all = await host.events.toList().timeout(const Duration(seconds: 5));
    expect((all.single as HostFailed).reason, TransferFailure.timedOut);
  });

  test('connecting to a port nobody listens on is unreachable', () async {
    final host = await startHost();
    final pairing = scanned(host);
    await host.close();
    await expectLater(
      TransferGuest.connect(pairing, timeout: const Duration(seconds: 2)),
      failsWith(TransferFailure.unreachable),
    );
  });
}
