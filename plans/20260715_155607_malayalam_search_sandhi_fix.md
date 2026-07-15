# Malayalam Search Sandhi & Conjuncts Fix

**Status:** `completed`

## Issue
Malayalam search fails to find terms when they are part of a Sandhi conjoined word (e.g. searching "മീനാദ" in "ചലന്മീനാദലോചനാ"). This happens because the `characters` package parses "ന്മീ" (n + virama + m + ii) as a single grapheme cluster, but the search query "മീനാദ" starts with "മീ" (m + ii). Since the matching engine only checked for matches starting exactly at grapheme cluster boundaries, it failed to match.

## Plan for the Fix
1. Modify `findAll` in `lib/core/search/search_normalizer.dart` to perform standard substring search on the folded key.
2. For each match, ensure the match ends exactly on a grapheme cluster boundary (to prevent splitting consonants from their vowel signs / combining marks).
3. If it ends on a cluster boundary, map the start of the match to the cluster containing it, and expand the matched source range to include the entire first cluster.
4. Update the test suite with a test case covering this Malayalam Sandhi situation.

## Files to be Changed
- `lib/core/search/search_normalizer.dart`
- `test/core/search/search_normalizer_test.dart`
