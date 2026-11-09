# Changelog

All notable changes to **ProgressOS** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-11-10

### Initial Full Release
- **Clean Architecture Foundation:** Established feature-based modular folder structure with strict separation of Presentation, Domain, Data, and Services layers.
- **Design System:** Created cohesive theme tokens (`AppTheme`, `AppColors`, `AppTypography`, `AppSpacing`, `AppElevation`), supporting responsive Dark and Light modes.
- **Local Database (Drift SQLite):** Full relational schema with tables for Tasks, Subtasks, Projects, Milestones, Skills, Learning Modules, Topics, Sessions, Goals, Habits, Focus Sessions, Notes, and Activity Logs.
- **Automated Local Notification System:** Channels, exact alarm triggers, reschedule on task update, snooze and completion actions, and permission handling.
- **Task Management System:** Priority matrix (Low/Medium/High/Urgent), due date & time, recurrence (daily, weekly, monthly, weekdays), subtasks, tagging, search, filter, and sorting.
- **Tech Learning Tracker & Roadmaps:** Categorized skills, structured roadmaps (Modules, Topics, Prerequisites, Statuses), progress calculation from verified milestone completion, and learning session timer.
- **Project Command Center:** Comprehensive tracking of startup, web, mobile, ML, IoT, and college projects with tech stack tags, milestones, associated tasks, and activity logs.
- **Habits & Goals:** Streak counter, daily check-in matrix, constructive progress visualization, and multi-tier goals (daily, weekly, monthly, long-term).
- **Pomodoro Focus Timer:** Customizable focus duration, break intervals, task/project association, session persistence, and time analytics.
- **Analytics & Insights:** Visual dashboards powered by `fl_chart` analyzing task throughput, focus time per technology, project milestones, and an achievement timeline.
- **Knowledge Vault:** Quick and structured markdown notes with entity cross-referencing and tag filters.
- **Android Home Screen Widgets:** 6 native Kotlin AppWidgetProviders (Daily Progress, Today's Tasks, Learning Streak, Active Project, Focus Timer, Quick Add) with live synchronization via `home_widget`.
- **Offline Data Backup & Restore:** Full JSON export and import engine.
- **Optional GitHub Integration:** Secure token storage, repository activity, and commit metrics.

