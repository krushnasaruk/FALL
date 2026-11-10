# FALL (`progress_os`) — UX Audit (Phase 1)

**Target Product:** FALL — Personal Productivity, Engineering & Learning Companion  
**Codebase Version Audited:** `3.0.0+3` (`pubspec.yaml`)  
**Audit Date:** 2026-11-10

---

## Executive Summary

The FALL v3.0 Flutter + Drift codebase provides a strong visual foundation (Light default `#F8F9FC`, Dark Slate `#0D1117`, docked 5-tab navigation shell, real SQLite analytics without fabricated fallback numbers, and 6 functional Android home-screen widgets). However, a thorough screen-by-screen and interaction-level inspection revealed **12 high-impact UX, motion, personality, and reliability gaps** that prevent the app from feeling responsive, forgiving, memorable, and delightfully alive.

---

## Screen & Component Audit Findings

| Area / File | Observed Current Behaviour | UX Defect & User Impact | Severity |
|---|---|---|---|
| **Skeleton & Async Loading** (`lib/core/widgets/state_views.dart`, `lib/features/vault/screens/vault_screen.dart#L161`) | `LoadingSkeleton` renders static gray rounded rectangles; `VaultScreen` renders an unstyled `CircularProgressIndicator()`; `InsightsScreen` renders `0` values silently while streams connect. | Abrupt layout snap when local queries settle; zero motion/shimmer cue; inconsistent spinner on Vault. | **High** |
| **Motion Tokens & Route Transitions** (`lib/routing/app_router.dart`, `lib/core/widgets/app_button.dart`) | No centralized duration/curve tokens (`AppMotion`). `GoRouter` uses stock abrupt platform routes; `AppButton` has no tactile press compression and bypasses `FeedbackService` by calling `HapticFeedback.lightImpact()` directly (`app_button.dart#L157`), ignoring the user's Settings haptics toggle. | Button haptics ignore user mute preference; lack of cohesive interactive feel; reduced-motion accessibility flags unhandled. | **High** |
| **Destructive Actions & Task Undo** (`lib/features/tasks/widgets/task_card.dart#L68-L80`, `lib/features/tasks/screens/tasks_screen.dart#L375-L390`) | Swiping a task card (`Dismissible`) triggers `onDelete` immediately with no `confirmDismiss` dialog and no Undo banner. Completing a task in the `Today` view removes it instantaneously without a toast + `Undo` option. | High risk of accidental permanent task deletion on swipe; accidental task check-off disappears from Today with no instant Undo. | **Critical** |
| **Unsaved Form Loss** (`task_form_sheet.dart`, `project_form_sheet.dart`, `skill_form_sheet.dart`, `vault_screen.dart`) | Tapping outside a modal sheet or pressing system Back discards entered title/notes/subtasks silently without warning. | Users lose carefully written engineering notes, tasks, or project descriptions accidentally. | **High** |
| **Focus Timer Persistence & Summary** (`lib/features/focus/screens/focus_screen.dart#L42-L136`) | Timer state lives purely in volatile `_FocusScreenState` via `Timer.periodic`. Navigating away or backgrounding pauses/loses countdown; finishing only pops a brief `AppToast` with no recorded summary card; no 1-tap preset selector beyond Pomodoro/Short/Long. | Deep-work timers break when switching apps or locking phone; paused/interrupted sessions lose accuracy; minimal post-focus reward. | **Critical** |
| **Personality & Companion Visual World** (`assets/images/`, `lib/core/widgets/fall_logo.dart`) | Only `fall_logo_light.png` exists. Empty states across all 9 modules render only small monochrome line icons inside bordered gray boxes (`EmptyStateView`). Zero companion expressions, onboarding scenes, achievement badges, or widget character visuals. | App feels clinical when empty or at milestones; lacks emotional continuity across onboarding, celebrations, and widgets. | **High** |
| **Onboarding & Feature Discovery** (`lib/routing/app_router.dart#L29`, `onboarding_screen.dart`) | `initialLocation` is hardcoded to `'/dashboard'`, so new users never experience first-launch onboarding, name setup, or theme choice. Zero contextual dismissible tips exist for first project, learning roadmap, focus timer, or dashboard reordering. | First-time setup (user name `'Robertson'` in `user_preferences_repository.dart#L58`) feels arbitrary; power features go undiscovered. | **Medium** |
| **XP, Milestones & Non-Punishing Streaks** (`lib/data/database/tables.dart`, `habit_repository.dart`) | No auditable XP ledger (`XpEvents`) or unlockable achievement badges (`UnlockedAchievements`). Completing goals/milestones gives only a brief sound/toast. Habit check-ins give subtle selection click only and lack forgiving copy after skipped days. | Milestones feel invisible; repeat actions aren't tracked cleanly; no long-term growth progression. | **Medium** |
| **Notifications Granularity & Quiet Hours** (`lib/services/notification_service.dart`, `settings_screen.dart#L384-L500`) | Only Morning Agenda & Evening Review have toggles; task/habit/learning/goal/milestone/focus categories lack individual opt-out toggles; no Quiet Hours window is enforced; notification copy (`Scheduled in FALL`) feels generic. | Users cannot silence one notification type or configure sleep/focus quiet hours. | **Medium** |
| **Audio Sound Library Completeness** (`assets/sounds/`, `MainActivity.kt#L41-L47`, `FeedbackService`) | 5 WAV assets exist (`task_complete`, `focus_start`, `focus_complete`, `goal_achieved`, `reminder_alert`), missing dedicated `achievement_unlocked.wav` and `milestone_achieved.wav` differentiation. | Achievements share no unique subtle celebration chime. | **Low** |
| **Android Home-Screen Widgets** (`android/.../Progress*.kt`, `res/layout/widget_*.xml`) | 6 widgets exist, all static text/bars without companion/module visual personality. **Learning Companion Widget (Widget C)** is missing. **Quick Capture (`ProgressQuickAddWidgetProvider`)** offers only `"Add Task"` instead of Task + Note + Focus + Learning. **Daily Progress Widget** ignores widget size variants. | Widgets lack Duolingo-like visual charm and miss learning companion + multi-action capture utility. | **High** |
| **Kanban & Accessible Controls** (`tasks_screen.dart#L401-L551`) | Board view (`_buildBoardColumn`) classifies In Progress heuristically (`actualMinutes > 0 || subtask done`) and offers no quick action menu to move/complete without opening detail sheet. | Keyboard/screen-reader/one-handed task state moves require extra navigation steps. | **Medium** |

---

## Audit Verification Baseline (`3.0.0+3`)
- Static analysis prior to UX Overhaul: `flutter analyze` → `No issues found!`
- Unit & Widget tests: `+40 ~1: All tests passed!` (`screenshot_capture_test.dart` skipped by default)
- Current database schema: Drift `schemaVersion == 1` across 15 tables cleanly zeroed on first launch.

