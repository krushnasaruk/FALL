# FALL Interaction, Haptics & Audio Feedback Specification

Interaction feedback is centralized inside [feedback_service.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/services/feedback_service.dart) and backed on Android by native `SoundPool` audio playback inside [MainActivity.kt](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/android/app/src/main/kotlin/com/progressos/progress_os/MainActivity.kt).

## 1. Haptic Mapping & Rate Limiting

`FeedbackService` wraps Flutter's `HapticFeedback` with a `45ms` burst throttle (`_canTriggerHaptic`) and global `hapticsEnabled` preference:

| Event Method | Haptic Call | Trigger Context |
|---|---|---|
| `buttonTap()` | `HapticFeedback.lightImpact()` | Primary buttons, quick actions, sheet opening |
| `selectionClick()` | `HapticFeedback.selectionClick()` | Bottom nav switches, filter chips, theme selection, switch toggles |
| `taskCompleted(completed)` | `HapticFeedback.lightImpact()` | Toggling task completion checkbox |
| `habitCheckedIn()` | `HapticFeedback.selectionClick()` | Marking a daily habit check-in |
| `milestoneAchieved()` | `HapticFeedback.mediumImpact()` | Completing milestones or hitting 100% of a target goal |
| `reorder()` | `HapticFeedback.selectionClick()` | Dragging dashboard sections in customization sheet |
| `timerStart()` | `HapticFeedback.lightImpact()` | Starting Pomodoro / Focus timer |
| `timerComplete()` | `heavyImpact()` + `110ms` + `mediumImpact()` | Auto-completion or manual logging of Focus session |
| `destructiveAction()` | `HapticFeedback.heavyImpact()` | Delete confirmation triggers |
| `validationError()` | `HapticFeedback.vibrate()` | Submitting empty required form fields |

## 2. Subtle Offline Audio Chimes

Five short 16-bit PCM WAV files are bundled locally under `assets/sounds/` (registered in [pubspec.yaml](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/pubspec.yaml)):

- `assets/sounds/task_complete.wav` (`taskCompleted(completed: true)`)
- `assets/sounds/focus_start.wav` (`timerStart()`)
- `assets/sounds/focus_complete.wav` (`timerComplete()`)
- `assets/sounds/goal_achieved.wav` (`milestoneAchieved()`)
- `assets/sounds/reminder_alert.wav` (`playPreviewAlert()`)

### Playback Safeguards
1. **Ringer-mode respect:** On Android, `MainActivity.kt` checks `AudioManager.ringerMode == AudioManager.RINGER_MODE_NORMAL` before playing via `SoundPool` (`0.45f` volume, `USAGE_ASSISTANCE_SONIFICATION`). Silent/Vibrate phone modes remain strictly respected.
2. **Flood protection:** `FeedbackService._canPlaySound()` enforces a `120ms` cooldown between triggered chimes.
3. **Graceful non-Android & test fallback:** Calls catch `MissingPluginException` cleanly under Windows desktop and `flutter_test` harnesses.

## 3. User Controls (Persisted Preferences)

`FeedbackSettingsNotifier` persists three independent `SharedPreferences` switches configurable anytime in **Settings -> Sounds & Vibrations** ([settings_screen.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/features/settings/screens/settings_screen.dart)):

| Toggle | Preference Key | Default |
|---|---|---|
| Haptic Feedback | `feedback_haptics_enabled` | `true` |
| In-App UI Chimes | `feedback_sound_effects_enabled` | `true` |
| Notification Alert Sound | `feedback_notification_sounds_enabled` | `true` |

