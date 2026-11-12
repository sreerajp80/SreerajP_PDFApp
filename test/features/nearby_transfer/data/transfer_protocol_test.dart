import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_protocol.dart';

void main() {
  Matcher badData() => throwsA(
    isA<TransferException>().having(
      (e) => e.reason,
      'reason',
      TransferFailure.badData,
    ),
  );

  group('TransferMessage', () {
    test('round-trips', () {
      const m = TransferMessage(MessageType.offer, {
        'kind': 'settings',
        'n': 3,
      });
      final back = TransferMessage.decode(m.encode());
      expect(back.type, MessageType.offer);
      expect(back.body, {'kind': 'settings', 'n': 3});
    });

    test('empty, unknown type, bad JSON and non-object bodies fail', () {
      expect(() => TransferMessage.decode(Uint8List(0)), badData());
      expect(() => TransferMessage.decode(Uint8List.fromList([99])), badData());
      expect(
        () =>
            TransferMessage.decode(Uint8List.fromList([1, ...'{x'.codeUnits])),
        badData(),
      );
      expect(
        () => TransferMessage.decode(
          Uint8List.fromList([1, ...utf8.encode('[1,2]')]),
        ),
        badData(),
      );
    });
  });

  group('FrameDecoder', () {
    test('rebuilds frames split into one-byte pieces', () {
      final a = FrameDecoder.encode(Uint8List.fromList([1, 2, 3]));
      final b = FrameDecoder.encode(Uint8List.fromList(List.filled(300, 7)));
      final all = [...a, ...b];
      final decoder = FrameDecoder();
      final frames = <Uint8List>[];
      for (final byte in all) {
        frames.addAll(decoder.add([byte]));
      }
      expect(frames.length, 2);
      expect(frames[0], [1, 2, 3]);
      expect(frames[1].length, 300);
    });

    test('returns several frames from one piece', () {
      final bytes = [
        ...FrameDecoder.encode(Uint8List.fromList([1])),
        ...FrameDecoder.encode(Uint8List.fromList([2])),
        ...FrameDecoder.encode(Uint8List.fromList([3])),
      ];
      expect(FrameDecoder().add(bytes), [
        [1],
        [2],
        [3],
      ]);
    });

    test('a zero or huge length is refused', () {
      expect(() => FrameDecoder().add([0, 0, 0, 0]), badData());
      expect(() => FrameDecoder().add([0xFF, 0xFF, 0xFF, 0xFF]), badData());
    });

    test('a truncated frame waits instead of failing', () {
      final frame = FrameDecoder.encode(Uint8List.fromList([1, 2, 3, 4]));
      final decoder = FrameDecoder();
      expect(decoder.add(frame.sublist(0, 5)), isEmpty);
      expect(decoder.add(frame.sublist(5)), [
        [1, 2, 3, 4],
      ]);
    });

    test(
      'random garbage never crashes with anything but TransferException',
      () {
        final random = Random(42);
        for (var round = 0; round < 200; round++) {
          final decoder = FrameDecoder();
          final junk = List.generate(
            random.nextInt(64),
            (_) => random.nextInt(256),
          );
          try {
            decoder.add(junk);
          } on TransferException {
            // Expected for most inputs.
          }
        }
      },
    );

    test('encode refuses empty and too-large messages', () {
      expect(() => FrameDecoder.encode(Uint8List(0)), badData());
      expect(
        () => FrameDecoder.encode(Uint8List(FrameDecoder.maxFrameLength + 1)),
        badData(),
      );
    });
  });
}
