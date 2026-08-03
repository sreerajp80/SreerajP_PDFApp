# Fix gaps and errors in docs/features.md (round 3)

Implements: `plans/20260803_170000_fix_features_doc_gaps3.md`

## What changed

Only `docs/features.md` was edited. No app code changed.

### Wrong claims fixed

- Compress PDF: corrected from "downsample embedded images and optimize
  stream structure" to what the code actually does — strips document-info
  and XMP metadata and re-saves the file, with no image downsampling or
  stream recompression.
- Encrypt PDF: corrected from "AES/RC4 security handlers" to "AES-256"
  only, matching the hard-coded `encryptionKeyLength = 256` /
  `setPreferAES(true)` in the native code.

### Missing items added

- Open-source stack list (section 1): added `flutter_riverpod` (state
  management, used across ~30 files), `path_provider` (app-local file
  paths), `intl` (locale-aware formatting), and `flutter_localizations`
  (backs the English/Malayalam UI).
- Recent Files Dashboard: noted the 30-item cap on stored recent files.
- Custom Trust Store: noted the 512 KB size cap on imported certificate
  files.
- Images-to-PDF Converter: gave the exact number for the "maximum image
  count" limit (100).
- App overview sentence (section 1): added "encrypting/decrypting" and
  "compressing" to the list of things the app does, since Protect/Unlock
  and Compress are real features in section 2.4 that the summary sentence
  previously left out.

## Why

A fresh code audit compared `docs/features.md` against `pubspec.yaml`, the
Android manifest, and the Flutter/Kotlin source. It found the Compress and
Encrypt bullets no longer matched the code, a load-bearing dependency
(`flutter_riverpod`) missing from the stack list, and a few numeric limits
mentioned only qualitatively. It also found the top-level app description
omitted encrypt/decrypt and compress, even though those are documented
features further down. This change brings the document back in line with
the code and makes the overview sentence cover all major feature areas.
