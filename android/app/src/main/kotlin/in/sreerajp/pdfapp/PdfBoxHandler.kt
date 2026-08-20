package `in`.sreerajp.pdfapp

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.pdf.PdfDocument
import android.os.Handler
import android.os.Looper
import android.text.Layout
import android.text.StaticLayout
import android.text.TextPaint
import com.tom_roush.pdfbox.android.PDFBoxResourceLoader
import com.tom_roush.pdfbox.pdmodel.PDDocument
import com.tom_roush.pdfbox.pdmodel.PDPage
import com.tom_roush.pdfbox.pdmodel.PDPageContentStream
import com.tom_roush.pdfbox.pdmodel.encryption.InvalidPasswordException
import com.tom_roush.pdfbox.pdmodel.font.PDType1Font
import com.tom_roush.pdfbox.pdmodel.graphics.color.PDColor
import com.tom_roush.pdfbox.pdmodel.graphics.color.PDDeviceRGB
import com.tom_roush.pdfbox.pdmodel.graphics.image.JPEGFactory
import com.tom_roush.pdfbox.pdmodel.graphics.image.LosslessFactory
import com.tom_roush.pdfbox.pdmodel.graphics.image.PDImageXObject
import com.tom_roush.pdfbox.pdmodel.graphics.state.PDExtendedGraphicsState
import com.tom_roush.pdfbox.pdmodel.interactive.annotation.PDAnnotationText
import com.tom_roush.pdfbox.pdmodel.common.PDRectangle
import com.tom_roush.pdfbox.pdmodel.interactive.documentnavigation.destination.PDPageFitDestination
import com.tom_roush.pdfbox.pdmodel.interactive.documentnavigation.outline.PDDocumentOutline
import com.tom_roush.pdfbox.pdmodel.interactive.documentnavigation.outline.PDOutlineItem
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
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
                "exportAnnotations" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val outputPath = call.argument<String>("outputPath")
                    val annotations = call.argument<List<Map<String, Any?>>>("annotations")
                    if (path.isNullOrEmpty() || outputPath.isNullOrEmpty() || annotations == null) {
                        result.error("bad_args", "Missing path, outputPath, or annotations.", null)
                    } else {
                        exportAnnotations(path, password, outputPath, annotations, result)
                    }
                }
                "imagesToPdf" -> {
                    val paths = call.argument<List<String>>("paths")
                    val outputPath = call.argument<String>("outputPath")
                    if (paths.isNullOrEmpty() || outputPath.isNullOrEmpty()) {
                        result.error("bad_args", "Missing paths or outputPath.", null)
                    } else {
                        imagesToPdf(paths, outputPath, result)
                    }
                }
                "textToPdf" -> {
                    val text = call.argument<String>("text")
                    val outputPath = call.argument<String>("outputPath")
                    if (text == null || outputPath.isNullOrEmpty()) {
                        result.error("bad_args", "Missing text or outputPath.", null)
                    } else {
                        textToPdf(text, outputPath, result)
                    }
                }
                "canWriteTextToPdf" -> {
                    val text = call.argument<String>("text")
                    if (text == null) {
                        result.error("bad_args", "Missing text.", null)
                    } else {
                        result.success(text.isNotBlank())
                    }
                }
                "trimPdfMargins" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val outputPath = call.argument<String>("outputPath")
                    val padding = (call.argument<Double>("padding") ?: 12.0).toFloat()
                    val symmetric = call.argument<Boolean>("symmetric") ?: true
                    if (path.isNullOrEmpty() || outputPath.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path or outputPath.", null)
                    } else {
                        trimPdfMargins(path, password, outputPath, padding, symmetric, result)
                    }
                }
                "generateBooklet" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val outputPath = call.argument<String>("outputPath")
                    val binding = call.argument<String>("binding") ?: "ltr"
                    val sheetSize = call.argument<String>("sheetSize") ?: "auto"
                    val addFoldGuide = call.argument<Boolean>("addFoldGuide") ?: true
                    val gutter = (call.argument<Double>("gutter") ?: 0.0).toFloat()
                    if (path.isNullOrEmpty() || outputPath.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path or outputPath.", null)
                    } else {
                        generateBooklet(path, password, outputPath, binding, sheetSize, addFoldGuide, gutter, result)
                    }
                }
                "applyWatermark" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val outputPath = call.argument<String>("outputPath")
                    val text = call.argument<String>("text")
                    val imagePath = call.argument<String>("imagePath")
                    val opacity = (call.argument<Double>("opacity") ?: 0.3).toFloat()
                    val rotation = (call.argument<Double>("rotation") ?: 45.0).toFloat()
                    val fontSize = (call.argument<Double>("fontSize") ?: 36.0).toFloat()
                    val colorHex = call.argument<String>("colorHex")
                    val isTiled = call.argument<Boolean>("isTiled") ?: false
                    val tileSpacingX = (call.argument<Double>("tileSpacingX") ?: 150.0).toFloat()
                    val tileSpacingY = (call.argument<Double>("tileSpacingY") ?: 150.0).toFloat()
                    val pageRange = call.argument<String>("pageRange")
                    if (path.isNullOrEmpty() || outputPath.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path or outputPath.", null)
                    } else {
                        applyWatermark(
                            path, password, outputPath, text, imagePath, opacity,
                            rotation, fontSize, colorHex, isTiled, tileSpacingX, tileSpacingY, pageRange, result
                        )
                    }
                }
                "generateNUpPdf" -> {
                    val path = call.argument<String>("path")
                    val password = call.argument<String>("password")
                    val outputPath = call.argument<String>("outputPath")
                    val gridCount = call.argument<Int>("gridCount") ?: 4
                    val sheetSize = call.argument<String>("sheetSize") ?: "a4"
                    val orientation = call.argument<String>("orientation") ?: "auto"
                    val addBorders = call.argument<Boolean>("addBorders") ?: true
                    val margin = (call.argument<Double>("margin") ?: 12.0).toFloat()
                    if (path.isNullOrEmpty() || outputPath.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path or outputPath.", null)
                    } else {
                        generateNUpPdf(path, password, outputPath, gridCount, sheetSize, orientation, addBorders, margin, result)
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

    /**
     * Writes a new copy at [outputPath] with the overlay [annotations] baked in (copy-on-write —
     * the source is only read).
     *
     * Each annotation is a map `{type, page (1-based), color (ARGB or null), ...shape}`. All
     * coordinates arrive **normalized** (0–1, top-left origin); we convert to PDF points using
     * each page's MediaBox (PDF's origin is bottom-left).
     *
     * Highlight, underline, strikethrough, and ink are painted straight into the page's content
     * stream so they render in every PDF viewer without depending on annotation-appearance
     * generation (which PdfBox-Android does not do, and it has no ink-annotation class). Notes
     * become real sticky-note ([PDAnnotationText]) annotations, and bookmarks become PDF outline
     * (contents) entries — there is no PDF "bookmark annotation".
     */
    private fun exportAnnotations(
        path: String,
        password: String?,
        outputPath: String,
        annotations: List<Map<String, Any?>>,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val file = File(path)
                PDDocument.load(file, password ?: "").use { doc ->
                    val pageCount = doc.numberOfPages

                    for (index in 0 until pageCount) {
                        val oneBased = index + 1
                        val forPage = annotations.filter {
                            (it["page"] as? Number)?.toInt() == oneBased &&
                                it["type"] != "bookmark"
                        }
                        if (forPage.isEmpty()) continue
                        val page = doc.getPage(index)
                        val box = page.mediaBox

                        val painted = forPage.filter { it["type"] != "note" }
                        if (painted.isNotEmpty()) {
                            PDPageContentStream(
                                doc, page, PDPageContentStream.AppendMode.APPEND, true, true
                            ).use { cs ->
                                for (a in painted) {
                                    when (a["type"]) {
                                        "highlight" -> drawHighlight(cs, box, a)
                                        "underline" -> drawMarkupLine(cs, box, a, atBottom = true)
                                        "strikethrough" -> drawMarkupLine(cs, box, a, atBottom = false)
                                        "ink" -> drawInk(cs, box, a)
                                    }
                                }
                            }
                        }
                        for (a in forPage.filter { it["type"] == "note" }) {
                            addNote(page, box, a)
                        }
                    }

                    val bookmarks = annotations.filter { it["type"] == "bookmark" }
                    if (bookmarks.isNotEmpty()) addBookmarks(doc, bookmarks, pageCount)
                    doc.save(outputPath)
                }
                main.post { result.success(outputPath) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not export annotations: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "This PDF is too large to export.", null) }
            }
        }
    }

    // Normalized X (0–1, left origin) -> PDF X point.
    private fun pdfX(nx: Float, box: PDRectangle) = box.lowerLeftX + nx * box.width

    // Normalized Y (0–1, TOP origin) -> PDF Y point (bottom origin: flip).
    private fun pdfY(ny: Float, box: PDRectangle) = box.upperRightY - ny * box.height

    // ARGB int -> RGB floats, or [fallback] when there is no colour.
    private fun rgbOf(a: Map<String, Any?>, fallback: FloatArray): FloatArray {
        val argb = (a["color"] as? Number)?.toInt() ?: return fallback
        return floatArrayOf(
            ((argb shr 16) and 0xFF) / 255f,
            ((argb shr 8) and 0xFF) / 255f,
            (argb and 0xFF) / 255f,
        )
    }

    @Suppress("UNCHECKED_CAST")
    private fun drawHighlight(cs: PDPageContentStream, box: PDRectangle, a: Map<String, Any?>) {
        val quads = a["quads"] as? List<List<Number>> ?: return
        val rgb = rgbOf(a, floatArrayOf(1f, 0.92f, 0.23f)) // yellow
        // A translucent fill so the text underneath stays readable.
        val gs = PDExtendedGraphicsState()
        gs.setNonStrokingAlphaConstant(0.35f)
        cs.setGraphicsStateParameters(gs)
        cs.setNonStrokingColor(rgb[0], rgb[1], rgb[2])
        for (q in quads) {
            val (x, y, w, h) = pdfRect(q, box) ?: continue
            cs.addRect(x, y, w, h)
        }
        cs.fill()
    }

    @Suppress("UNCHECKED_CAST")
    private fun drawMarkupLine(
        cs: PDPageContentStream, box: PDRectangle, a: Map<String, Any?>, atBottom: Boolean
    ) {
        val quads = a["quads"] as? List<List<Number>> ?: return
        val rgb = rgbOf(a, floatArrayOf(0.9f, 0.2f, 0.2f)) // red
        cs.setStrokingColor(rgb[0], rgb[1], rgb[2])
        cs.setLineCapStyle(1)
        for (q in quads) {
            val (x, y, w, h) = pdfRect(q, box) ?: continue
            // Underline sits near the baseline; strike crosses the middle.
            val lineY = if (atBottom) y + h * 0.08f else y + h * 0.5f
            cs.setLineWidth((h * 0.06f).coerceIn(0.6f, 3f))
            cs.moveTo(x, lineY)
            cs.lineTo(x + w, lineY)
            cs.stroke()
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun drawInk(cs: PDPageContentStream, box: PDRectangle, a: Map<String, Any?>) {
        val strokes = a["strokes"] as? List<Map<String, Any?>> ?: return
        val rgb = rgbOf(a, floatArrayOf(0.1f, 0.1f, 0.9f)) // blue
        cs.setStrokingColor(rgb[0], rgb[1], rgb[2])
        cs.setLineCapStyle(1)
        cs.setLineJoinStyle(1)
        for (stroke in strokes) {
            val pts = stroke["pts"] as? List<List<Number>> ?: continue
            if (pts.size < 2) continue
            val widthNorm = (stroke["w"] as? Number)?.toFloat() ?: 0.004f
            cs.setLineWidth((widthNorm * box.width).coerceAtLeast(0.6f))
            val first = pts.first()
            cs.moveTo(pdfX(first[0].toFloat(), box), pdfY(first[1].toFloat(), box))
            for (i in 1 until pts.size) {
                val p = pts[i]
                cs.lineTo(pdfX(p[0].toFloat(), box), pdfY(p[1].toFloat(), box))
            }
            cs.stroke()
        }
    }

    // A normalized [x,y,w,h] quad (top-left origin) -> PDF rect (x, y, w, h) with bottom-left
    // origin, ready for addRect. Returns null on a malformed quad.
    private fun pdfRect(q: List<Number>, box: PDRectangle): FloatArray? {
        if (q.size < 4) return null
        val nx = q[0].toFloat(); val ny = q[1].toFloat()
        val nw = q[2].toFloat(); val nh = q[3].toFloat()
        val left = pdfX(nx, box)
        val bottom = pdfY(ny + nh, box) // lower edge has the larger normalized Y
        return floatArrayOf(left, bottom, nw * box.width, nh * box.height)
    }

    @Suppress("UNCHECKED_CAST")
    private fun addNote(page: PDPage, box: PDRectangle, a: Map<String, Any?>) {
        val at = a["at"] as? List<Number> ?: return
        val x = pdfX(at[0].toFloat(), box)
        val y = pdfY(at[1].toFloat(), box)
        val note = PDAnnotationText()
        note.setContents(a["text"] as? String ?: "")
        note.name = PDAnnotationText.NAME_NOTE
        val rgb = rgbOf(a, floatArrayOf(1f, 0.85f, 0.2f))
        note.color = PDColor(rgb, PDDeviceRGB.INSTANCE)
        note.setOpen(false)
        // Sticky-note icon is ~18pt square; anchor its top-left at the tap point.
        note.rectangle = PDRectangle(x, y - 18f, 18f, 18f)
        page.annotations.add(note)
    }

    private fun addBookmarks(doc: PDDocument, bookmarks: List<Map<String, Any?>>, pageCount: Int) {
        val outline = doc.documentCatalog.documentOutline ?: PDDocumentOutline().also {
            doc.documentCatalog.documentOutline = it
        }
        // Show marks in page order for a tidy contents list.
        val sorted = bookmarks.sortedBy { (it["page"] as? Number)?.toInt() ?: 0 }
        for ((i, b) in sorted.withIndex()) {
            val oneBased = (b["page"] as? Number)?.toInt() ?: continue
            val index = oneBased - 1
            if (index < 0 || index >= pageCount) continue
            val label = (b["label"] as? String).let { if (it.isNullOrBlank()) "Page $oneBased" else it }
            val item = PDOutlineItem()
            item.title = label
            val dest = PDPageFitDestination()
            dest.page = doc.getPage(index)
            item.destination = dest
            outline.addLast(item)
            if (i == 0) outline.openNode()
        }
    }

    // --- Building a PDF from incoming content (Phase 6). Always a NEW file. ---

    /**
     * Builds a new PDF at [outputPath] with one page per image in [paths] (in order).
     *
     * Each page is A4 with a small margin; the picture is scaled to fit and centred, keeping
     * its shape. Big pictures are sampled down while decoding — a modern phone photo would
     * otherwise eat the heap for no visible gain at print size.
     */
    private fun imagesToPdf(paths: List<String>, outputPath: String, result: MethodChannel.Result) {
        io.execute {
            try {
                check(resourcesReady)
                PDDocument().use { doc ->
                    var added = 0
                    for (p in paths) {
                        val bitmap = decodeScaled(p) ?: continue
                        try {
                            val page = PDPage(PDRectangle.A4)
                            doc.addPage(page)
                            // A picture with see-through parts must stay lossless; JPEG would
                            // turn those parts black. Everything else takes the smaller JPEG.
                            val image: PDImageXObject = if (bitmap.hasAlpha()) {
                                LosslessFactory.createFromImage(doc, bitmap)
                            } else {
                                JPEGFactory.createFromImage(doc, bitmap, JPEG_QUALITY)
                            }
                            PDPageContentStream(doc, page).use { cs ->
                                val box = page.mediaBox
                                val maxW = box.width - PAGE_MARGIN * 2
                                val maxH = box.height - PAGE_MARGIN * 2
                                val scale = minOf(maxW / image.width, maxH / image.height)
                                val w = image.width * scale
                                val h = image.height * scale
                                val x = box.lowerLeftX + (box.width - w) / 2
                                val y = box.lowerLeftY + (box.height - h) / 2
                                cs.drawImage(image, x, y, w, h)
                            }
                            added++
                        } finally {
                            bitmap.recycle()
                        }
                    }
                    if (added == 0) {
                        throw IllegalStateException("None of the pictures could be read.")
                    }
                    doc.save(outputPath)
                }
                main.post { result.success(outputPath) }
            } catch (e: Exception) {
                main.post {
                    result.error("op_failed", "Could not make a PDF from these pictures: ${e.message}", null)
                }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "These pictures are too large to make a PDF.", null) }
            }
        }
    }

    /**
     * Decodes the image at [path], sampled down so its longest side is near [MAX_IMAGE_PX].
     * Returns null if the file is not a picture we can read — the caller skips it rather than
     * failing the whole job.
     */
    private fun decodeScaled(path: String): Bitmap? {
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(path, bounds)
        if (bounds.outWidth <= 0 || bounds.outHeight <= 0) return null

        var sample = 1
        val longest = maxOf(bounds.outWidth, bounds.outHeight)
        while (longest / sample > MAX_IMAGE_PX) sample *= 2

        val opts = BitmapFactory.Options().apply { inSampleSize = sample }
        return BitmapFactory.decodeFile(path, opts)
    }

    /**
     * Builds a new PDF at [outputPath] holding [text], wrapped onto A4 pages.
     *
     * Uses Android's native [PdfDocument] with [StaticLayout] and [TextPaint]. This utilizes
     * the system font engine (HarfBuzz) to provide full complex script shaping (Malayalam,
     * Devanagari, Tamil, etc.), bidirectional text, font fallback, and TrueType subset embedding
     * with valid /ToUnicode CMaps so the generated text is fully searchable and copyable.
     */
    private fun textToPdf(text: String, outputPath: String, result: MethodChannel.Result) {
        io.execute {
            try {
                if (text.isBlank()) throw IllegalStateException("There is no text to save.")

                val cleaned = text.replace("\r\n", "\n").replace("\r", "\n").replace("\t", "    ")
                val textPaint = TextPaint().apply {
                    isAntiAlias = true
                    textSize = TEXT_FONT_SIZE
                    color = Color.BLACK
                }

                val pageWidth = PDRectangle.A4.width.toInt()
                val pageHeight = PDRectangle.A4.height.toInt()
                val printableWidth = (pageWidth - PAGE_MARGIN * 2).toInt()
                val printableHeight = pageHeight - PAGE_MARGIN * 2

                val layout = StaticLayout.Builder.obtain(
                    cleaned,
                    0,
                    cleaned.length,
                    textPaint,
                    printableWidth
                )
                    .setAlignment(Layout.Alignment.ALIGN_NORMAL)
                    .setLineSpacing(0f, 1.25f)
                    .setIncludePad(false)
                    .build()

                val lineCount = layout.lineCount
                val pdfDoc = PdfDocument()

                var startLine = 0
                var pageNum = 1

                while (startLine < lineCount && pageNum <= MAX_TEXT_PAGES) {
                    val startY = layout.getLineTop(startLine)
                    var endLine = startLine
                    while (endLine < lineCount && (layout.getLineBottom(endLine) - startY) <= printableHeight) {
                        endLine++
                    }
                    if (endLine == startLine) {
                        endLine = startLine + 1
                    }

                    val pageInfo = PdfDocument.PageInfo.Builder(pageWidth, pageHeight, pageNum).create()
                    val page = pdfDoc.startPage(pageInfo)
                    val canvas = page.canvas

                    canvas.save()
                    canvas.clipRect(
                        PAGE_MARGIN,
                        PAGE_MARGIN,
                        PAGE_MARGIN + printableWidth,
                        PAGE_MARGIN + printableHeight
                    )
                    canvas.translate(PAGE_MARGIN, PAGE_MARGIN - startY)
                    layout.draw(canvas)
                    canvas.restore()

                    pdfDoc.finishPage(page)
                    pageNum++
                    startLine = endLine
                }

                if (startLine < lineCount) {
                    pdfDoc.close()
                    throw IllegalStateException("This text is too long to save as a PDF.")
                }

                FileOutputStream(outputPath).use { out ->
                    pdfDoc.writeTo(out)
                }
                pdfDoc.close()

                main.post { result.success(outputPath) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not save this text as a PDF: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "This text is too long to save as a PDF.", null) }
            }
        }
    }

    // --- Phase 11 / Feature 2.7: Smart Margin Trimming & Foldable Booklet Imposition ---

    /**
     * Crops blank page margins from [path] by finding non-white content bounding boxes,
     * writing a new copy-on-write PDF to [outputPath] with updated CropBox.
     */
    private fun trimPdfMargins(
        path: String,
        password: String?,
        outputPath: String,
        padding: Float,
        symmetric: Boolean,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val file = File(path)
                PDDocument.load(file, password ?: "").use { doc ->
                    val renderer = com.tom_roush.pdfbox.rendering.PDFRenderer(doc)
                    val pageCount = doc.numberOfPages

                    for (i in 0 until pageCount) {
                        val page = doc.getPage(i)
                        val mediaBox = page.mediaBox ?: PDRectangle.A4
                        val mediaW = mediaBox.width
                        val mediaH = mediaBox.height

                        // Sample at 50 DPI for fast bounding box analysis
                        val sampleDpi = 50f
                        val bitmap = renderer.renderImageWithDPI(i, sampleDpi)
                        val bw = bitmap.width
                        val bh = bitmap.height

                        var minXPixel = bw
                        var maxXPixel = 0
                        var minYPixel = bh
                        var maxYPixel = 0
                        var hasContent = false

                        val pixels = IntArray(bw * bh)
                        bitmap.getPixels(pixels, 0, bw, 0, 0, bw, bh)

                        for (y in 0 until bh) {
                            val rowOffset = y * bw
                            for (x in 0 until bw) {
                                val pixel = pixels[rowOffset + x]
                                val alpha = (pixel ushr 24) and 0xFF
                                val r = (pixel ushr 16) and 0xFF
                                val g = (pixel ushr 8) and 0xFF
                                val b = pixel and 0xFF

                                if (alpha > 30 && (r < 242 || g < 242 || b < 242)) {
                                    hasContent = true
                                    if (x < minXPixel) minXPixel = x
                                    if (x > maxXPixel) maxXPixel = x
                                    if (y < minYPixel) minYPixel = y
                                    if (y > maxYPixel) maxYPixel = y
                                }
                            }
                        }

                        if (!hasContent || minXPixel >= maxXPixel || minYPixel >= maxYPixel) {
                            page.cropBox = mediaBox
                            continue
                        }

                        var leftPt = mediaBox.lowerLeftX + (minXPixel.toFloat() / bw) * mediaW
                        var rightPt = mediaBox.lowerLeftX + ((maxXPixel + 1).toFloat() / bw) * mediaW
                        var topPt = mediaBox.upperRightY - (minYPixel.toFloat() / bh) * mediaH
                        var bottomPt = mediaBox.upperRightY - ((maxYPixel + 1).toFloat() / bh) * mediaH

                        leftPt = (leftPt - padding).coerceAtLeast(mediaBox.lowerLeftX)
                        rightPt = (rightPt + padding).coerceAtMost(mediaBox.upperRightX)
                        bottomPt = (bottomPt - padding).coerceAtLeast(mediaBox.lowerLeftY)
                        topPt = (topPt + padding).coerceAtMost(mediaBox.upperRightY)

                        if (symmetric) {
                            val leftMargin = leftPt - mediaBox.lowerLeftX
                            val rightMargin = mediaBox.upperRightX - rightPt
                            val minHorizontalMargin = minOf(leftMargin, rightMargin)
                            leftPt = mediaBox.lowerLeftX + minHorizontalMargin
                            rightPt = mediaBox.upperRightX - minHorizontalMargin

                            val bottomMargin = bottomPt - mediaBox.lowerLeftY
                            val topMargin = mediaBox.upperRightY - topPt
                            val minVerticalMargin = minOf(bottomMargin, topMargin)
                            bottomPt = mediaBox.lowerLeftY + minVerticalMargin
                            topPt = mediaBox.upperRightY - minVerticalMargin
                        }

                        val cropW = (rightPt - leftPt).coerceAtLeast(50f)
                        val cropH = (topPt - bottomPt).coerceAtLeast(50f)

                        page.cropBox = PDRectangle(leftPt, bottomPt, cropW, cropH)
                    }

                    doc.save(outputPath)
                }
                main.post { result.success(outputPath) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not trim PDF margins: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "This PDF is too large to process.", null) }
            }
        }
    }

    /**
     * Generates a 2-Up foldable booklet imposition PDF from [path], writing to [outputPath].
     */
    private fun generateBooklet(
        path: String,
        password: String?,
        outputPath: String,
        binding: String,
        sheetSize: String,
        addFoldGuide: Boolean,
        gutter: Float,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val srcFile = File(path)
                PDDocument.load(srcFile, password ?: "").use { srcDoc ->
                    val totalPages = srcDoc.numberOfPages
                    if (totalPages == 0) {
                        main.post { result.error("bad_args", "The PDF has no pages.", null) }
                        return@execute
                    }

                    PDDocument().use { outDoc ->
                        val layerUtility = com.tom_roush.pdfbox.multipdf.LayerUtility(outDoc)
                        val isRtl = binding.equals("rtl", ignoreCase = true)

                        val paddedPages = ((totalPages + 3) / 4) * 4
                        val totalSheets = paddedPages / 4

                        val firstPageBox = srcDoc.getPage(0).mediaBox ?: PDRectangle.A4
                        val (sheetWidth, sheetHeight) = when (sheetSize.lowercase()) {
                            "a4" -> Pair(842f, 595f)
                            "letter" -> Pair(792f, 612f)
                            else -> {
                                val srcW = firstPageBox.width
                                val srcH = firstPageBox.height
                                Pair(srcW * 2f, srcH)
                            }
                        }

                        for (i in 0 until totalSheets) {
                            // Sheet i Front (Side 1)
                            val frontLeftNum = if (isRtl) 1 + (2 * i) else paddedPages - (2 * i)
                            val frontRightNum = if (isRtl) paddedPages - (2 * i) else 1 + (2 * i)

                            renderBookletSheetFace(
                                outDoc,
                                layerUtility,
                                srcDoc,
                                sheetWidth,
                                sheetHeight,
                                frontLeftNum,
                                frontRightNum,
                                totalPages,
                                addFoldGuide,
                                gutter
                            )

                            // Sheet i Back (Side 2)
                            val backLeftNum = if (isRtl) paddedPages - (2 * i) - 1 else 2 + (2 * i)
                            val backRightNum = if (isRtl) 2 + (2 * i) else paddedPages - (2 * i) - 1

                            renderBookletSheetFace(
                                outDoc,
                                layerUtility,
                                srcDoc,
                                sheetWidth,
                                sheetHeight,
                                backLeftNum,
                                backRightNum,
                                totalPages,
                                addFoldGuide,
                                gutter
                            )
                        }

                        outDoc.save(outputPath)
                    }
                }
                main.post { result.success(outputPath) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not generate booklet: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "This PDF is too large to process.", null) }
            }
        }
    }

    private fun renderBookletSheetFace(
        outDoc: PDDocument,
        layerUtil: com.tom_roush.pdfbox.multipdf.LayerUtility,
        srcDoc: PDDocument,
        sheetW: Float,
        sheetH: Float,
        leftPageNum: Int,
        rightPageNum: Int,
        totalPages: Int,
        addFoldGuide: Boolean,
        gutter: Float
    ) {
        val sheetPage = PDPage(PDRectangle(sheetW, sheetH))
        outDoc.addPage(sheetPage)

        val halfW = sheetW / 2f

        PDPageContentStream(outDoc, sheetPage, PDPageContentStream.AppendMode.OVERWRITE, false, false).use { cs ->
            if (leftPageNum in 1..totalPages) {
                val form = layerUtil.importPageAsForm(srcDoc, leftPageNum - 1)
                drawFormInRect(cs, form, 0f + (gutter / 2f), 0f, halfW - gutter, sheetH)
            }

            if (rightPageNum in 1..totalPages) {
                val form = layerUtil.importPageAsForm(srcDoc, rightPageNum - 1)
                drawFormInRect(cs, form, halfW + (gutter / 2f), 0f, halfW - gutter, sheetH)
            }

            if (addFoldGuide) {
                cs.setStrokingColor(0.7f, 0.7f, 0.7f)
                cs.setLineWidth(0.75f)
                cs.setLineDashPattern(floatArrayOf(4f, 4f), 0f)
                cs.moveTo(halfW, 0f)
                cs.lineTo(halfW, sheetH)
                cs.stroke()
            }
        }
    }

    private fun drawFormInRect(
        cs: PDPageContentStream,
        form: com.tom_roush.pdfbox.pdmodel.graphics.form.PDFormXObject,
        targetX: Float,
        targetY: Float,
        targetW: Float,
        targetH: Float
    ) {
        val bBox = form.bBox ?: PDRectangle.A4
        val srcW = bBox.width
        val srcH = bBox.height
        if (srcW <= 0 || srcH <= 0) return

        val scale = minOf(targetW / srcW, targetH / srcH)
        val renderedW = srcW * scale
        val renderedH = srcH * scale
        val offsetX = targetX + (targetW - renderedW) / 2f
        val offsetY = targetY + (targetH - renderedH) / 2f

        cs.saveGraphicsState()
        val matrix = com.tom_roush.pdfbox.util.Matrix()
        matrix.translate(offsetX, offsetY)
        matrix.scale(scale, scale)
        cs.transform(matrix)
        cs.drawForm(form)
        cs.restoreGraphicsState()
    }

    private fun applyWatermark(
        path: String,
        password: String?,
        outputPath: String,
        text: String?,
        imagePath: String?,
        opacity: Float,
        rotationDegrees: Float,
        fontSize: Float,
        colorHex: String?,
        isTiled: Boolean,
        tileSpacingX: Float,
        tileSpacingY: Float,
        pageRange: String?,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val srcFile = File(path)
                PDDocument.load(srcFile, password ?: "").use { doc ->
                    val totalPages = doc.numberOfPages
                    if (totalPages == 0) {
                        main.post { result.error("bad_args", "The PDF has no pages.", null) }
                        return@execute
                    }

                    val targetPages = parsePageRange(pageRange, totalPages)
                    val r: Float
                    val g: Float
                    val b: Float
                    if (!colorHex.isNullOrBlank() && colorHex.startsWith("#") && colorHex.length >= 7) {
                        val parsed = Color.parseColor(colorHex)
                        r = Color.red(parsed) / 255f
                        g = Color.green(parsed) / 255f
                        b = Color.blue(parsed) / 255f
                    } else {
                        r = 0.5f
                        g = 0.5f
                        b = 0.5f
                    }

                    val font = PDType1Font.HELVETICA_BOLD
                    val rad = Math.toRadians(rotationDegrees.toDouble()).toFloat()

                    val imageObj: PDImageXObject? = if (!imagePath.isNullOrEmpty() && File(imagePath).exists()) {
                        try {
                            val bmp = BitmapFactory.decodeFile(imagePath)
                            if (bmp != null) LosslessFactory.createFromImage(doc, bmp) else null
                        } catch (_: Exception) { null }
                    } else null

                    for (pageIdx in targetPages) {
                        val page = doc.getPage(pageIdx)
                        val box = page.cropBox ?: page.mediaBox ?: PDRectangle.A4
                        val pageW = box.width
                        val pageH = box.height

                        val extGState = PDExtendedGraphicsState().apply {
                            nonStrokingAlphaConstant = opacity
                            strokingAlphaConstant = opacity
                        }

                        PDPageContentStream(doc, page, PDPageContentStream.AppendMode.APPEND, true, true).use { cs ->
                            cs.setGraphicsStateParameters(extGState)

                            if (imageObj != null) {
                                val imgW = imageObj.width.toFloat()
                                val imgH = imageObj.height.toFloat()
                                val scale = minOf(pageW / (imgW * 2f), pageH / (imgH * 2f)).coerceIn(0.1f, 1.0f)
                                val drawW = imgW * scale
                                val drawH = imgH * scale

                                if (isTiled) {
                                    val stepX = maxOf(drawW + tileSpacingX, 100f)
                                    val stepY = maxOf(drawH + tileSpacingY, 100f)
                                    var y = stepY / 2f
                                    while (y < pageH) {
                                        var x = stepX / 2f
                                        while (x < pageW) {
                                            cs.saveGraphicsState()
                                            val m = com.tom_roush.pdfbox.util.Matrix()
                                            m.translate(x, y)
                                            m.rotate(rad.toDouble())
                                            m.translate(-drawW / 2f, -drawH / 2f)
                                            cs.transform(m)
                                            cs.drawImage(imageObj, 0f, 0f, drawW, drawH)
                                            cs.restoreGraphicsState()
                                            x += stepX
                                        }
                                        y += stepY
                                    }
                                } else {
                                    cs.saveGraphicsState()
                                    val m = com.tom_roush.pdfbox.util.Matrix()
                                    m.translate(pageW / 2f, pageH / 2f)
                                    m.rotate(rad.toDouble())
                                    m.translate(-drawW / 2f, -drawH / 2f)
                                    cs.transform(m)
                                    cs.drawImage(imageObj, 0f, 0f, drawW, drawH)
                                    cs.restoreGraphicsState()
                                }
                            }

                            if (!text.isNullOrBlank()) {
                                cs.setNonStrokingColor(r, g, b)
                                val textWidth = (font.getStringWidth(text) / 1000f) * fontSize
                                val textHeight = fontSize * 0.75f

                                if (isTiled) {
                                    val stepX = maxOf(textWidth + tileSpacingX, 120f)
                                    val stepY = maxOf(fontSize + tileSpacingY, 100f)
                                    var y = stepY / 2f
                                    while (y < pageH) {
                                        var x = stepX / 2f
                                        while (x < pageW) {
                                            cs.saveGraphicsState()
                                            val m = com.tom_roush.pdfbox.util.Matrix()
                                            m.translate(x, y)
                                            m.rotate(rad.toDouble())
                                            m.translate(-textWidth / 2f, -textHeight / 2f)
                                            cs.transform(m)
                                            cs.beginText()
                                            cs.setFont(font, fontSize)
                                            cs.showText(text)
                                            cs.endText()
                                            cs.restoreGraphicsState()
                                            x += stepX
                                        }
                                        y += stepY
                                    }
                                } else {
                                    cs.saveGraphicsState()
                                    val m = com.tom_roush.pdfbox.util.Matrix()
                                    m.translate(pageW / 2f, pageH / 2f)
                                    m.rotate(rad.toDouble())
                                    m.translate(-textWidth / 2f, -textHeight / 2f)
                                    cs.transform(m)
                                    cs.beginText()
                                    cs.setFont(font, fontSize)
                                    cs.showText(text)
                                    cs.endText()
                                    cs.restoreGraphicsState()
                                }
                            }
                        }
                    }

                    doc.save(outputPath)
                }
                main.post { result.success(outputPath) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not apply watermark: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "This PDF is too large to process.", null) }
            }
        }
    }

    private fun parsePageRange(range: String?, totalPages: Int): List<Int> {
        if (range.isNullOrBlank() || range.equals("all", ignoreCase = true)) {
            return (0 until totalPages).toList()
        }
        if (range.equals("odd", ignoreCase = true)) {
            return (0 until totalPages step 2).toList()
        }
        if (range.equals("even", ignoreCase = true)) {
            return (1 until totalPages step 2).toList()
        }
        val pages = mutableSetOf<Int>()
        for (part in range.split(",")) {
            val trimmed = part.trim()
            if (trimmed.contains("-")) {
                val bounds = trimmed.split("-")
                val start = bounds[0].trim().toIntOrNull() ?: 1
                val end = bounds.getOrNull(1)?.trim()?.toIntOrNull() ?: totalPages
                for (p in start..end) {
                    if (p in 1..totalPages) pages.add(p - 1)
                }
            } else {
                val p = trimmed.toIntOrNull()
                if (p != null && p in 1..totalPages) {
                    pages.add(p - 1)
                }
            }
        }
        return if (pages.isEmpty()) (0 until totalPages).toList() else pages.sorted()
    }

    private fun generateNUpPdf(
        path: String,
        password: String?,
        outputPath: String,
        gridCount: Int,
        sheetSize: String,
        orientation: String,
        addBorders: Boolean,
        margin: Float,
        result: MethodChannel.Result
    ) {
        io.execute {
            try {
                check(resourcesReady)
                val srcFile = File(path)
                PDDocument.load(srcFile, password ?: "").use { srcDoc ->
                    val totalPages = srcDoc.numberOfPages
                    if (totalPages == 0) {
                        main.post { result.error("bad_args", "The PDF has no pages.", null) }
                        return@execute
                    }

                    PDDocument().use { outDoc ->
                        val layerUtil = com.tom_roush.pdfbox.multipdf.LayerUtility(outDoc)

                        var baseW: Float
                        var baseH: Float
                        when (sheetSize.lowercase()) {
                            "letter" -> { baseW = 612f; baseH = 792f }
                            else -> { baseW = 595f; baseH = 842f } // A4
                        }

                        val (cols, rows, sheetLandscape) = when (gridCount) {
                            2 -> Triple(2, 1, true)
                            4 -> Triple(2, 2, false)
                            6 -> Triple(3, 2, true)
                            9 -> Triple(3, 3, false)
                            else -> Triple(2, 2, false)
                        }

                        val forceOrientation = orientation.lowercase()
                        val isLandscape = when (forceOrientation) {
                            "landscape" -> true
                            "portrait" -> false
                            else -> sheetLandscape
                        }

                        val sheetW = if (isLandscape) maxOf(baseW, baseH) else minOf(baseW, baseH)
                        val sheetH = if (isLandscape) minOf(baseW, baseH) else maxOf(baseW, baseH)

                        val cellW = (sheetW - (margin * 2f)) / cols
                        val cellH = (sheetH - (margin * 2f)) / rows

                        val totalSheets = (totalPages + gridCount - 1) / gridCount

                        for (sheetIdx in 0 until totalSheets) {
                            val sheetPage = PDPage(PDRectangle(sheetW, sheetH))
                            outDoc.addPage(sheetPage)

                            PDPageContentStream(outDoc, sheetPage, PDPageContentStream.AppendMode.OVERWRITE, false, false).use { cs ->
                                for (slot in 0 until gridCount) {
                                    val pageNum = sheetIdx * gridCount + slot + 1
                                    if (pageNum > totalPages) break

                                    val col = slot % cols
                                    val row = slot / cols
                                    val cellX = margin + (col * cellW)
                                    val cellY = sheetH - margin - ((row + 1) * cellH)

                                    val form = layerUtil.importPageAsForm(srcDoc, pageNum - 1)
                                    drawFormInRect(cs, form, cellX + 2f, cellY + 2f, cellW - 4f, cellH - 4f)

                                    if (addBorders) {
                                        cs.saveGraphicsState()
                                        cs.setStrokingColor(0.8f, 0.8f, 0.8f)
                                        cs.setLineWidth(0.5f)
                                        cs.addRect(cellX, cellY, cellW, cellH)
                                        cs.stroke()
                                        cs.restoreGraphicsState()
                                    }
                                }
                            }
                        }

                        outDoc.save(outputPath)
                    }
                }
                main.post { result.success(outputPath) }
            } catch (e: InvalidPasswordException) {
                main.post { result.error("password_required", "This PDF is locked.", null) }
            } catch (e: Exception) {
                main.post { result.error("op_failed", "Could not generate N-Up layout: ${e.message}", null) }
            } catch (e: OutOfMemoryError) {
                main.post { result.error("op_failed", "This PDF is too large to process.", null) }
            }
        }
    }

    fun dispose() {
        io.shutdown()
    }

    companion object {
        const val CHANNEL = "in.sreerajp.pdfapp/pdfbox"

        // --- Phase 6: building a PDF from incoming content ---
        /** Blank edge kept around pictures and text, in PDF points (~8.5 mm). */
        private const val PAGE_MARGIN = 24f
        /** JPEG quality for photos placed on a page. High enough to look clean in print. */
        private const val JPEG_QUALITY = 0.85f
        /** Longest side a picture is sampled down to before it goes on a page. */
        private const val MAX_IMAGE_PX = 2400
        private const val TEXT_FONT_SIZE = 11f
        /** Line-to-line distance; ~1.3x the font size reads comfortably. */
        private const val TEXT_LEADING = 14f
        /** Refuse absurdly long text rather than grinding the device to a halt. */
        private const val MAX_TEXT_PAGES = 500
    }
}
