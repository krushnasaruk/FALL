# FALL — Web UI Studio & Mobile Simulator

This web studio is an interactive, pixel-perfect copy of the mobile UI of **FALL**. It allows you to visually inspect, test, and edit the UI for mobile screens directly in your browser, and then synchronize any changes back to the Flutter codebase.

---

## How to Run

1. **Option A (Instant 1-Click):**
   Double-click `open_web_ui.bat` in the project root, or double-click `web_ui/index.html`. It opens immediately in your default web browser (Chrome, Edge, Safari, Firefox).

2. **Option B (Local Web Server):**
   ```bash
   python -m http.server 8080 --directory web_ui
   ```
   Then open `http://localhost:8080` in your browser.

---

## Key Features

1. **Mobile Simulator (`320px` / `360px` / `390px` / `420px`) & Traditional Bottom NavBar:**
   - Full-width docked bottom navigation bar (`Home`, `Tasks`, `Projects`, `Learning`, `More`) with pill active highlights and interactive bottom sheets (no floating capsule).
   - All **14 Flutter screens** synced to the Phase 1–8 UI/UX overhaul with `localStorage` persistence and Empty State testing:
     - `Dashboard` (greeting, live calculated Today's Progress card, 2x2 Quick Stat cards, upcoming tasks, reorderable sections)
     - `Tasks` (List & Kanban Board views, priority badges, interactive subtasks, progressive task creation)
     - `Projects` & `Project Detail` (search, status filters, dynamic progress, 4-tab detail view with milestones & timeline)
     - `Learning` & `Skill Detail` (real 7-day trend sparkline, study logger, roadmap topics)
     - `More Hub`, `Goals` (`/goals`), `Habits` (`/habits`), `Focus Time` (live SVG countdown timer), `Calendar`, `Knowledge Vault` & `Developer Journal`, `Analytics` (real Completion Index & 28-day heatmap), `Settings` (Sounds & Vibrations preview chimes), and `Onboarding`.

2. **Mobile UI Studio & Design Token Editor (Right Panel):**
   - **Light & Dark Theme Switcher:** Switch seamlessly between FALL Light Mode (`#F8F9FC`) and Dark Mode (`#0D1117`).
   - **Design Tokens & Styling:** Tweak `AppColors.primary`, `AppColors.background`, `AppRadii.card` radius, and quick palette presets.
   - **Live App State:** Edit user display name and toggle dashboard section visibility (`UserPreferences`).
   - **Generated Flutter Diff:** Automatically mirrors adjusted tokens into ready-to-paste Flutter Dart code via **Sync / Copy Specs**.

