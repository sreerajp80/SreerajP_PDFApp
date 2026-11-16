import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:pdfapp/features/reading/domain/search_hit.dart';
import 'package:pdfrx/pdfrx.dart';

/// Draws search matches straight onto the rendered page.
///
/// pdfrx hands each page's paint callback a canvas and the rectangle the page
/// occupies on screen. Our hits carry PDF page coordinates, so each one is
/// converted to screen coordinates for the page it belongs to. Because the
/// conversion uses the page rect it is given, highlights stay correct at any
/// zoom, in any view mode, and after a rotation.
///
/// The colours follow the theme, but their lightness is adjusted so they stand
/// out on the page (see [highlightTone]). The current match also gets a solid
/// border, so the reader can see at once where they are.
class SearchHighlightPainter {
  const SearchHighlightPainter({
    required this.hits,
    required this.current,
    required this.matchColor,
    required this.currentMatchColor,
    this.nightMode = false,
  });

  final List<SearchHit> hits;

  /// The match the reader is standing on, drawn in a stronger colour and with
  /// a border so it can be told apart from the rest.
  final SearchHit? current;

  /// Theme colour for the other matches (alpha is ignored).
  final Color matchColor;

  /// Theme colour for the current match (alpha is ignored).
  final Color currentMatchColor;

  /// True when the viewer inverts the page colours for night reading. The
  /// page then shows as dark, and the invert filter is also applied to what we
  /// paint, so the colours are inverted here first to cancel it out.
  final bool nightMode;

  static const double _matchFillAlpha = 0.45;
  static const double _currentFillAlpha = 0.55;
  static const double _borderWidth = 2;
  static const double _borderGap = 1.5;
  static const Radius _corner = Radius.circular(2);

  /// Give this to `PdfViewerParams.pagePaintCallbacks`.
  void paint(ui.Canvas canvas, Rect pageRect, PdfPage page) {
    if (hits.isEmpty) return;

    final matchPaint = Paint()
      ..color = _onPage(matchColor).withValues(alpha: _matchFillAlpha);
    final currentTone = _onPage(currentMatchColor);
    final currentPaint = Paint()
      ..color = currentTone.withValues(alpha: _currentFillAlpha);
    final borderPaint = Paint()
      ..color = currentTone
      ..style = PaintingStyle.stroke
      ..strokeWidth = _borderWidth;

    for (final hit in hits) {
      // Each page paints only its own matches.
      if (hit.pageNumber != page.pageNumber) continue;

      final isCurrent = identical(hit, current);
      for (final rect in hit.rects) {
        final screenRect = rect
            .toRect(page: page, scaledPageSize: pageRect.size)
            .translate(pageRect.left, pageRect.top);
        if (isCurrent) {
          final box = RRect.fromRectAndRadius(
            screenRect.inflate(_borderGap),
            _corner,
          );
          canvas
            ..drawRRect(box, currentPaint)
            ..drawRRect(box, borderPaint);
        } else {
          canvas.drawRect(screenRect, matchPaint);
        }
      }
    }
  }

  /// The theme colour as it must be painted so the reader sees a tone that
  /// stands out on this page.
  Color _onPage(Color color) {
    final tone = highlightTone(color, darkPage: nightMode);
    return nightMode ? invertRgb(tone) : tone;
  }
}

/// Lightest tone kept on a white page; lighter colours are darkened to this.
const double _maxLightnessOnLight = 0.45;

/// Darkest tone kept on a dark page; darker colours are lightened to this.
const double _minLightnessOnDark = 0.6;

/// Returns [color] with the same hue and saturation, but with its lightness
/// moved, if needed, so it stands out on the page: darker on a white page,
/// lighter on a dark page. A colour that already stands out is returned as is.
/// The result is opaque.
Color highlightTone(Color color, {required bool darkPage}) {
  final hsl = HSLColor.fromColor(color.withValues(alpha: 1));
  if (!darkPage && hsl.lightness > _maxLightnessOnLight) {
    return hsl.withLightness(_maxLightnessOnLight).toColor();
  }
  if (darkPage && hsl.lightness < _minLightnessOnDark) {
    return hsl.withLightness(_minLightnessOnDark).toColor();
  }
  return color.withValues(alpha: 1);
}

/// Flips the red, green and blue parts of [color], keeping its alpha. This is
/// the same change the viewer's night-mode filter makes, so painting
/// `invertRgb(c)` under that filter shows `c`.
Color invertRgb(Color color) => Color.from(
  alpha: color.a,
  red: 1 - color.r,
  green: 1 - color.g,
  blue: 1 - color.b,
);
