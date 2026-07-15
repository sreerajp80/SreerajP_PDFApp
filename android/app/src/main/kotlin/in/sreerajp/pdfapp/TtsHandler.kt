package `in`.sreerajp.pdfapp

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.speech.tts.TextToSpeech
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Helps the reader install a missing text-to-speech voice (Phase 2).
 *
 * `flutter_tts` can say whether a voice is there, but not offer to fetch it.
 * These three doors are all the platform gives us, in the order we try them:
 *  1. [TextToSpeech.Engine.ACTION_INSTALL_TTS_DATA] — the engine's own download
 *     screen. Best, but not every engine implements it.
 *  2. The system text-to-speech settings, where voices can be managed by hand.
 *  3. Google's speech engine on the Play Store, for a device with no usable
 *     engine at all.
 *
 * Each returns false rather than throwing when that door does not exist, so Dart
 * can fall through to the next and never show a dead button.
 */
class TtsHandler(private val context: Context, messenger: BinaryMessenger) {

    init {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "installVoiceData" -> result.success(start(installVoiceDataIntent()))
                "openTtsSettings" -> result.success(start(ttsSettingsIntent()))
                "openPlayStore" -> result.success(openPlayStore())
                else -> result.notImplemented()
            }
        }
    }

    private fun installVoiceDataIntent() =
        Intent(TextToSpeech.Engine.ACTION_INSTALL_TTS_DATA)

    private fun ttsSettingsIntent() = Intent("com.android.settings.TTS_SETTINGS")

    /** Opens the Play Store app, falling back to the browser. */
    private fun openPlayStore(): Boolean {
        val store = Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=$GOOGLE_TTS"))
        if (start(store)) return true
        return start(
            Intent(
                Intent.ACTION_VIEW,
                Uri.parse("https://play.google.com/store/apps/details?id=$GOOGLE_TTS"),
            ),
        )
    }

    /**
     * Starts [intent], or reports false if nothing on this device can handle it.
     *
     * NEW_TASK because we are launching another app from a plain Context.
     */
    private fun start(intent: Intent): Boolean = try {
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
        true
    } catch (_: ActivityNotFoundException) {
        false
    } catch (_: SecurityException) {
        false
    }

    companion object {
        const val CHANNEL = "in.sreerajp.pdfapp/tts"
        private const val GOOGLE_TTS = "com.google.android.tts"
    }
}
