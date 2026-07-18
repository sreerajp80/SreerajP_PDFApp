# Phase 7 — Digital signature verification

**Status:** completed

**Approved:** 2026-07-17. Decision A = offline-only revocation (no `INTERNET`).
Decision B = EUTL only; AATL not bundled (licence not clearly open).

Implements Phase 7 of `docs/pdf-app-implementation-plan.md` (§5, §6, §9, §11) and the
signature rules in `docs/security-rules.md`. This is the highest-risk phase: it is real
cryptography, mostly in native Kotlin, and a wrong answer here is worse than no answer.

---

## 1. What the issue is

A PDF can carry a **digital signature**. It tells the reader two things:

1. **Integrity** — the bytes the signer signed have not changed since.
2. **Identity** — who signed it, and whether we have reason to believe that name.

The app cannot answer either question today. Nothing in the Flutter world does this well, and
we may not use a commercial SDK (project rule 1). So we build it ourselves in Kotlin:
PdfBox-Android reads the signature, Bouncy Castle checks the cryptography, and Android's
`CertPathValidator` checks the certificate chain.

The hard part is **not** the maths. It is being **honest**. A green tick that is not earned is
worse than a grey question mark, because the user will trust it. Every rule below exists to
stop us faking trust.

---

## 2. Two decisions I need from you

These change what gets built, so please confirm (or correct) them before I start.

### Decision A — revocation checking must stay offline

A certificate can be **revoked** (cancelled early) after it was issued. Checking that normally
means calling the internet (an OCSP or CRL server). But this app is **offline-first** and its
manifest has **no `INTERNET` permission** — a hard project rule.

**My recommendation: never go online. Do not add `INTERNET`.**

Instead:
- Many signed PDFs **carry their own revocation proof inside them** (the signer embeds it, so
  the file can be checked years later). When it is there, we use it.
- When it is not there, we say exactly that: **"Could not check if the certificate was
  cancelled."** The signature can still show as valid-and-trusted, with that note attached.
  We never silently pretend we checked.

This is the standard offline behaviour, and it keeps the app's biggest promise intact.

### Decision B — what "globally trusted" means

The plan says to bundle the Adobe AATL and EU EUTL certificate lists.

**My recommendation: ship the EUTL list only, and treat AATL as a later item.**

