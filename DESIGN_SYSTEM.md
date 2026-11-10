# FALL Design System Overview

FALL ("Plan. Build. Learn. Grow.") combines calm editorial whitespace (Apple discipline), comfortable one-handed bottom navigation & thumb-zone action placement (Samsung One UI practicality), and subtle module color accents plus live home-screen widgets (Funtouch OS personality).

## 1. Visual Architecture Principles

1. **75–85% Neutral Surface Dominance:** Screens rest on cool-warm near-white canvas (`#F8F9FC`) with crisp `#FFFFFF` content cards delimited by `1.0dp` `#EAECF1` hairline borders (or `#0D1117` canvas / `#161B22` cards / `#30363D` borders in Dark Mode) instead of floating blurs or stacked shadows.
2. **Functional Cards Only:** Every `AppCard` or restrained `PastelCard` holds actionable or summary data. Decorative floating blobs were stripped from card primitives.
3. **Typography-First Hierarchy:** [app_typography.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/theme/app_typography.dart) provides bundled static **Plus Jakarta Sans** with `tabularFigures` across timers, KPI percentages, and streak counters.
4. **Honest Empty & Live Data States:** Zero screens fabricate percentages, hours, velocity charts, or heatmap intensities when SQLite is empty. Every screen reflects live Drift queries (`AppDatabase` schemaVersion `1`).

## 2. Spacing & Corner Geometry

Defined cleanly in [app_spacing.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/theme/app_spacing.dart) and [app_radii.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/theme/app_radii.dart):

- **Grid Rhythm (4/8dp multiples):** `xs = 4.0`, `sm = 8.0`, `md = 12.0`, `lg = 16.0`, `xl = 20.0`, `xxl = 24.0`, `xxxl = 32.0`.
- **Standard Horizontal Margin:** `AppSpacing.pageHorizontal = 20.0`.
- **Card Padding:** `16.0dp` (`AppSpacing.card`) or `14.0dp` (`AppSpacing.compactCard`).
- **Corner Radii:** `xs = 6.0`, `sm = 10.0`, `md = 14.0` (inputs/buttons), `card = 18.0`, `xl = 20.0` (sheets/dialogs), `full = 999.0` (pills).

## 3. Semantic Iconography

Standardized in [app_icons.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/theme/app_icons.dart):
- Outline rounded icons represent inactive states (`home_outlined`, `check_circle_outline_rounded`, `folder_outlined`, `school_outlined`, `grid_view_outlined`).
- Solid/rounded variants mark active bottom-navigation tabs only (`home_rounded`, `check_circle_rounded`, `folder_rounded`, `school_rounded`, `grid_view_rounded`).
- Secondary tools share uniform line weight (`flag_outlined` Goals, `repeat_rounded` Habits, `timer_outlined` Focus, `calendar_today_outlined` Calendar, `menu_book_outlined` Knowledge Vault, `edit_note_rounded` Dev Journal, `bar_chart_rounded` Analytics).

## 4. Navigation Structure

[scaffold_with_nav_bar.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/routing/scaffold_with_nav_bar.dart) renders a docked 5-tab bottom navigation bar on mobile (`Home`, `Tasks`, `Projects`, `Learning`, `More`) and a vertical desktop `NavigationRail` with `FallLogo` at widths `>= 800dp`. All specialized tools (`Goals`, `Habits`, `Focus`, `Calendar`, `Knowledge Vault`, `Developer Journal`, `Analytics`, `Settings`, `Welcome Tour`) sit cleanly under the Command Hub (`/more`) and direct home dashboard shortcuts.

