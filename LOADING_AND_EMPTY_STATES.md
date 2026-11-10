# FALL (`progress_os`) — Loading, Skeleton & Empty States

## 1. Screen-Matched Skeleton Loaders (`lib/core/widgets/state_views.dart`)
- **`DashboardSkeleton`:** Mirrors `AppHeader` avatar + eyebrow + title, hero `TodayProgressCard` height (`126dp`), responsive `Expanded` quick-action pill row, 2x2 KPI grid (`88dp`), and 2 upcoming task placeholders. Fixed-width rows are avoided so `320dp` viewports never overflow.
- **`TasksSkeleton`:** Stack of `76dp` task card placeholders aligned with `AppSpacing.pageHorizontal`.
- **`ProjectsSkeleton`:** Header hero banner (`152dp`) plus stacked `132dp` project cards.
- **`AnalyticsSkeleton`:** Ring overview block (`240dp`), 2x2 KPI blocks (`86dp`), and chart box (`168dp`).

## 2. Illustrated Empty States & Zero-Fake-Data Policy
Every core domain renders dedicated Pip fox artwork (`assets/images/empty/`) with calm, action-oriented copy — zero fabricated charts, placeholder counts, or fake news:
- **Dashboard Upcoming (`DashboardScreen`):** Pip idle/happy avatar + *"Nothing on your list yet."*
- **Tasks / Projects / Learning / Goals / Habits / Notes / Journal / Analytics:** Dedicated `EmptyStateView` illustrations (`empty_tasks.png`, `empty_projects.png`, `empty_learning.png`, `empty_goals.png`, `empty_habits.png`, `empty_notes.png`, `empty_journal.png`, `empty_analytics.png`).
- **ProgressOS Radar (`RadarHomeScreen`, `RadarBriefingScreen`):** Renders honest empty prompts (*"Nothing synced in For You yet"*) with a single primary **"Sync Radar"** CTA until live sources or offline cache contain real records.
- **Dismissible Guidance (`DismissibleTipBanner`):** Non-intrusive tip banners can be permanently dismissed and persisted in `UserPreferencesRepository.dismissedTips`.

