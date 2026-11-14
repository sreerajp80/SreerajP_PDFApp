# Change log: record the Google Play short description

Implements plan: `plans/20261114_090207_play_short_description.md`

## What changed

- `docs/PROJECT_PROFILE.md` — added a row "Google Play short description (max 80
  characters)" under the store title:
  - `en-IN` (78): `Read & listen to PDFs offline. Annotate, merge, split, compress, lock. No ads.`
  - `ml-IN` (77): `PDF വായിക്കാം, കേൾക്കാം, കുറിപ്പെഴുതാം, ലയിപ്പിക്കാം, വിഭജിക്കാം. പരസ്യമില്ല.`

The store title stays `Folio: Offline PDF Reader`. The existing project one-liner row is
unchanged. Play Console is updated by the owner by hand.

**Security impact:** none (documentation only).

## Checks

- Documentation only; no build or tests needed.
- The Malayalam text was chosen by the owner, a native reader.
