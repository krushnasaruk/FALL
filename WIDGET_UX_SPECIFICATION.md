# FALL (`progress_os`) — Android Home-Screen Widget UX Specification

## 1. 7-Widget Native Android Family
Synced centrally through `WidgetSyncService` (`home_widget`) across `HomeWidget` providers in `android/app/src/main/kotlin/com/progressos/progress_os/` with matching light/dark night-qualified colors (`res/values/colors.xml`, `res/values-night/colors.xml`) and compact Pip fox companion icons (`drawable-nodpi/widget_companion_*.png`).

| Widget Provider | Layout XML | Focus & Actions |
|---|---|---|
| `ProgressDailyWidgetProvider` | `widget_daily_progress.xml` | Daily completion ring/percentage & responsive `onAppWidgetOptionsChanged` compact adaptation |
| `ProgressTasksWidgetProvider` | `widget_tasks.xml` | Open task count, upcoming priority task & direct `+ Task` deep link (`new_task`) |
| `ProgressStreakWidgetProvider` | `widget_streak.xml` | Habit streak continuity & open-habits deep link (`open_habits`) |
| `ProgressFocusWidgetProvider` | `widget_focus.xml` | Today's recorded focus minutes & 1-tap launch into Focus timer (`open_focus`) |
| `ProgressProjectWidgetProvider` | `widget_project.xml` | Active project name, milestone ratio & project launch (`open_projects`) |
| `ProgressQuickAddWidgetProvider` | `widget_quick_add.xml` | 4-button fast capture deck: `Task` (`new_task`), `Note` (`new_note`), `Focus` (`open_focus`), `Learn` (`open_learning`) |
| `ProgressLearningWidgetProvider` | `widget_learning.xml` | Active skill name, topic completion (`completed/total`), logged minutes & `open_learning` deep link |

## 2. Deep Link Routing (`MainActivity.kt` + `ScaffoldWithNavBar`)
Every widget button dispatches an Android explicit `Intent` carrying `action` extra to `MainActivity.launchAction`. Flutter drains `consumeLaunchAction` on cold boot and `AppLifecycleState.resumed`, routing directly to the target screen or form sheet.

