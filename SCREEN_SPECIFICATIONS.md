# FALL Screen & Navigation Specifications

Every screen uses [app_scaffold.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/app_scaffold.dart) (`AppScaffold` + `PageTitle`), respects both Light (`#F8F9FC`) and Dark (`#0D1117`) themes, and reads live Drift SQLite streams without fabricated fallback values.

## 1. Shell & Primary Tabs (`ScaffoldWithNavBar`)

Defined in [app_router.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/routing/app_router.dart) and [scaffold_with_nav_bar.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/routing/scaffold_with_nav_bar.dart):

- **Home (`/dashboard`)**: Docked tab 0 (`AppIcons.home` / `homeActive`). Greeting (`displayName`), upcoming reminder sheet trigger, theme toggle, customization trigger (`ReorderableListView` + visibility switches), `TodayProgressCard`, `QuickActionsBar`, `QuickStatMiniCard` 2x2 grid, upcoming tasks, active projects, and learning/focus summary.
- **Tasks (`/tasks`)**: Docked tab 1 (`AppIcons.tasks` / `tasksActive`). List vs Kanban Board view switch, expandable `SearchField`, view pills (`Today`, `Upcoming`, `All`, `Completed`, `Overdue`), priority chips, `TaskCard`, detail sheet, and progressive-disclosure `TaskFormSheet` with reminder scheduling (`NotificationService`).
- **Projects (`/projects`)**: Docked tab 2 (`AppIcons.projects` / `projectsActive`). Project filter chips, clean `ProjectCard` without fake team avatars, and 4-tab `ProjectDetailScreen` (**Overview**, **Milestones**, **Tasks**, **Activity Timeline**).
- **Learning (`/learning`)**: Docked tab 3 (`AppIcons.learning` / `learningActive`). Total accumulated study minutes, interactive per-skill 7-day `fl_chart` learning sparkline, `SkillCard` list, session logger, and `SkillDetailScreen` with expandable roadmap modules and persisted `TopicEditDialog`.
- **More (`/more`)**: Docked tab 4 (`AppIcons.more` / `moreActive`). FALL workspace card plus calm grouped lists for **Execution & Consistency**, **Knowledge & Insights**, and **Preferences & System**.

## 2. Sub-Module Routes

- **Goals (`/goals` — `GoalsScreen`)**: Intentionally separated from Tasks & Habits. Targets filter (`All`, `Daily`, `Weekly`, `Monthly`, `Long Term`), numerical progress bars, `+1` increment with `milestoneAchieved` chime when reached, exact progress dialog, and target deletion.
- **Habits (`/habits` — `HabitsScreen`)**: Recurring daily rituals with streak calculation, 7-day interactive completion check-in indicators, check-in haptic feedback, and deletion confirmation.
- **Focus (`/focus` — `FocusScreen`)**: Clean `AppProgressRing` countdown timer (`Pomodoro` 25m / `Short Break` 5m / `Long Break` 15m), optional Task/Project session attribution, recent focus logs, native widget sync (`syncFocusStatus`), completion sound + notification.
- **Calendar & Agenda (`/calendar` — `AgendaCalendarScreen`)**: Expandable month/week strip displaying real Tasks, Project Deadlines, Milestones, and Focus sessions on their actual dates without placeholder events.
- **Knowledge Vault (`/vault` — `VaultScreen`)** & **Developer Journal (`/journal` — `VaultScreen(initialJournalMode: true)`)**: Markdown notes backed by Drift `Notes` table, tag/project/skill links, pin support, and structured Dev Journal template (`category: 'journal'` — *Development Notes*, *Problems & Solutions*, *Next Steps*).
- **Analytics & Insights (`/insights` — `InsightsScreen`)**: Timeframe selector (`7D`, `30D`, `3M`, `1Y`), overall execution `AppProgressRing`, 2x2 real KPI grid, effort allocation bar (`Tasks` vs `Learning` vs `Focus`), 28-day heatmap generated directly from real DB records, and 7-day velocity `BarChart` with honest empty state.
- **Settings (`/settings` — `SettingsScreen`)**: Theme selector (`Light`/`Dark`/`System`), Display Name, Dashboard Layout trigger, persisted Notifications & Exact Alarm permissions, `Sounds & Vibrations` toggles + preview chime, Native Widget sync, JSON Backup/Restore, GitHub PAT integration, and About FALL (`FallLogo`).
- **Welcome Tour (`/onboarding` — `OnboardingScreen`)**: Editorial 3-page tour highlighting FALL's offline-first design.

