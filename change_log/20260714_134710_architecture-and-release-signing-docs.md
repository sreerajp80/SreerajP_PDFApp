# Change log — Add architecture and release-signing docs

**Date:** 2026-07-14 13:47 (local time)
**Implements plan:** [../plans/20260714_134410_architecture-and-release-signing-docs.md](../plans/20260714_134410_architecture-and-release-signing-docs.md)

## What was changed

Added the two design docs the sibling project `SreerajP_TextApp` has, so all projects follow
the same structure and guidelines.

### Files created

- `doc/architecture.md` — full technical design, mirroring TextApp's `architecture.md` layout,
  filled with PDF decisions from `PDF-Idea.md` and `pdf-app-implementation-plan.md`. Sections:
  design goals, layered architecture, open-source packages, Tier-2 `lib/` module layout, UI
  approach, feature modules, native Kotlin platform channels (PdfBox / signature / print), data
  and database migrations, Settings + About config, security architecture, non-functional
  requirements, and testing strategy.
- `doc/release-signing.md` — signed-release runbook, mirroring TextApp's `release-signing.md`,
  adapted to this app: secrets warning, build wiring expectation, keystore generation,
  `key.properties`, obfuscated build with `--split-debug-info`, verify-signature, offline
  manifest check, and backup checklist.

### Files changed

- `CLAUDE.md`:
  - Intro now points to `doc/architecture.md` as the full technical design.
  - "Where things live" tree lists `doc/architecture.md` and `doc/release-signing.md`.

### Files referenced, not modified

- `doc/PDF-Idea.md` and `doc/pdf-app-implementation-plan.md` — used as sources, left unchanged.

## Notes

- Content was summarised and cross-linked from the existing docs, not copy-pasted wholesale.
- `release-signing.md` describes the intended process; the Gradle signing wiring it expects is
  set up during Phase 0 scaffolding (no Flutter/`android/` project exists yet).
- Structure matches `SreerajP_TextApp`, per the requirement that all projects follow the same
  structure and guidelines.
