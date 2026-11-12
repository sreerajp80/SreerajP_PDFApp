# Change log: update the shared guidelines submodule (October 2026 changes)

Implements: `plans/20261107_170203_update_guidelines_submodule.md`

## What changed

| File | Change |
|---|---|
| `docs/guidelines` (submodule pointer) | `519e7f3` → `644faee` (the current upstream `master`) |

- The submodule's local `master` branch was fast-forwarded to `origin/master`, so it is on a
  branch, not a detached HEAD.
- `git submodule status` shows `644faee`.
- The parent repository still records `eb4b462` until the pointer change is committed.

## What the new upstream commits bring

Seven commits (12 to 27 October 2026), only additions and edits:

- The submodule is made strictly read-only for projects.
- Built-in Kotlin notes for Flutter 3.47+ and AGP 9+.
- An "agent intake" step for new projects.
- A security baseline for every app; privacy policy URL and About badge clarified.
- Two review passes fixing conflicts, errors and gaps across the guides.
- Dependabot removed from the CI advice.

## Checks

- All 20 files this project's docs link to inside `docs/guidelines/` exist in `644faee`.
- Engineering standard sections quoted in `CLAUDE.md` / `AGENTS.md` (6.1, 7.8, 8.3.2) keep the
  same numbers and titles.

## Not changed

- No file inside `docs/guidelines/` was edited.
- No project docs or code were changed. Nothing was committed.
- Follow-up idea (not done): review whether the new security baseline and Kotlin notes need
  changes in this app.
