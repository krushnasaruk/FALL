# ProgressOS Architecture Guide

ProgressOS is architected using **Clean Architecture** principles combined with feature-based modular packaging. This ensures strict separation of concerns, testability, offline independence, and maintainability.

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   (Screens, Riverpod Notifiers/Providers, Widgets)     │
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│                      Domain Layer                      │
│   (Entities, Value Objects, Use Cases, Failures)       │
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│                       Data Layer                       │
│    (Drift SQLite DB, Repositories, DAOs, DTOs, Mappers)│
└───────────────────────────┬────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────┐
│                    Services & Platform                 │
│  (NotificationService, WidgetSyncService, GitHub API)  │
└────────────────────────────────────────────────────────┘
```

---

## 1. Directory Structure

```
lib/
├── core/
│   ├── constants/             # App constants, DB names, channel IDs
│   ├── errors/                # Failure models, exceptions
│   ├── theme/                 # AppTheme, ColorPalette, Typography, Spacing
│   ├── utils/                 # Date formatters, recurrence calculators, validation
│   └── widgets/               # Universal design system components
├── data/
│   ├── database/              # Drift database definition, tables, DAOs, migrations
│   ├── repositories/          # Concrete implementations of Domain repositories
│   └── models/                # Data Transfer Objects and JSON serialization
├── domain/
│   ├── models/                # Pure business entities & enums
│   └── repositories/          # Abstract repository interfaces
├── features/
│   ├── dashboard/             # Home command center
│   ├── tasks/                 # Task management, subtasks, recurrence
│   ├── learning/              # Skills, roadmaps, topics, sessions
│   ├── projects/              # Projects, milestones, activity
│   ├── habits/                # Habits, goals, streaks, check-ins
│   ├── focus/                 # Pomodoro focus timer, session logs
│   ├── insights/              # fl_chart analytics, growth timeline
│   ├── vault/                 # Lightweight notes and ideas
│   ├── settings/              # App config, backup/restore, widgets, theme
│   └── github/                # GitHub API integration & repo activity
├── routing/                   # GoRouter navigation configuration
└── services/                  # Platform services (Notifications, Widgets, Storage)
```

---

## 2. State Management with Riverpod

- **Notifier Providers (`AsyncNotifier` & `StateNotifier`):** Manage state with explicit loading, data, and error lifecycle.
- **Dependency Injection:** Repositories, database instances, and services are provided via immutable Riverpod providers (`Provider<T>`).
- **Stream Providers:** Used for reactive Drift database queries to automatically trigger UI updates when data alters.

---

## 3. Local-First Data Flow

1. Every write operation hits the local Drift SQLite database first.
2. Drift emits reactive stream updates that Riverpod `StreamProvider`s listen to.
3. The UI rebuilds only the necessary components.
4. Services (such as `WidgetSyncService` and `NotificationService`) observe repository events to update native Android widgets and schedule local reminders asynchronously.

---

## 4. Platform Channels & Native Android Integration

- **Home Screen Widgets:** Managed through native Android Kotlin `AppWidgetProvider` classes using `RemoteViews` layouts. `home_widget` synchronizes state between Flutter SharedPreferences / AppGroup storage and the Android widgets.
- **Notifications:** Built with `flutter_local_notifications` targeting Android 8.0+ notification channels and Android 12+ exact alarm scheduling with `timezone` support.

