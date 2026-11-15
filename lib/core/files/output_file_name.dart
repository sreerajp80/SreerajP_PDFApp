import 'dart:io';

/// Builds the file name of a new file made from an open document, for example
/// `EliteHub_Invoice.pdf` + `signed` → `EliteHub_Invoice_signed_20261115_143205.pdf`.
///
/// Every tool that writes a new file (sign, page tools, split, batch, annotation
/// export, share-to-PDF) names its output through this class, so names look the
/// same everywhere. The display name comes from outside the app, so it is
/// always cleaned before it becomes part of a file name.
abstract final class OutputFileName {
  /// The most characters kept from the original name. Android file names are
  /// limited to 255 bytes, and a Malayalam letter takes 3 bytes in UTF-8.
  static const int maxBaseLength = 100;

  /// Used when nothing usable is left of the original name.
  static const String fallbackBase = 'document';

  static final RegExp _pdfExtension = RegExp(r'\.pdf$', caseSensitive: false);
  static final RegExp _unsafe = RegExp(r'[\\/:*?"<>|\x00-\x1F\x7F]');
  static final RegExp _edges = RegExp(r'^[\s.]+|[\s.]+$');

  /// The cleaned base name (no extension) of [displayName].
  static String baseOf(String displayName) {
    var base = displayName.trim().replaceFirst(_pdfExtension, '');
    base = base.replaceAll(_unsafe, '_').replaceAll(_edges, '');
    final runes = base.runes;
    if (runes.length > maxBaseLength) {
      base = String.fromCharCodes(runes.take(maxBaseLength))
          .replaceAll(_edges, '');
    }
    return base.isEmpty ? fallbackBase : base;
  }

  /// The local date and time as `yyyyMMdd_HHmmss`.
  static String stampOf(DateTime now) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${now.year.toString().padLeft(4, '0')}${two(now.month)}'
        '${two(now.day)}_${two(now.hour)}${two(now.minute)}${two(now.second)}';
  }

  /// `<base>_<action>_<yyyyMMdd_HHmmss>.<extension>`, or without `_<action>`
  /// when [action] is null. `_<copy>` is added before the extension when
  /// [copy] is 2 or more (two outputs in the same second).
  static String build(
    String displayName,
    DateTime now, {
    String? action,
    String extension = 'pdf',
    int copy = 1,
  }) {
    final actionPart = action == null || action.isEmpty ? '' : '_$action';
    final copyPart = copy >= 2 ? '_$copy' : '';
    return '${baseOf(displayName)}${actionPart}_${stampOf(now)}'
        '$copyPart.$extension';
  }

  /// A full path in [dir] named by [build] that does not exist yet, adding
  /// `_2`, `_3`, … when needed so an earlier output is never overwritten.
  static Future<String> uniquePath(
    Directory dir,
    String displayName,
    DateTime now, {
    String? action,
    String extension = 'pdf',
  }) async {
    var copy = 1;
    while (true) {
      final name = build(
        displayName,
        now,
        action: action,
        extension: extension,
        copy: copy,
      );
      final path = '${dir.path}/$name';
      if (!await File(path).exists()) return path;
      copy++;
    }
  }
}
