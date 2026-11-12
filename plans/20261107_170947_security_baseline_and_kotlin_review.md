# Apply the new upstream Security Baseline and AGP 9 / Kotlin notes

**Status:** draft

Follows: `plans/20261107_170203_update_guidelines_submodule.md` (the submodule now points to
`644faee`, which brings these two changes).

## The issue

The shared guidelines added two things that this app does not fully meet yet.

### A. Security Baseline for every app (engineering standard §15.1, `security.md` §1.1)

What the app already does well (checked in the code):

- No `INTERNET` permission; backups off (`allowBackup="false"`, data extraction rules).
- All `PendingIntent`s in `TtsHandler.kt` use `FLAG_IMMUTABLE`.
- `FileProvider` is not exported. `kotlin { compilerOptions { } }` is used, not `kotlinOptions`.
- The print service is exported, but only the system can bind it (`BIND_PRINT_SERVICE`).

Gaps:

1. **`docs/security.md` is missing the new sections** from the template: §1.1 Security Baseline
   checklist, §3.1 Entry Points table, the Third-Party SDKs table in §4, §7.1 Usability
   Balance, and the new items in §18. §10 does not yet list exported components,
   `PendingIntent` and `FileProvider` checks.
2. **Entry points are not recorded or fully checked.** The app takes outside input from:
   `ACTION_VIEW` (`content://` and `file://`), `ACTION_SEND` (PDF, image, text),
   `ACTION_SEND_MULTIPLE` (images), the print service, and platform channels. The baseline
   says each must check type and size before parsing. This needs an audit of
   `MainActivity.kt` and `PdfPrintService.kt` (for example: is there a size limit on shared
   text and images?).
3. **`file://` in the VIEW filters — decision: keep (user's choice).** The user wants other
   apps to be able to open files in this app directly. Note for the record: current apps send
   `content://` links, which already do this. A `file://` link comes only from old apps, and
   the app can usually not read it, because it has no storage permission (by design). So the
   fix here is: keep `file://`, but make sure an unreadable `file://` link shows the friendly
   "cannot open" message, and record this entry point in `docs/security.md` §3.1.
4. **`FileProvider` path is wide.** `file_paths.xml` shares the whole cache folder (`path="."`).
   The code only shares from `cache/opened/` and `cache/printer/`. The baseline says "as
   narrow as possible".
5. **`docs/release_process.md`** is missing the four new Security checklist items, and the
   OWASP line is now a MUST for production.

### B. AGP 9 / Gradle 9 / built-in Kotlin notes (flavors guide, "Android Toolchain Baseline")

- The app is still on **AGP 8.12.1, KGP 2.2.20, Gradle 8.14**. Flutter 3.47.6 generates
  AGP 9.1.0 / Gradle 9.3.1, so the app is behind.
- `android.builtInKotlin=false` and `android.newDsl=false` are the values Flutter wrote. The
  guide says keep them. **No change needed here.** Built-in Kotlin is an optional, separate
  migration.
- **Blocker for Gradle 9:** `android/app/build.gradle.kts` uses `project.exec { }` (two calls
  in the `generateBuildMetadata` task). Gradle 9 removed it. It must use an injected
  `ExecOperations`. This change also works on Gradle 8, so it can be done now, safely.

## Files to change

- `docs/security.md` — add §1.1, §3.1, §4 SDK table (none), §7.1, §10 and §18 items.
- `docs/release_process.md` — add the new Security checklist items.
- `android/app/src/main/res/xml/file_paths.xml` — narrow to `opened/` and `printer/`.
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` — add type/size checks
  only where the audit finds them missing.
- `change_log/<timestamp>_security_baseline_and_kotlin_review.md` — the change log.

No file inside `docs/guidelines/` (submodule) is changed.

## Plan for the fix

1. Audit the entry points (A.2) and write the results into the new `docs/security.md` §3.1.
2. Fill `docs/security.md` §1.1 with `verified` / `n/a` and a short reason for each row.
3. Add the missing small code fixes found by the audit (size limits, friendly error for an
   unreadable `file://` link, FileProvider).
4. (Moved) The `project.exec` → `ExecOperations` change is now part of
   `plans/20261107_171200_toolchain_upgrade_agp9_gradle9.md`.
5. Update `docs/release_process.md` checklist.
6. Run `flutter analyze`, `flutter test`, a clean `flutter build apk --flavor dev`, and test
   "Open with", share-in, and print-to-PDF on a device. Then `android\gradlew --stop`.
7. Write the change log.

**Out of scope:** the AGP 9 / Gradle 9 upgrade has its own plan
(`plans/20261107_171200_toolchain_upgrade_agp9_gradle9.md`). Turning on built-in Kotlin is not
planned.

**Security impact:** makes the app stricter (smaller FileProvider scope, checked input). No
control is weakened. `file://` stays accepted by the user's choice; it is recorded as an entry
point and must fail safely.
