# FALL Android Home-Screen Widget Specification

FALL ships 6 native Android home-screen widgets backed by `home_widget` (`HomeWidget.saveWidgetData` + `HomeWidget.updateWidget`) orchestrated from [widget_sync_service.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/services/widget_sync_service.dart).

## 1. Adaptive Light & Dark Theme Support

All widget drawables and layouts consume resource colors from [values/colors.xml](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/android/app/src/main/res/values/colors.xml) and [values-night/colors.xml](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/android/app/src/main/res/values-night/colors.xml) with shared rounded container [@drawable/widget_background.xml](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/android/app/src/main/res/drawable/widget_background.xml):

| Role | Light Value | Dark (`-night`) Value |
|---|---|---|
| `@color/widget_bg` | `#FFFFFF` | `#161B22` |
| `@color/widget_border` | `#EAECF1` | `#30363D` |
| `@color/widget_text_primary` | `#171923` | `#F0F6FC` |
| `@color/widget_text_secondary` | `#727786` | `#94A3B8` |
| `@color/widget_text_tertiary` | `#A0A5B0` | `#6E7681` |
| `@color/widget_accent` | `#7167E8` | `#8B83F6` |
| `@color/widget_track` | `#EAECF1` | `#21262D` |

## 2. Widget Providers & Deep-Link Actions

Tapping any widget launches [MainActivity.kt](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/android/app/src/main/kotlin/com/progressos/progress_os/MainActivity.kt) with an explicit `"action"` `Intent` extra consumed by [scaffold_with_nav_bar.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/routing/scaffold_with_nav_bar.dart) via `consumeLaunchAction`:

| Provider Class | Layout XML | Data Keys | Tap Deep-Link Action |
|---|---|---|---|
| `ProgressDailyWidgetProvider` | `widget_daily_progress.xml` | `daily_completion_rate`, `completed_tasks_count`, `remaining_tasks_count`, `today_date_str` | `open_tasks` |
| `ProgressTasksWidgetProvider` | `widget_tasks.xml` | `task_{1..3}_title`, `task_{1..3}_priority`, `task_{1..3}_time` (+ empty state `tv_tasks_empty`) | `open_tasks` |
| `ProgressStreakWidgetProvider` | `widget_streak.xml` | `streak_days`, `learning_hours` | `open_habits` (`/habits`) |
| `ProgressProjectWidgetProvider` | `widget_project.xml` | `project_name`, `project_progress`, `next_milestone` | `open_projects` |
| `ProgressFocusWidgetProvider` | `widget_focus.xml` | `focus_time_text` (`syncFocusStatus` + daily minutes) | `open_focus` (`/focus`) |
| `ProgressQuickAddWidgetProvider` | `widget_quick_add.xml` | Vector `+` pill (`ic_widget_add.xml`, `widget_add_pill.xml`) | `new_task` (opens `TaskFormSheet`) |

## 3. Sync Triggers

`WidgetSyncService.syncAllWidgets()` runs at startup in `main.dart`, on task creation/completion/deletion, habit check-ins, focus session completion (`syncFocusStatus` updates during timer start/pause/reset), and on-demand in **Settings -> Sync Now**.

