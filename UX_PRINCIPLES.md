# FALL (`progress_os`) — UX Principles

FALL (Personal Productivity, Engineering & Learning Companion) combines Apple-inspired clarity and typography discipline, Samsung One UI reachability, Funtouch OS warm personality, and Duolingo-inspired progression without streak guilt.

---

## 1. Non-Negotiable Principles

1. **Make the next action obvious:** Every screen tells the user where they are (`PageTitle`), what matters right now (`SectionHeader`), and offers one clear primary CTA (`FloatingActionButton` or primary `AppButton`).
2. **Reduce cognitive load:** Progressive disclosure hides secondary metadata (recurrence, estimation, tags, markdown repo URLs) until expanded; form validation points directly to the missing field without modal cascades.
3. **Make interactions feel immediate:** Tapping task completion, habit check-ins, filter chips, or timers animates immediately and writes cleanly to local SQLite, pairing destructive deletions or quick completions with Undo recovery.
4. **Never punish the user:** No red guilt badges for ordinary pending work, no aggressive streak-shame prompts, no nagging notifications. Rest days are treated calmly (`"Yesterday was a break. Start again whenever you're ready."`).
5. **Delight must serve usability:** Pip (the FALL Fox companion) appears at onboarding, empty states, achievement unlocks, and companion widgets — never cluttering dense work lists or blocking task creation.

---

## 2. Core Emotional States

| Moment | Desired User Feeling | Product Behaviour |
|---|---|---|
| **Opening the app** | Calm, oriented | Time-of-day greeting, `0%`–`100%` honest Today ring/bars, zero fake data or quote banners |
| **Planning work** | Clear, unhurried | Clean progressive sheets, clear date/priority tags, unsaved-change protection |
| **Focusing deeply** | Anchored, distraction-free | Persistent wall-clock countdown, paused time excluded, muted secondary chrome |
| **Making progress** | Encouraged, rewarded | Smooth animated bars, `+XP` feedback, quiet audio/haptic response, milestone banner |
| **Returning after missed days** | Welcomed back cleanly | Calm summary copy, streak calculation respects local calendar day & schedule, zero scolding |
| **Encountering empty modules** | Invited to begin | Friendly illustrated Pip expression + one encouraging sentence + single primary button |

