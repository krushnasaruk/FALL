# FALL Android Notification System Specification

Local offline scheduling is implemented in [notification_service.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/services/notification_service.dart) and declared in [AndroidManifest.xml](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/android/app/src/main/AndroidManifest.xml).

## 1. Android Notification Channels (7 Channels)

Initialized at app startup via `NotificationService.initialize()`:

| Channel ID | Name | Importance | Purpose |
|---|---|---|---|
| `channel_tasks` | Task Reminders | `Importance.max` | Direct scheduled task alerts with action buttons |
| `channel_deadlines` | Upcoming Deadlines | `Importance.high` | Approaching due-date warnings |
| `channel_milestones` | Project Milestones | `Importance.high` | Target date milestone reminders |
| `channel_focus` | Focus Timer Alerts | `Importance.high` | Focus/Pomodoro completion notifications |
| `channel_daily_agenda` | Morning Daily Agenda | `Importance.defaultImportance` | 8:30 AM daily agenda summary |
| `channel_daily_summary` | Evening Daily Review | `Importance.defaultImportance` | 9:00 PM wrap-up prompt |
| `channel_habits` | Habits & Learning Reminders | `Importance.defaultImportance` | Daily recurring habit nudges |

## 2. Permissions & Rationale Flow

- **Android 13+ Runtime Permission (`POST_NOTIFICATIONS`):** `NotificationService.requestPermissionsWithExplanation(context)` presents an explanatory `ConfirmationDialog` explaining that FALL operates 100% offline before invoking the OS permission sheet.
- **Exact Alarms (`SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM`):** `canScheduleExactAlarms()` checks OS approval; when ungranted, `scheduleTaskReminder()` degrades cleanly to `AndroidScheduleMode.inexactAllowWhileIdle` instead of throwing an Android 12+ `SecurityException`. Settings displays live status badges (`Exact Alarms Ready` / `Inexact Fallback`) plus a shortcut to `requestExactAlarmPermission()`.

## 3. Notification Action Buttons

Task reminders expose two interactive Android actions (`_onNotificationTapped`):
- **`ACTION_DONE` ("Mark Done"):** Marks the task `isCompleted = true` and `completedAt = DateTime.now()` directly inside Drift `Tasks` and cancels pending notifications for that `taskId`.
- **`ACTION_SNOOZE_15` ("Snooze 15m"):** Reschedules the task reminder for `DateTime.now().add(Duration(minutes: 15))`.

## 4. Persistence, Deduplication & Reboot Recovery

- Every task reminder inserts/replaces a row in the Drift `ScheduledNotifications` table (`taskId` + `type: 'task_reminder'`) so repeated edits replace rather than duplicate alarms.
- `NotificationService.rescheduleStoredReminders()` is executed on every cold startup (`initialize()`) to prune stale past entries and re-register future uncompleted task reminders.
- `AndroidManifest.xml` registers `com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver` with `RECEIVE_BOOT_COMPLETED` / `QUICKBOOT_POWERON`.

## 5. Honest OS Limitations

- On aggressive vendor ROMs (MIUI, ColorOS, OneUI Battery Optimization), alarms delayed by Doze may drift slightly if exact alarms or unrestricted battery mode are revoked by the user.
- Background notification sound toggles apply at scheduling/channel-evaluation time; existing Android OS channel settings always override app requests on API 26+.

