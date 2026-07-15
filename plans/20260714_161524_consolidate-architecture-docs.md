# Plan — Consolidate the two architecture.md files into one

**Status:** completed

## The issue

The project has **two** `architecture.md` files, in two different folders:

- `doc/architecture.md` — the **full technical design blueprint**. 12 sections, ~360 lines.
  Covers design goals, layered architecture, the open-source package table, the full
  feature-first module layout, every feature module (viewer, reading, extraction, page-ops,
  annotation, printer, signature), the complex-script (Malayalam/Sanskrit) search design,
  platform channels, database schema (v1–v4), settings + About config, security architecture,
  non-functional requirements, and the testing strategy. CLAUDE.md calls this "the full
  technical design".
- `docs/architecture.md` — the **engineering-standard architecture record**. ~100 lines.
  A concise, current-state record that maps to `flutter_project_engineering_standard.md §21`.
  It holds a few things the big design doc does **not**: the applicability profiles in force,
  the detailed `main()` initialization sequence, the "current schema version = 1" statement,
  concrete build facts (Java 17, AGP 8.x, Gradle 8.14, Impeller, dev/prod flavors), and a
  "known risks / follow-ups" list. README.md points here.

They are **not** simple duplicates — they overlap in structure but each carries content the
other lacks. The wider effort is to move everything from `doc/` into `docs/` (the user is doing
that move). When the move happens, these two files collide. This plan resolves that collision by
merging them into **one** file: `docs/architecture.md`.

## Scope note

- The user is moving all other `doc/` files into `docs/` themselves. This plan only consolidates
  the two `architecture.md` files. It does **not** move the other docs.
- Cross-references (`CLAUDE.md`, `README.md`) will need path fixes as part of the wider `doc/`→
  `docs/` move. This plan updates only the links **inside** the consolidated file. It leaves the
  `doc/`→`docs/` link fixes in the other files for the wider move, to avoid stepping on that work.

## Files to be changed

| File | Action | What |
|---|---|---|
| `docs/architecture.md` | rewrite | Replace with the consolidated document: the full design blueprint (base) with the engineering-record's unique current-state content folded in. |
| `doc/architecture.md` | delete | Content is merged into `docs/architecture.md`; removing it prevents the folder-move collision. |
| `change_log/…` | create | Change-log entry after implementation (per workflow rules). |

## The plan for the merge

Use the **full design blueprint** (`doc/architecture.md`) as the base — it is the more complete
document — and fold in the engineering-record content that it is missing:

1. **Intro** — keep the design-doc intro. Add one line naming this file as the
   engineering-standard architecture record (`flutter_project_engineering_standard.md §21`), and
   the **applicability profiles in force** (Core Baseline + Production App Extension + selected
   Sensitive Data controls) from the `docs/` file. Fix the sibling-doc links to point within the
   same `docs/` folder (e.g. `PDF-Idea.md`, `pdf-app-implementation-plan.md`) instead of `../doc/`.
2. **Initialization sequence** — add a new short section with the detailed `main()` order (binding
   → error boundaries → logger → db → config → lifecycle → runApp) from the `docs/` file. The
   design doc does not have this.
3. **Database** — keep the design doc's schema table (v1–v4). Add the engineering record's
   "current schema version = 1; v2/v3/v4 planned in Phases 1/5/7" note so the doc states what is
   built now vs. planned.
4. **State / navigation / theming** — the design doc already covers these; fold in the concrete
   detail from the `docs/` file (root providers overridden in `main()`, `AppRoute` enum,
   `AppThemeMode`) where it adds value, without duplicating.
5. **Platform / build** — add the concrete build facts (Android only, minSdk 26, Java 17, AGP 8.x,
   Gradle 8.14, Impeller, dev/prod flavors, no `INTERNET` permission) as a short section.
6. **Known risks / follow-ups** — add the engineering record's list (release signing in Phase 8,
   log rotation not yet implemented, 16 KB page-size compliance to verify) as a closing section.
7. Keep everything else from the design doc as-is (feature modules, complex-script search,
   security architecture, NFRs, testing strategy).

Result: one `docs/architecture.md` that is both the full design blueprint and the engineering
record, with no loss of content from either source.

## What this does NOT change

- No source code changes.
- No moving of other `doc/` files (user does that).
- No edits to `CLAUDE.md` / `README.md` link paths (left for the wider move).

## Verify

- Read the merged `docs/architecture.md` end to end; confirm every unique fact from **both**
  originals is present.
- Confirm `doc/architecture.md` is deleted.
- Confirm no internal link in the merged file still points at `../doc/`.