Why:
- **EUTL** (the EU's Trusted Lists) is published by the European Commission as an open XML
  file. Free to read and redistribute.
- **AATL** (Adobe Approved Trust List) is Adobe's own list, shipped through Adobe's updater.
  Its redistribution terms are not clearly open, and rule 1 of this project says check the
  licence before adding anything. I do not want to bundle it on a guess.
- Any bundled list also **goes stale**, because we are offline and never refresh it. So the
  list is a convenience, not the main path. The **main path stays the user's own trust
  store** — the user adds the certificate they actually trust.

If you would rather ship **no bundled list at all** in Phase 7 (user-added certificates only),
that is a smaller, safer build and I am happy to do it. Say so and I will adjust.

---

## 3. What gets built

### 3.1 Native Kotlin — `SignatureHandler.kt`

New method channel `in.sreerajp.pdfapp/signature` (the id already exists in `AppConstants`).
Same shape as `PdfBoxHandler`: background thread, reply on main thread, never throw into
Flutter.

One method, `verifySignatures(path, password)`, returning a list — one entry per signature.
For each signature in the document:

1. **Read it** — PdfBox gives the signature dictionary, the signer name, the claimed signing
   time, and the **ByteRange** (the exact byte spans that were signed).
2. **Check integrity** — feed the ByteRange bytes to Bouncy Castle and verify the PKCS#7 / CMS
   blob. This answers "were these bytes changed?".
3. **Check coverage** — the ByteRange must cover the **whole file**. If it does not, part of
   the document was added or changed *after* signing. This is a real attack, and a signature
   that only covers part of the file must **never** show a green tick. This check is easy to
   forget and I am calling it out on purpose.
4. **Check the chain** — build the certificate chain and run Android's `CertPathValidator`
   against our trust anchors (user store + bundled list), with revocation per Decision A.
5. **Report** everything found, including *why* it failed when it failed.

The Kotlin side reports **facts**. It does **not** decide the green tick — that rule lives in
Dart where it can be unit-tested (see §3.3).

**Bouncy Castle dependency.** Android ships its own stripped, old copy of Bouncy Castle, which
can collide with ours. The known fix is a repackaged artifact. Modern `bcprov-jdk15to18` /
`bcpkix-jdk15to18` (MIT licence — fine) usually sit alongside Android's copy without a clash on
minSdk 26. **First task of this phase is to prove that on a real device**, before any UI is
written. If it does clash, the fallback is a repackaged/shaded artifact. I will not build on
top of an unproven dependency.

### 3.2 Trust store — DB migration v4

New `trust_store` table (fingerprint of the certificate, subject, issuer, validity dates, the
DER bytes, when the user added it). Certificates are **public** — not secret — so plain sqflite
is right; `flutter_secure_storage` is for secrets and is not needed here.

The user adds a certificate by picking a `.cer` / `.crt` / `.pem` file through the SAF picker
(the same scoped-storage path everything else uses). We parse and show it (who, who issued it,
valid until) and ask for confirmation **before** storing it. Adding a trust anchor is a
security decision, so the user must see what they are trusting.

### 3.3 Dart — the trust rules (fully unit-tested)

A pure-Dart `SignatureTrustEvaluator` turns the native facts into one of four honest states:

| State | Shown as | When |
|---|---|---|
| **Trusted** | green tick | cryptography valid **and** covers the whole file **and** chain leads to a trusted certificate |
| **Valid, not trusted** | neutral | cryptography valid, but we do not know the signer |
| **Invalid** | red | bytes changed, or the signature does not verify |
| **Unknown** | grey | we could not read or understand the signature |

Plus separate notes carried alongside: "does not cover the whole file", "certificate had
expired when signing", "could not check for cancellation".

This is pure logic with no I/O, so every rule gets a unit test — including the nasty ones
(partial coverage must not be green; expired-at-signing must not be silently green).

### 3.4 UI

- **Viewer menu → "Signatures"** — a new item, alongside the existing menu entries. It is
  hidden when the document has no signatures at all (no dead button — project rule 6).
- **Signatures screen** — one card per signature: state badge, signer, signing time, notes,
  and a "Trust this certificate" button on the *not trusted* state. That button adds the
  signer's certificate to the trust store, after a confirmation that shows the details.
- **Signature details** — certificate subject/issuer/validity, and the plain-English reason
  for the state.
- All text goes through `l10n` (`app_en.arb` + `app_ml.arb`), like every other feature.

---

## 4. Files to be changed

**New — Kotlin**
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/SignatureHandler.kt`

**Changed — Kotlin / Gradle**
- `android/app/build.gradle.kts` — Bouncy Castle dependency (after the clash test in §3.1)
- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` — register the handler

**New — Dart**
- `lib/core/platform/signature_channel.dart`
- `lib/features/signature/domain/pdf_signature.dart`
- `lib/features/signature/domain/signature_status.dart`
- `lib/features/signature/domain/trusted_certificate.dart`
- `lib/features/signature/domain/signature_trust_evaluator.dart`
- `lib/features/signature/data/trust_store_dao.dart`
- `lib/features/signature/data/signature_repository.dart`
- `lib/features/signature/presentation/providers.dart`
- `lib/features/signature/presentation/signatures_screen.dart`
- `lib/features/signature/presentation/widgets/signature_card.dart`
- `lib/features/signature/presentation/widgets/signature_badge.dart`
- `lib/features/signature/presentation/widgets/trust_certificate_dialog.dart`
- `lib/features/settings/presentation/trust_store_screen.dart` (manage / remove added certs)

**Changed — Dart**
- `lib/core/constants/app_constants.dart` — `databaseVersion` 3 → 4, `tableTrustStore`
- `lib/core/storage/migrations.dart` — v4 migration
- `lib/core/errors/app_exception.dart` — signature failure types
- `lib/app/routing/app_router.dart` — signatures + trust store routes
- `lib/features/viewer/presentation/viewer_screen.dart` — menu entry
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb` (+ generated localization files)

**New — assets (only if Decision B keeps the bundled list)**
- `assets/trust/eutl_certificates.pem` + a short note recording where it came from and when
- `pubspec.yaml` — asset entry

**New — tests**
- `test/core/storage/migration_v4_test.dart`
- `test/features/signature/signature_trust_evaluator_test.dart`
- `test/features/signature/trust_store_dao_test.dart`
- `test/features/signature/signature_repository_test.dart`
- `test/features/signature/signatures_screen_test.dart`
- `test/features/signature/signature_badge_test.dart`

**Changed — docs**
- `docs/architecture.md` (signature module + schema v4)
- `docs/pdf-app-implementation-progress.md`
- `change_log/<ts>_phase7_signature_verification.md` (written at the end)

---

## 5. Build order

1. **Prove Bouncy Castle works on a device.** A throwaway verify of a known PKCS#7 blob. If it
   clashes with Android's copy, sort that out before anything else. *Everything else depends on
   this.*
2. Kotlin `SignatureHandler` — read signatures, ByteRange, whole-file coverage, CMS verify.
3. Chain validation with `CertPathValidator` + trust anchors + offline revocation.
4. Dart channel + models + `SignatureTrustEvaluator` (with its tests).
5. DB migration v4 + trust store DAO (with tests).
6. UI: signatures screen, badges, trust dialog, viewer menu entry, trust store screen.
7. Bundled EUTL list (if Decision B keeps it).
8. Docs + change log + progress tracker.

---

## 6. How this gets tested

**Honest note on limits.** The real cryptography runs in Kotlin, so `flutter test` (which runs
on the host, not Android) **cannot** test it. I will not claim it is verified when it is not.
So:

- **Unit tests (host)** — cover everything in Dart: the trust rules (every state, plus the
  partial-coverage and expired-at-signing traps), the DAO, the repository, exception mapping.
  Fake channel replies stand in for the native side.
- **Widget tests (host)** — badge states, screen states (loading / empty / list / error), the
  trust-confirmation dialog.
- **Migration test** — v3 → v4 upgrade path, matching the existing `migration_v2`/`v3` tests.
- **On device (manual, required)** — a real signed PDF must verify correctly; a **tampered**
  copy of that same PDF must come back invalid. Phase 7 is **not** done until this passes on
  hardware. If I cannot get a signed test PDF, I will tell you rather than mark it done.

Test fixtures: a signed PDF and a tampered copy under `test/fixtures/`.

---

## 7. Risks and how they are handled

| Risk | Handling |
|---|---|
| Bouncy Castle clashes with Android's stripped copy | Proven on device as step 1, before anything is built on it. Fallback: repackaged/shaded artifact |
| Faking trust (worst outcome) | Green tick needs valid crypto **+ whole-file coverage + trusted chain**. Rules are pure Dart and unit-tested |
| Signature covers only part of the file | Checked explicitly; can never be green. Called out because it is the classic miss |
| Revocation needs network | Offline only — embedded proof when present, honest "not checked" when absent. No `INTERNET` |
| Bundled list goes stale | User's own trust store is the main path; the list is a convenience. Its age is recorded |
| Malformed signature crashes the parser | Every signature is read in its own try/catch — one bad signature shows as Unknown; the rest still report |
| Native code cannot be host-tested | Stated plainly; on-device pass is a required exit condition, not a nice-to-have |

---

## 8. Done when

- A signed test PDF verifies against a known certificate on a real device; a tampered copy
  reports invalid.
- The green tick appears only under the §3.3 rule; unknown/invalid states read honestly.
- The user can add a certificate to the trust store and see the state change to trusted.
- Schema v4 upgrades cleanly from v3.
- `flutter analyze` clean, `dart format` clean, all tests pass, no `INTERNET` in the manifest.
- Change log written, progress tracker updated.

---

## 9. Approval

No project file will be changed until you approve this plan. Please also confirm **Decision A**
(offline revocation) and **Decision B** (EUTL only / no bundled list / bundle AATL too).

**Do you approve this plan?**
