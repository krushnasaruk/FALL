# FALL (`progress_os`) — Core User Journeys

---

## Journey 1: First-Time User Launch & Onboarding
1. **Trigger:** App detects `onboarding_completed == false` on fresh install.
2. **Steps:**
   - User greets **Pip** (`welcome` expression) on Page 1 with brand clarity (*Plan. Build. Learn. Grow.*).
   - User personalizes Workspace Name (defaults cleanly to `Developer`, not an arbitrary placeholder) and selects preferred Theme (**Light**, **Dark**, or **System**) with live preview.
   - User optionally chooses whether to enable daily Agenda/Review reminders (never forced at launch without consent).
3. **Result:** Navigates smoothly to `/dashboard` with zero fake tasks/metrics, showing an inviting empty dashboard card (`"Nothing on your list yet."`) and a single dismissible first-run tip when appropriate.

## Journey 2: Task Lifecycle, Completion & Safe Recovery
1. **Create:** User taps **+ Task** (`FloatingActionButton` or Quick Action) → opens `TaskFormSheet` with Title, Priority, Due Date immediately accessible, plus expandable *More Options*. Attempting to dismiss with unsaved input asks *Save changes? / Continue Editing / Discard*.
2. **Complete:** Tapping the circular checkbox animates checkmark + strikethrough + `+15 XP`, triggers light haptic & soft chime (if enabled), updates Today's Progress ring/bars & Android widgets, and surfaces an **Undo** toast (`"Task completed (+15 XP)" • Undo`).
3. **Safe Delete:** Swiping left prompts `ConfirmationDialog` (or restores safely on Cancel), preventing accidental data loss.
4. **Recover / Edit:** Completed tasks remain browsable under the **Completed** filter tab or editable via `TaskDetailSheet` + `Move / Duplicate / Edit` visible controls.

## Journey 3: Focus Deep Work Across App Backgrounding
1. **Select:** User navigates to `/focus`, picks preset duration (`15m`, `25m Pomodoro`, `45m Deep`, `5m Break`, `15m Rest`) and optionally links an open Task or active Project.
2. **Run:** Tapping **Start** persists `targetEndEpochMs` & elapsed focus state in `SharedPreferences` via `FocusTimerController`. Leaving `/focus`, switching tabs, or backgrounding the app preserves exact remaining wall-clock time; pausing freezes active accumulation so paused time is never billed as focus.
3. **Complete:** Reaching zero (or tapping **Finish Session**) opens the **Focus Completion Summary Sheet** with Pip (`celebrating`), exact recorded focused minutes, linked task, `+20 XP` earned, and 1-tap dismissal.

## Journey 4: Habit Consistency Without Streak Shame
1. **Check-In:** User taps the 1-tap circle on `HabitCard`. `HabitAndGoalRepository` writes the local date (`YYYY-MM-DD`) and recalculates current & longest streak.
2. **State Feedback:**
   - First check-in today animates green ring + shows `"Checked in for today (+15 XP)"`.
   - Tapping again clearly communicates `"Already checked in today — tap Undo to uncheck"`.
   - After missed days, card copy gently states `"Yesterday was a break. Start again whenever you're ready."` rather than `"Streak lost!"`.

## Journey 5: Learning Roadmap & Milestone Progression
1. **Discover:** First visit to Learning / Projects shows a concise dismissible contextual tip explaining Roadmaps (Modules → Topics) or Project Milestones → Tasks.
2. **Log & Advance:** Completing topics or logging study sessions animates `fl_chart` 7-day trend + `AppProgressBar`, records `+XP`, and unlocks category achievements (*First Spark*, *Focused Mind*, *Knowledge Builder*, *Project Shipper*, etc.).

## Journey 6: Home-Screen Widget Quick Actions
1. **Daily Progress / Learning / Streak / Focus / Project / Quick Capture Widgets:** User glances at real stats paired with cohesive Pip companion artwork on their launcher.
2. **Action:** Tapping Quick Capture opens **New Task** (`new_task`), **New Note** (`new_note`), **Focus Mode** (`open_focus`), or **Learning** (`open_learning`) straight to the destination inside FALL.

