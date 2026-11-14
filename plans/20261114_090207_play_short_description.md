# Record the Google Play short description

**Status:** completed

## The issue

The Play title stays `Folio: Offline PDF Reader` ("Reader" is the word most people search
for). But Folio does much more than read: read aloud, annotate, merge, split, compress, lock
with a password, and check signatures. Those tools should appear in the Play **short
description** (max 80 characters), which is shown under the title in Play.

`docs/PROJECT_PROFILE.md` has no Play short description yet. Its "Short description (one
line)" row is the project one-liner (125 characters), too long for Play.

## Files to change

| File | Change |
|---|---|
| `docs/PROJECT_PROFILE.md` | Add a row "Google Play short description" under the store title row, with the `en-IN` and `ml-IN` texts. The existing one-line row stays as it is. |

Play Console itself is not changed by this plan. The owner types the texts into Play Console.

## Draft texts (pick one of each)

English (`en-IN`):

| # | Text | Length |
|---|---|---|
| E1 | `Read & listen to PDFs offline. Annotate, merge, split, compress, lock. No ads.` | 78 |
| E2 | `Read PDFs offline. Listen, annotate, merge, split, compress, lock & sign-check.` | 79 |
| E3 | `Read & listen to PDFs in Malayalam or English. Annotate, merge, split. No ads.` | 78 |

Malayalam (`ml-IN`):

| # | Text | Length |
|---|---|---|
| M1 | `PDF വായിക്കാം, കേൾക്കാം, കുറിപ്പെഴുതാം, ലയിപ്പിക്കാം, വിഭജിക്കാം. പരസ്യമില്ല.` | 77 |
| M2 | `PDF വായിക്കാം, ഉറക്കെ കേൾക്കാം, കുറിപ്പെഴുതാം, പേജുകൾ ക്രമീകരിക്കാം. പരസ്യമില്ല.` | 80 |

Lengths are counted as Unicode characters. Play Console shows the live count; if it
counts Malayalam differently, shorten there.

Recommendation: **E1 + M1**. E1 names the most-searched tools and the "no ads" point;
"lock" is plainer than "encrypt". E3 is a good choice if Malayalam read-aloud is the main
selling point.

Notes:
- Avoid the word "Editor": Folio cannot change the text inside a PDF, and users searching
  "PDF editor" expect that.
- No "best", "free", "#1" or emoji: Play's metadata policy does not allow them.
- "No ads" is true (ad SDKs are banned by the project rules).
- The Malayalam text should be checked by a native reader.

## Security impact

None. Documentation only.

## Checks after the change

- Read the new row in `docs/PROJECT_PROFILE.md`; no code, so no build or tests.
