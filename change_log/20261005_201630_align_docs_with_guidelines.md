# Change Log — Align project documents with the shared guidelines

**Date:** 2026-10-05
**Plan:** [plans/20261005_200520_align_docs_with_guidelines.md](../plans/20261005_200520_align_docs_with_guidelines.md)

---

## 1. Summary

The project's own documents now follow the updated shared guidelines in `docs/guidelines/`
(AI agent start page, manifest, docs-folder guideline, CLAUDE.md / AGENTS.md guidelines, project
profile template, the architecture / security / release templates, and the Sanskrit–Malayalam
language pack). Only documents changed. No code, build, or test file was touched, and the
`docs/guidelines/` submodule was not edited.

---

## 2. Files changed

| File | Change |
|---|---|
| `docs/GUIDELINES_MANIFEST.md` | Replaced with an exact copy of `docs/guidelines/GUIDELINES_MANIFEST.md` (G1) |
| `docs/PROJECT_PROFILE.md` | **New.** Identity, profiles (all three), Android-only platform with Google Play + direct APK, languages `en`/`ml`/`sa` with the language pack, About options, optional values (G2) |
| `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md` | Added Stores and Languages rows and pinned Flutter/Dart versions; extended the docs table (profile, AI start page, engineering standard, `guideline.md`, flavors guide, store readiness, language pack); full localization rules (parity, `@key`, language pack, `sa` fallback delegates, `DisplayFormat`, language picker, short labels, tooltips, `material_ui`, About badge); `build/` gitignore rule; per-version symbols folder; store-readiness pointer. The three files now hold the same rules (G3–G7) |
| All `docs/*.md` project files | "Read first" links now point to `../CLAUDE.md` and `../AGENTS.md` (G8) |
| `docs/implementation_plan.md`, `docs/implementation_progress.md`, `docs/feature_analysis_and_roadmap.md` | `**Date:**` block moved under the purpose paragraph (G9) |
| `docs/security.md` | Re-shaped to the full 18-section template: storage model, auth, binary protections, logging policy, platform controls, permissions, OWASP table, data retention and purge, backup/import/export, testing, incident response, open risks, review checklist. Sensitive Data Extension now stated as in force (G10, G13) |
| `docs/release_process.md` | Re-shaped to the full template for Android only: release scope, roles, versioning, branch policy, flavor matrix, hardening checks, signing, release checklist, Android steps (bash + PowerShell), distribution channels, rollback, evidence, post-release checks, and an "open release items" list (G11) |
| `docs/architecture.md` | Re-ordered into the template's 22 sections. All old content kept or moved; added lifecycle, offline, state, data flow, error table, domain model, DI, navigation, build model, decisions, related docs (G12, G13) |
| `docs/project_structure.md` | Tree now lists `PROJECT_PROFILE.md` and `GUIDELINES_MANIFEST.md` |

---

## 3. Facts corrected while re-shaping

These old statements no longer matched the code and were fixed:

- `architecture.md` listed `file_picker`, `share_plus` and `flutter_secure_storage` as packages.
  None is a dependency; file access and sharing go through the native channel.
- `architecture.md` said NFC uses the device ICU; the code uses `unorm_dart` (as `pubspec.yaml`
  already explains).
- `architecture.md` said the Adobe AATL list is bundled; only the EU trusted list is
  (`assets/trust/eutl_certificates.pem`).
- `architecture.md` said the system print service was dropped; `PdfPrintService` now exists as a
  virtual "Save as PDF" destination.
- `architecture.md` listed only `en` and `ml` locales; `sa` is also supported.
- During this work I first recorded the About signature badge as "off". The code shows it
  (`MadeWithLove` on the About screen), so the profile and rule files say **on**.

---

## 4. Deviations from the plan

- G13 also listed `docs/implementation_plan.md` for the "selected Sensitive Data controls"
  wording. That file is a point-in-time record, and the docs guideline says such records are not
  rewritten later, so its §11 heading was left as it was.
- `pubspec.yaml` has a comment that mentions "architecture.md §6.1". That section is now §3.2.
  The comment was not changed, because this plan covers only documents.

---

## 5. Open items recorded (need their own plans)

These are code or setup gaps. They are now listed in `docs/security.md` §17,
`docs/release_process.md` §16 and `docs/architecture.md` §21:

1. `android:allowBackup` is not set (Android treats it as `true`). This blocks the first Google
   Play release.
2. Copies of opened PDFs in `cache/opened/` are not deleted when the reader closes.
3. There is no single "Delete all data" action.
4. App Bundle language splitting is not turned off in Gradle.
5. There is no privacy policy URL yet. Google Play requires one.
6. The code imports `package:flutter/material.dart` instead of `material_ui`.
7. `features_screen.dart` has raw English strings in widgets.
8. There is no CI, no automated offline test, and no `test/fixtures/` PDF set.

---

## 6. Verification

- Every relative link in `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md` and `docs/*.md` was
  checked by a script: 0 broken links.
- `docs/GUIDELINES_MANIFEST.md` is byte-for-byte equal to the submodule copy.
- `CLAUDE.md` and `AGENTS.md` differ only in their title, intro line, tree comments, and the
  "Claude" vs "AI agents" heading. `.agents/AGENTS.md` differs from `AGENTS.md` only in its
  `../` link prefixes.
- `flutter analyze`: no issues found.
- This plan and change log contain only relative paths and no local system details.
