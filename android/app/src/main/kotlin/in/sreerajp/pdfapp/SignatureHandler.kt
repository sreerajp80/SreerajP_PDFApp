package `in`.sreerajp.pdfapp

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Base64
import com.tom_roush.pdfbox.android.PDFBoxResourceLoader
import com.tom_roush.pdfbox.pdmodel.PDDocument
import com.tom_roush.pdfbox.pdmodel.encryption.InvalidPasswordException
import com.tom_roush.pdfbox.pdmodel.interactive.digitalsignature.PDSignature
import com.tom_roush.pdfbox.cos.COSDictionary
import com.tom_roush.pdfbox.cos.COSName
import com.tom_roush.pdfbox.pdmodel.interactive.annotation.PDAnnotationWidget
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import org.bouncycastle.asn1.ASN1Set
import org.bouncycastle.asn1.cms.CMSAttributes
import org.bouncycastle.asn1.x509.Time
import org.bouncycastle.cert.X509CertificateHolder
import org.bouncycastle.cert.jcajce.JcaX509CertificateConverter
import org.bouncycastle.cms.CMSProcessableByteArray
import org.bouncycastle.cms.CMSSignedData
import org.bouncycastle.cms.SignerInformation
import org.bouncycastle.jce.provider.BouncyCastleProvider
import org.bouncycastle.cms.jcajce.JcaSimpleSignerInfoVerifierBuilder
import java.io.File
import java.security.MessageDigest
import java.security.cert.CertPathValidator
import java.security.cert.CertificateFactory
import java.security.cert.PKIXParameters
import java.security.cert.TrustAnchor
import java.security.cert.X509CRL
import java.security.cert.X509Certificate
import java.util.Date
import java.util.concurrent.Executors

/**
 * PDF digital-signature verification (Phase 7).
 *
 * This is the app's only real cryptography, and the rule that governs it is: **report facts,
 * never grant trust**. Everything here answers questions of fact —
 *
 *  - do the signed bytes still hash to what was signed? (`integrity`)
 *  - do those bytes cover the *whole* file, or only part of it? (`coversWholeFile`)
 *  - does the certificate chain reach one of the anchors Dart handed us? (`chainTrusted`)
 *
 * — and the *decision* about showing a green tick is made in Dart (`SignatureTrustEvaluator`),
 * where it is pure logic and can be unit-tested. Native code cannot be tested on the host, so
 * as little judgement as possible lives here.
 *
 * Three things worth knowing before changing this file:
 *
 *  1. **Trust anchors are passed in, not stored here.** The handler keeps no state. Dart owns
 *     the trust store (user-added certificates + the bundled EUTL list) and sends the anchors
 *     with each call.
 *  2. **Nothing here goes online.** The app has no `INTERNET` permission by project rule, so
 *     certificate-revocation checking uses only proof embedded in the PDF itself. When there
 *     is none, we report `revocationChecked = false` rather than implying we checked.
 *  3. **Bouncy Castle is used by instance, never by name.** `Security.getProvider("BC")` on
 *     Android returns *Android's* stripped copy, not the full one PdfBox pulls in. Asking for
 *     it by name is the classic way to get mysterious "algorithm not found" failures.
 *
 * Everything runs on a background thread and replies on the main thread, matching
 * [PdfBoxHandler]. One malformed signature is reported as unknown and never takes down the
 * others, or the app (project rule: never crash on bad input).
 */
class SignatureHandler(context: Context, messenger: BinaryMessenger) {

