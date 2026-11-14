# Open PDF: always use the system file picker

**Status:** approval_pending

## The issue

On the test phone (a Xiaomi phone on Android 10), tapping **Open PDF** does not open the
Android system file picker. It opens another installed app instead (a file vault app made by
the same developer). That app says it can answer the "open a document" request
(`ACTION_OPEN_DOCUMENT`), and on this phone it is set as the **default** for it.

Checked on the phone with `adb shell cmd package resolve-activity`:

- `ACTION_OPEN_DOCUMENT` (PDF) -> the vault app (default)
- `ACTION_CREATE_DOCUMENT`, `ACTION_GET_CONTENT` -> the system picker (`documentsui`)

The vault app hands back a short-lived link to the file. It does not allow *lasting* access
(a "persistable URI permission"). So the file opens fine the first time, but after Folio is
closed fully, Android takes the access away, and the recent-files list shows
**"Can't reopen file"** every time.

The same thing happens for the merge picker (`pickPdfs`) and the certificate picker
(`pickCertificate`), because they use the same request.

## Why not our own file picker

An in-app file browser needs the **"All files access"** permission
(`MANAGE_EXTERNAL_STORAGE`). Google Play allows it only for apps whose main job is managing
files (file managers, backup, antivirus). PDF readers are named as **not** allowed, so the
app would be rejected. It also breaks this project's hard rule 3 (scoped storage only, no
in-app file browser). The system picker is the right tool; we just need to make sure we
reach it.

## The fix

When starting any of the three "open a document" pickers, send the request **straight to
the phone's built-in system picker**, not to whatever app is set as default.

1. Add a small helper in `MainActivity.kt`, `systemPickerPackage(intent)`:
   - ask Android which apps can handle the intent (`queryIntentActivities`);
   - pick the one that is a **system app** (`ApplicationInfo.FLAG_SYSTEM`) — this is
     `com.google.android.documentsui` or `com.android.documentsui`, depending on the phone;
   - return its package name, or `null` if none is found.
2. In `startPickPdf`, `startPickPdfs` and `startPickCertificate`: if the helper finds the
   system picker, call `intent.setPackage(...)` on the request. If it finds nothing, start
   the request as today (no change in behaviour, never a dead button).
3. Add an `ACTION_OPEN_DOCUMENT` entry to the `<queries>` block in `AndroidManifest.xml`.
   Since Android 11, an app cannot see other apps unless it says what it is looking for;
   without this, the helper would find nothing on newer phones and silently fall back.

The system picker still lets the user browse other apps' storage from its side menu if
they choose to. Files picked that way may still not be reopenable; the existing
"Can't reopen file" dialog already explains that case, so it stays.

## Files to change

- `android/app/src/main/kotlin/in/sreerajp/pdfapp/MainActivity.kt` — helper + use it in the
  three pickers.
- `android/app/src/main/AndroidManifest.xml` — one `<intent>` in `<queries>`.
- `CHANGELOG.md` — one line under the unreleased section.
- `change_log/<timestamp>_open_pdf_use_system_picker.md` — the change log.

No Dart, ARB or test changes (the native picker is not covered by Flutter tests).

## Security impact

Platform folder change. It **narrows** where the file request goes (to the system picker
only), and adds a `<queries>` entry that lets the app see which apps handle "open
document". No new permission, no network, no storage widening.

## How to check

1. `flutter run --flavor dev` on the Xiaomi phone.
2. Tap **Open PDF** -> the system picker opens (not the vault app).
3. Open a PDF from Downloads, close Folio fully (swipe it away), reopen it, tap the file in
   Recent files -> it opens with no "Can't reopen file" dialog.
4. Repeat on the Motorola phone (newer Android) to check the `<queries>` entry works.

## Side note (not part of this change)

The vault app itself could also be improved, so it gives lasting access or shows up
inside the system picker as a proper storage location (a `DocumentsProvider`). That is a
separate project and needs its own plan there.
