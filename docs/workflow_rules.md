# Workflow Rules — Folio

This document details the mandatory workflow rules for modifying the Folio app codebase. Read this before proposing or making any changes to the project.

> Read first: [../CLAUDE.md](../CLAUDE.md) and [../AGENTS.md](../AGENTS.md) for project rules, and [guidelines/flutter_project_engineering_standard.md](guidelines/flutter_project_engineering_standard.md) for the engineering standard.

---

## 1. Plan Before Changing

Before making any source or documentation changes:
1. Create a plan file under `plans/` named `yyyymmdd_hhMMss_<short-slug>.md` (local date/time prefix).
2. The plan must include:
   - `**Status:**` header (`draft`, `approval_pending`, `in_progress`, `completed`, `dropped`, or `partial_completion`).
   - Issue description.
   - Proposed fix and architectural details.
   - Complete list of files to be created, modified, or deleted.
   - A short **"Security impact"** line if the plan touches network, storage, sign-in,
     permissions, deep links, WebViews, platform folders or dependencies (engineering standard §22.2).

### Approval Gate (Mandatory)
- After writing the plan, **STOP**.
- Do not modify, create, or delete any project files (other than the plan file itself) until the user gives explicit approval.
- Proceed only upon receiving an explicit confirmation (e.g., "Approved", "Go ahead", "Yes").

---

## 2. Log After Changing

After implementing the approved plan:
1. Create a change log file under `change_log/` named `yyyymmdd_hhMMss_<short-slug>.md`.
2. Detail all files modified/created, summary of changes, and reference the corresponding plan file.
3. Update the corresponding plan's status to `completed`.

---

## 3. Relative Paths & Privacy Rules

`plans/` and `change_log/` are committed to the repository and may become public:
- **Relative Paths Only**: MUST use relative repository paths (e.g. `lib/main.dart`), never absolute OS paths (`C:\...`, `l:\...`, `file:///...`).
- **No Local System Details**: MUST NOT contain username, hostname, machine names, IP addresses, local port URLs, device serials, or personal emails.
- **No Secrets**: MUST NOT contain passwords, API keys, keystore passphrases, or tokens.

---

## 4. The Guidelines Submodule Is Read-Only

`docs/guidelines/` is a shared Git submodule. Never edit, pull, check out or commit the submodule
or its version from this project. If a guideline needs a change, write a note for the user
instead (`guidelines/DOCS_FOLDER_GUIDELINE.md` §1.1). If the folder is empty or missing, stop and
ask the user.

---

## 5. CI Is Checks Only

GitHub CI runs only `flutter pub get`, code generation (if used), the format check,
`flutter analyze`, `flutter test`, and other pass/fail check scripts. No Dependabot or other
update bot: dependencies are updated by hand. CI never builds release artifacts, signs, holds
signing secrets, uploads, or publishes. Release builds are done locally
(`guidelines/flutter_project_engineering_standard.md` §19).
