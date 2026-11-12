import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:pdfapp/features/nearby_transfer/data/transfer_guest.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_host.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_protocol.dart';
import 'package:pdfapp/features/nearby_transfer/domain/pairing_code.dart';
import 'package:pdfapp/features/nearby_transfer/domain/transfer_offer.dart';

/// PDFs sent host → guest over loopback (tests only).
void main() {
  late Directory work;

  setUp(() async {
    work = await Directory.systemTemp.createTemp('folio_send_');
  });

  tearDown(() async {
    if (work.existsSync()) await work.delete(recursive: true);
  });

  Future<({String path, OfferedFile offered})> makeFile(
    String name,
    Uint8List bytes, {
    String? wrongHash,
  }) async {
    final file = File(p.join(work.path, 'src_$name'));
    await file.writeAsBytes(bytes);
    return (
      path: file.path,
      offered: OfferedFile(
        name: name,
        sizeBytes: bytes.length,
        sha256: wrongHash ?? sha256.convert(bytes).toString(),
      ),
    );
  }

  Uint8List pdfBytes(int size, {int seed = 1}) {
    final random = Random(seed);
    final bytes = Uint8List(size);
    for (var i = 0; i < size; i++) {
      bytes[i] = random.nextInt(256);
    }
    bytes.setRange(0, 5, '%PDF-'.codeUnits);
    return bytes;
  }

  Future<TransferGuest> connect(TransferHost host) {
    final code = ScannedCode.parse(
      host.pairing.toQrText(),
      allowLoopback: true,
    );
    return TransferGuest.connect((code as WifiCode).pairing);
  }

  test('message pieces round-trip as raw bytes', () {
    final data = Uint8List.fromList(List.generate(1000, (i) => i % 256));
    final back = TransferMessage.decode(TransferMessage.chunk(data).encode());
    expect(back.type, MessageType.fileChunk);
    expect(back.data, data);
  });

  test(
    'three files arrive; checks catch a damaged and a non-PDF file',
    () async {
      // A 3 MB file is sent in many pieces, so flow control is exercised too.
      final big = await makeFile('big.pdf', pdfBytes(3 * 1024 * 1024 + 17));
      final small = await makeFile('small.pdf', pdfBytes(10, seed: 2));
      final damaged = await makeFile(
        'damaged.pdf',
        pdfBytes(5000, seed: 3),
        wrongHash: 'f' * 64,
      );
      final text = await makeFile(
        'not_pdf.pdf',
        Uint8List.fromList('hello, not a pdf'.codeUnits),
      );
      final files = [big, small, damaged, text];
      final host = await TransferHost.start(
        bindAddress: InternetAddress.loopbackIPv4,
        offer: FileOffer([for (final f in files) f.offered]),
        filePaths: [for (final f in files) f.path],
      );
      final events = host.events.toList();
      final guest = await connect(host);
      final offer = await guest.receiveOffer() as FileOffer;
      expect(offer.files.map((f) => f.name), [
        'big.pdf',
        'small.pdf',
        'damaged.pdf',
        'not_pdf.pdf',
      ]);
      await guest.answer(accepted: true);

      var lastProgress = 0;
      final received = await guest.receiveFiles(
        offer,
        Directory(p.join(work.path, 'in')),
        onProgress: (done, total) {
          expect(done, greaterThanOrEqualTo(lastProgress));
          expect(total, offer.totalBytes);
          lastProgress = done;
        },
      );
      expect(lastProgress, offer.totalBytes);
      expect(received.map((f) => f.problem), [
        null,
        null,
        ReceivedFileProblem.damaged,
        ReceivedFileProblem.notPdf,
      ]);
      // Good files are byte-for-byte equal; bad ones were deleted.
      expect(
        await File(received[0].path).readAsBytes(),
        await File(big.path).readAsBytes(),
      );
      expect(File(received[2].path).existsSync(), isFalse);
      expect(File(received[3].path).existsSync(), isFalse);

      await guest.sendResult(received: received.where((f) => f.ok).length);
      await guest.close();
      final all = await events.timeout(const Duration(seconds: 10));
      expect(all.whereType<HostSending>(), isNotEmpty);
      final finished = all.last as HostFinished;
      expect(finished.accepted, isTrue);
      expect(finished.filesReceived, 2);
    },
  );

  test('a declined file offer sends nothing', () async {
    final f = await makeFile('a.pdf', pdfBytes(100));
    final host = await TransferHost.start(
      bindAddress: InternetAddress.loopbackIPv4,
      offer: FileOffer([f.offered]),
      filePaths: [f.path],
    );
    final events = host.events.toList();
    final guest = await connect(host);
    await guest.receiveOffer();
    await guest.answer(accepted: false);
    await guest.close();
    final all = await events.timeout(const Duration(seconds: 5));
    expect(all.whereType<HostSending>(), isEmpty);
    expect((all.last as HostFinished).accepted, isFalse);
  });

  test('a file that shrank after the offer ends the session', () async {
    final f = await makeFile('a.pdf', pdfBytes(1000));
    final host = await TransferHost.start(
      bindAddress: InternetAddress.loopbackIPv4,
      offer: FileOffer([
        OfferedFile(name: 'a.pdf', sizeBytes: 5000, sha256: 'a' * 64),
      ]),
      filePaths: [f.path],
    );
    final events = host.events.toList();
    final guest = await connect(host);
    final offer = await guest.receiveOffer() as FileOffer;
    await guest.answer(accepted: true);
    await expectLater(
      guest.receiveFiles(
        offer,
        Directory(p.join(work.path, 'in2')),
        pieceTimeout: const Duration(seconds: 5),
      ),
      throwsA(anything),
    );
    await guest.close();
    final all = await events.timeout(const Duration(seconds: 5));
    expect(all.last, isA<HostFailed>());
  });

  test('a file offer needs one path per file', () async {
    expect(
      () => TransferHost.start(
        bindAddress: InternetAddress.loopbackIPv4,
        offer: FileOffer([
          OfferedFile(name: 'a.pdf', sizeBytes: 1, sha256: 'a' * 64),
        ]),
      ),
      throwsArgumentError,
    );
  });
}
