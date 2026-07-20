# Change log: fix "Page Not Found" when opening a PDF from another app

Implements plan `plans/20260720_222210_fix-view-intent-deeplink.md`.

## What was wrong

Opening a PDF directly from another app (for example Telegram) showed a
**"Page Not Found"** screen:

```
no routes for location: content://org.telegram.messenger.provider/.../file.pdf
```

Tapping **Home** then opened the same PDF fine.

Cause: the `VIEW` intent filters include the `BROWSABLE` category (needed for
"Open with"), which turns on Flutter's automatic deep-linking. Flutter passed the
opened file's `content://` URI to go_router as the initial route. No route
matches it, so the error screen appeared instead of Home. The app's own native
intent bridge only ran once Home was built (which is why tapping Home worked).

## What was changed

- `android/app/src/main/AndroidManifest.xml`
  - Added a meta-data flag inside the `.MainActivity` activity to disable
    Flutter's automatic deep-linking:
    ```xml
    <meta-data
        android:name="flutter_deeplinking_enabled"
        android:value="false" />
    ```
  - Added a comment explaining why.

No Dart code changed. The app already opens the shared/opened PDF through its
native intent bridge (`MainActivity.payloadFromIntent` → `getInitialIntent` →
`HomeScreen._handleLaunchIntent`), which is untouched.

## Effect

- go_router now keeps its normal start location `/` (Home) on launch.
- The launch intent still reaches Kotlin, so the PDF opens straight in the
  viewer with no "Page Not Found" screen.
- Share (SEND) of PDF / image / text and the in-app picker and recents are
  unaffected.

## Testing notes

Manual test recommended: open a PDF from Telegram and from a file manager,
share a PDF into the app, and share an image/text into the app, confirming each
lands on the right screen with no error page.
