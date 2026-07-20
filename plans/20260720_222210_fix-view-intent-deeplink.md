# Fix: "Page Not Found" when opening a PDF from another app (VIEW intent)

**Status:** completed

## What the issue is

When another app (for example Telegram) opens a PDF directly in this app, the
app shows a **"Page Not Found"** screen with the message:

```
no routes for location: content://org.telegram.messenger.provider/.../file.pdf
```

If the user then taps **Home**, the same PDF opens correctly.

### Why this happens

- The app uses **go_router** (`lib/app/routing/app_router.dart`) with
  `MaterialApp.router` (`lib/app/app.dart`).
- The Android manifest declares `VIEW` intent filters that include
  `android.intent.category.BROWSABLE` (needed so the app appears in "Open with").
- Because of that BROWSABLE filter, **Flutter turns on automatic deep-linking**.
  On launch it reads the intent's data URI (`content://...`) and passes it to
  go_router as the **initial route**.
- go_router has no route that matches a `content://...` URI, so it shows its
  "Page Not Found" error screen instead of `HomeScreen`.
- Our own file-open path never runs at first, because `HomeScreen.initState`
  (which calls `_handleLaunchIntent()` to consume the native intent) only runs
  once `HomeScreen` is actually built. Tapping **Home** navigates to `/`, builds
  `HomeScreen`, and only then does the stored native intent get consumed and the
  PDF opens — which is why Home "fixes" it.

The app already receives the intent correctly through its own native bridge
(`MainActivity.payloadFromIntent` → `getInitialIntent` → `HomeScreen._handleLaunchIntent`).
So Flutter's automatic deep-linking is redundant here and is the sole cause of
the error.

## Files to be changed

1. `android/app/src/main/AndroidManifest.xml`
   - Add a single meta-data flag to turn off Flutter's automatic deep-linking:
     ```xml
     <meta-data
         android:name="flutter_deeplinking_enabled"
         android:value="false" />
     ```
   - Placed inside the `<activity android:name=".MainActivity">` element.

No Dart code needs to change: the native intent bridge already handles opening
the shared/opened PDF.

## The plan for the fix

1. Add the `flutter_deeplinking_enabled = false` meta-data to `MainActivity` in
   the manifest. This stops Flutter from parsing the launch intent's URI as a
   route, so go_router keeps its normal `initialLocation` of `/` (Home) and the
   "Page Not Found" screen no longer appears.
2. The launch intent still reaches Kotlin (`getIntent()` is unaffected), so
   `getInitialIntent` / the incoming stream keep working and `HomeScreen`
   opens the PDF as before.

## How to test

- Build and install the app.
- From Telegram (and a file manager), tap a PDF and choose this app.
  - Expected: the PDF opens straight in the viewer, no "Page Not Found" screen.
- Share a PDF to the app (SEND) — still opens in the viewer.
- Share an image / text to the app — still goes to the Import screen.
- Open a PDF with the app already running (onNewIntent path) — still opens.
- Open a PDF with the in-app picker and from recents — unchanged.

## Risk

- Very low. The change only disables Flutter's built-in URL-style deep-link
  routing, which this app does not use (there are no web/app-link routes). All
  file opening is done through the native intent bridge, which is untouched.
