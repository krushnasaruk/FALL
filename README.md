# ProgressOS / FALL — Personal Tech Progress, Productivity & Radar OS

> A unified personal command center engineered for technology enthusiasts, software engineers, and student founders.

FALL bridges daily task execution, technical skill roadmaps, project engineering, habit consistency, deep focus sessions, and **ProgressOS Radar** (continuous technology intelligence & discovery across 18 categories) into a cohesive, local-first operating system.

---

## Key Highlights

- **Local-First & Offline:** 100% operational without an internet connection. Powered by SQLite via Drift (`schemaVersion: 3`).
- **Pip Companion & Calming UX Motion:** Custom fox companion visual assets (`assets/images/`), reduced-motion-aware `AppMotion` transitions, synthesized audio chimes (`assets/sounds/`), undo recovery, and auditable `XpEvents` + `UnlockedAchievements`.
- **ProgressOS Radar (`backend/radar_server/` + `lib/features/radar/`):**
  - Covers **18 technology categories (A–R)** prioritized across configurable levels (`P0`–`P3`) with mute/keyword rules and adjustable exploratory discovery balance (`70%` aligned / `30%` exploratory default).
  - Independent live connectors for GitHub Search + star/fork snapshots, Hacker News Firebase, YouTube Data API v3 + zero-quota Atom channel feeds, Hugging Face Hub models/Spaces, arXiv preprints, universal RSS/Atom (Reddit `.rss`, Product Hunt, engineering blogs), DEV Community & Lobsters.
  - Budget-capped Gemini AI analysis (`backend/radar_server/.env`, zero keys shipped in Flutter!) with automatic deterministic fallback, cross-source Trend Detection, and 10-section Daily Briefings.
- **Skills & Roadmaps:** Structured technical mastery tracking with modules, subtopics, and visual study charts.
- **Projects & Milestones:** Track startups, open-source repos, hardware/IoT builds, and milestones.
- **Persistent Focus Timer:** Wall-clock Pomodoro/Deep Work timer preserving paused accuracy + linked logs.
- **Android Home Screen Widgets:** 7 native Kotlin `RemoteViews` widgets (`Daily Progress`, `Tasks`, `Streak`, `Focus`, `Project`, `Quick Add`, `Learning`) with direct deep links.
- **Smart Notifications & Quiet Hours:** 7 channels with category toggles and configurable quiet hours (`22:00–07:30` default).

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

### ProgressOS Radar Server (Self-Hosted Desktop Companion)
```bash
# Copy example env and add your own API keys (never commit .env)
copy backend\radar_server\.env.example backend\radar_server\.env

# Run one live collection cycle
python -m backend.radar_server.server --collect-once

# Start local API server (reachable from Android emulator at http://10.0.2.2:8787)
python -m backend.radar_server.server --port 8787
```
