# Change log: update the shared guidelines submodule

Implements plan: [plans/20261005_195627_update_guidelines_submodule.md](../plans/20261005_195627_update_guidelines_submodule.md)

## What changed

- `docs/guidelines` (submodule) moved from `eb4b462` to `519e7f3`, the latest upstream
  `master`. The submodule's local `master` branch was fast-forwarded to match.
- The new guideline commits bring the Flutter 3.47 toolchain update, the "latest stable
  versions" rule, generic and multi-platform guidelines (with new files such as
  `AI_AGENT_START_HERE.md`, `PROJECT_PROFILE_TEMPLATE.md`, a profile example, a
  Sanskrit/Malayalam language pack, and `platform_store_readiness.md`), clarity fixes, and
  new glossary terms.

## Checks

- `git submodule status` shows `519e7f3`.
- All 16 links from this project's docs into `docs/guidelines/` still point to existing
  files.

## Not changed

- This project's own doc copies in `docs/` stay as they are (the local copy wins).
- Nothing was committed.
