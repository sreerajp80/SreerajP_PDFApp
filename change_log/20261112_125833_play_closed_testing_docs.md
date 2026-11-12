# Change log — Play closed testing documents and graphics (partial)

**Plan:** [plans/20261112_121936_play_closed_testing_docs.md](../plans/20261112_121936_play_closed_testing_docs.md)
**Date:** 2026-11-12
**Plan status:** partial_completion

## What changed

| File | Change |
| --- | --- |
| `PRIVACY.md` | New. Privacy policy (no data collected; Device sync, camera, read aloud explained) |
| `.gitignore` | Added `play_store_private/` |
| `play_store_private/*` | New, local only: publishing guide, store listing (en-IN, ml-IN draft), data safety, app content, production access draft, submission record, raw captures |
| `docs/graphics/app_icon_512.png` | New. 512 × 512 full-square store icon from `assets/branding/ic_launcher_1024.png` |
| `docs/graphics/feature_graphic_1024x500.png` | New. 1024 × 500, no transparency |
| `docs/graphics/screenshots/en/01…08.png`, `ml/01…08.png` | New. 1080 × 1920, 24-bit PNG, made-up sample PDFs only |
| `docs/release_process.md` | §15: language splitting marked done; listing languages `en-IN`, `ml-IN` |

No app code, manifest, ARB or submodule file changed.

## Not done (left for a next step)

- `README.md` rewrite to use `docs/graphics/`.
- Removing the old `docs/screenshots/` (kept, because the current README still uses it).
- `docs/PROJECT_PROFILE.md` privacy URL (after `PRIVACY.md` is pushed and the link works).

## Found while working (each needs its own plan)

1. **`READ_EXTERNAL_STORAGE` in the release manifest.** Implied by the CameraX plugin's
   `WRITE_EXTERNAL_STORAGE`. Breaks Hard Rule 3. Fix with `tools:node="remove"`. Blocks the Play upload.
2. **Search misses page 3 of `Reading_Guide.pdf`** (3 pages; words on page 3 give "No matches",
   even when visible). PDFium reads the page text normally. Pages 7–8 of an 8-page file work.
3. **Search field draws Malayalam conjuncts wrongly** on the Android 17 emulator
   (കർമ്മണി shown as കരമ്മണ।), while the chip below shows it right. Check on a real phone.
4. Organise pages: a rotated page shows "90°" but the thumbnail does not turn.
5. Malayalam Device sync text says "Folio" instead of ഗ്രന്ഥം.

## Needs native-reader review

The Malayalam store listing and release notes in `play_store_private/store_listing.md` §3, §5.
