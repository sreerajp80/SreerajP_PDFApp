import 'dart:ui';

/// Where one copy of the signature goes: a page and a box on it.
///
/// [rect] is **normalized** like the annotation overlay: each value is a
/// fraction (0.0–1.0) of the page width or height as the page is shown on
/// screen (rotation already applied), with the origin at the top-left.
class SignaturePlacement {
  const SignaturePlacement({required this.page, required this.rect});

  /// 1-based page number.
  final int page;
  final Rect rect;

  SignaturePlacement copyWith({int? page, Rect? rect}) =>
      SignaturePlacement(page: page ?? this.page, rect: rect ?? this.rect);

  /// The values the native stamp method reads.
  Map<String, Object?> toPlatformMap(String imagePath) => {
    'page': page,
    'x': rect.left,
    'y': rect.top,
    'w': rect.width,
    'h': rect.height,
    'imagePath': imagePath,
  };
}