    private val appContext = context.applicationContext
    private val io = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())

    /** Our own full Bouncy Castle, held as an instance — see the class note (point 3). */
    private val bc = BouncyCastleProvider()

    private val resourcesReady: Boolean by lazy {
        PDFBoxResourceLoader.init(appContext)
        true
    }

    init {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "countSignatures" -> {
                    val path = call.argument<String>("path")
                    if (path.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path.", null)
                    } else {
                        countSignatures(path, call.argument<String>("password"), result)
                    }
                }
                "verifySignatures" -> {
                    val path = call.argument<String>("path")
                    if (path.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path.", null)
                    } else {
                        verifySignatures(
                            path,
                            call.argument<String>("password"),
                            call.argument<List<String>>("trustAnchors") ?: emptyList(),
                            result,
                        )
                    }
                }
                "readCertificate" -> {
                    val path = call.argument<String>("path")
                    if (path.isNullOrEmpty()) {
                        result.error("bad_args", "Missing path.", null)
                    } else {
                        readCertificate(path, result)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    fun dispose() {
        io.shutdown()
    }

    // --- Entry points ---

    /**
     * How many signatures the document holds. Drives whether the viewer offers the
     * Signatures menu at all, so it never becomes a dead button (project rule 6).
     */
    private fun countSignatures(path: String, password: String?, result: MethodChannel.Result) {
        runOnIo(result) {
            openDocument(path, password).use { doc ->
                doc.signatureDictionaries.size
            }
        }
    }

    private class SignatureLoc(
        val pageIndex: Int,
        val x: Float,
        val y: Float,
        val width: Float,
        val height: Float
    )

    private fun findSignatureLocations(doc: PDDocument): Map<COSDictionary, SignatureLoc> {
        val locations = mutableMapOf<COSDictionary, SignatureLoc>()
        val cosNameV = COSName.V
        for (pageIndex in 0 until doc.numberOfPages) {
            val page = doc.getPage(pageIndex)
            val annots = try { page.annotations } catch (_: Exception) { emptyList() }
            for (annot in annots) {
                if (annot is PDAnnotationWidget) {
                    val cosDict = annot.cosObject
                    val vDict = cosDict.getDictionaryObject(cosNameV)
                    if (vDict is COSDictionary) {
                        val rect = annot.rectangle
                        if (rect != null) {
                            locations[vDict] = SignatureLoc(
                                pageIndex = pageIndex,
                                x = rect.lowerLeftX,
                                y = rect.lowerLeftY,
                                width = rect.width,
                                height = rect.height
                            )
                        }
                    }
                }
            }
        }
        return locations
    }

    private fun verifySignatures(
        path: String,
        password: String?,
        trustAnchorsB64: List<String>,
        result: MethodChannel.Result,
    ) {
        runOnIo(result) {
            val file = File(path)
            val fileBytes = file.readBytes()
            val anchors = trustAnchorsB64.mapNotNull { decodeCertificate(it) }

            openDocument(path, password).use { doc ->
                val locations = findSignatureLocations(doc)
                doc.signatureDictionaries.map { sig ->
                    // One bad signature must not hide the good ones next to it.
                    try {
                        val baseResult = verifyOne(sig, fileBytes, anchors)
                        val loc = locations[sig.cosObject]
                        if (loc != null) {
                            baseResult.toMutableMap().apply {
                                put("position", mapOf(
                                    "pageIndex" to loc.pageIndex,
                                    "x" to loc.x,
                                    "y" to loc.y,
                                    "width" to loc.width,
                                    "height" to loc.height
                                ))
                            }
                        } else {
                            baseResult
                        }
                    } catch (e: Exception) {
                        unknownSignature(sig, e.message)
                    }
                }
            }
        }
    }

    /** Parses a certificate file the user picked, so the UI can show it before trusting it. */
    private fun readCertificate(path: String, result: MethodChannel.Result) {
        runOnIo(result) {
            val cert = parseCertificateFile(File(path).readBytes())
                ?: throw IllegalArgumentException("not_a_certificate")
            certificateMap(cert)
        }
    }

    // --- Verification of one signature ---

    private fun verifyOne(
        sig: PDSignature,
        fileBytes: ByteArray,
        anchors: List<X509Certificate>,
    ): Map<String, Any?> {
        val byteRange = sig.byteRange
        val coversWholeFile = coversWholeFile(byteRange, fileBytes.size)
        val claimedTime = sig.signDate?.time

        val base = mutableMapOf<String, Any?>(
            "name" to sig.name,
            "reason" to sig.reason,
            "location" to sig.location,
            "subFilter" to sig.subFilter,
            "claimedSignedAt" to claimedTime?.time,
            "coversWholeFile" to coversWholeFile,
        )

        // adbe.x509.rsa_sha1 is a bare signature, not CMS; we do not parse it, and saying
        // "unknown" is the honest answer rather than guessing.
        val subFilter = sig.subFilter
        if (subFilter != null && !CMS_SUBFILTERS.contains(subFilter)) {
            return base.apply {
                put("integrity", UNKNOWN)
                put("detail", "unsupported_subfilter")
            }
        }

        val signedContent = sig.getSignedContent(fileBytes)
        val contents = sig.getContents(fileBytes)

        // adbe.pkcs7.sha1 encapsulates the SHA-1 hash of the document bytes inside the CMS container.
        // Detached signatures have no encapsulated content and verify the document bytes directly.
        val cms = if (subFilter == "adbe.pkcs7.sha1") {
            CMSSignedData(contents)
        } else {
            CMSSignedData(CMSProcessableByteArray(signedContent), contents)
        }
        val signer = cms.signerInfos.signers.firstOrNull()
            ?: return base.apply {
                put("integrity", UNKNOWN)
                put("detail", "no_signer_info")
            }

        val certStore = cms.certificates
        val holder = certStore.getMatches(signer.sid as org.bouncycastle.util.Selector<X509CertificateHolder>).firstOrNull() as? X509CertificateHolder
            ?: return base.apply {
                put("integrity", UNKNOWN)
                put("detail", "no_signer_certificate")
            }
        val signerCert = JcaX509CertificateConverter().setProvider(bc).getCertificate(holder)

        // The cryptographic check: were these exact bytes signed by this certificate's key?
        val integrityValid = try {
            val verifier = JcaSimpleSignerInfoVerifierBuilder().setProvider(bc).build(signerCert)
            val sigValid = signer.verify(verifier)
            if (sigValid && subFilter == "adbe.pkcs7.sha1") {
                val expectedSha1 = cms.signedContent?.content as? ByteArray
                val actualSha1 = MessageDigest.getInstance("SHA-1").digest(signedContent)
                expectedSha1 != null && expectedSha1.contentEquals(actualSha1)
            } else {
                sigValid
            }
        } catch (e: Exception) {
            // A verifier that throws means "did not verify" — not a crash, and not trust.
            android.util.Log.e("SignatureHandler", "Signature cryptographic verification failed", e)
            false
        }

        // Prefer the time the signer put inside the signed data over the document dictionary's:
        // the dictionary sits outside the signed bytes and anyone could edit it.
        val signedAt = signingTimeOf(signer) ?: claimedTime
        val chain = buildChain(signerCert, certStore.getMatches(null).filterIsInstance<X509CertificateHolder>())

        val certExpiredAtSigning = signedAt != null &&
            (signedAt.before(signerCert.notBefore) || signedAt.after(signerCert.notAfter))

        val revocation = checkRevocationOffline(signerCert, chain, cms)
        val trust = checkChain(chain, anchors, signedAt ?: Date())

        return base.apply {
            put("integrity", if (integrityValid) VALID else INVALID)
            put("signedAt", signedAt?.time)
            put("signerCertSha256", sha256Hex(signerCert.encoded))
            put("chain", chain.map { certificateMap(it) })
            put("chainTrusted", trust.first)
            put("chainDetail", trust.second)
            put("certExpiredAtSigning", certExpiredAtSigning)
            put("revocationChecked", revocation.first)
            put("revoked", revocation.second)
        }
    }

    /**
     * True when the signed byte ranges span the entire file.
     *
     * A PDF signature covers everything except the gap holding the signature itself, so the
     * ByteRange looks like `[0, a, b, c]`: bytes `0..a` and `b..b+c`. If `b + c` falls short of
     * the file length, **content was added after signing** and the signature says nothing about
     * it. That is a real attack, not a quirk, which is why this is checked separately and why a
     * signature failing it can never show a green tick.
     */
    private fun coversWholeFile(byteRange: IntArray?, fileLength: Int): Boolean {
        if (byteRange == null || byteRange.size < 4) return false
        if (byteRange[0] != 0) return false
        val end = byteRange[2].toLong() + byteRange[3].toLong()
        return end == fileLength.toLong()
    }

    /** The signing time from the *signed* attributes, which cannot be edited after the fact. */
    private fun signingTimeOf(signer: SignerInformation): Date? = try {
        val attrs: ASN1Set? = signer.signedAttributes?.get(CMSAttributes.signingTime)?.attrValues
        val value = attrs?.getObjectAt(0)
        if (value == null) null else Time.getInstance(value).date
    } catch (_: Exception) {
        null
    }

    /**
     * Orders the certificates the signature carries into a chain, signer first.
     *
     * Stops on a self-signed certificate or a missing issuer — an incomplete chain simply
     * fails validation later, which is the honest outcome.
     */
    private fun buildChain(
        signerCert: X509Certificate,
        holders: List<X509CertificateHolder>,
    ): List<X509Certificate> {
        val pool = holders.mapNotNull {
            try {
                JcaX509CertificateConverter().setProvider(bc).getCertificate(it)
            } catch (_: Exception) {
                null
            }
        }
        val chain = mutableListOf(signerCert)
        var current = signerCert
        // A malformed bundle could loop; the pool size is a natural bound.
        while (chain.size <= pool.size + 1) {
            if (current.subjectX500Principal == current.issuerX500Principal) break
            val issuer = pool.firstOrNull {
                it.subjectX500Principal == current.issuerX500Principal &&
                    chain.none { c -> c.serialNumber == it.serialNumber && c.issuerX500Principal == it.issuerX500Principal }
            } ?: break
            chain.add(issuer)
            current = issuer
        }
        return chain
    }

    /**
     * Runs the chain against the trust anchors with Android's `CertPathValidator`.
     *
     * Returns (trusted, detail-or-null). Revocation is switched **off** here on purpose: PKIX
     * revocation checking reaches for the network, which this app must never do. Revocation is
     * handled separately and offline by [checkRevocationOffline].
     */
    private fun checkChain(
        chain: List<X509Certificate>,
        anchors: List<X509Certificate>,
        at: Date,
    ): Pair<Boolean, String?> {
        if (anchors.isEmpty()) return false to "no_trust_anchors"

        // The common case in this app: the user trusted the signer's own certificate directly.
        // PKIX cannot express that (a path needs at least one certificate below its anchor), so
        // it is answered here instead of being reported as untrusted.
        val signerCert = chain.first()
        if (anchors.any { it.encoded.contentEquals(signerCert.encoded) }) {
            return try {
                signerCert.checkValidity(at)
                true to "trusted_directly"
            } catch (_: Exception) {
                // Trusted by the user, but not valid at signing time. Honest answer: it is
                // still trusted; the expiry is reported on its own field and shown as a note.
                true to "trusted_directly_expired"
            }
        }

        // PKIX wants the path to stop *below* the anchor, so drop any anchor sitting in it.
        val path = chain.filterNot { cert -> anchors.any { it.encoded.contentEquals(cert.encoded) } }
        if (path.isEmpty()) return false to "empty_path"

        return try {
            val factory = CertificateFactory.getInstance("X.509")
            val certPath = factory.generateCertPath(path)
            val params = PKIXParameters(anchors.map { TrustAnchor(it, null) }.toSet()).apply {
                isRevocationEnabled = false // offline — see the KDoc above
                date = at
            }
            CertPathValidator.getInstance("PKIX").validate(certPath, params)
            true to null
        } catch (e: Exception) {
            // Not an error: "this chain does not reach a certificate you trust" is a normal,
            // expected answer for most PDFs in the wild.
            false to (e.message?.take(200) ?: "chain_not_trusted")
        }
    }

    /**
     * Offline revocation check. Returns (checked, revoked).
     *
     * A certificate can be cancelled before it expires, and the usual way to find out is to
     * call an OCSP or CRL server — which this app will not do. Some signers embed the proof in
     * the signature itself so it can be checked years later offline; when that is there we use
     * it, and when it is not we report `checked = false` so the UI can say plainly that this
     * was not verified. Claiming a certificate is good because we could not check would be
     * exactly the kind of fake trust the security rules forbid.
     */
    private fun checkRevocationOffline(
        signerCert: X509Certificate,
        chain: List<X509Certificate>,
        cms: CMSSignedData,
    ): Pair<Boolean, Boolean> {
        val crls = try {
            cms.crLs.getMatches(null).mapNotNull { holder ->
                try {
                    val factory = CertificateFactory.getInstance("X.509")
                    val encoded = (holder as? org.bouncycastle.cert.X509CRLHolder)?.encoded
                        ?: return@mapNotNull null
                    factory.generateCRL(encoded.inputStream()) as? X509CRL
                } catch (_: Exception) {
                    null
                }
            }
        } catch (_: Exception) {
            emptyList()
        }
        if (crls.isEmpty()) return false to false

        val issuer = chain.getOrNull(1)
        var checkedAny = false
        for (crl in crls) {
            if (crl.issuerX500Principal != signerCert.issuerX500Principal) continue
            // An unsigned or wrongly-signed CRL proves nothing — anyone can write one.
            if (issuer != null) {
                try {
                    crl.verify(issuer.publicKey, bc)
                } catch (_: Exception) {
                    continue
                }
            }
            checkedAny = true
            if (crl.isRevoked(signerCert)) return true to true
        }
        return checkedAny to false
    }

    // --- Helpers ---

    private fun unknownSignature(sig: PDSignature, detail: String?): Map<String, Any?> = mapOf(
        "name" to sig.name,
        "reason" to sig.reason,
        "location" to sig.location,
        "subFilter" to sig.subFilter,
        "claimedSignedAt" to sig.signDate?.time?.time,
        "coversWholeFile" to false,
        "integrity" to UNKNOWN,
        "detail" to (detail?.take(200) ?: "unreadable_signature"),
    )

    private fun certificateMap(cert: X509Certificate): Map<String, Any?> = mapOf(
        "subject" to cert.subjectX500Principal.name,
        "issuer" to cert.issuerX500Principal.name,
        "serial" to cert.serialNumber.toString(16),
        "notBefore" to cert.notBefore.time,
        "notAfter" to cert.notAfter.time,
        "sha256" to sha256Hex(cert.encoded),
        "der" to Base64.encodeToString(cert.encoded, Base64.NO_WRAP),
    )

    private fun decodeCertificate(base64: String): X509Certificate? = try {
        parseCertificateFile(Base64.decode(base64, Base64.DEFAULT))
    } catch (_: Exception) {
        null
    }

    /** Reads a certificate in either DER (binary) or PEM (text) form — both are common. */
    private fun parseCertificateFile(bytes: ByteArray): X509Certificate? = try {
        CertificateFactory.getInstance("X.509")
            .generateCertificate(bytes.inputStream()) as? X509Certificate
    } catch (_: Exception) {
        null
    }

    private fun sha256Hex(bytes: ByteArray): String =
        MessageDigest.getInstance("SHA-256").digest(bytes).joinToString("") { "%02x".format(it) }

    private fun openDocument(path: String, password: String?): PDDocument {
        require(resourcesReady)
        val file = File(path)
        if (!file.exists()) throw IllegalArgumentException("file_not_found")
        return if (password.isNullOrEmpty()) PDDocument.load(file) else PDDocument.load(file, password)
    }

    /** Runs [work] off the UI thread and answers [result] on the main thread, never throwing. */
    private fun <T> runOnIo(result: MethodChannel.Result, work: () -> T) {
        io.execute {
            try {
                val value = work()
                main.post { result.success(value) }
            } catch (e: InvalidPasswordException) {
                main.post {
                    result.error("password_required", "This PDF is locked.", null)
                }
            } catch (e: Exception) {
                // Messages here are about the file, never about key material (security rules).
                main.post {
                    result.error(
                        "signature_failed",
                        "This PDF's signatures could not be read.",
                        e.message?.take(200),
                    )
                }
            }
        }
    }

    companion object {
        const val CHANNEL = "in.sreerajp.pdfapp/signature"

        private const val VALID = "valid"
        private const val INVALID = "invalid"
        private const val UNKNOWN = "unknown"

        /** Sub-filters whose /Contents is a PKCS#7 / CMS blob we know how to read. */
        private val CMS_SUBFILTERS = setOf(
            "adbe.pkcs7.detached",
            "adbe.pkcs7.sha1",
            "ETSI.CAdES.detached",
        )
    }
}
