# ProgressOS — Personal Tech Progress & Productivity OS

> A unified personal command center engineered for technology enthusiasts, software engineers, and student founders.

ProgressOS bridges daily task execution, technical skill roadmaps, project engineering, habit consistency, and deep focus sessions into a single, cohesive, local-first operating system.

---

## Key Highlights

- **Local-First & Offline:** 100% operational without an internet connection. Powered by SQLite via Drift.
- **Developer-Centric Design:** Clean, distraction-free aesthetic with high-contrast typography, refined spacing, and light/dark modes.
- **Skills & Roadmaps:** Structured technical mastery tracking with modules, subtopics, and prerequisite trees.
- **Projects & Milestones:** Manage startups, open-source repos, hardware/IoT builds, and college projects with live milestone progress.
- **Pomodoro Focus Timer:** Deep work sessions linked directly to tasks, skills, and projects with automated time allocation.
- **Android Home Screen Widgets:** 6 native Kotlin widgets keeping your streak, today's tasks, active project, and daily velocity always on hand.
- **Automated Notifications:** Exact alarm reminders, morning briefings, evening summaries, and milestone alerts.
- **Privacy & Ownership:** Full JSON export, import, and backup capability. Zero tracking.

---

## Architecture & Tech Stack

- **Framework:** Flutter (Dart 3.5+)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Database:** SQLite via Drift (`drift`, `drift_flutter`, `sqlite3_flutter_libs`)
- **Navigation:** GoRouter
- **Charts & Visualizations:** `fl_chart`
- **Native Android Widgets:** Kotlin `RemoteViews` + `home_widget`
- **Notifications:** `flutter_local_notifications` + `timezone`
- **Storage & Preferences:** `shared_preferences`, `flutter_secure_storage`

---

## Project Structure

Refer to [ARCHITECTURE.md](ARCHITECTURE.md) and [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md) for full architectural specifications.

---

## Getting Started

### Prerequisites
- Flutter SDK 3.24.5 or newer
- Android SDK 33+ (for Android builds)

### Installation
```bash
# Clone the repository
git clone <repo-url>
cd progress_os

# Fetch dependencies
flutter pub get

# Generate Drift database code
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```
