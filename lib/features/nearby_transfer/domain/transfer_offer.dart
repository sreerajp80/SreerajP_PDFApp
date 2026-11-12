import 'package:characters/characters.dart';
import 'package:pdfapp/features/nearby_transfer/domain/settings_snapshot.dart';

/// What the sending phone offers once a WiFi session is paired.
sealed class TransferOffer {
  const TransferOffer();

  Map<String, Object?> toWire();

  /// Reads an offer. Returns `null` for an unknown kind or a damaged body.
  static TransferOffer? fromWire(Map<String, Object?> wire) {
    switch (wire['kind']) {
      case SettingsOffer.kind:
        final snapshot = SettingsSnapshot.fromWire(wire['settings']);
        return snapshot == null ? null : SettingsOffer(snapshot);
      case FileOffer.kind:
        return FileOffer.fromWire(wire);
      default:
        return null;
    }
  }
}

/// The sending phone's settings.
final class SettingsOffer extends TransferOffer {
  const SettingsOffer(this.snapshot);

  static const String kind = 'settings';

  final SettingsSnapshot snapshot;

  @override
  Map<String, Object?> toWire() => {
    'kind': kind,
    'settings': snapshot.toWire(),
  };
}

/// One PDF on offer: its name, exact size and SHA-256 (lower-case hex).
///
/// The receiving phone checks size and SHA-256 after the last byte arrives,
/// so a file damaged or changed on the way is never saved.
class OfferedFile {
  const OfferedFile({
    required this.name,
    required this.sizeBytes,
    required this.sha256,
  });

  final String name;
  final int sizeBytes;
  final String sha256;

  Map<String, Object?> toWire() => {
    'name': name,
    'size': sizeBytes,
    'sha256': sha256,
  };

  static final RegExp _hex64 = RegExp(r'^[0-9a-f]{64}$');

  static OfferedFile? fromWire(Object? wire) {
    if (wire is! Map) return null;
    final name = wire['name'];
    final size = wire['size'];
    final hash = wire['sha256'];
    if (name is! String || name.trim().isEmpty || name.length > 255) {
      return null;
    }
    if (size is! int || size < 0 || size > FileOffer.maxFileBytes) return null;
    if (hash is! String || !_hex64.hasMatch(hash)) return null;
    return OfferedFile(name: name, sizeBytes: size, sha256: hash);
  }
}

/// One or more PDFs the sending phone wants to send.
final class FileOffer extends TransferOffer {
  const FileOffer(this.files);

  static const String kind = 'files';

  /// Most files in one session (plan §3.5).
  static const int maxFiles = 50;

  /// Largest single file accepted: 2 GiB.
  static const int maxFileBytes = 2 * 1024 * 1024 * 1024;

  final List<OfferedFile> files;

  int get totalBytes => files.fold(0, (sum, f) => sum + f.sizeBytes);

  @override
  Map<String, Object?> toWire() => {
    'kind': kind,
    'files': [for (final f in files) f.toWire()],
  };

  /// Reads a file offer. Returns `null` if the list is empty, too long, or
  /// any entry is not valid: a partly bad list is refused as a whole.
  static FileOffer? fromWire(Map<String, Object?> wire) {
    final raw = wire['files'];
    if (raw is! List || raw.isEmpty || raw.length > maxFiles) return null;
    final files = <OfferedFile>[];
    for (final item in raw) {
      final file = OfferedFile.fromWire(item);
      if (file == null) return null;
      files.add(file);
    }
    return FileOffer(files);
  }
}

/// Makes a file name from another phone safe to use: no folders, no `..`, no
/// control or reserved characters, not too long, and ending in `.pdf`.
String safePdfFileName(String name) {
  var base = name.split(RegExp(r'[/\\]')).last;
  base = base
      .replaceAll(RegExp(r'[\x00-\x1F\x7F:*?"<>|]'), '_')
      .replaceAll(RegExp(r'^\.+'), '')
      .trim();
  if (base.toLowerCase().endsWith('.pdf')) {
    base = base.substring(0, base.length - 4).trim();
  }
  if (base.isEmpty) base = 'document';
  // Cut by whole letters (grapheme clusters), so a Malayalam or Devanagari
  // letter is never split in half.
  final letters = base.characters;
  if (letters.length > 120) base = letters.take(120).toString().trim();
  return '$base.pdf';
}
