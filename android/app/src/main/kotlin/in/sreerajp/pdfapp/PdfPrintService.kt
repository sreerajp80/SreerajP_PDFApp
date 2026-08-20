package `in`.sreerajp.pdfapp

import android.content.Intent
import android.print.PrintAttributes
import android.print.PrinterCapabilitiesInfo
import android.print.PrinterId
import android.print.PrinterInfo
import android.printservice.PrintJob
import android.printservice.PrintService
import android.printservice.PrinterDiscoverySession
import androidx.core.content.FileProvider
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

/**
 * Android system Virtual Print Service.
 *
 * Appears in Android's system print dialog as a destination printer:
 * "Save as PDF (SreerajP PDF App)".
 *
 * When an external app prints to this service:
 * 1. Reads the spooled PDF stream from [PrintJob.getDocument].
 * 2. Writes the PDF to a safe cache file.
 * 3. Marks the print job as completed.
 * 4. Launches [MainActivity] with ACTION_VIEW to open the newly generated PDF.
 */
class PdfPrintService : PrintService() {

    override fun onCreatePrinterDiscoverySession(): PrinterDiscoverySession {
        return object : PrinterDiscoverySession() {
            override fun onStartPrinterDiscovery(priorityList: List<PrinterId>) {
                val printerId = generatePrinterId(PRINTER_ID)
                val printerName = getString(R.string.printer_name_save_pdf)
                val caps = PrinterCapabilitiesInfo.Builder(printerId)
                    .addMediaSize(PrintAttributes.MediaSize.ISO_A4, true)
                    .addMediaSize(PrintAttributes.MediaSize.NA_LETTER, false)
                    .addMediaSize(PrintAttributes.MediaSize.NA_LEGAL, false)
                    .addResolution(PrintAttributes.Resolution("res_300", "300 dpi", 300, 300), true)
                    .setColorModes(
                        PrintAttributes.COLOR_MODE_COLOR or PrintAttributes.COLOR_MODE_MONOCHROME,
                        PrintAttributes.COLOR_MODE_COLOR
                    )
                    .build()

                val printerInfo = PrinterInfo.Builder(printerId, printerName, PrinterInfo.STATUS_IDLE)
                    .setCapabilities(caps)
                    .build()

                addPrinters(listOf(printerInfo))
            }

            override fun onStopPrinterDiscovery() {}

            override fun onValidatePrinters(printerIds: List<PrinterId>) {}

            override fun onStartPrinterStateTracking(printerId: PrinterId) {}

            override fun onStopPrinterStateTracking(printerId: PrinterId) {}

            override fun onDestroy() {}
        }
    }

    override fun onRequestCancelPrintJob(printJob: PrintJob) {
        printJob.cancel()
    }

    override fun onPrintJobQueued(printJob: PrintJob) {
        if (!printJob.isQueued) return
        printJob.start()

        Thread {
            try {
                val document = printJob.document
                val data = document?.data
                if (data == null) {
                    printJob.fail("No print data received.")
                    return@Thread
                }

                val dir = File(cacheDir, "printer").apply { mkdirs() }
                val ts = System.currentTimeMillis()
                val label = printJob.info.label?.toString()
                val jobDocName = if (label.isNullOrBlank()) "print_job" else label
                val safeName = jobDocName.replace(Regex("[^A-Za-z0-9._-]"), "_")
                val outFile = File(dir, "${safeName}_$ts.pdf")

                data.use { pfd ->
                    FileInputStream(pfd.fileDescriptor).use { input ->
                        FileOutputStream(outFile).use { output ->
                            input.copyTo(output)
                        }
                    }
                }

                printJob.complete()

                // Launch MainActivity to open the printed PDF in SreerajP PDF App
                val uri = FileProvider.getUriForFile(
                    this@PdfPrintService,
                    "${packageName}.fileprovider",
                    outFile
                )
                val intent = Intent(Intent.ACTION_VIEW).apply {
                    setDataAndType(uri, "application/pdf")
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                startActivity(intent)
            } catch (e: Exception) {
                printJob.fail(e.message ?: "Failed to save printed document.")
            }
        }.start()
    }

    companion object {
        private const val PRINTER_ID = "sreerajp_pdf_virtual_printer"
    }
}
