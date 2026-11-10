# ProgressOS UX Guidelines & Interaction Architecture

---

## 1. Information Architecture & Navigation Hierarchy

### 1.1 Five Primary Bottom Navigation Destinations
As specified in the Design System and reference image:
1. **Home (`/dashboard`)**: Daily command center with greeting, today's completion ring/bars, quick stats grid, upcoming tasks, active builds.
2. **Tasks (`/tasks`)**: Complete task management with Today / Upcoming / Completed views and Kanban Board mode.
3. **Projects (`/projects`)**: Categorized project management, milestones checklist, tech stack chips, and dynamic progress tracking.
4. **Learning (`/learning`)**: Skill roadmaps, interactive topic milestones, and study time logging.
5. **More (`/more`)**: Samsung One UI-style reachable hub providing 1-tap access to:
   - Goals & Habits
   - Focus & Pomodoro Timer
   - Agenda & Calendar
   - Knowledge Vault (Notes & Snippets)
   - Analytics & Insights
   - System Settings & Backup

---

## 2. Interaction Patterns & Ergonomics

### 2.1 One-Handed Reachability (Samsung One UI Influence)
- Upper 35% of the screen displays contextual titles, greetings, and visual status.
- Primary interactive targets (filter chips, bottom sheets, list items, action buttons) are anchored in the lower 65% interaction zone.
- Bottom-docked quick creation button allows instant task capture without stretching thumb to the top bar.

### 2.2 Progressive Disclosure
- **Task Creation**: Title, due date, and priority are surfaced upfront. Advanced fields (recurrence, tags, estimated duration, project linking, subtasks) are housed in an expandable section.
- **Project Detail**: High-level progress, status, and milestone checklist are immediately legible. Technical architecture notes and deep links expand when needed.
- **Learning Roadmaps**: Skills show high-level mastery and progress; expanding reveals modules and subtopics with documentation URLs.

### 2.3 Immediate Feedback & Micro-Interactions (Funtouch OS Influence)
- **Task Completion**: Instant check animation with strikethrough transition and subtle counter decrement.
- **Habit Check-In**: 1-tap check with immediate streak increment.
- **Copy Actions**: Instant snackbar confirmation when repository URLs or note snippets are copied.
- **Destructive Actions**: Always confirm via explicit `ConfirmationDialog` with distinct primary cancel action.

---

## 3. Accessibility & Usability Standards

- **Touch Targets**: All interactive elements maintain a minimum hit box of `48 x 48` logical pixels.
- **Text Contrast**: Text against pastel card backgrounds adheres to WCAG AA standard (> 4.5:1 contrast ratio).
- **Semantics**: Icon-only buttons feature explicit `Tooltip` and screen-reader `Semantics` labels.
- **Font Scaling**: All components use flexible layouts (`Column(mainAxisSize: MainAxisSize.min)`, `Wrap`, `Flexible`) to ensure no layout overflows on large font settings.

