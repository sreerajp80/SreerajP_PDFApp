import 'dart:convert';
import 'dart:typed_data';

import 'package:pdfapp/core/errors/app_exception.dart';

/// The kinds of message in a Device sync session.
///
/// The numbers are part of the wire format: never change or reuse one.
enum MessageType {
  /// Guest → host, first message. Proves the guest holds the key.
  hello(1),

  /// Host → guest. What is on offer (settings, or a list of PDFs).
  offer(2),

  /// Guest → host. Whether the user accepted the offer.
  answer(3),

  /// Host → guest. A piece of file content: raw bytes, no JSON.
  fileChunk(4),

  /// Guest → host. After all files arrived: how many passed the checks.
  result(5);

  const MessageType(this.code);
  final int code;

  static MessageType? byCode(int code) {
    for (final t in values) {
      if (t.code == code) return t;
    }
    return null;
  }
}

/// One message before encryption: a type byte followed by a JSON body, or,
/// for [MessageType.fileChunk], followed by raw file bytes ([data]).
class TransferMessage {
  const TransferMessage(this.type, this.body) : data = null;

  /// A piece of file content.
  TransferMessage.chunk(Uint8List this.data)
    : type = MessageType.fileChunk,
      body = const {};

  /// The largest file piece sent in one message. Small enough to keep memory
  /// low on both phones; large enough that the per-message cost is small.
  static const int chunkSize = 256 * 1024;

  final MessageType type;
  final Map<String, Object?> body;
  final Uint8List? data;

  Uint8List encode() {
    final payload = data ?? utf8.encode(jsonEncode(body));
    final out = Uint8List(1 + payload.length);
    out[0] = type.code;
    out.setRange(1, out.length, payload);
    return out;
  }

  /// Reads a decrypted message. Throws [TransferException]
  /// ([TransferFailure.badData]) for anything that is not a valid message.
  static TransferMessage decode(Uint8List bytes) {
    if (bytes.isEmpty) throw _bad('Empty message.');
    final type = MessageType.byCode(bytes[0]);
    if (type == null) throw _bad('Unknown message type.');
    if (type == MessageType.fileChunk) {
      if (bytes.length < 2) throw _bad('Empty file piece.');
      return TransferMessage.chunk(Uint8List.sublistView(bytes, 1));
    }
    try {
      final body = jsonDecode(utf8.decode(bytes.sublist(1)));
      if (body is! Map<String, Object?>) throw _bad('Body is not an object.');
      return TransferMessage(type, body);
    } on FormatException catch (e) {
      throw _bad('Body is not valid JSON.', cause: e);
    }
  }
}

/// Splits the incoming byte stream into frames.
///
/// A frame is a 4-byte big-endian length followed by that many bytes of
/// encrypted message. Bytes arrive in pieces of any size, so this keeps what
/// it has until a whole frame is there.
class FrameDecoder {
  /// The largest encrypted message accepted. Large enough for a settings
  /// offer and for a 1 MiB file piece (Part 2), small enough that a bad
  /// length can never make the app hold a huge buffer.
  static const int maxFrameLength = 1024 * 1024 + 4096;

  final BytesBuilder _buffer = BytesBuilder(copy: false);

  /// Adds received bytes and returns every frame now complete, in order.
  ///
  /// Throws [TransferException] ([TransferFailure.badData]) on a zero or too
  /// large length; the connection must then be dropped.
  List<Uint8List> add(List<int> chunk) {
    _buffer.add(chunk);
    final frames = <Uint8List>[];
    var data = _buffer.takeBytes();
    var offset = 0;
    while (data.length - offset >= 4) {
      final length = ByteData.sublistView(
        data,
        offset,
        offset + 4,
      ).getUint32(0);
      if (length == 0 || length > maxFrameLength) {
        throw _bad('Frame length out of range.');
      }
      if (data.length - offset - 4 < length) break;
      frames.add(Uint8List.sublistView(data, offset + 4, offset + 4 + length));
      offset += 4 + length;
    }
    if (offset < data.length) {
      data = Uint8List.sublistView(data, offset);
      _buffer.add(Uint8List.fromList(data));
    }
    return frames;
  }

  /// Puts the length in front of an encrypted message.
  static Uint8List encode(Uint8List sealed) {
    if (sealed.isEmpty || sealed.length > maxFrameLength) {
      throw _bad('Frame length out of range.');
    }
    final out = Uint8List(4 + sealed.length);
    ByteData.sublistView(out).setUint32(0, sealed.length);
    out.setRange(4, out.length, sealed);
    return out;
  }
}

TransferException _bad(String message, {Object? cause}) =>
    TransferException(TransferFailure.badData, message, cause: cause);
