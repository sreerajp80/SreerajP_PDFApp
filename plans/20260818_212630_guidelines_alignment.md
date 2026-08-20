# Plan: Ensure Project Structure, Docs, and Code Align with Guidelines

**Status:** completed

## Issue

The project needs to be audited and updated to ensure full compliance with the shared Flutter guidelines in `docs/guidelines/`:
1. `AGENTS.md`, `CLAUDE.md`, and `.agents/AGENTS.md` are using an older format and lack the mandatory standard sections defined in `AGENTS_MD_GUIDELINE.md` and `CLAUDE_MD_GUIDELINE.md` (such as the Project Identity table, Doc references table, Localization rules, Code style/naming, Testing rules, Dependency constraints, Dos & Don'ts, and detailed Privacy/Relative path workflow rules).
2. The `docs/` folder is missing some of the mandatory baseline living documents specified in `DOCS_FOLDER_GUIDELINE.md` §6:
   - `docs/dependencies.md` (Living — package catalog with open-source licenses and blocked list)
   - `docs/project_structure.md` (Living — detailed file tree and responsibility boundaries)
   - Standardized naming for `docs/release_process.md` and `docs/workflow_rules.md` (standardizing from kebab-case).
   - Standardized naming/aliases for `docs/implementation_plan.md` and `docs/implementation_progress.md`.
3. Verify that code and project configuration continue to conform to `guideline.md` (§1 About-screen constants, §2 Keystore rules, §3 `lib/` layout), passing all tests and static analysis.

## Proposed Changes

### 1. Root and Agent Instruction Files
- **`CLAUDE.md`**, **`AGENTS.md`**, and **`.agents/AGENTS.md`**:
  - Update to the canonical Thin Profile structure matching `CLAUDE_MD_GUIDELINE.md` and `AGENTS_MD_GUIDELINE.md`:
    - Title & read-first banner
    - Project Identity table
    - Doc references table pointing to `docs/`
    - Hard rules (1 to 7)
    - Architecture rules (Tier 2 Feature-First structure)
    - Build & run commands
    - Signing / keystore rules
    - Security rules
    - Localization rules
    - Code style & naming conventions
    - Testing rules
    - Dependency constraints (approved open source + blocked list)
    - Where things live (project directory tree)
    - Workflow rules (plan -> approve -> log with relative paths & privacy requirements)
    - Communication rules (simple English)
    - Dos & Don'ts table

### 2. Documentation Suite (`docs/`)
- **`docs/dependencies.md`** (NEW):
  - Document all runtime and dev dependencies, their licenses (MIT, BSD, Apache 2.0), their purpose, and explicit blocked dependency list (proprietary SDKs, cloud SDKs, ads, tracking).
- **`docs/project_structure.md`** (NEW):
  - Document the Tier 2 Feature-First structure, directory responsibilities (`app/`, `core/`, `features/`, `l10n/`), and architectural boundaries.
- **`docs/release_process.md`** (NEW / Standardized):
  - Align with `release-signing.md` / `release_process.md` standards for building, signing, verifying, and distributing releases.
- **`docs/workflow_rules.md`** (NEW / Standardized):
  - Standardized snake_case living document for workflow rules (plan -> approve -> log).
- **`docs/implementation_plan.md`** & **`docs/implementation_progress.md`**:
  - Ensure standard named point-in-time files exist matching `DOCS_FOLDER_GUIDELINE.md`.

### 3. Verification
- Run `flutter analyze` to ensure 0 lint warnings.
- Run `flutter test` to ensure all 308 tests pass.
- Run `dart format .` to maintain code formatting standards.

## Files to Change / Create

- `CLAUDE.md` [MODIFY]
- `AGENTS.md` [MODIFY]
- `.agents/AGENTS.md` [MODIFY]
- `docs/dependencies.md` [NEW]
- `docs/project_structure.md` [NEW]
- `docs/release_process.md` [NEW]
- `docs/workflow_rules.md` [NEW]
- `docs/implementation_plan.md` [NEW]
- `docs/implementation_progress.md` [NEW]

---

**Approval Gate:**
We will pause here and await your explicit approval before modifying or creating any of the project files.
