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
    private var pendingPickCert: MethodChannel.Result? = null
    private var pendingSave: MethodChannel.Result? = null
    private var pendingSaveSource: String? = null
    private var eventSink: EventChannel.EventSink? = null

    // PDF data bridge (Phase 2). Owns its own channel; see PdfBoxHandler.
    private var pdfBoxHandler: PdfBoxHandler? = null

    // Signature verification (Phase 7). Owns its own channel; see SignatureHandler.
    private var signatureHandler: SignatureHandler? = null

    // An "Open with" intent that arrived before Dart was listening.
    private var initialIntentPayload: Map<String, Any?>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "pickPdf" -> startPickPdf(result)
                    "pickPdfs" -> startPickPdfs(result)
                    "pickCertificate" -> startPickCertificate(result)
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
        signatureHandler = SignatureHandler(this, flutterEngine.dartExecutor.binaryMessenger)
        TtsHandler(this, flutterEngine.dartExecutor.binaryMessenger)
        PrintHandler(this, flutterEngine.dartExecutor.binaryMessenger)

        // Capture a launch "Open with" intent so Dart can ask for it once ready.
        initialIntentPayload = payloadFromIntent(intent)
    }

    override fun onDestroy() {
        pdfBoxHandler?.dispose()
        pdfBoxHandler = null
        signatureHandler?.dispose()
        signatureHandler = null
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
            REQUEST_PICK_CERT -> handlePickCertResult(resultCode, data)
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
            result.success(uris.map { pdfPayload(it) })
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

    // --- Certificate picker for the trust store (Phase 7) ---

    /**
     * Picks a certificate file and copies it into the cache, returning the path.
     *
     * No *persistable* permission is taken here, unlike [startPickPdf]: the file is read once
     * and its bytes go into the trust store, so there is nothing to reopen later and no reason
     * to hold lasting access to the user's storage.
     *
     * The type filter is a convenience, not a check — the picker cannot be trusted to return
     * what it advertises, so the file is still parsed as untrusted input on the other side.
     */
    private fun startPickCertificate(result: MethodChannel.Result) {
        if (pendingPickCert != null) {
            result.error("busy", "A pick is already in progress.", null)
            return
        }
        pendingPickCert = result
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "*/*"
            putExtra(Intent.EXTRA_MIME_TYPES, CERT_MIME_TYPES)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        try {
            startActivityForResult(intent, REQUEST_PICK_CERT)
        } catch (e: Exception) {
            pendingPickCert = null
            result.error("no_picker", "No file picker is available.", e.message)
        }
    }

    private fun handlePickCertResult(resultCode: Int, data: Intent?) {
        val result = pendingPickCert ?: return
        pendingPickCert = null

        if (resultCode != Activity.RESULT_OK || data?.data == null) {
            result.success(null) // user cancelled
            return
        }
        try {
            val uri = data.data!!
            val name = queryDisplayName(uri) ?: "certificate"
            result.success(copyToCache(uri, name).absolutePath)
        } catch (e: Exception) {
            result.error("copy_failed", "Could not read the selected file.", e.message)
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
            result.success(pdfPayload(uri))
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

    /**
     * Turns a VIEW/SEND intent into something Dart can act on, or null if it isn't one.
     *
     * Every payload carries a `kind` so Dart knows where to send it:
     *  - `pdf`    — open it in the viewer (Phase 1).
     *  - `images` — build a PDF out of the pictures (Phase 6).
     *  - `text`   — build a PDF out of the text (Phase 6).
     *
     * Anything unreadable returns null rather than throwing: a share we cannot make sense of
     * must never take the app down (project rule).
     */
    private fun payloadFromIntent(intent: Intent?): Map<String, Any?>? {
        if (intent == null) return null
        return try {
            when (intent.action) {
                Intent.ACTION_VIEW -> intent.data?.let { pdfPayload(it) }
                Intent.ACTION_SEND -> sendPayload(intent)
                Intent.ACTION_SEND_MULTIPLE -> sendMultiplePayload(intent)
                else -> null
            }
        } catch (_: Exception) {
            null
        }
    }

    private fun sendPayload(intent: Intent): Map<String, Any?>? {
        val uri: Uri? = intent.getParcelableExtra(Intent.EXTRA_STREAM)
        if (uri == null) {
            // Text shared straight from another app, with no file behind it.
            val text = intent.getCharSequenceExtra(Intent.EXTRA_TEXT)?.toString()
            return if (text.isNullOrBlank()) null else textPayload(text)
        }
        val mime = mimeOf(uri, intent.type)
        return when {
            mime == "application/pdf" -> pdfPayload(uri)
            mime.startsWith("image/") -> imagesPayload(listOf(uri))
            mime.startsWith("text/") -> {
                val text = readText(uri)
                if (text.isNullOrBlank()) null else textPayload(text)
            }
            else -> null
        }
    }

    private fun sendMultiplePayload(intent: Intent): Map<String, Any?>? {
        val uris: List<Uri> = intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)
            ?: return null
        // Only pictures can be joined into one PDF; ignore anything else in the batch.
        val images = uris.filter { mimeOf(it, null).startsWith("image/") }
        return if (images.isEmpty()) null else imagesPayload(images)
    }

    private fun pdfPayload(uri: Uri): Map<String, Any?> {
        val name = queryDisplayName(uri) ?: "document.pdf"
        val cacheFile = copyToCache(uri, name)
        return mapOf(
            "kind" to "pdf",
            "uri" to uri.toString(),
            "name" to name,
            "size" to cacheFile.length(),
            "path" to cacheFile.absolutePath,
        )
    }

    /** Copies each picture into the cache so PdfBox can read it by path. */
    private fun imagesPayload(uris: List<Uri>): Map<String, Any?>? {
        val paths = arrayListOf<String>()
        var total = 0L
        for (uri in uris) {
            try {
                val name = queryDisplayName(uri) ?: "image"
                val file = copyToCache(uri, name)
                paths.add(file.absolutePath)
                total += file.length()
            } catch (_: Exception) {
                // Skip the one we cannot read; the rest of the batch still works.
            }
        }
        if (paths.isEmpty()) return null
        val firstName = queryDisplayName(uris.first())?.substringBeforeLast('.')
        return mapOf(
            "kind" to "images",
            "name" to (if (firstName.isNullOrBlank()) "images" else firstName),
            "size" to total,
            "paths" to paths,
        )
    }

    private fun textPayload(text: String): Map<String, Any?> = mapOf(
        "kind" to "text",
        "name" to "text",
        "size" to text.toByteArray().size.toLong(),
        "text" to text,
    )

    /** The type of [uri], preferring what the sender declared. */
    private fun mimeOf(uri: Uri, declared: String?): String {
        val type = declared?.takeIf { !it.contains('*') } ?: contentResolver.getType(uri)
        return type ?: ""
    }

    /** Reads a shared text file, capped so a huge file cannot exhaust memory. */
    private fun readText(uri: Uri): String? = try {
        contentResolver.openInputStream(uri)?.use { input ->
            val bytes = ByteArray(MAX_SHARED_TEXT_BYTES)
            var filled = 0
            // One read() may return less than asked for even with more to come, so keep
            // going until the cap is reached or the stream ends.
            while (filled < bytes.size) {
                val read = input.read(bytes, filled, bytes.size - filled)
                if (read < 0) break
                filled += read
            }
            if (filled <= 0) null else String(bytes, 0, filled, Charsets.UTF_8)
        }
    } catch (_: Exception) {
        null
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
        const val REQUEST_PICK_CERT = 4204

        /**
         * Types shown when picking a certificate (Phase 7). Certificates travel under a
         * spread of types and often none at all, so `application/octet-stream` and
         * `text/plain` are included — without them, a perfectly good `.pem` can be greyed
         * out in the picker and look broken.
         */
        val CERT_MIME_TYPES = arrayOf(
            "application/x-x509-ca-cert",
            "application/x-x509-user-cert",
            "application/pkix-cert",
            "application/octet-stream",
            "text/plain",
        )

        /** Most shared text we will take in (Phase 6). Past this the PDF would be absurd. */
        const val MAX_SHARED_TEXT_BYTES = 2 * 1024 * 1024
    }
}
