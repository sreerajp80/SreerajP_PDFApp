# Fix a false claim about the `printing` package in the Phase 6 docs

**Status:** completed

Implemented by `change_log/20260718_005500_fix_printing_package_claim.md`. One note beyond the
plan: `plans/20260714_134410_architecture-and-release-signing-docs.md` also mentions `printing`,
but as a package *recommendation* made on that date, not as the false claim — that is accurate
history and was left alone.

---

## 1. What the issue is

While planning Phase 6 I wrote that we could not use the `printing` package because "it bundles a
second copy of PDFium and would clash with `pdfrx`". I stated this as a checked fact. It is
**wrong**, and it then spread into four documents.

**What I checked.** The `printing` package (version 5.14.3, sitting in the local pub cache) has an
Android implementation made of five Java files and nothing else:

- No PDFium. No `.so` files. No native libraries at all in `android/`.
- No third-party dependencies in its `android/build.gradle`.
- It renders with `android.graphics.pdf.PdfRenderer` and prints with
  `PrintManager` / `PrintDocumentAdapter` — **the same OS APIs I hand-wrote** in
  `PrintHandler.kt`.

**Where the mistake came from.** `printing` *does* link PDFium in its **Windows and Linux desktop**
implementations. I generalised that to Android without checking. This app is Android-only, so the
claim is simply false here.

**Why this matters more than the code.** The app has exactly one copy of PDFium (from `pdfrx`), and
adding `printing` would not have added a second. So the recorded reason for a locked-in
architectural decision is a technical justification that was never true. A future reader — me
included — would take it as verified and never re-check it. A wrong reason in the decision record
is worse than a debatable decision, because it cannot be argued with honestly.

**Honest position on the decision itself.** Keeping `PrintHandler.kt` is still reasonable, but the
case is weaker than I presented. `printing` is Apache 2.0, so the open-source rule always allowed
it, and on Android it would have done the same job for roughly 150 fewer lines of Kotlin. The real
reasons to keep our own are ordinary ones: it matches the native-channel pattern the app already
uses (PdfBox, TTS, SAF), it adds no dependency for something the OS gives us directly, and it is
already written, tested, and building. That is a preference, not a constraint, and the docs should
say so.

**Scope:** documentation only. No code changes. `PrintHandler.kt` stays as built.

---

## 2. Files to be changed

All four repeat the same false claim.

| File                                               | Line | What is there now                                                                |
| -------------------------------------------------- | ---- | -------------------------------------------------------------------------------- |
| `docs/architecture.md`                             | 87   | Package table: "it bundles a second copy of PDFium and would clash with `pdfrx`" |
| `docs/pdf-app-implementation-progress.md`          | ~176 | Phase 6 notes: same claim                                                        |
| `plans/20260717_114932_phase6_pdf_printer.md`      | ~150 | §4 Rules: "bundles its own pdfium copy and would fight with `pdfrx`"             |
| `change_log/20260717_121500_phase6_pdf_printer.md` | ~77  | "Decisions worth knowing": same claim                                            |

---

## 3. The plan for the fix

Replace the invented reason with the true one in all four places. The new wording says the same
thing everywhere:

> **No new package.** Android's print framework is an OS API, and PdfBox was already in the build,
> so nothing new was needed. The `printing` package (Apache 2.0) would also have worked — on
> Android it wraps the same `PrintManager` / `PrintDocumentAdapter` we use, with no native code of
> its own. We wrote our own because the app already owns a native-channel path (PdfBox, TTS, SAF)
> and this fits it, not because `printing` was unusable.

Per-file detail:

1. **`docs/architecture.md` line 87** — shorten the table cell to "Android's own print framework
   via a native channel (see §6, PDF printer)", and put the honest comparison in the §6 PDF
   printer bullet where there is room for a sentence. Drop the PDFium claim.
2. **`docs/pdf-app-implementation-progress.md`** — rewrite the "No new package" note in the Phase 6
   notes with the wording above.
3. **`plans/20260717_114932_phase6_pdf_printer.md`** — this plan is `completed`, so it is a
   historical record and must not be quietly rewritten. Correct the false sentence in §4 **and**
   add a line under the Status block saying the original claim was wrong and pointing to this
   plan. That way the record shows the error and its correction, rather than hiding it.
4. **`change_log/20260717_121500_phase6_pdf_printer.md`** — same treatment: fix the "Decisions
   worth knowing" bullet and add a short "Correction" line noting what was wrong and why, so the
   log stays truthful about what happened.

---

## 4. What this does not change

- No `lib/`, `android/`, `test/`, or `pubspec` changes.
- `PrintHandler.kt` and the whole Phase 6 feature stay exactly as they are.
- No re-run of analyze/test/build is needed (documentation only), though `flutter analyze` is
  cheap and will be re-run as a sanity check.

---

## 5. Done when

- No document claims `printing` bundles PDFium or clashes with `pdfrx`.
- All four files give the same, true reason for writing our own print bridge.
- The plan and the change log show the correction openly instead of silently overwriting history.

---

## 6. Approval

No file will be changed until you approve this plan.

**Do you approve this plan?**
