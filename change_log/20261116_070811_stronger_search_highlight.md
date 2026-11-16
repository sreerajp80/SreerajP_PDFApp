# Make search highlights easier to see

Implements plan: `plans/20261116_065642_stronger_search_highlight.md`

## What changed

- `lib/features/reading/presentation/widgets/search_highlight_painter.dart`
  - The painter now takes the plain theme colours and a `nightMode` flag, and owns the
    styling itself.
  - Fill is stronger: other matches 0.35 → 0.45, current match 0.5 → 0.55.
  - The current match is drawn 1.5 px larger on each side, with rounded corners and a solid
    2 px border in the full accent colour. Other matches have no border.
  - New helper `highlightTone(color, darkPage:)`: keeps the hue and saturation, but moves the
    lightness so the colour stands out — at most 0.45 on a white page, at least 0.6 on a dark
    page. This fixes pale dark-theme accents and pale custom accents on a white PDF page.
  - New helper `invertRgb(color)`: in night mode the colours are inverted before painting, so
    after the viewer's invert filter the reader sees the real theme colour.
- `lib/features/viewer/presentation/viewer_screen.dart`
  - Passes `scheme.tertiary`, `scheme.primary` and `nightMode: _invert` to the painter.
  - Toggling night mode now repaints the pages, so highlights switch colour at once.
- `test/features/reading/presentation/widgets/search_highlight_painter_test.dart` — new
  tests for `highlightTone` and `invertRgb`.
- `docs/features.md` — search entry describes the new highlight look.

## Checks

- `dart format` — no changes needed.
- `flutter analyze` — no issues.
- `flutter test` — all 665 tests pass.
- Not yet checked on a device (light theme, dark theme, pale custom accent, night mode).

No text (ARB) changes, no new packages. Security impact: none.
