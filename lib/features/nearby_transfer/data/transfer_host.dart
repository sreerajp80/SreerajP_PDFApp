import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/core/logging/app_logger.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_cipher.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_connection.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_protocol.dart';
import 'package:pdfapp/features/nearby_transfer/domain/pairing_code.dart';
import 'package:pdfapp/features/nearby_transfer/domain/transfer_offer.dart';

/// Something that happened in a host session, for the screen to show.
sealed class HostEvent {
  const HostEvent();
}

/// A phone proved it holds the key. The session is now locked to it.
final class HostGuestConnected extends HostEvent {
  const HostGuestConnected(this.address);
  final String address;
}

/// File content is on its way: [sentBytes] of [totalBytes] sent so far.
final class HostSending extends HostEvent {
  const HostSending(this.sentBytes, this.totalBytes);
  final int sentBytes;
  final int totalBytes;
}

/// The other phone answered the offer (and, for files, received them). The
/// session is over. [filesReceived] is how many files passed the other
/// phone's checks; it is set for a file offer only.
final class HostFinished extends HostEvent {
  const HostFinished({required this.accepted, this.filesReceived});
  final bool accepted;
  final int? filesReceived;
}

/// The session ended without an answer. The session is over.
final class HostFailed extends HostEvent {
  const HostFailed(this.reason);
  final TransferFailure reason;
}

/// The sending phone's side of a WiFi session (plan §3.3).
///
/// - Listens on the given local WiFi address only, on a random free port.
/// - A phone that connects must send a `hello` sealed with the session key
///   within [helloTimeout]. One that cannot is dropped; after
///   [maxBadAttempts] such phones the session ends.
/// - The first phone that passes locks the session: the listening socket is
///   closed, so no other phone can connect.
/// - With no good phone within [pairingTimeout], the session ends.
///
/// Socket use is limited to `lib/features/nearby_transfer/data/` (CI check).
class TransferHost {
  TransferHost._({
    required this._server,
    required this.pairing,
    required this._offer,
    required this.expiresAt,
    required this._helloTimeout,
    required this._answerTimeout,
    required this._maxBadAttempts,
    required this._filePaths,
  });

  /// Starts listening on [bindAddress] and returns the session, whose
  /// [pairing] goes into the QR code.
  ///
  /// For a [FileOffer], [filePaths] holds the local file for each offered
  /// file, in the same order.
  ///
  /// Throws [TransferException] ([TransferFailure.unreachable]) if the
  /// address cannot be used.
  static Future<TransferHost> start({
    required InternetAddress bindAddress,
    required TransferOffer offer,
    List<String> filePaths = const [],
    Duration pairingTimeout = const Duration(minutes: 3),
    Duration helloTimeout = const Duration(seconds: 10),
    Duration answerTimeout = const Duration(minutes: 5),
    int maxBadAttempts = 5,
  }) async {
    if (offer is FileOffer && offer.files.length != filePaths.length) {
      throw ArgumentError('One local path is needed for each offered file.');
    }
    final ServerSocket server;
    try {
      server = await ServerSocket.bind(bindAddress, 0);
    } on SocketException catch (e) {
      throw TransferException(
        TransferFailure.unreachable,
        'Could not start listening.',
        cause: e.runtimeType,
      );
    }
    final pairing = WifiPairing(
      host: bindAddress.address,
      port: server.port,
      sessionId: TransferCipher.randomBytes(WifiPairing.sessionIdLength),
      key: TransferCipher.randomBytes(WifiPairing.keyLength),
    );
    final host = TransferHost._(
      server: server,
      pairing: pairing,
      offer: offer,
      expiresAt: DateTime.now().add(pairingTimeout),
      helloTimeout: helloTimeout,
      answerTimeout: answerTimeout,
      maxBadAttempts: maxBadAttempts,
      filePaths: List.unmodifiable(filePaths),
    );
    host._listen(pairingTimeout);
    AppLogger.info('Device sync: host session started.');
    return host;
  }

  final WifiPairing pairing;

  /// When the code stops working if no phone has connected.
  final DateTime expiresAt;

  final ServerSocket _server;
  final TransferOffer _offer;
  final Duration _helloTimeout;
  final Duration _answerTimeout;
  final int _maxBadAttempts;
  final List<String> _filePaths;

  /// How long to wait for the other phone to confirm it received the files.
  static const Duration _resultTimeout = Duration(minutes: 2);

  final StreamController<HostEvent> _events = StreamController<HostEvent>();
  Future<void>? _serverClosing;
  Timer? _pairingTimer;
  TransferConnection? _guest;
  int _badAttempts = 0;
  bool _locked = false;
  bool _ended = false;

  /// Session events. Single listener; events before listening are kept.
  Stream<HostEvent> get events => _events.stream;

