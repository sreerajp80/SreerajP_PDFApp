package `in`.sreerajp.pdfapp

import android.content.ContentResolver
import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract
import java.io.File

/**
 * Saves files into a folder the user picked with the system folder picker
 * (`ACTION_OPEN_DOCUMENT_TREE`). Used by Device sync to store received PDFs
 * (plan 20261112_104132_device_sync_qr_wifi.md §3.5).
 *
 * Scoped storage only (Hard Rule 3): the app writes through the folder's tree
 * URI and the documents provider, never through a file path, and only into the
 * one folder the user chose. Every file is a **new** document (copy-on-write):
 * a name that is already taken gets " (2)", " (3)" ... added, so nothing in the
 * folder is ever overwritten.
 */
object FolderSaver {

    private const val PDF_MIME = "application/pdf"
    private const val TREE_FLAGS =
        Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION

    /** True when the app still holds lasting read + write access to [tree]. */
    fun hasAccess(resolver: ContentResolver, tree: Uri): Boolean = try {
        resolver.persistedUriPermissions.any {
            it.uri == tree && it.isReadPermission && it.isWritePermission
        }
    } catch (_: Exception) {
        false
    }

    /** The folder's display name, or null when it cannot be reached any more. */
    fun folderName(resolver: ContentResolver, tree: Uri): String? = try {
        val docId = DocumentsContract.getTreeDocumentId(tree)
        val doc = DocumentsContract.buildDocumentUriUsingTree(tree, docId)
        resolver.query(
            doc,
            arrayOf(DocumentsContract.Document.COLUMN_DISPLAY_NAME),
            null,
            null,
            null,
        )?.use { cursor ->
            if (cursor.moveToFirst()) cursor.getString(0) else null
        }
    } catch (_: Exception) {
        null
    }

    /** Takes lasting read + write access to a folder the user just picked. */
    fun keepAccess(resolver: ContentResolver, tree: Uri) {
        resolver.takePersistableUriPermission(tree, TREE_FLAGS)
    }

    /** Gives back lasting access to [tree]. Safe to call when none is held. */
    fun releaseAccess(resolver: ContentResolver, tree: Uri) {
        try {
            resolver.releasePersistableUriPermission(tree, TREE_FLAGS)
        } catch (_: SecurityException) {
            // Not held any more; nothing to release.
        }
    }

    /**
     * Copies each `(path, name)` into the folder as a new PDF document.
     * Returns one map per file: `{name, uri}` when saved, `{name, error}` when
     * not. One failure does not stop the others. Runs on a background thread
     * (the caller's job): it does disk and provider I/O.
     */
    fun saveAll(
        resolver: ContentResolver,
        tree: Uri,
        files: List<Map<String, String>>,
    ): List<Map<String, String>> {
        val parentId = DocumentsContract.getTreeDocumentId(tree)
        val parent = DocumentsContract.buildDocumentUriUsingTree(tree, parentId)
        val taken = childNames(resolver, tree, parentId)
        val out = ArrayList<Map<String, String>>()
        for (file in files) {
            val path = file["path"]
            val wanted = file["name"]
            if (path == null || wanted == null) continue
            val name = uniqueName(wanted, taken)
            var created: Uri? = null
            try {
                val source = File(path)
                require(source.exists()) { "The received file is gone." }
                created = DocumentsContract.createDocument(resolver, parent, PDF_MIME, name)
                    ?: throw IllegalStateException("The folder refused a new file.")
                resolver.openOutputStream(created).use { output ->
                    requireNotNull(output) { "Could not write into the folder." }
                    source.inputStream().use { input -> input.copyTo(output) }
                }
                taken.add(name.lowercase())
                out.add(mapOf("name" to (displayName(resolver, created) ?: name), "uri" to created.toString()))
            } catch (e: Exception) {
                // Do not leave a half-written file behind.
                created?.let {
                    try {
                        DocumentsContract.deleteDocument(resolver, it)
                    } catch (_: Exception) {
                        // Nothing more we can do; the user sees the error.
                    }
                }
                out.add(mapOf("name" to name, "error" to (e.javaClass.simpleName)))
            }
        }
        return out
    }

    /** Lower-cased names already in the folder, to avoid clashes. */
    private fun childNames(resolver: ContentResolver, tree: Uri, parentId: String): MutableSet<String> {
        val names = HashSet<String>()
        try {
            val children = DocumentsContract.buildChildDocumentsUriUsingTree(tree, parentId)
            resolver.query(
                children,
                arrayOf(DocumentsContract.Document.COLUMN_DISPLAY_NAME),
                null,
                null,
                null,
            )?.use { cursor ->
                while (cursor.moveToNext()) {
                    cursor.getString(0)?.let { names.add(it.lowercase()) }
                }
            }
        } catch (_: Exception) {
            // If listing fails, the provider still renames clashes itself.
        }
        return names
    }

    /** "report.pdf" → "report (2).pdf" → "report (3).pdf" … until free. */
    private fun uniqueName(wanted: String, taken: Set<String>): String {
        if (wanted.lowercase() !in taken) return wanted
        val dot = wanted.lastIndexOf('.')
        val base = if (dot > 0) wanted.substring(0, dot) else wanted
        val ext = if (dot > 0) wanted.substring(dot) else ""
        var n = 2
        while (true) {
            val candidate = "$base ($n)$ext"
            if (candidate.lowercase() !in taken) return candidate
            n++
        }
    }

    private fun displayName(resolver: ContentResolver, doc: Uri): String? = try {
        resolver.query(
            doc,
            arrayOf(DocumentsContract.Document.COLUMN_DISPLAY_NAME),
            null,
            null,
            null,
        )?.use { cursor -> if (cursor.moveToFirst()) cursor.getString(0) else null }
    } catch (_: Exception) {
        null
    }
}
