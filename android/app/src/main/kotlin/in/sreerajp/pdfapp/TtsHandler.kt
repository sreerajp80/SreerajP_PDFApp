package `in`.sreerajp.pdfapp

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.ActivityNotFoundException
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.Uri
import android.os.Build
import android.speech.tts.TextToSpeech
import androidx.core.app.NotificationCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Helps the reader install a missing text-to-speech voice and manages persistent
 * background notification player controls.
 */
class TtsHandler(private val context: Context, messenger: BinaryMessenger) {

    private val methodChannel = MethodChannel(messenger, CHANNEL)
    private val notificationManager =
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    private val actionReceiver = object : BroadcastReceiver() {
        override fun onReceive(ctx: Context?, intent: Intent?) {
            val action = intent?.getStringExtra(EXTRA_ACTION) ?: return
            methodChannel.invokeMethod("onNotificationAction", mapOf("action" to action))
        }
    }

    init {
        createNotificationChannel()
        val filter = IntentFilter(ACTION_TTS_CONTROL)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.registerReceiver(actionReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            context.registerReceiver(actionReceiver, filter)
        }

        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "installVoiceData" -> result.success(start(installVoiceDataIntent()))
                "openTtsSettings" -> result.success(start(ttsSettingsIntent()))
                "openPlayStore" -> result.success(openPlayStore())
                "showNotification" -> {
                    val title = call.argument<String>("title") ?: "SreerajP PDF App"
                    val content = call.argument<String>("content") ?: ""
                    val isPlaying = call.argument<Boolean>("isPlaying") ?: true
                    showNotification(title, content, isPlaying)
                    result.success(true)
                }
                "cancelNotification" -> {
                    cancelNotification()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                "Read Aloud Playback",
                NotificationManager.IMPORTANCE_LOW,
            ).apply {
                description = "Controls for background PDF read aloud"
                setShowBadge(false)
            }
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun showNotification(title: String, content: String, isPlaying: Boolean) {
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val contentPendingIntent = PendingIntent.getActivity(
            context,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val toggleActionIntent = Intent(ACTION_TTS_CONTROL).apply {
            putExtra(EXTRA_ACTION, if (isPlaying) "pause" else "play")
            setPackage(context.packageName)
        }
        val togglePendingIntent = PendingIntent.getBroadcast(
            context,
            1,
            toggleActionIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val stopActionIntent = Intent(ACTION_TTS_CONTROL).apply {
            putExtra(EXTRA_ACTION, "stop")
            setPackage(context.packageName)
        }
        val stopPendingIntent = PendingIntent.getBroadcast(
            context,
            2,
            stopActionIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val builder = NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setContentTitle(title)
            .setContentText(content)
            .setContentIntent(contentPendingIntent)
            .setOngoing(isPlaying)
            .setSilent(true)
            .addAction(
                if (isPlaying) android.R.drawable.ic_media_pause else android.R.drawable.ic_media_play,
                if (isPlaying) "Pause" else "Play",
                togglePendingIntent,
            )
            .addAction(
                android.R.drawable.ic_menu_close_clear_cancel,
                "Stop",
                stopPendingIntent,
            )

        notificationManager.notify(NOTIFICATION_ID, builder.build())
    }

    private fun cancelNotification() {
        notificationManager.cancel(NOTIFICATION_ID)
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
        private const val NOTIFICATION_CHANNEL_ID = "in.sreerajp.pdfapp.tts_playback"
        private const val NOTIFICATION_ID = 2001
        private const val ACTION_TTS_CONTROL = "in.sreerajp.pdfapp.ACTION_TTS_CONTROL"
        private const val EXTRA_ACTION = "action"
    }
}
