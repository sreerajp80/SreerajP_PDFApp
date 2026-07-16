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
    private var pendingPickMulti: MethodChannel.Result? = null
    private var pendingSave: MethodChannel.Result? = null
    private var pendingSaveSource: String? = null
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
                    "pickPdfs" -> startPickPdfs(result)
                    "saveToDevice" -> {
                        val sourcePath = call.argument<String>("sourcePath")
                        val suggestedName = call.argument<String>("suggestedName")
                        val mimeType = call.argument<String>("mimeType") ?: "application/pdf"
                        if (sourcePath.isNullOrEmpty() || suggestedName.isNullOrEmpty()) {
                            result.error("bad_args", "Missing sourcePath or suggestedName.", null)
                        } else {
                            startSaveToDevice(sourcePath, suggestedName, mimeType, result)
                        }
                    }
                    "resolveToCache" -> {
                        val uri = call.argument<String>("uri")
                        if (uri == null) {
                            result.error("bad_args", "Missing uri.", null)
                        } else {
                            resolveToCache(uri, result)
                        }
                    }
                    "getInitialIntent" -> result.success(consumeInitialIntent())
                    "shareFiles" -> {
                        val paths = call.argument<List<String>>("paths")
                        val mimeType = call.argument<String>("mimeType")
                        if (paths.isNullOrEmpty()) {
                            result.error("bad_args", "Missing paths.", null)
                        } else {
                            shareFiles(paths, mimeType, result)
                        }
                    }
                    "shareText" -> {
                        val text = call.argument<String>("text")
                        if (text == null) {
                            result.error("bad_args", "Missing text.", null)
                        } else {
                            shareText(text, result)
                        }
                    }
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
        when (requestCode) {
            REQUEST_PICK_PDF -> handlePickResult(resultCode, data)
            REQUEST_PICK_PDFS -> handlePickMultiResult(resultCode, data)
            REQUEST_SAVE_DOC -> handleSaveResult(resultCode, data)
        }
    }

    private fun handlePickResult(resultCode: Int, data: Intent?) {
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

    private fun handlePickMultiResult(resultCode: Int, data: Intent?) {
        val result = pendingPickMulti ?: return
        pendingPickMulti = null

        if (resultCode != Activity.RESULT_OK || data == null) {
            result.success(emptyList<Map<String, Any?>>()) // user cancelled
            return
        }
        // Gather one or many picked items (clipData for multi-select, data for single).
        val uris = arrayListOf<Uri>()
        val clip = data.clipData
        if (clip != null) {
            for (i in 0 until clip.itemCount) {
                clip.getItemAt(i).uri?.let { uris.add(it) }
            }
        } else {
            data.data?.let { uris.add(it) }
        }
        try {
            val payloads = uris.map { uri ->
                val name = queryDisplayName(uri) ?: "document.pdf"
                val cacheFile = copyToCache(uri, name)
                mapOf(
                    "uri" to uri.toString(),
                    "name" to name,
                    "size" to cacheFile.length(),
                    "path" to cacheFile.absolutePath,
                )
            }
            result.success(payloads)
        } catch (e: Exception) {
            result.error("copy_failed", "Could not read a selected file.", e.message)
        }
    }

    private fun handleSaveResult(resultCode: Int, data: Intent?) {
        val result = pendingSave ?: return
        val sourcePath = pendingSaveSource
        pendingSave = null
        pendingSaveSource = null

        if (resultCode != Activity.RESULT_OK || data?.data == null || sourcePath == null) {
            result.success(null) // user cancelled
            return
        }
        val target = data.data!!
        try {
            val source = File(sourcePath)
            if (!source.exists()) {
                result.error("file_not_found", "The file to save is gone.", null)
                return
            }
            contentResolver.openOutputStream(target).use { output ->
                requireNotNull(output) { "Could not open the chosen location." }
                source.inputStream().use { input -> input.copyTo(output) }
            }
            result.success(queryDisplayName(target) ?: source.name)
        } catch (e: Exception) {
            result.error("save_failed", "Could not save the file.", e.message)
        }
    }

    // --- Multi-select picker for merge (ACTION_OPEN_DOCUMENT + ALLOW_MULTIPLE) ---

    private fun startPickPdfs(result: MethodChannel.Result) {
        if (pendingPickMulti != null) {
            result.error("busy", "A pick is already in progress.", null)
            return
        }
        pendingPickMulti = result
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "application/pdf"
            putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        try {
            startActivityForResult(intent, REQUEST_PICK_PDFS)
        } catch (e: Exception) {
            pendingPickMulti = null
            result.error("no_picker", "No file picker is available.", e.message)
        }
    }

    // --- Save a cache file to a user-chosen location (ACTION_CREATE_DOCUMENT) ---

    private fun startSaveToDevice(
        sourcePath: String,
        suggestedName: String,
        mimeType: String,
        result: MethodChannel.Result
    ) {
        if (pendingSave != null) {
            result.error("busy", "A save is already in progress.", null)
            return
        }
        pendingSave = result
        pendingSaveSource = sourcePath
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = mimeType
            putExtra(Intent.EXTRA_TITLE, suggestedName)
        }
        try {
            startActivityForResult(intent, REQUEST_SAVE_DOC)
        } catch (e: Exception) {
            pendingSave = null
            pendingSaveSource = null
            result.error("no_saver", "No place to save is available.", e.message)
        }
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

    private fun shareFiles(paths: List<String>, mimeType: String?, result: MethodChannel.Result) {
        try {
            val uris = arrayListOf<Uri>()
            for (path in paths) {
                val file = File(path)
                if (!file.exists()) {
                    result.error("file_not_found", "File not found: $path", null)
                    return
                }
                val uri = androidx.core.content.FileProvider.getUriForFile(
                    this,
                    "${packageName}.fileprovider",
                    file
                )
                uris.add(uri)
            }

            val intent = if (uris.size == 1) {
                Intent(Intent.ACTION_SEND).apply {
                    type = mimeType ?: "*/*"
                    putExtra(Intent.EXTRA_STREAM, uris[0])
                }
            } else {
                Intent(Intent.ACTION_SEND_MULTIPLE).apply {
                    type = mimeType ?: "*/*"
                    putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)
                }
            }
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

            val chooser = Intent.createChooser(intent, "Share via").apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            startActivity(chooser)
            result.success(null)
        } catch (e: Exception) {
            result.error("share_failed", "Could not share files.", e.message)
        }
    }

    private fun shareText(text: String, result: MethodChannel.Result) {
        try {
            val intent = Intent(Intent.ACTION_SEND).apply {
                type = "text/plain"
                putExtra(Intent.EXTRA_TEXT, text)
            }
            val chooser = Intent.createChooser(intent, "Share via").apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            startActivity(chooser)
            result.success(null)
        } catch (e: Exception) {
            result.error("share_failed", "Could not share text.", e.message)
        }
    }

    private companion object {
        const val REQUEST_PICK_PDF = 4201
        const val REQUEST_PICK_PDFS = 4202
        const val REQUEST_SAVE_DOC = 4203
    }
}
