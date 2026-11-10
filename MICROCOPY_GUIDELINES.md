# FALL (`progress_os`) — Microcopy Guidelines

## 1. Voice & Tone
- **Calm, grounded, encouraging, developer-literate.** Never patronizing, hyperactive, guilt-inducing, or vague.
- **Concrete next step:** Empty states tell the user exactly what belongs there and offer one clear CTA.
- **Time-aware greetings:** `DashboardScreen` adapts greeting by local hour (*Good morning / Good afternoon / Good evening*), using configured display name (`Developer` default).

## 2. Honest Provenance & Non-Fabrication Standards (FALL + Radar)
- **Progress metrics:** Display `0%`, `0m`, or an empty state until user-recorded Drift rows exist.
- **Radar items:** Explicitly distinguish:
  - *Verified / Source-Reported Metrics* (`Stars`, `HN Points`, `Likes`, `Downloads`, plus real `observation` delta only when `>= 2` time-series snapshots exist)
  - *AI Explanation (Gemini)* vs *Deterministic Summary* vs *Source-Reported Excerpt*
  - *System Trend Assessments* (`Emerging`, `Growing`, `Established`, `Cooling`, `Needs Cross-Source Evidence`)
- **Notifications (`NotificationService`):** Supportive reminders (*"A gentle nudge for ..."*, *"Daily check-in"*), respectful of configured Quiet Hours (`22:00–07:30` default).

