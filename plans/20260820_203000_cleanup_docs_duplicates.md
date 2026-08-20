# Cleanup Duplicate and Redundant Files in `docs/`

**Status:** completed

This plan outlines the cleanup of duplicate, obsolete, and non-standard documentation files in the `docs/` folder to adhere to `DOCS_FOLDER_GUIDELINE.md` and `AGENTS.md`.

---

## 1. Issue Description

The `docs/` folder contains several duplicate and predecessor files that cause confusion and redundancy:
1. `docs/workflow-rules.md` is a duplicate of `docs/workflow_rules.md` (the latter is snake_case, referenced in AGENTS.md, and contains the privacy rules section).
2. `docs/security-rules.md` is an older summary duplicate of `docs/security.md` (the latter is the complete security engineering blueprint).
3. `docs/release-signing.md` is an older duplicate of `docs/release_process.md` (the latter is the complete release guide).
4. `docs/pdf-app-implementation-plan.md` and `docs/implementation_plan.md` are duplicate plans (the latter is standard naming, but currently short; we will consolidate the full detailed plan into `docs/implementation_plan.md`).
5. `docs/pdf-app-implementation-progress.md` and `docs/implementation_progress.md` are duplicate trackers (the latter is standard naming; we will consolidate the full progress details into `docs/implementation_progress.md`).
6. `docs/PDF-Idea.md` uses non-standard casing (`PDF-Idea.md` vs snake_case `pdf_idea.md`).

Additionally, several project files still contain references pointing to the old hyphenated document names.

---

## 2. Proposed Changes

### Documentation File Cleanup
1. **Delete Duplicate Files**:
   - Delete `docs/workflow-rules.md` (superseded by `docs/workflow_rules.md`).
   - Delete `docs/security-rules.md` (superseded by `docs/security.md`).
   - Delete `docs/release-signing.md` (superseded by `docs/release_process.md`).
   - Delete `docs/pdf-app-implementation-plan.md` (consolidated into `docs/implementation_plan.md`).
   - Delete `docs/pdf-app-implementation-progress.md` (consolidated into `docs/implementation_progress.md`).
   - Rename `docs/PDF-Idea.md` -> `docs/pdf_idea.md` to match snake_case naming standard.

2. **Consolidate Standard Docs**:
   - Update `docs/implementation_plan.md` with the comprehensive phase-by-phase implementation plan.
   - Update `docs/implementation_progress.md` with the full phase status checklist and implementation notes.

3. **Update Cross-References**:
   - `docs/architecture.md`: Update markdown links to point to `security.md`, `release_process.md`, `implementation_plan.md`, `implementation_progress.md`, and `pdf_idea.md`.
   - `android/app/build.gradle.kts`: Update warning log link from `docs/release-signing.md` to `docs/release_process.md`.
   - `lib/features/signature/domain/signature_trust_evaluator.dart`: Update doc comment reference from `docs/security-rules.md` to `docs/security.md`.
   - `lib/features/signature/domain/signature_status.dart`: Update doc comment reference from `docs/security-rules.md` to `docs/security.md`.
   - `lib/features/signature/data/eutl_trust_list.dart`: Update doc comment reference from `docs/security-rules.md` to `docs/security.md`.

---

## 3. Files to Modify / Delete

| File | Action | Purpose |
|---|---|---|
| `docs/workflow-rules.md` | Delete | Redundant duplicate of `workflow_rules.md` |
| `docs/security-rules.md` | Delete | Redundant duplicate of `security.md` |
| `docs/release-signing.md` | Delete | Redundant duplicate of `release_process.md` |
| `docs/pdf-app-implementation-plan.md` | Delete | Consolidated into `implementation_plan.md` |
| `docs/pdf-app-implementation-progress.md` | Delete | Consolidated into `implementation_progress.md` |
| `docs/PDF-Idea.md` | Delete / Move | Renamed to `docs/pdf_idea.md` |
| `docs/pdf_idea.md` | Create / Move | Standard snake_case concept doc |
| `docs/implementation_plan.md` | Modify | Full consolidated phase build plan |
| `docs/implementation_progress.md` | Modify | Full consolidated progress checklist |
| `docs/architecture.md` | Modify | Update links to consolidated and renamed docs |
| `android/app/build.gradle.kts` | Modify | Update release doc link |
| `lib/features/signature/domain/signature_trust_evaluator.dart` | Modify | Update doc comment reference |
| `lib/features/signature/domain/signature_status.dart` | Modify | Update doc comment reference |
| `lib/features/signature/data/eutl_trust_list.dart` | Modify | Update doc comment reference |

---

## 4. Verification Plan

1. **Static Analysis & Tests**:
   - Run `flutter analyze` to ensure zero analysis errors.
   - Run `flutter test` to verify all 384 tests pass.
2. **Grep Search**:
   - Verify no broken references or remaining pointers to deleted doc filenames exist in active code and active docs.
