import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_cipher.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_connection.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_protocol.dart';
import 'package:pdfapp/features/nearby_transfer/domain/pairing_code.dart';
import 'package:pdfapp/features/nearby_transfer/domain/transfer_offer.dart';

/// Why a received file was not kept.
enum ReceivedFileProblem {
  /// Size or SHA-256 did not match the offer: damaged or changed on the way.
  damaged,

  /// The bytes are not a PDF (no `%PDF-` header).
  notPdf,
}

/// One file after it arrived in the receiving phone's private cache.
class ReceivedFile {
  const ReceivedFile({required this.offered, required this.path, this.problem});

  final OfferedFile offered;

  /// The cache copy. Deleted after saving (or when the check failed).
  final String path;
  final ReceivedFileProblem? problem;

  bool get ok => problem == null;
}

/// The receiving phone's side of a WiFi session (plan §3.3).
///
/// Connects to the address from a scanned [WifiPairing] (already checked to
/// be a private LAN address by `ScannedCode.parse`), proves it holds the key,
/// reads the offer and sends back the user's answer.
class TransferGuest {
  TransferGuest._(this._connection);

  final TransferConnection _connection;

  /// Connects and says hello. Throws [TransferException]
  /// ([TransferFailure.unreachable]) when the other phone cannot be reached
  /// within [timeout].
  static Future<TransferGuest> connect(
    WifiPairing pairing, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    // Closed by TransferConnection.close(), which owns it from here on.
    // ignore: close_sinks
    final Socket socket;
    try {
      socket = await Socket.connect(
        pairing.host,
        pairing.port,
        timeout: timeout,
      );
    } on SocketException catch (e) {
      throw TransferException(
        TransferFailure.unreachable,
        'Could not reach the other phone.',
        cause: e.runtimeType,
      );
    }
    final guest = TransferGuest._(
      TransferConnection(
        socket,
        TransferCipher(
          key: pairing.key,
          sessionId: pairing.sessionId,
          isHost: false,
        ),
      ),
    );
    try {
      await guest._connection.send(
        const TransferMessage(MessageType.hello, {
          'app': 'folio',
          'v': WifiPairing.formatVersion,
        }),
      );
    } on TransferException {
      await guest.close();
      rethrow;
    }
    return guest;
  }

  /// Waits for the other phone's offer.
  ///
  /// If the other phone drops the connection before sending anything, the
  /// code was wrong, old or already used by another phone, so that is
  /// reported as [TransferFailure.wrongCode].
  Future<TransferOffer> receiveOffer({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final TransferMessage message;
    try {
      message = await _connection.receive(timeout: timeout);
    } on TransferException catch (e) {
      if (e.reason == TransferFailure.connectionLost &&
          _connection.receivedCount == 0) {
        throw TransferException(
          TransferFailure.wrongCode,
          'The other phone refused the code.',
          cause: e.reason,
        );
      }
      rethrow;
    }
    if (message.type != MessageType.offer) {
      throw const TransferException(TransferFailure.badData, 'No offer.');
    }
    final offer = TransferOffer.fromWire(message.body);
    if (offer == null) {
      throw const TransferException(
        TransferFailure.unsupportedVersion,
        'Unknown offer.',
      );
    }
    return offer;
  }

  /// Receives every file of an accepted [offer] into [folder] (a private
  /// cache folder), checking each one. Files that fail a check are deleted
  /// and returned with their [ReceivedFile.problem]; the transfer goes on.
  ///
  /// [onProgress] gets (received bytes, total bytes). Throws
  /// [TransferException]: [TransferFailure.cannotSave] when the phone cannot
  /// write (storage full), [TransferFailure.badData] when the other phone
  /// sends more than it offered, or a connection failure.
  Future<List<ReceivedFile>> receiveFiles(
    FileOffer offer,
    Directory folder, {
    void Function(int received, int total)? onProgress,
    Duration pieceTimeout = const Duration(seconds: 60),
  }) async {
    final total = offer.totalBytes;
    var received = 0;
    final results = <ReceivedFile>[];
    try {
      await folder.create(recursive: true);
    } on FileSystemException catch (e) {
      throw TransferException(
        TransferFailure.cannotSave,
        'Could not prepare the receive folder.',
        cause: e.runtimeType,
      );
    }
    onProgress?.call(0, total);
    for (var i = 0; i < offer.files.length; i++) {
      final offered = offer.files[i];
      final path = p.join(
        folder.path,
        '${i + 1}_${safePdfFileName(offered.name)}',
      );
      final digestSink = _DigestSink();
      final hashing = sha256.startChunkedConversion(digestSink);
      final head = BytesBuilder();
      RandomAccessFile? out;
      try {
        out = await File(path).open(mode: FileMode.write);
        var left = offered.sizeBytes;
        while (left > 0) {
          final message = await _connection.receive(timeout: pieceTimeout);
          final piece = message.data;
          if (message.type != MessageType.fileChunk || piece == null) {
            throw const TransferException(
              TransferFailure.badData,
              'Expected file content.',
            );
          }
          if (piece.length > left) {
            throw const TransferException(
              TransferFailure.badData,
              'More bytes than offered.',
            );
          }
          if (head.length < 5) head.add(piece.take(5 - head.length).toList());
          hashing.add(piece);
          await out.writeFrom(piece);
          left -= piece.length;
          received += piece.length;
          onProgress?.call(received, total);
        }
      } on FileSystemException catch (e) {
        throw TransferException(
          TransferFailure.cannotSave,
          'Could not write a received file.',
          cause: e.runtimeType,
        );
      } finally {
        await out?.close();
      }
      hashing.close();
      final problem = digestSink.value != offered.sha256
          ? ReceivedFileProblem.damaged
          : !_isPdfHeader(head.toBytes())
          ? ReceivedFileProblem.notPdf
          : null;
      if (problem != null) {
        try {
          await File(path).delete();
        } on FileSystemException {
          // The cache cleanup at startup removes it later.
        }
      }
      results.add(ReceivedFile(offered: offered, path: path, problem: problem));
    }
    return results;
  }

  static bool _isPdfHeader(Uint8List head) =>
      head.length >= 5 &&
      head[0] == 0x25 && // %
      head[1] == 0x50 && // P
      head[2] == 0x44 && // D
      head[3] == 0x46 && // F
      head[4] == 0x2D; // -

  /// Tells the other phone how many files passed the checks.
  Future<void> sendResult({required int received}) => _connection.send(
    TransferMessage(MessageType.result, {'received': received}),
  );

  /// Tells the other phone whether the user accepted.
  Future<void> answer({required bool accepted}) => _connection.send(
    TransferMessage(MessageType.answer, {'accepted': accepted}),
  );

  Future<void> close() => _connection.close();
}

/// Captures the single digest of a chunked SHA-256 conversion.
class _DigestSink implements Sink<Digest> {
  String value = '';

  @override
  void add(Digest data) => value = data.toString();

  @override
  void close() {}
}
