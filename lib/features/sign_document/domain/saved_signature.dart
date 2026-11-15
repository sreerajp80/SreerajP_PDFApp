import 'dart:typed_data';

/// Where a saved signature came from. The stored value is [storageName]; keep
/// these names stable — they are persisted data.
enum SignatureSource {
  /// Drawn on the screen with a finger or stylus.
  drawn,

  /// Imported from a picture (photo or scan) through the system picker.
  imported;

  String get storageName => name;

  /// Parses a stored value. An unknown value falls back to [imported] so one
  /// odd row can never hide the user's signature list.
  static SignatureSource fromStorage(String value) {
    for (final s in SignatureSource.values) {
      if (s.storageName == value) return s;
    }
    return SignatureSource.imported;
  }
}

/// One saved signature picture (a PNG with a see-through background).
///
/// The picture lives in the app's private files folder; this record holds only
/// its file name and size. Only the repository turns [fileName] into a path.
class SavedSignature {
  const SavedSignature({
    required this.id,
    required this.fileName,
    required this.widthPx,
    required this.heightPx,
    required this.source,
    required this.createdAt,
  });

  /// Row id. Null before the row is inserted.
  final int? id;
  final String fileName;
  final int widthPx;
  final int heightPx;
  final SignatureSource source;
  final DateTime createdAt;

  /// Width divided by height. Never zero or infinite, even for a bad row.
  double get aspectRatio {
    if (widthPx <= 0 || heightPx <= 0) return 1;
    return widthPx / heightPx;
  }

  SavedSignature copyWith({
    int? id,
    String? fileName,
    int? widthPx,
    int? heightPx,
    SignatureSource? source,
    DateTime? createdAt,
  }) => SavedSignature(
    id: id ?? this.id,
    fileName: fileName ?? this.fileName,
    widthPx: widthPx ?? this.widthPx,
    heightPx: heightPx ?? this.heightPx,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );

  Map<String, Object?> toRow() => {
    if (id != null) 'id': id,
    'file_name': fileName,
    'width_px': widthPx,
    'height_px': heightPx,
    'source': source.storageName,
    'created_at': createdAt.millisecondsSinceEpoch,
  };

  factory SavedSignature.fromRow(Map<String, Object?> row) => SavedSignature(
    id: (row['id'] as num?)?.toInt(),
    fileName: row['file_name']! as String,
    widthPx: (row['width_px']! as num).toInt(),
    heightPx: (row['height_px']! as num).toInt(),
    source: SignatureSource.fromStorage(row['source']! as String),
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      (row['created_at']! as num).toInt(),
    ),
  );
}

/// A saved signature together with its PNG bytes, ready to show on screen.
class LoadedSignature {
  const LoadedSignature({required this.signature, required this.png});

  final SavedSignature signature;
  final Uint8List png;
}
