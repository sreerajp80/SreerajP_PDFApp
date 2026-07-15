package `in`.sreerajp.pdfapp

import android.app.Activity
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Bridges scoped-storage file opening to Flutter (Phase 1).
 *
 * The app never browses storage. Files come in only through:
 *  - the system picker (`ACTION_OPEN_DOCUMENT`, method `pickPdf`), and
 *  - "Open with" / share intents (`ACTION_VIEW` / `ACTION_SEND`), streamed on
 *    the [openEventChannel].
 *
 * Because pdfium needs random access and cannot read a `content://` URI, the
 * picked content is copied into the app's private cache and the cache path is
 * returned. The original is only ever read (copy-on-read). For the picker we
 * take a *persistable* URI permission so the recents list can reopen the file
 * later; the durable identity stored by Dart is the URI, not the cache path.
 */
class MainActivity : FlutterActivity() {

    private val methodChannelName = "in.sreerajp.pdfapp/open"
    private val eventChannelName = "in.sreerajp.pdfapp/open_events"

    private var pendingPick: MethodChannel.Result? = null
    private var eventSink: EventChannel.EventSink? = null

    // PDF data bridge (Phase 2). Owns its own channel; see PdfBoxHandler.
    private var pdfBoxHandler: PdfBoxHandler? = null

    // An "Open with" intent that arrived before Dart was listening.
    private var initialIntentPayload: Map<String, Any?>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "pickPdf" -> startPickPdf(result)
                    "resolveToCache" -> {
                        val uri = call.argument<String>("uri")
                        if (uri == null) {
                            result.error("bad_args", "Missing uri.", null)
                        } else {
                            resolveToCache(uri, result)
                        }
                    }
                    "getInitialIntent" -> result.success(consumeInitialIntent())
                    else -> result.notImplemented()
                }
            }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannelName)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                    eventSink = sink
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })

        pdfBoxHandler = PdfBoxHandler(this, flutterEngine.dartExecutor.binaryMessenger)
        TtsHandler(this, flutterEngine.dartExecutor.binaryMessenger)

        // Capture a launch "Open with" intent so Dart can ask for it once ready.
        initialIntentPayload = payloadFromIntent(intent)
    }

    override fun onDestroy() {
        pdfBoxHandler?.dispose()
        pdfBoxHandler = null
        super.onDestroy()
    }

    // --- System picker (ACTION_OPEN_DOCUMENT) ---

    private fun startPickPdf(result: MethodChannel.Result) {
        if (pendingPick != null) {
            result.error("busy", "A pick is already in progress.", null)
            return
        }
        pendingPick = result
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "application/pdf"
            addFlags(
                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                    Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION,
            )
        }
        try {
            startActivityForResult(intent, REQUEST_PICK_PDF)
        } catch (e: Exception) {
            pendingPick = null
            result.error("no_picker", "No file picker is available.", e.message)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != REQUEST_PICK_PDF) return
        val result = pendingPick ?: return
        pendingPick = null

        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            result.success(null) // user cancelled
            return
        }
        val uri = data.data!!
        // Persist read access so recents can reopen after a reboot.
        try {
            contentResolver.takePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION,
            )
        } catch (_: SecurityException) {
            // Some providers don't grant persistable access; recents may fail
            // to reopen later, which Dart handles gracefully.
        }
        deliverCopy(uri, result)
    }

    // --- Resolve a stored URI back to a fresh cache copy (reopen from recents) ---

    private fun resolveToCache(uriString: String, result: MethodChannel.Result) {
        deliverCopy(Uri.parse(uriString), result)
    }

    private fun deliverCopy(uri: Uri, result: MethodChannel.Result) {
        try {
            val name = queryDisplayName(uri) ?: "document.pdf"
            val cacheFile = copyToCache(uri, name)
            result.success(
                mapOf(
                    "uri" to uri.toString(),
                    "name" to name,
                    "size" to cacheFile.length(),
                    "path" to cacheFile.absolutePath,
                ),
            )
        } catch (e: SecurityException) {
            result.error("no_access", "No permission to read this file.", e.message)
        } catch (e: Exception) {
            result.error("copy_failed", "Could not read the selected file.", e.message)
        }
    }

    // --- "Open with" / share intents ---

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val payload = payloadFromIntent(intent) ?: return
        val sink = eventSink
        if (sink != null) {
            sink.success(payload)
        } else {
            initialIntentPayload = payload
        }
    }

    private fun consumeInitialIntent(): Map<String, Any?>? {
        val payload = initialIntentPayload
        initialIntentPayload = null
        return payload
    }

    /** Extracts a PDF URI from a VIEW/SEND intent, or null if it isn't one. */
    private fun payloadFromIntent(intent: Intent?): Map<String, Any?>? {
        if (intent == null) return null
        val uri: Uri? = when (intent.action) {
            Intent.ACTION_VIEW -> intent.data
            Intent.ACTION_SEND -> intent.getParcelableExtra(Intent.EXTRA_STREAM)
            else -> null
        }
        if (uri == null) return null
        return try {
            val name = queryDisplayName(uri) ?: "document.pdf"
            val cacheFile = copyToCache(uri, name)
            mapOf(
                "uri" to uri.toString(),
                "name" to name,
                "size" to cacheFile.length(),
                "path" to cacheFile.absolutePath,
            )
        } catch (_: Exception) {
            null
        }
    }

    // --- Helpers ---

    private fun queryDisplayName(uri: Uri): String? {
        if (uri.scheme == "file") return uri.lastPathSegment
        var cursor: Cursor? = null
        return try {
            cursor = contentResolver.query(uri, null, null, null, null)
            if (cursor != null && cursor.moveToFirst()) {
                val idx = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (idx >= 0) cursor.getString(idx) else null
            } else {
                null
            }
        } catch (_: Exception) {
            null
        } finally {
            cursor?.close()
        }
    }

    /** Copies the content behind [uri] into a fresh file in the app cache. */
    private fun copyToCache(uri: Uri, displayName: String): File {
        val dir = File(cacheDir, "opened").apply { mkdirs() }
        val safeName = displayName.replace(Regex("[^A-Za-z0-9._-]"), "_")
        val outFile = File(dir, "${System.currentTimeMillis()}_$safeName")
        contentResolver.openInputStream(uri).use { input ->
            requireNotNull(input) { "Could not open the file stream." }
            outFile.outputStream().use { output -> input.copyTo(output) }
        }
        return outFile
    }

    private companion object {
        const val REQUEST_PICK_PDF = 4201
    }
}
