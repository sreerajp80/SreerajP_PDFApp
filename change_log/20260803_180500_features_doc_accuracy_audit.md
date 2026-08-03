# Change log — docs/features.md accuracy audit

Implements: [plans/20260803_180000_features_doc_accuracy_audit.md](../plans/20260803_180000_features_doc_accuracy_audit.md)

## What changed

Checked `docs/features.md` against the real app (routes, screens, Android manifest,
`pubspec.yaml`, `build.gradle.kts`). Made three small fixes in `docs/features.md`:

1. **About Screen bullet (section 2.8)**: removed the wrong claim that it shows the
   package identifier. Replaced with an accurate description — the screen is driven
   by `assets/config/app_config.json` and shows app name, description, version+build,
   and a details list (Author, Email, License, "AI used", "IDE used").
2. **Text-to-PDF Converter bullet (section 2.6)**: added a sentence about the
   friendly error shown when shared text has characters the PDF font can't draw,
   instead of producing a broken file.
3. **App Settings bullet (section 2.8)**: noted that Theme and Trust Store are each
   their own screen, not just settings rows.

Everything else in the doc (dependency list, permissions, intent filters, signature
verification, search engine, annotations, page operations, print, extraction,
viewer) was checked against the code and found accurate — no changes needed there.
