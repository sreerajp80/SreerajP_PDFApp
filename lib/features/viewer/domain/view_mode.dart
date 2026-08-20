/// How pages are laid out in the viewer.
///
/// - [auto]: automatically picks single-page/continuous on phones and dual-page book view on foldables/wide screens.
/// - [continuous]: vertical scroll through all pages (default for normal files).
/// - [single]: one page at a time (used as the degraded mode for large files).
/// - [book]: two pages side by side.
enum PdfViewMode {
  auto,
  continuous,
  single,
  book;

  String get storageValue => name;

  static PdfViewMode fromStorage(String? value) => PdfViewMode.values
      .firstWhere((m) => m.name == value, orElse: () => PdfViewMode.auto);
}
