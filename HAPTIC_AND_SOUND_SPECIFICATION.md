# FALL (`progress_os`) — Haptic & Sound Feedback Specification

## 1. Architecture (`lib/services/feedback_service.dart` + `MainActivity.kt`)
- **Centralized Dispatch:** No widget calls `HapticFeedback` directly without going through `FeedbackService` (e.g., `FeedbackService.triggerButtonTapSafely`, `buttonTap()`, `selectionClick()`, `taskCompleted()`, `timerStart()`, `timerComplete()`, `goalAchieved()`, `achievementUnlocked()`, `destructiveAction()`).
- **Anti-Spam Throttling:** Minimum `45 ms` debounce between haptics (`_canTriggerHaptic`) and sound effect rate control (`_lastSoundAt`).
- **OS Ringer Compliance:** Android `MainActivity.kt` checks `AudioManager.ringerMode == AudioManager.RINGER_MODE_NORMAL` via `SoundPool` before playing any `.wav` asset so Silent/Vibrate mode is never overridden.

## 2. Synthesized Audio Chimes (`assets/sounds/`)
1. `task_complete.wav` — crisp ascending confirmation tone
2. `focus_start.wav` — gentle grounding bell for session start
3. `focus_complete.wav` — warm multi-note completion chime
4. `goal_achieved.wav` — uplifting harmonic triad
5. `reminder_alert.wav` — soft, non-startling preview chime
6. `achievement_unlocked.wav` — `23,416 B` celebratory unlock chime
7. `milestone_achieved.wav` — `22,094 B` milestone chord

## 3. User Controls
Three persisted SharedPreferences switches (`FeedbackSettingsNotifier`) let users toggle **Haptics**, **In-App Sound Effects**, and **Notification Sounds** independently in Settings.