  void _listen(Duration pairingTimeout) {
    _pairingTimer = Timer(pairingTimeout, () {
      if (!_locked) _end(const HostFailed(TransferFailure.timedOut));
    });
    _server.listen(
      (socket) => unawaited(_tryGuest(socket)),
      onError: (Object _) =>
          _end(const HostFailed(TransferFailure.connectionLost)),
    );
  }

  Future<void> _tryGuest(Socket socket) async {
    if (_locked || _ended) {
      socket.destroy();
      return;
    }
    final connection = TransferConnection(
      socket,
      TransferCipher(
        key: pairing.key,
        sessionId: pairing.sessionId,
        isHost: true,
      ),
    );
    try {
      final hello = await connection.receive(timeout: _helloTimeout);
      if (hello.type != MessageType.hello || !_helloIsValid(hello.body)) {
        throw const TransferException(TransferFailure.badData, 'Bad hello.');
      }
    } on TransferException {
      await connection.close();
      _badAttempts++;
      AppLogger.warning('Device sync: a phone failed to pair.');
      if (_badAttempts >= _maxBadAttempts) {
        _end(const HostFailed(TransferFailure.wrongCode));
      }
      return;
    }
    if (_locked || _ended) {
      await connection.close();
      return;
    }
    await _serve(connection);
  }

  static bool _helloIsValid(Map<String, Object?> body) =>
      body['app'] == 'folio' && body['v'] == WifiPairing.formatVersion;

  Future<void> _serve(TransferConnection connection) async {
    _locked = true;
    _guest = connection;
    _pairingTimer?.cancel();
    await _closeServer();
    _emit(HostGuestConnected(connection.remoteAddress));
    try {
      await connection.send(
        TransferMessage(MessageType.offer, _offer.toWire()),
      );
      final answer = await connection.receive(timeout: _answerTimeout);
      if (answer.type != MessageType.answer) {
        throw const TransferException(TransferFailure.badData, 'No answer.');
      }
      final accepted = answer.body['accepted'] == true;
      final offer = _offer;
      if (!accepted || offer is! FileOffer) {
        _end(HostFinished(accepted: accepted));
        return;
      }
      await _sendFiles(connection, offer);
      final result = await connection.receive(timeout: _resultTimeout);
      if (result.type != MessageType.result) {
        throw const TransferException(TransferFailure.badData, 'No result.');
      }
      final received = result.body['received'];
      _end(
        HostFinished(
          accepted: true,
          filesReceived: received is int ? received : 0,
        ),
      );
    } on TransferException catch (e) {
      _end(HostFailed(e.reason));
    }
  }

  /// Streams every offered file, in order, in pieces of at most
  /// [TransferMessage.chunkSize] bytes. A file whose size changed since the
  /// offer was made ends the session: the other phone would reject it anyway.
  Future<void> _sendFiles(
    TransferConnection connection,
    FileOffer offer,
  ) async {
    final total = offer.totalBytes;
    var sent = 0;
    var lastReport = DateTime.fromMillisecondsSinceEpoch(0);
    _emit(HostSending(0, total));
    for (var i = 0; i < offer.files.length; i++) {
      final expected = offer.files[i].sizeBytes;
      RandomAccessFile? file;
      try {
        file = await File(_filePaths[i]).open();
        var left = expected;
        while (left > 0) {
          if (_ended) return;
          final want = left < TransferMessage.chunkSize
              ? left
              : TransferMessage.chunkSize;
          final Uint8List piece = await file.read(want);
          if (piece.isEmpty) {
            throw const TransferException(
              TransferFailure.badData,
              'The file got shorter while sending.',
            );
          }
          await connection.send(TransferMessage.chunk(piece));
          left -= piece.length;
          sent += piece.length;
          final now = DateTime.now();
          if (now.difference(lastReport).inMilliseconds >= 200) {
            lastReport = now;
            _emit(HostSending(sent, total));
          }
        }
      } on FileSystemException catch (e) {
        throw TransferException(
          TransferFailure.badData,
          'Could not read a file to send.',
          cause: e.runtimeType,
        );
      } finally {
        await file?.close();
      }
    }
    _emit(HostSending(total, total));
  }

  void _emit(HostEvent event) {
    if (!_events.isClosed) _events.add(event);
  }

  void _end(HostEvent last) {
    if (_ended) return;
    _ended = true;
    _emit(last);
    unawaited(close());
  }

  /// Stops listening. Closing the server socket also ends its stream, so the
  /// listener is not cancelled separately: on a server socket, cancelling the
  /// listener already closes it, and a later `close()` would then never finish.
  Future<void> _closeServer() =>
      _serverClosing ??= _server.close().then((_) {});

  /// Ends the session at once: stops listening, closes any connection and
  /// lets the key go with this object.
  Future<void> close() async {
    _ended = true;
    _pairingTimer?.cancel();
    await _closeServer();
    await _guest?.close();
    // Not awaited: with no listener, close() on a single-listener stream only
    // completes once someone listens, which may never happen.
    if (!_events.isClosed) unawaited(_events.close());
  }
}
