# Fix gaps and errors in docs/features.md (round 2)

Implements: `plans/20260803_161500_fix_features_doc_gaps2.md`

## What changed

Only `docs/features.md` was edited. No app code changed.

### Wrong claims fixed

- Annotation colors: corrected from "5 (incl. Pink)" to the real 7
  (Yellow, Green, Blue, Red, Purple, Orange, Black).
- Ink drawing: removed the "stroke width is customizable" claim — only
  the color can be changed by the user.
- Sticky notes: removed the "custom titles" claim — notes only have a
  text body.
- Bookmarks: removed the "custom label editing" claim, since no screen
  lets the user set a label; noted the data field exists but is unused.
- Signature trust list: removed the claim that Adobe's AATL is bundled.
  Code deliberately excludes AATL for licensing reasons; only EU EUTL is
  bundled. Added a note that users can still import AATL roots manually.
- Share intents: clarified that `ACTION_SEND_MULTIPLE` is registered for
  images only, not a general multi-file share target.

### Missing features added

- Viewer: "Reset Zoom" button, and the large-file safeguard that forces
  single-page mode with a warning.
- Annotations: "Clear All" bulk delete action.
- Page operations: a note that Merge/Split/Organize/Compress need an
  already-unlocked source file (no password parameter is wired up yet).
- Extraction: form-field export (clipboard/JSON share); corrected the
  render-to-image DPI range to the real 100–300 slider.
- Printer/importer: noted the max-image-count limit on image import.
- Signatures: added certificate revocation status checking, the
  document-level "weakest signature wins" summary verdict, and the
  on-page status overlay drawn over the PDF viewer's native signature
  widget.
- App overview: added `go_router`, `shared_preferences`,
  `package_info_plus`, `crypto`, and `logger` to the open-source stack
  list.

## Why

A code audit (Explore agent) compared every claim in `docs/features.md`
against the actual Flutter/Kotlin source, the Android manifest, and
`pubspec.yaml`. It found several claims that didn't match the code and
several real, user-facing behaviors the doc left out. This change brings
the document back in line with what the app actually does.
