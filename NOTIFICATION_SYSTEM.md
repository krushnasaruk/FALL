# ProgressOS — Automated Notification System Specification

## 1. Overview & Architecture

ProgressOS uses `flutter_local_notifications` integrated with the `timezone` database to handle exact scheduling, recurring daily notifications, and lifecycle triggers.

```
┌────────────────────────────────────────────────────────┐
│                   Flutter Data Layer                   │
│   (Tasks, Habits, Milestones, Daily Schedule Changes)  │
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│                  NotificationService                   │
│   - Channel configuration (AndroidNotificationDetails) │
│   - Exact Alarm scheduling (zonedSchedule)             │
│   - Notification state persistence (Drift table)       │
│   - Rescheduling & Cancellations                       │
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│              flutter_local_notifications               │
│   - Android NotificationManager                        │
│   - Actions: 'MARK_DONE', 'SNOOZE'                     │
│   - Timezone: tz.TZDateTime                            │
└────────────────────────────────────────────────────────┘
```

---

## 2. Notification Categories & Channels

1. **Task Reminders (`channel_tasks`)**
   - Importance: High, Priority: High, Vibration: enabled
   - Trigger: Specific reminder time set on task
   - Actions: `MARK_DONE`, `SNOOZE_15`
2. **Upcoming Deadlines (`channel_deadlines`)**
   - Importance: High
   - Trigger: 24h & 2h before due date if uncompleted
3. **Overdue Tasks (`channel_overdue`)**
   - Importance: Default
   - Trigger: 1 hour past due date
4. **Daily Morning Agenda (`channel_daily_agenda`)**
   - Importance: Default
   - Trigger: Configurable morning time (default: 08:00 AM)
   - Summary of tasks due today and priority targets
5. **Daily Evening Review (`channel_daily_summary`)**
   - Importance: Default
   - Trigger: Configurable evening time (default: 09:00 PM)
   - Daily progress recap, completed count, streak status
6. **Habit & Learning Reminders (`channel_habits_learning`)**
   - Importance: Low to Default
   - Trigger: Custom habit reminder time or learning prompt
7. **Project Milestones (`channel_milestones`)**
   - Importance: High
   - Trigger: Milestone target date alert

---

## 3. Resilience, Exact Alarms & System Restrictions

- **Exact Alarms (Android 12+ / 13+ / 14+):**
  - Requires `android.permission.SCHEDULE_EXACT_ALARM` and `android.permission.USE_EXACT_ALARM`.
  - Android 13+ requires runtime `POST_NOTIFICATIONS` permission request.
  - The app gracefully checks whether exact alarms can be scheduled; if restricted by OEM battery optimizers, a prominent banner in Notification Settings guides the user.
- **Reboot Resilience:**
  - Android `RECEIVE_BOOT_COMPLETED` broadcast receiver wakes up and triggers rescheduling from the Drift SQLite `scheduled_notifications` table.
- **Deduplication:**
  - Deterministic notification IDs derived from task ID hashes and channel offsets ensure no duplicate alerts are scheduled.
