package `in`.sreerajp.pdfapp

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.tom_roush.pdfbox.android.PDFBoxResourceLoader
import com.tom_roush.pdfbox.pdmodel.PDDocument
import com.tom_roush.pdfbox.pdmodel.encryption.InvalidPasswordException
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.Calendar
import java.util.concurrent.Executors

/**
 * PdfBox-Android bridge (Phase 2).
 *
 * PdfBox reads the PDF *data* the renderer does not expose — for now the document
 * information fields (title, author, dates, ...). Rendering and text extraction stay
 * with pdfrx/pdfium, which is the only source of per-character rectangles.
 *
 * Everything runs on a background thread: PdfBox parses the whole file and would
 * otherwise block the UI. Results are posted back on the main thread, which is where
 * Flutter requires [MethodChannel.Result] to be answered.
 *
 * Nothing here throws into Flutter: a broken or locked file becomes a typed error the
 * Dart side maps to a friendly message (project rule: never crash on bad input).
 */
class PdfBoxHandler(context: Context, messenger: BinaryMessenger) {

    private val appContext = context.applicationContext
    private val io = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())

    // PdfBox-Android needs its resources loaded once before any document is parsed.
    private val resourcesReady: Boolean by lazy {
        PDFBoxResourceLoader.init(appContext)
        true
    }

    init {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "readMetadata" -> {
                    val path = call.argument<String>("path")
                    if (path.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path.", null)
                    } else {
                        readMetadata(path, call.argument<String>("password"), result)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun readMetadata(path: String, password: String?, result: MethodChannel.Result) {
        io.execute {
            try {
                val payload = loadMetadata(path, password)
                main.post { result.success(payload) }
            } catch (e: InvalidPasswordException) {
                // Locked with a user password we were not given. Honest, typed answer —
                // Dart shows file details only and says the PDF details are unavailable.
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("read_failed", "Could not read this PDF.", e.message) }
            } catch (e: OutOfMemoryError) {
                // A huge or malformed file can exhaust the heap. Report, never crash.
                main.post { result.error("read_failed", "This PDF is too large to read.", null) }
            }
        }
    }

    private fun loadMetadata(path: String, password: String?): Map<String, Any?> {
        check(resourcesReady)
        val file = File(path)
        if (!file.exists()) throw IllegalStateException("File not found.")

        PDDocument.load(file, password ?: "").use { doc ->
            val info = doc.documentInformation
            return mapOf(
                "title" to info?.title.orNullIfBlank(),
                "author" to info?.author.orNullIfBlank(),
                "subject" to info?.subject.orNullIfBlank(),
                "keywords" to info?.keywords.orNullIfBlank(),
                "creator" to info?.creator.orNullIfBlank(),
                "producer" to info?.producer.orNullIfBlank(),
                "creationDate" to info?.creationDate.toEpochMillis(),
                "modificationDate" to info?.modificationDate.toEpochMillis(),
                "pageCount" to doc.numberOfPages,
                "encrypted" to doc.isEncrypted,
                "pdfVersion" to doc.version.toString(),
            )
        }
    }

    /** Blank document-info fields are common; treat them as absent, not as empty text. */
    private fun String?.orNullIfBlank(): String? = this?.trim()?.takeIf { it.isNotEmpty() }

    private fun Calendar?.toEpochMillis(): Long? = this?.timeInMillis

    fun dispose() {
        io.shutdown()
    }

    companion object {
        const val CHANNEL = "in.sreerajp.pdfapp/pdfbox"
    }
}
