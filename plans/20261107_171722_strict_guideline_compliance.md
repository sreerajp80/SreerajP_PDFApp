# Strict guideline compliance (after the October 2026 guidelines update)

**Status:** partial_completion

Follows: `plans/20261107_170203_update_guidelines_submodule.md` (submodule now at `644faee`).
Related open plans (not repeated here):
- `plans/20261107_170947_security_baseline_and_kotlin_review.md` (**draft**) — `docs/security.md`
  new sections, entry-point audit, narrow `FileProvider`, `docs/release_process.md` security items.
- `plans/20261107_171200_toolchain_upgrade_agp9_gradle9.md` (**in_progress**) — the build files
  are already changed, but the clean build, device check and change log are not done yet.

## How the audit was done

Read the guideline changes from `eb4b462` to `644faee`, then checked the app against them.
Already fine: `flutter analyze` is clean; no `package:flutter/material.dart` imports; no raw
`Text('...')` in widgets; no `AppLogger.d(`; no `print`; data layers do not use `BuildContext`;
`kReleaseMode` is used only for build mode (error widget), not as the flavor; badge keys
`madeWithLove` / `madeWithLoveA11y` use `{heart}` in all three ARB files; `.gitignore` has the
signing files and `/build/`; CI pins Flutter 3.47.6 and uses `contents: read`.

## The issues found

| # | Rule | What is wrong now |
|---|---|---|
| 1 | Standard §19.3 "What CI must not do" | `.github/workflows/ci.yml` has an `android` job that builds a release App Bundle, uploads the debug symbols as a CI artifact, and runs a size build. CI must only run checks. Its header comment still cites the old §19.2 "release build". |
| 2 | `CLAUDE_MD_GUIDELINE.md` / `AGENTS_MD_GUIDELINE.md` template | `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md` lack: workflow rule 4 (submodule is read-only), rule 5 (CI is checks only), the "Security impact" line in rule 1, and the Security Baseline lines ("follow §15.1, never weaken a control; ask first", "no secrets in code, assets or `--dart-define`"). |
| 3 | `guideline.md` §1.8 "The app name" | (a) `AppFlavorConfig.appName` writes the app name as a Dart literal; the rule is a `nameSuffix` only. It is not used anywhere, so this is a safe rename. (b) The Android launcher name comes from a `manifestPlaceholders["appLabel"]` literal in Gradle. The rule is `@string/app_name` in `res/values/strings.xml` plus `res/values-ml/` and `res/values-sa/`, with the dev suffix in the dev source set. (c) The print-service strings in `strings.xml` exist only in English. |
| 4 | `guideline.md` §1.8 "must match" | `app_config.json` `appName.en` is **"Sreeraj P PDF App"** (with a space), but the launcher, `PROJECT_PROFILE.md` and `CLAUDE.md` say **"SreerajP PDF App"**. They must be the same. |
| 5 | Standard §8.3.2 (fixed upstream, B7) | `DisplayFormat.formattingLocale` checks the raw locale name only. The rule is: `Intl.canonicalizedLocale(name)`, then the language code, then the template language. |
| 6 | Standard §20.4 | `.gitignore` does not ignore `.env` / `.env.*`. |
| 7 | Release gate (not fixable in code) | No privacy policy URL yet. `PROJECT_PROFILE.md` already records it as required before the first Play release. Only noted here. |

## Files to change

- `.github/workflows/ci.yml` — remove the `android` job; fix the header comment.
- `CLAUDE.md`, `AGENTS.md`, `.agents/AGENTS.md` — add workflow rules 4 and 5, the "Security
  impact" sentence, and the two Security Baseline lines (all three files kept in sync).
- `lib/app/config/app_flavor_config.dart` — `appName` → `nameSuffix` (`' Dev'` / `''`).
- `android/app/build.gradle.kts` — remove the two `manifestPlaceholders["appLabel"]` lines.
- `android/app/src/main/AndroidManifest.xml` — `android:label="@string/app_name"`.
- `android/app/src/main/res/values/strings.xml` — add `app_name`.
- New: `android/app/src/main/res/values-ml/strings.xml`, `.../values-sa/strings.xml` —
  `app_name` and the three print-service strings, translated.
- New: `android/app/src/dev/res/values/strings.xml`, `values-ml/`, `values-sa/` — `app_name`
  with the dev suffix.
- `assets/config/app_config.json` — make `appName.en` match the decision in question 1 below.
- `lib/core/format/display_format.dart` — canonicalize, then language code, then `en`.
- `test/core/format/display_format_test.dart` — add cases (`en_US`, `en-US`, `ml`, `sa`, bad name).
- `.gitignore` — add `.env` and `.env.*`.
- `change_log/<timestamp>_strict_guideline_compliance.md` — the change log.

No file in `docs/guidelines/` is changed.

## Plan for the fix

1. CI: delete the `android` job and fix the comment.
2. Instruction files: add the missing template rules to all three files.
3. App name: steps for issues 3 and 4 above. Malayalam and Sanskrit names are taken from the
   existing `app_config.json` values, so the OS name matches the About screen.
4. `formattingLocale`: new logic + tests.
5. `.gitignore`: add the two lines.
6. Run `dart format .`, `flutter analyze`, `flutter test`, then
   `flutter build apk --flavor dev` and check the launcher name in English, Malayalam and
   Sanskrit on a device. Then `android\gradlew --stop` and end leftover daemons.
7. Write the change log; flag the new Malayalam/Sanskrit `strings.xml` texts for native review.

## Open questions for the user

1. Which English name is right: "SreerajP PDF App" (profile, launcher) or "Sreeraj P PDF App"
   (About screen)? Default if no answer: "SreerajP PDF App".
2. Order: the toolchain plan is half done (files changed, not built). Finish it first, so a
   build failure is not mixed with these changes? Default: yes, finish it first.

**Security impact:** CI loses the release build and the symbols upload (less in CI, which is
safer). No permission, manifest security setting or storage change. `.env` ignore is stricter.

**Rollback:** revert the listed files.
