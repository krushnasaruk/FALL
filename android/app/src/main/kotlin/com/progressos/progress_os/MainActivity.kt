package com.progressos.progress_os

import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.SoundPool
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val feedbackChannel = "com.progressos.progress_os/feedback"
    private var soundPool: SoundPool? = null
    private val loadedSounds = mutableMapOf<String, Int>()
    private var launchAction: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        launchAction = intent?.getStringExtra("action")
        initSoundPool()
    }

    override fun onNewIntent(intent: android.content.Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        launchAction = intent.getStringExtra("action")
    }

    private fun initSoundPool() {
        val attrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ASSISTANCE_SONIFICATION)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        soundPool = SoundPool.Builder()
            .setMaxStreams(3)
            .setAudioAttributes(attrs)
            .build()

        val soundFiles = listOf(
            "task_complete",
            "focus_start",
            "focus_complete",
            "goal_achieved",
            "reminder_alert",
            "achievement_unlocked",
            "milestone_achieved"
        )
        for (name in soundFiles) {
            try {
                val key = flutterEngine?.dartExecutor?.binaryMessenger?.let {
                    "flutter_assets/assets/sounds/$name.wav"
                } ?: "flutter_assets/assets/sounds/$name.wav"
                val afd = assets.openFd(key)
                soundPool?.let { sp ->
                    loadedSounds[name] = sp.load(afd, 1)
                }
            } catch (_: Exception) {
                // Asset missing or not yet bundled
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, feedbackChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "playSound" -> {
                        val name = call.argument<String>("name")
                        val audioManager = getSystemService(Context.AUDIO_SERVICE) as? AudioManager
                        val ringerNormal = audioManager?.ringerMode == AudioManager.RINGER_MODE_NORMAL
                        val soundId = if (name != null) loadedSounds[name] else null

                        if (ringerNormal && soundId != null) {
                            soundPool?.play(soundId, 0.45f, 0.45f, 1, 0, 1.0f)
                        }
                        result.success(null)
                    }
                    "consumeLaunchAction" -> {
                        val action = launchAction
                        launchAction = null
                        result.success(action)
                    }
                    "openUrl" -> {
                        val rawUrl = call.argument<String>("url")?.trim() ?: ""
                        if (rawUrl.startsWith("https://") || rawUrl.startsWith("http://")) {
                            try {
                                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(rawUrl)).apply {
                                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                }
                                startActivity(intent)
                                result.success(true)
                            } catch (_: Exception) {
                                result.success(false)
                            }
                        } else {
                            result.success(false)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        soundPool?.release()
        soundPool = null
        loadedSounds.clear()
        super.onDestroy()
    }
}
