# Change Log — Malayalam Search Sandhi & Conjuncts Fix

**Status:** `completed`

This change implements the plan defined in [plans/20260715_155607_malayalam_search_sandhi_fix.md](file:///l:/Android/SreerajP_PDFApp/plans/20260715_155607_malayalam_search_sandhi_fix.md).

## What Was Changed
- Modified the `findAll` method in `lib/core/search/search_normalizer.dart` to support substring search on the normalized text key instead of forcing search matches to only start at grapheme cluster boundaries.
- The matching logic now checks that the match ends exactly on a grapheme cluster boundary (so we don't slice vowel signs or other combining marks), but allows starting in the middle of a cluster (such as a conjoined prefix consonant).
- Added unit tests in `test/core/search/search_normalizer_test.dart` under the group `Malayalam Sandhi conjoined search` to cover conjoined Sandhi searches and verify that vowel slicing is correctly rejected.

## How it was verified
- Ran the automated test suite (`flutter test`) and verified all 161 tests pass.
