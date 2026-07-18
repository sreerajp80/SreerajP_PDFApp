package `in`.sreerajp.pdfapp

import android.app.Activity
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.CancellationSignal
import android.os.ParcelFileDescriptor
import android.print.PageRange
import android.print.PrintAttributes
import android.print.PrintDocumentAdapter
import android.print.PrintDocumentInfo
import android.print.PrintManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

/**
 * Android print-framework bridge (Phase 6).
 *
 * Hands an existing PDF file to the system print spooler. Android then draws the whole print
 * dialog — printer choice, copies, paper size, and its own built-in "Save as PDF" printer — so
 * the app does not need any of that itself.
 *
 * The adapter only ever *reads* the file it is given, and the file is always one the app made
 * in its own cache. Page ranges are handled before we get here, by writing a range-only copy
 * with PdfBox: the spooler's own range handling would need the adapter to re-cut the document
 * on the fly, which is easy to get subtly wrong.
 *
 * Nothing here throws into Flutter — a device with no printing support becomes a typed error
 * the Dart side turns into a friendly message (project rule: never crash).
 */
class PrintHandler(private val activity: Activity, messenger: BinaryMessenger) {

    init {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "printPdf" -> {
                    val path = call.argument<String>("path")
                    val jobName = call.argument<String>("jobName")
                    if (path.isNullOrEmpty() || jobName.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path or jobName.", null)
                    } else {
                        printPdf(path, jobName, result)
                    }
                }
                "isPrintingAvailable" -> result.success(isPrintingAvailable())
                else -> result.notImplemented()
            }
        }
    }

    /** True when this device can print at all. Some Android builds ship without it. */
    private fun isPrintingAvailable(): Boolean {
        val hasFeature = activity.packageManager.hasSystemFeature(PackageManager.FEATURE_PRINTING)
        val hasService = activity.getSystemService(Activity.PRINT_SERVICE) != null
        return hasFeature && hasService
    }

    /**
     * Opens the system print dialog for the PDF at [path].
     *
     * Returns as soon as the dialog is handed over. What the user then does — print, save,
     * or cancel — happens inside the system UI and is not reported back; that is how the
     * Android print framework works, and there is nothing for the app to undo either way.
     */
    private fun printPdf(path: String, jobName: String, result: MethodChannel.Result) {
        val file = File(path)
        if (!file.exists()) {
            result.error("file_not_found", "The file to print is gone.", null)
            return
        }
        if (!isPrintingAvailable()) {
            result.error("print_unavailable", "This device cannot print.", null)
            return
        }
        val printManager = activity.getSystemService(Activity.PRINT_SERVICE) as? PrintManager
        if (printManager == null) {
            result.error("print_unavailable", "This device cannot print.", null)
            return
        }
        try {
            val attributes = PrintAttributes.Builder()
                .setMediaSize(PrintAttributes.MediaSize.ISO_A4)
                .setColorMode(PrintAttributes.COLOR_MODE_COLOR)
                .build()
            printManager.print(jobName, PdfFileAdapter(file, jobName), attributes)
            result.success(null)
        } catch (e: Exception) {
            result.error("print_failed", "Could not start printing.", e.message)
        }
    }

    /** Streams one already-built PDF file to the print spooler. */
    private class PdfFileAdapter(
        private val file: File,
        private val jobName: String,
    ) : PrintDocumentAdapter() {

        override fun onLayout(
            oldAttributes: PrintAttributes?,
            newAttributes: PrintAttributes?,
            cancellationSignal: CancellationSignal?,
            callback: LayoutResultCallback?,
            extras: Bundle?,
        ) {
            if (cancellationSignal?.isCanceled == true) {
                callback?.onLayoutCancelled()
                return
            }
            // The file is already laid out as a PDF, so a change of paper or orientation
            // never re-flows it: the content is the same bytes every time.
            val info = PrintDocumentInfo.Builder(jobName)
                .setContentType(PrintDocumentInfo.CONTENT_TYPE_DOCUMENT)
                .setPageCount(PrintDocumentInfo.PAGE_COUNT_UNKNOWN)
                .build()
            callback?.onLayoutFinished(info, false)
        }

        override fun onWrite(
            pages: Array<out PageRange>?,
            destination: ParcelFileDescriptor?,
            cancellationSignal: CancellationSignal?,
            callback: WriteResultCallback?,
        ) {
            if (destination == null) {
                callback?.onWriteFailed("No place to write the document.")
                return
            }
            try {
                file.inputStream().use { input ->
                    FileOutputStream(destination.fileDescriptor).use { output ->
                        val buffer = ByteArray(16 * 1024)
                        while (true) {
                            if (cancellationSignal?.isCanceled == true) {
                                callback?.onWriteCancelled()
                                return
                            }
                            val read = input.read(buffer)
                            if (read <= 0) break
                            output.write(buffer, 0, read)
                        }
                    }
                }
                callback?.onWriteFinished(arrayOf(PageRange.ALL_PAGES))
            } catch (e: Exception) {
                callback?.onWriteFailed(e.message ?: "Could not send the document to the printer.")
            }
        }
    }

    companion object {
        const val CHANNEL = "in.sreerajp.pdfapp/print"
    }
}
