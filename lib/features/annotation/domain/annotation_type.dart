/// The kinds of overlay annotation the app supports (Phase 5).
///
/// The value stored in the `annotations.type` column is [storageName]. Keep
/// these names stable — they are persisted data.
enum AnnotationType {
  highlight,
  underline,
  strikethrough,
  note,
  ink,
  bookmark;

  /// The exact string written to the database.
  String get storageName => name;

  /// The three text-markup kinds that sit on top of real text. They need a
  /// text layer to exist, so they are disabled on scanned PDFs.
  bool get isTextMarkup =>
      this == highlight || this == underline || this == strikethrough;

  /// Parses a stored value back to a type. Throws [ArgumentError] on an unknown
  /// value so a corrupt row fails loudly in tests rather than silently.
  static AnnotationType fromStorage(String value) {
    for (final t in AnnotationType.values) {
      if (t.storageName == value) return t;
    }
    throw ArgumentError.value(value, 'value', 'Unknown annotation type');
  }
}
