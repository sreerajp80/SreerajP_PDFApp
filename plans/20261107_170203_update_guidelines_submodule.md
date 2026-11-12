# Update the shared guidelines submodule (October 2026 changes)

**Status:** completed

## The issue

`docs/guidelines` is a Git submodule. It points to the shared Flutter guidelines repository.

- The parent repository still records commit `eb4b462`.
- The submodule folder is already checked out at `519e7f3` (done by the plan
  `plans/20261005_195627_update_guidelines_submodule.md`), but that pointer change is not yet
  committed in the parent.
- The upstream `master` branch is now at `644faee`, seven commits newer than `519e7f3`
  (12 to 27 October 2026).

What the seven new commits bring (only additions and edits; no files are removed or renamed):

- The submodule is made strictly read-only for projects (matches this project's rule).
- Built-in Kotlin notes for Flutter 3.47+ and AGP 9+.
- An "agent intake" step for new projects.
- A security baseline for every app; privacy policy URL and About badge clarified.
- Two review passes that fix conflicts, errors and gaps across the engineering standard,
  build flavors guide, release process, security, store readiness and the language pack.
- Removal of Dependabot from the CI advice.
- The guidelines repository's own `plans/` and `change_log/` files for the above.

## Files to change

| File | Change |
|---|---|
| `docs/guidelines` (submodule pointer) | `519e7f3` → `644faee` (parent still records `eb4b462`) |

Nothing else changes. Checked before writing this plan:

- All 20 files that this project's docs link to inside `docs/guidelines/` still exist in
  `644faee`.
- The engineering standard sections quoted in `CLAUDE.md` / `AGENTS.md` (6.1, 7.8, 8.3.2) keep
  the same numbers and titles.

## The fix

1. `git -C docs/guidelines checkout 644faee` (the current upstream `master`; a fast-forward).
2. Check that `git submodule status` shows the new commit.
3. Write the change log.

## What is not changed

- No file inside `docs/guidelines/` is edited.
- This project's own copies in `docs/` are not changed. Whether the new upstream rules (for
  example the security baseline or Kotlin notes) need changes in this app would be a separate
  review and plan, if wanted.
- Nothing is committed unless the user asks.
