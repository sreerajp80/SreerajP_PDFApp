import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:pdfapp/core/errors/app_exception.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_cipher.dart';
import 'package:pdfapp/features/nearby_transfer/data/transfer_protocol.dart';

/// One encrypted, framed connection to the other phone.
///
/// Incoming frames are decrypted strictly in arrival order (the cipher's
/// counters depend on it) and queued until [receive] asks for them. Any
/// failure — a bad frame, a failed check, the socket closing — is kept and
/// reported to every later [receive], so callers never wait forever.
class TransferConnection {
  TransferConnection(this._socket, this._cipher) {
    _subscription = _socket.listen(
      _onData,
      // Both are queued behind the frames still being decrypted, so a message
      // that arrived just before the other side closed is not lost.
      onError: (Object e) => _afterPendingFrames(
        TransferException(
          TransferFailure.connectionLost,
          'Socket error.',
          cause: e.runtimeType,
        ),
      ),
      onDone: () => _afterPendingFrames(
        const TransferException(
          TransferFailure.connectionLost,
          'The other phone closed the connection.',
        ),
      ),
      cancelOnError: true,
    );
  }

  final Socket _socket;
  final TransferCipher _cipher;
  final FrameDecoder _decoder = FrameDecoder();
  late final StreamSubscription<Uint8List> _subscription;

  final Queue<TransferMessage> _ready = Queue<TransferMessage>();
  final Queue<Completer<TransferMessage>> _waiting =
      Queue<Completer<TransferMessage>>();
  Future<void> _decryptChain = Future<void>.value();
  TransferException? _failure;
  bool _closed = false;
  int _received = 0;

  /// Frames received but not yet taken by [receive] (waiting to be decrypted,
  /// or decrypted and queued). Above [_pauseAt] the socket is paused, so a
  /// fast sender cannot fill this phone's memory while it decrypts and writes
  /// a large file; TCP then slows the sender down. Below [_resumeAt] reading
  /// starts again.
  int _pending = 0;
  static const int _pauseAt = 8;
  static const int _resumeAt = 2;

  /// The other phone's address, for showing who connected.
  String get remoteAddress {
    try {
      return _socket.remoteAddress.address;
    } on SocketException {
      return '';
    }
  }

  /// How many messages have been received and checked so far.
  int get receivedCount => _received;

  void _onData(Uint8List chunk) {
    if (_failure != null) return;
    final List<Uint8List> frames;
    try {
      frames = _decoder.add(chunk);
    } on TransferException catch (e) {
      _fail(e);
      return;
    }
    for (final frame in frames) {
      _pending++;
      _decryptChain = _decryptChain.then((_) => _openFrame(frame));
    }
    if (_pending >= _pauseAt && !_subscription.isPaused && !_closed) {
      _subscription.pause();
    }
  }

  void _taken() {
    _pending--;
    if (_pending <= _resumeAt && _subscription.isPaused && !_closed) {
      _subscription.resume();
    }
  }

  Future<void> _openFrame(Uint8List frame) async {
    if (_failure != null) return;
    try {
      final message = TransferMessage.decode(await _cipher.open(frame));
      _received++;
      if (_waiting.isNotEmpty) {
        _waiting.removeFirst().complete(message);
        _taken();
      } else {
        _ready.add(message);
      }
    } on TransferException catch (e) {
      _fail(e);
    }
  }

  void _afterPendingFrames(TransferException e) {
    _decryptChain = _decryptChain.then((_) => _fail(e));
  }

  void _fail(TransferException e) {
    // Messages already checked stay readable; only waiters past them fail.
    _failure ??= e;
    while (_waiting.isNotEmpty) {
      _waiting.removeFirst().completeError(_failure!);
    }
  }

  /// The next message. Throws [TransferException] on failure, or with
  /// [TransferFailure.timedOut] when nothing arrives within [timeout].
  Future<TransferMessage> receive({required Duration timeout}) {
    if (_ready.isNotEmpty) {
      final message = _ready.removeFirst();
      _taken();
      return Future.value(message);
    }
    if (_failure != null) return Future.error(_failure!);
    final completer = Completer<TransferMessage>();
    _waiting.add(completer);
    return completer.future.timeout(
      timeout,
      onTimeout: () {
        _waiting.remove(completer);
        throw const TransferException(
          TransferFailure.timedOut,
          'No message in time.',
        );
      },
    );
  }

  /// Encrypts and sends [message]. Callers send one message at a time (each
  /// call is awaited before the next).
  Future<void> send(TransferMessage message) async {
    if (_failure != null || _closed) {
      throw _failure ??
          const TransferException(
            TransferFailure.connectionLost,
            'Connection closed.',
          );
    }
    final sealed = await _cipher.seal(message.encode());
    try {
      _socket.add(FrameDecoder.encode(sealed));
      await _socket.flush();
    } on SocketException catch (e) {
      throw TransferException(
        TransferFailure.connectionLost,
        'Could not send.',
        cause: e.runtimeType,
      );
    } on StateError catch (e) {
      // The connection was closed while this message was being written
      // (for example the session was stopped mid-file).
      throw TransferException(
        TransferFailure.connectionLost,
        'Connection closed while sending.',
        cause: e.runtimeType,
      );
    }
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _fail(
      const TransferException(
        TransferFailure.connectionLost,
        'Connection closed.',
      ),
    );
    await _subscription.cancel();
    try {
      await _socket.close();
    } on SocketException {
      // Already gone; nothing to do.
    } on StateError {
      // A send() is still flushing ("StreamSink is bound to a stream").
      // destroy() below ends the socket either way.
    }
    _socket.destroy();
  }
}
