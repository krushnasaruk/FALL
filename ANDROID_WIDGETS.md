# ProgressOS — Native Android Home Screen Widgets

ProgressOS features real, native Android App Widgets written in Kotlin with Android `RemoteViews`, `AppWidgetProvider`, and dynamic update dispatchers.

---

## 1. Data Flow & Synchronization Bridge

```
┌────────────────────────────────────────────────────────┐
│             Flutter / Drift Local Storage              │
│       (Tasks, Focus Timer, Projects, Habits)          │
└───────────────────────────┬────────────────────────────┘
                            │
                            │ Writes snapshot on every change
                            ▼
┌────────────────────────────────────────────────────────┐
│          WidgetSyncService (home_widget)               │
│ - Saves structured payload to Android SharedPreferences│
│ - Calls HomeWidget.updateWidget(name, provider)        │
└───────────────────────────┬────────────────────────────┘
                            │
                            │ Android OS Widget Broadcast
                            ▼
┌────────────────────────────────────────────────────────┐
│           Kotlin AppWidgetProvider Classes             │
│ - ProgressDailyWidgetProvider                          │
│ - ProgressTasksWidgetProvider                          │
│ - ProgressStreakWidgetProvider                         │
│ - ProgressProjectWidgetProvider                        │
│ - ProgressFocusWidgetProvider                          │
│ - ProgressQuickAddWidgetProvider                       │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│       RemoteViews XML & App Launch PendingIntents      │
│ - Click task -> Completes or opens task                │
│ - Click Quick Add -> Directly opens Task Creation Modal│
│ - Supports Light/Dark System Appearance                │
└────────────────────────────────────────────────────────┘
```

---

## 2. Widget Suite Details

| Widget Name | Size | Purpose | Key Data Fields |
|---|---|---|---|
| **Daily Progress** | 2x2, 4x2 | Snapshot of today's progress | Percentage, Completed count, Pending count, Progress bar |
| **Today's Tasks** | 4x2, 4x3 | Interactive checklist of tasks | Top 3-5 tasks with priority chips and due times |
| **Learning Streak** | 2x1, 2x2 | Continuous technical learning streak | Current streak count, week activity dots, total learning hours |
| **Active Project** | 3x2, 4x2 | Primary engineering focus | Project name, tech badges, milestone progress % |
| **Focus Timer** | 2x1, 2x2 | Quick glance at focus state | Active session time, current task/project name, quick launch |
| **Quick Add** | 1x1, 2x1 | One-tap task/idea capture | Direct deep-link to task creation sheet |

---

## 3. Deep-Linking and Native Interaction

- Clicking on any widget invokes a deep link handled by GoRouter:
  - Daily Progress & Streak -> `/dashboard` or `/insights`
  - Today's Tasks -> `/tasks`
  - Quick Add -> `/tasks?action=new`
  - Active Project -> `/projects/:id`
  - Focus Timer -> `/focus`

