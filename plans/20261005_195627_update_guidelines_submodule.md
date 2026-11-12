# Update the shared guidelines submodule

**Status:** completed

## The issue

`docs/guidelines` is a Git submodule. It points to the shared Flutter guidelines repository.
It is pinned at commit `eb4b462`. The upstream `master` branch is now at `519e7f3`, four
commits newer (21 September to 2 October 2026).

What the new commits bring (only additions and edits; no files are removed or renamed):

- An update to the Flutter 3.47 toolchain. This matches the package upgrade just done in this
  project.
- The rule "use the latest stable versions, not pinned old ones".
- The guidelines are made generic and multi-platform. New files: `AI_AGENT_START_HERE.md`,
  `PROJECT_PROFILE_TEMPLATE.md`, `profiles/example_en_ml_sa_profile.md`,
  `language_packs/sanskrit_malayalam.md`, `platform_store_readiness.md`.
- Clarity fixes across the engineering standard, security, release process, and build
  flavors guides.
- New glossary terms (Contact, Call, Tag, Phone number).

## Files to change

| File | Change |
|---|---|
| `docs/guidelines` (submodule pointer) | `eb4b462` → `519e7f3` |

Nothing else changes. All 16 links from this project's docs into `docs/guidelines/` still point
to files that exist in the new version (checked).

## The fix

1. `git -C docs/guidelines checkout 519e7f3` (the current upstream `master`).
2. Check that `git submodule status` shows the new commit and that the links still work.
3. Write the change log.

## What is not changed

- This project's own copies in `docs/` (`GUIDELINES_MANIFEST.md`, `architecture.md`,
  `security.md`, `release_process.md`) are already project-specific and differ from the
  upstream files. Under `CLAUDE.md`, the local copy wins, so they stay as they are.
- The new upstream ideas (for example a project profile file) are not adopted here. That would
  be a separate plan if wanted.
- Nothing is committed unless the user asks.
