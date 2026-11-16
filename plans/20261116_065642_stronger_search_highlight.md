# Make search highlights easier to see

**Status:** completed

## The issue

In the PDF viewer, search matches are hard to spot quickly.

- Other matches are filled with the theme's `tertiary` colour at 35% strength.
- The current match is filled with the theme's `primary` (accent) colour at 50% strength.
- There is no border, so the current match looks a lot like the other matches.
- The PDF page is white in both the light and dark app themes. In the dark theme, `primary`
  and `tertiary` are pale colours, so they almost vanish on a white page.
- In night (invert) mode, the invert filter is applied to the page *after* the highlights
  are drawn. This changes their colour (for example, a blue accent turns orange).

## The idea (agreed with the user)

Keep the theme and accent colours, but:

1. Make the fill a little stronger.
2. Put a solid border around the current match, so it is clear where the reader is.
3. Make sure it works in both the light and dark themes, and in night mode.

## The fix

1. **Keep the hue, fix the lightness.** Add a small pure helper in the painter file that
   takes a theme colour and the page background (white, or black in night mode) and returns
   a version of the same hue that stands out:
   - on a white page, a colour that is too light is made darker;
   - on a black page, a colour that is too dark is made lighter.
   This uses `HSLColor`, so the accent's hue stays the same — only lightness changes.
2. **Stronger fill.** Other matches: `tertiary`, fill alpha 0.35 → 0.45.
   Current match: `primary`, fill alpha 0.5 → 0.55.
3. **Border on the current match.** Draw the current match's rectangles a little larger
   (about 1.5 logical pixels on each side) with a solid 2-pixel border in the full-strength
   `primary` colour. Other matches get no border, so the current one stands out.
4. **Night mode.** When invert is on, pass the colours through the same invert, before
   painting, so after the page filter the reader sees the real theme colour. The page
   background used in step 1 is then black.
5. **Tests.** Add a unit test for the colour helper: a pale colour on white becomes darker,
   a dark colour on black becomes lighter, a colour that already stands out is unchanged,
   and the hue never changes.

## Files to change

- `lib/features/reading/presentation/widgets/search_highlight_painter.dart` — add the
  border for the current match, the colour helper, and the night-mode colour handling.
- `lib/features/viewer/presentation/viewer_screen.dart` — pass the new colours and the
  invert flag to the painter.
- `test/features/reading/presentation/widgets/search_highlight_painter_test.dart` — new
  test for the colour helper.
- `docs/features.md` — only if it describes the highlight colours.

No ARB (text) changes. No new packages.

## Security impact

None. Drawing only; no network, storage, permissions or platform changes.

## Checks

- `dart format .`, `flutter analyze` (0 warnings), `flutter test`.
- Manual check on a device: light theme, dark theme, a pale custom accent, and night mode.
