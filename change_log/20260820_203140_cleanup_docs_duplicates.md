# Change Log: Cleanup Duplicate and Redundant Files in `docs/`

**Plan:** [plans/20260820_203000_cleanup_docs_duplicates.md](../plans/20260820_203000_cleanup_docs_duplicates.md)
**Status:** Completed
**Date:** 2026-08-20

---

## 1. Summary of Changes

Cleaned up duplicate, obsolete, and non-standard documentation files in the `docs/` folder to adhere to `DOCS_FOLDER_GUIDELINE.md` and `AGENTS.md`. Consolidated implementation plans and progress tracking into canonical `snake_case` filenames, and updated references across the project.

---

## 2. File Operations

### Removed Duplicate / Obsolete Files:
- `docs/workflow-rules.md` (redundant duplicate of `docs/workflow_rules.md`)
- `docs/security-rules.md` (redundant duplicate of `docs/security.md`)
- `docs/release-signing.md` (redundant duplicate of `docs/release_process.md`)
- `docs/pdf-app-implementation-plan.md` (consolidated into `docs/implementation_plan.md`)
- `docs/pdf-app-implementation-progress.md` (consolidated into `docs/implementation_progress.md`)
- `docs/PDF-Idea.md` (renamed to `docs/pdf_idea.md`)

### Created / Renamed Files:
- `docs/pdf_idea.md` (standard snake_case concept document)

### Consolidated & Updated Documentation:
- `docs/implementation_plan.md`: Expanded with the comprehensive 8-phase implementation roadmap.
- `docs/implementation_progress.md`: Expanded with full phase status tracking, test counts, and notes.
- `docs/architecture.md`: Updated cross-links to point to `security.md`, `release_process.md`, `implementation_plan.md`, `implementation_progress.md`, and `pdf_idea.md`.

### Project Cross-Reference Updates:
- `android/app/build.gradle.kts`: Updated signing instructions link from `docs/release-signing.md` to `docs/release_process.md`.
- `lib/features/signature/domain/signature_trust_evaluator.dart`: Updated doc comment reference to `docs/security.md`.
- `lib/features/signature/domain/signature_status.dart`: Updated doc comment reference to `docs/security.md`.
- `lib/features/signature/data/eutl_trust_list.dart`: Updated doc comment reference to `docs/security.md`.

---

## 3. Verification Results

- `flutter analyze`: Completed with 0 issues.
- `flutter test`: 100% passing (all 390 unit and widget tests).
- Active codebase and documentation checked for broken references.
