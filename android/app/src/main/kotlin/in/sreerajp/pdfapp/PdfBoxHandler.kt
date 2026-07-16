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
                "extractText" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val startPage = call.argument<Int>("startPage") ?: 1
                    val endPage = call.argument<Int>("endPage") ?: 1
                    if (path.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path.", null)
                    } else {
                        extractText(path, password, startPage, endPage, result)
                    }
                }
                "extractImages" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val startPage = call.argument<Int>("startPage") ?: 1
                    val endPage = call.argument<Int>("endPage") ?: 1
                    val outputDir = call.argument<String>("outputDir")
                    if (path.isNullOrEmpty() || outputDir.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path or outputDir.", null)
                    } else {
                        extractImages(path, password, startPage, endPage, outputDir, result)
                    }
                }
                "readFormFields" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    if (path.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path.", null)
                    } else {
                        readFormFields(path, password, result)
                    }
                }
                "renderPagesToImages" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val startPage = call.argument<Int>("startPage") ?: 1
                    val endPage = call.argument<Int>("endPage") ?: 1
                    val outputDir = call.argument<String>("outputDir")
                    val format = call.argument<String>("format") ?: "png"
                    val dpi = call.argument<Int>("dpi") ?: 150
                    if (path.isNullOrEmpty() || outputDir.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path or outputDir.", null)
                    } else {
                        renderPagesToImages(path, password, startPage, endPage, outputDir, format, dpi, result)
                    }
                }
                "mergePdfs" -> {
                    val paths = call.argument<List<String>>("paths")
                    val outputPath = call.argument<String>("outputPath")
                    if (paths.isNullOrEmpty() || outputPath.isNullOrEmpty()) {
                        result.error("bad_args", "Missing paths or outputPath.", null)
                    } else {
                        mergePdfs(paths, outputPath, result)
                    }
                }
                "splitPdf" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val outputDir = call.argument<String>("outputDir")
                    if (path.isNullOrEmpty() || outputDir.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path or outputDir.", null)
                    } else {
                        splitPdf(path, password, outputDir, result)
                    }
                }
                "organizePages" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val outputPath = call.argument<String>("outputPath")
                    val pages = call.argument<List<Map<String, Int>>>("pages")
                    if (path.isNullOrEmpty() || outputPath.isNullOrEmpty() || pages.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path, outputPath, or pages.", null)
                    } else {
                        organizePages(path, password, outputPath, pages, result)
                    }
                }
                "compressPdf" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val outputPath = call.argument<String>("outputPath")
                    if (path.isNullOrEmpty() || outputPath.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path or outputPath.", null)
                    } else {
                        compressPdf(path, password, outputPath, result)
                    }
                }
                "encryptPdf" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val outputPath = call.argument<String>("outputPath")
                    val userPassword = call.argument<String>("userPassword")
                    val ownerPassword = call.argument<String>("ownerPassword")
                    if (path.isNullOrEmpty() || outputPath.isNullOrEmpty() || userPassword.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path, outputPath, or userPassword.", null)
                    } else {
                        encryptPdf(path, password, outputPath, userPassword, ownerPassword, result)
                    }
                }
                "decryptPdf" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val outputPath = call.argument<String>("outputPath")
                    if (path.isNullOrEmpty() || outputPath.isNullOrEmpty() || password.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path, outputPath, or password.", null)
                    } else {
                        decryptPdf(path, password, outputPath, result)
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

    private fun extractText(
        path: String,
        password: String?,
        startPage: Int,
        endPage: Int,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val file = File(path)
                val text = PDDocument.load(file, password ?: "").use { doc ->
                    val stripper = com.tom_roush.pdfbox.text.PDFTextStripper()
                    stripper.startPage = startPage
                    stripper.endPage = endPage
                    stripper.getText(doc)
                }
                main.post { result.success(text) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("extract_failed", "Could not extract text: ${e.message}", null) }
            }
        }
    }

    private fun extractImages(
        path: String,
        password: String?,
        startPage: Int,
        endPage: Int,
        outputDir: String,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val file = File(path)
                val outDir = File(outputDir).apply { mkdirs() }
                val savedPaths = ArrayList<String>()
                var imgCount = 0

                PDDocument.load(file, password ?: "").use { doc ->
                    val pages = doc.pages
                    val actualStart = (startPage - 1).coerceIn(0, doc.numberOfPages - 1)
                    val actualEnd = (endPage - 1).coerceIn(actualStart, doc.numberOfPages - 1)

                    for (p in actualStart..actualEnd) {
                        val page = pages[p]
                        val resources = page.resources ?: continue
                        for (name in resources.xObjectNames) {
                            if (resources.isImageXObject(name)) {
                                val image = resources.getXObject(name) as? com.tom_roush.pdfbox.pdmodel.graphics.image.PDImageXObject ?: continue
                                val bitmap = image.image ?: continue
                                imgCount++
                                val imgFile = File(outDir, "extracted_page_${p + 1}_img_${imgCount}.png")
                                imgFile.outputStream().use { out ->
                                    bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, out)
                                }
                                savedPaths.add(imgFile.absolutePath)
                            }
                        }
                    }
                }
                main.post { result.success(savedPaths) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("extract_failed", "Could not extract images: ${e.message}", null) }
            }
        }
    }

    private fun readFormFields(
        path: String,
        password: String?,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val file = File(path)
                val fieldsList = PDDocument.load(file, password ?: "").use { doc ->
                    val acroForm = doc.documentCatalog.acroForm
                    acroForm?.fields?.map { field ->
                        mapOf(
                            "name" to field.fullyQualifiedName,
                            "value" to (field.valueAsString ?: ""),
                            "type" to field.fieldType,
                            "readOnly" to field.isReadOnly
                        )
                    } ?: emptyList()
                }
                main.post { result.success(fieldsList) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("extract_failed", "Could not read form fields: ${e.message}", null) }
            }
        }
    }

    private fun renderPagesToImages(
        path: String,
        password: String?,
        startPage: Int,
        endPage: Int,
        outputDir: String,
        format: String,
        dpi: Int,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val file = File(path)
                val outDir = File(outputDir).apply { mkdirs() }
                val savedPaths = ArrayList<String>()

                PDDocument.load(file, password ?: "").use { doc ->
                    val renderer = com.tom_roush.pdfbox.rendering.PDFRenderer(doc)
                    val actualStart = (startPage - 1).coerceIn(0, doc.numberOfPages - 1)
                    val actualEnd = (endPage - 1).coerceIn(actualStart, doc.numberOfPages - 1)

                    val compressFormat = if (format.equals("jpeg", ignoreCase = true) || format.equals("jpg", ignoreCase = true)) {
                        android.graphics.Bitmap.CompressFormat.JPEG
                    } else {
                        android.graphics.Bitmap.CompressFormat.PNG
                    }
                    val ext = if (compressFormat == android.graphics.Bitmap.CompressFormat.JPEG) "jpg" else "png"

                    for (p in actualStart..actualEnd) {
                        val bitmap = renderer.renderImageWithDPI(p, dpi.toFloat())
                        val imgFile = File(outDir, "page_${p + 1}.$ext")
                        imgFile.outputStream().use { out ->
                            bitmap.compress(compressFormat, 90, out)
                        }
                        savedPaths.add(imgFile.absolutePath)
                    }
                }
                main.post { result.success(savedPaths) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("extract_failed", "Could not render pages: ${e.message}", null) }
            }
        }
    }

    // --- Page operations (Phase 4). Every op writes a NEW file; the source is only read. ---

    /** Joins [paths] (in order) into a single new PDF at [outputPath]. */
    private fun mergePdfs(paths: List<String>, outputPath: String, result: MethodChannel.Result) {
        io.execute {
            try {
                check(resourcesReady)
                val merger = com.tom_roush.pdfbox.multipdf.PDFMergerUtility()
                merger.destinationFileName = outputPath
                for (p in paths) {
                    val file = File(p)
                    if (!file.exists()) throw IllegalStateException("File not found: $p")
                    merger.addSource(file)
                }
                merger.mergeDocuments(
                    com.tom_roush.pdfbox.io.MemoryUsageSetting.setupTempFileOnly()
                )
                main.post { result.success(outputPath) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "A PDF to merge is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not merge PDFs: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "These PDFs are too large to merge.", null) }
            }
        }
    }

    /** Splits [path] into one file per page inside [outputDir]. Returns the new file paths. */
    private fun splitPdf(
        path: String,
        password: String?,
        outputDir: String,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val file = File(path)
                val outDir = File(outputDir).apply { mkdirs() }
                val baseName = file.nameWithoutExtension.ifEmpty { "document" }
                val savedPaths = ArrayList<String>()

                PDDocument.load(file, password ?: "").use { doc ->
                    val splitter = com.tom_roush.pdfbox.multipdf.Splitter()
                    val parts = splitter.split(doc)
                    for ((index, part) in parts.withIndex()) {
                        part.use { single ->
                            val outFile = File(outDir, "${baseName}_page_${index + 1}.pdf")
                            single.save(outFile)
                            savedPaths.add(outFile.absolutePath)
                        }
                    }
                }
                main.post { result.success(savedPaths) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not split PDF: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "This PDF is too large to split.", null) }
            }
        }
    }

    /**
     * Builds a new PDF at [outputPath] from selected source pages.
     *
     * [pages] is an ordered list of maps `{page: 1-based original page, rotation: 0/90/180/270}`.
     * Pages missing from the list are dropped, so this single op covers reorder, rotate, and
     * delete at once.
     */
    private fun organizePages(
        path: String,
        password: String?,
        outputPath: String,
        pages: List<Map<String, Int>>,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val file = File(path)
                PDDocument.load(file, password ?: "").use { source ->
                    val pageCount = source.numberOfPages
                    PDDocument().use { target ->
                        for (entry in pages) {
                            val oneBased = entry["page"] ?: continue
                            val srcIndex = oneBased - 1
                            if (srcIndex < 0 || srcIndex >= pageCount) continue
                            val page = source.getPage(srcIndex)
                            val rotation = entry["rotation"] ?: 0
                            // Apply rotation on top of the page's existing rotation.
                            page.rotation = (page.rotation + rotation) % 360
                            target.importPage(page)
                        }
                        if (target.numberOfPages == 0) {
                            throw IllegalStateException("No pages left to save.")
                        }
                        target.save(outputPath)
                    }
                }
                main.post { result.success(outputPath) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not organize pages: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "This PDF is too large to organize.", null) }
            }
        }
    }

    /**
     * Best-effort compression: drops optional metadata and re-saves, letting PdfBox write
     * compressed object streams. It will not shrink an already-optimized file much.
     */
    private fun compressPdf(
        path: String,
        password: String?,
        outputPath: String,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val file = File(path)
                PDDocument.load(file, password ?: "").use { doc ->
                    // Strip optional metadata that only adds bytes.
                    doc.documentInformation = com.tom_roush.pdfbox.pdmodel.PDDocumentInformation()
                    doc.documentCatalog.metadata = null
                    doc.save(outputPath)
                }
                main.post { result.success(outputPath) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not compress PDF: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "This PDF is too large to compress.", null) }
            }
        }
    }

    /** Writes a password-protected copy at [outputPath]. Passwords are never logged (§11). */
    private fun encryptPdf(
        path: String,
        password: String?,
        outputPath: String,
        userPassword: String,
        ownerPassword: String?,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val file = File(path)
                PDDocument.load(file, password ?: "").use { doc ->
                    val owner = if (ownerPassword.isNullOrEmpty()) userPassword else ownerPassword
                    val ap = com.tom_roush.pdfbox.pdmodel.encryption.AccessPermission()
                    val policy = com.tom_roush.pdfbox.pdmodel.encryption.StandardProtectionPolicy(
                        owner, userPassword, ap
                    )
                    policy.encryptionKeyLength = 256
                    policy.setPreferAES(true)
                    doc.protect(policy)
                    doc.save(outputPath)
                }
                main.post { result.success(outputPath) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not protect PDF: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "This PDF is too large to protect.", null) }
            }
        }
    }

    /** Writes an unprotected copy at [outputPath] using the current [password]. */
    private fun decryptPdf(
        path: String,
        password: String,
        outputPath: String,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val file = File(path)
                PDDocument.load(file, password).use { doc ->
                    doc.setAllSecurityToBeRemoved(true)
                    doc.save(outputPath)
                }
                main.post { result.success(outputPath) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "That password did not unlock this PDF.", null) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not unlock PDF: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "This PDF is too large to unlock.", null) }
            }
        }
    }

    fun dispose() {
        io.shutdown()
    }

    companion object {
        const val CHANNEL = "in.sreerajp.pdfapp/pdfbox"
    }
}
