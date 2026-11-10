# FALL Typography Guidelines

Typography is the primary visual structure across FALL. Every screen uses offline-bundled static **Plus Jakarta Sans** weights configured in [pubspec.yaml](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/pubspec.yaml) (`assets/fonts/PlusJakartaSans-{Regular,Medium,SemiBold,Bold,ExtraBold}.ttf`) and defined in [app_typography.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/theme/app_typography.dart).

## 1. Type Scale & Weights

| Role / Token | Size | Weight | Line Height | Letter Spacing | Usage |
|---|---|---|---|---|---|
| `AppTypography.display` | `32.0` | Bold (`700`) | `1.15` | `-0.6` | Onboarding titles & major hero readouts |
| `AppTypography.pageTitle` | `27.0` | SemiBold (`600`) | `1.22` | `-0.4` | Screen headers via `PageTitle` |
| `AppTypography.sectionTitle` | `19.0` | SemiBold (`600`) | `1.30` | `-0.25` | Section group headings |
| `AppTypography.cardTitle` | `16.0` | SemiBold (`600`) | `1.35` | `-0.1` | Card titles and list headers |
| `AppTypography.body` | `15.0` | Regular (`400`) | `1.45` | `0.0` | Long-form notes, task descriptions |
| `AppTypography.bodyMedium` | `14.0` | Regular (`400`) | `1.45` | `0.0` | Compact copy, form inputs, buttons |
| `AppTypography.secondary` | `13.0` | Regular (`400`) | `1.40` | `0.0` | Subtitles, secondary explanations |
| `AppTypography.metadata` | `11.5` | Medium (`500`) | `1.30` | `0.1` | Dates, counts, filter chips, small badges |

## 2. Tabular Numerical Discipline

To eliminate jitter when countdowns tick or dashboard progress updates, numerical tokens explicitly declare `FontFeature.tabularFigures()`:

- `AppTypography.statNumerical`: `30.0`, Bold (`700`), `-0.6` tracking, tabular figures — Dashboard/Analytics primary numbers.
- `AppTypography.statMedium`: `22.0`, Bold (`700`), `-0.4` tracking, tabular figures — KPI tile metrics & mini stats.
- `AppTypography.timerDisplay`: `44.0`, Bold (`700`), `-1.0` tracking, tabular figures — Pomodoro / Focus countdown ring.

## 3. Formatting & Wrapping Rules

- **Strict single-line prevention on critical titles:** Task titles, skill headings, and goal titles allow `maxLines: 2` + `TextOverflow.ellipsis` instead of mid-word truncation on narrow phones (`320dp`).
- **Sentence-case clarity:** Body labels, section subtitles, and helper text use natural sentence case. Micro uppercase is limited to short widget kickers and Kanban column status headers.
- **No tiny unreadable captions:** Interactive badge text uses a `11.0–12.5dp` floor with crisp contrast against its tint (`AppColors.*Accent` rather than low-contrast neon yellow/pink text on white).

