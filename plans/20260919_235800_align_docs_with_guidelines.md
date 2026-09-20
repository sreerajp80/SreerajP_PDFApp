# Plan: Align Project Documentation with Guidelines

**Status:** completed

## Issue Description

The documentation files in `docs/` have minor deviations from the project guidelines defined in `docs/guidelines/DOCS_FOLDER_GUIDELINE.md`, `docs/guidelines/architecture.md`, `docs/guidelines/security.md`, and `docs/guidelines/release_process.md`:
1. **Title Inconsistencies**: Several files use `SreerajP_PDFApp` instead of the canonical display name `SreerajP PDF App` in their `# H1` title.
2. **Missing Standard Anatomy Elements**: Several documents lack the mandatory "Read first" links block with relative links up to `../.agents/AGENTS.md` / `../CLAUDE.md` and sideways/submodule links.
3. **Unnumbered Sections**: `docs/pdf_idea.md` and `docs/implementation_progress.md` have unnumbered `##` section headings rather than following the numbered section convention (`## 1.`, `## 2.`, ...). `docs/pdf_idea.md` also lacks a purpose paragraph directly below the `# H1` title.
4. **Missing Production Flavor in Release Commands**: `docs/release_process.md` lists build commands without `--flavor prod`, which causes Gradle builds to fail because flavors are configured.
5. **Absolute System Path**: `docs/feature_analysis_and_roadmap.md` contains an absolute drive-letter path reference (`L:\...`), violating the relative-paths-only privacy rule.
6. **Outdated Layout in Project Structure**: `docs/project_structure.md` is missing `lib/app/app.dart` from the source code layout.
7. **Security Blueprint Alignment**: `docs/security.md` is missing an explicit `## 2. Security Objectives` section from the standard security blueprint template.

## Proposed Changes

### Documentation Files in `docs/`

#### 1. `docs/workflow_rules.md`
- Update title to `# Workflow Rules — SreerajP PDF App`.
- Add "Read first" links to `../.agents/AGENTS.md`, `../CLAUDE.md`, and `guidelines/flutter_project_engineering_standard.md`.

#### 2. `docs/project_structure.md`
- Update title to `# Project Structure — SreerajP PDF App`.
- Add "Read first" links to `../.agents/AGENTS.md`, `../CLAUDE.md`, `architecture.md`, and `guidelines/guideline.md`.
- Add `lib/app/app.dart` to the `lib/app/` directory tree in §2.

#### 3. `docs/dependencies.md`
- Update title to `# Dependencies — SreerajP PDF App`.
- Add "Read first" links to `../.agents/AGENTS.md`, `../CLAUDE.md`, `architecture.md`, and `guidelines/flutter_project_engineering_standard.md`.

#### 4. `docs/release_process.md`
- Update title to `# Release Process — SreerajP PDF App`.
- Add "Read first" links to `../.agents/AGENTS.md`, `../CLAUDE.md`, `security.md`, and `guidelines/release_process.md`.
- Update build commands to include `--flavor prod` (e.g. `flutter build appbundle --flavor prod --release --obfuscate --split-debug-info=build/symbols/android-prod/` and `flutter build apk --flavor prod --release --obfuscate --split-debug-info=build/symbols/android-prod/ --split-per-abi`).
- Provide both PowerShell and bash commands.

#### 5. `docs/security.md`
- Update title to `# Security — SreerajP PDF App`.
- Add "Read first" links to `../.agents/AGENTS.md`, `../CLAUDE.md`, `architecture.md`, and `guidelines/security.md`.
- Add `## 2. Security Objectives` section matching the security blueprint template, and renumber subsequent sections accordingly.

#### 6. `docs/architecture.md`
- Update title to `# Architecture — SreerajP PDF App`.
- Ensure "Read first" links include `../.agents/AGENTS.md`, `../CLAUDE.md`, `pdf_idea.md`, `implementation_plan.md`, `features.md`, and `guidelines/architecture.md`.

#### 7. `docs/pdf_idea.md`
- Update title to `# Product Idea & Concepts — SreerajP PDF App`.
- Add purpose paragraph directly under the title.
- Add "Read first" links to `../.agents/AGENTS.md`, `../CLAUDE.md`, `architecture.md`, and `features.md`.
- Number all main `##` sections (`## 1. Core Product Concept`, `## 2. Development Tool Requirements`, `## 3. Licensing Constraints`, `## 4. Shared Capabilities`, `## 5. Core Feature Domains`, `## 6. Risks & Hard Features`, `## 7. Open-Source Library Decisions`, `## 8. Non-Functional Requirements`) and separate blocks with `---`.

#### 8. `docs/implementation_plan.md`
- Update title to `# Implementation Plan — SreerajP PDF App`.
- Add `../.agents/AGENTS.md` and `../CLAUDE.md` to "Read first" links.

#### 9. `docs/implementation_progress.md`
- Update title to `# Implementation Progress — SreerajP PDF App`.
- Add `../.agents/AGENTS.md` and `../CLAUDE.md` to "Read first" links.
- Number all main `##` sections (`## 1. Overall Status`, `## 2. Phase 0 — Scaffolding & Foundation`, ..., `## 11. Change-Log Links`) and separate blocks with `---`.

#### 10. `docs/features.md`
- Add `../.agents/AGENTS.md` to "Read first" links.

#### 11. `docs/feature_analysis_and_roadmap.md`
- Add `../.agents/AGENTS.md` to "Read first" links.
- Remove absolute path reference `L:\Android\MyFlutterApps\myapps.md` and replace with relative reference `myapps.md`.

### Files Kept Untouched (As required by `DOCS_FOLDER_GUIDELINE.md` §1)
- `docs/GUIDELINES_MANIFEST.md` (shared portable pointer file, copied in unchanged)
- `docs/guidelines/*` (shared Git submodule, never edited from within a project)

## Verification Plan

### Automated Verification
- Run static checks and search for any remaining absolute paths or formatting discrepancies:
  ```powershell
  rg "[a-zA-Z]:\\\\" docs/
  ```
  Ensure 0 matches in project documentation files.

### Manual Review
- Verify that every document in `docs/` satisfies:
  1. `# H1` title with `— SreerajP PDF App`.
  2. Purpose paragraph directly under title.
  3. "Read first" links with relative paths.
  4. Numbered `##` sections separated by `---`.
  5. Simple English throughout.
  6. Living docs have no date line; point-in-time docs have `**Date:**`.
  7. No absolute paths or local system details.
