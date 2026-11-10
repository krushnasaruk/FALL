# FALL (`progress_os`) — Interaction Specification

## 1. Core Interaction Principles
- **Immediate Perceived Response:** Interactive cards, chips, icon actions, and primary/secondary buttons respond instantaneously with subtle press compression (`AppMotion.pressScale = 0.97` via `AppButton`, `AppIconButton`, and `AppPressable`) and centralized `FeedbackService` haptics/chimes.
- **Safety Over Regret:** Task deletions, habit resets, and destructive clear actions either use reversible undo bars (`AppToast.showWithUndo`) or explicit unsaved-changes confirmation dialogs (`confirmDiscardChanges`) when dismissing dirty sheets.
- **No Mystery Controls:** Primary creation and quick actions sit in ergonomic lower-screen thumb reach (`ScaffoldWithNavBar` docked 5-tab bar + floating action buttons on `Dashboard`, `Tasks`, `Projects`, `Learning`).

## 2. Screen Interaction Flows
- **Onboarding (`OnboardingScreen`):** 3 calm steps — (1) Personal workspace name defaulting to `Developer` (`UserPreferencesRepository`), (2) Theme choice (Light/Dark/System) + opt-in gentle reminders, (3) Ready summary directing to Dashboard with honest empty-state starting point.
- **Dashboard (`DashboardScreen`):** Customize layout drawer (`DashboardCustomizationSheet`) with drag-to-reorder & visibility switches, dismissible onboarding hint (`DismissibleTipBanner`), one-tap XP/Level header linking to Insights & unlocked achievements, quick action bar (including `Focus` & `Radar`), and swipe/tap task completion with live undo toast + `RewardCelebrationDialog`.
- **Execution Screens (`Tasks`, `Projects`, `Learning`, `Focus`, `Habits`, `Goals`):** Wall-clock persisted `FocusTimerController` (tracks running intervals cleanly without inflating paused elapsed time), live milestone progress rings, and non-blocking confetti/badge celebration dialogs.
- **ProgressOS Radar (`RadarHomeScreen`, `RadarDetailScreen`, `RadarBriefingScreen`, `RadarPreferencesScreen`):** Tabbed lenses across all 9 feeds (`For You`, `Explore`, `GitHub Radar`, `Creators`, `AI & Models`, `Trending`, `Research`, `Build & Opps`, `Saved`), global search, 18-category filter drawer, P0–P3 priority/mute/keyword controls, and one-tap conversion into FALL Tasks or Learning Roadmaps.

