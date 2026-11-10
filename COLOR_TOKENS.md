# FALL Design System Color Tokens

Primary experience defaults to a calm, high-legibility near-white light theme (`ThemeMode.light`) paired with an independent low-glare dark slate theme (`ThemeMode.dark`). All tokens are centrally defined in [app_colors.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/theme/app_colors.dart).

## 1. Light Theme Foundation (Primary Experience)

| Token Name | Hex | Role |
|---|---|---|
| `AppColors.background` | `#F8F9FC` | Primary canvas / Scaffold background |
| `AppColors.surface` | `#FFFFFF` | Card, sheet, input, and dialog background |
| `AppColors.surfaceElevated` | `#F1F3F9` | Nested strips, chart tracks, inactive fills |
| `AppColors.border` | `#EAECF1` | Crisp 1dp hairline structural borders |
| `AppColors.borderSubtle` | `#F3F5FA` | Subtle inner boundaries |
| `AppColors.divider` | `#EAECF1` | List and card dividers |
| `AppColors.textPrimary` | `#171923` | Headings, primary titles, numerical KPIs |
| `AppColors.textSecondary` | `#727786` | Subtitles and supporting metadata |
| `AppColors.textTertiary` | `#A0A5B0` | Timestamps, hints, secondary placeholders |

## 2. Independent Dark Theme Foundation

| Token Name | Hex | Role |
|---|---|---|
| `AppColors.darkBackground` | `#0D1117` | Main dark canvas |
| `AppColors.darkSurface` | `#161B22` | Cards, sheets, navigation chrome |
| `AppColors.darkSurfaceElevated` | `#21262D` | Elevated tiles, inputs, progress tracks |
| `AppColors.darkBorder` | `#30363D` | Structural dark border |
| `AppColors.darkDivider` | `#21262D` | Section dividers |
| `AppColors.darkTextPrimary` | `#F0F6FC` | Primary high-contrast dark mode ink |
| `AppColors.darkTextSecondary` | `#94A3B8` | Supporting labels |
| `AppColors.darkTextTertiary` | `#6E7681` | Muted metadata |

## 3. Brand, Action & Semantic Accents

| Token Name | Hex | Usage |
|---|---|---|
| `AppColors.primary` | `#7167E8` | Primary buttons, active tab indicators, links |
| `AppColors.primaryDark` | `#8B83F6` | Primary accent tuned for dark surfaces |
| `AppColors.primarySoft` | `#EEECFC` | Soft lavender highlight pills and chips |
| `AppColors.secondary` | `#70BDEB` | Secondary visual accents & rings |
| `AppColors.success` | `#62B989` | Completed tasks, habits, and target checks |
| `AppColors.warning` | `#E9B85B` | Approaching deadlines & medium attention states |
| `AppColors.error` | `#E47C86` | Validation errors, destructive buttons, overdue warnings |

## 4. Restrained Module Identity Surfaces

Soft pastel surfaces appear strictly on purposeful module containers (`QuickStatMiniCard`, module KPI cards, and category badges), accompanied by AA-compliant foreground accents:

| Module | Light Surface | Light Border | Foreground Accent | Dark Surface |
|---|---|---|---|---|
| **Tasks** | `#F0F8FE` (`taskSurface`) | `#D7ECFA` | `#2B7FB8` (`taskAccent`) | `#14212E` (`darkTaskSurface`) |
| **Projects** | `#F3F1FD` (`projectSurface`) | `#DFD9F8` | `#5D52D6` (`projectAccent`) | `#1A1B2E` (`darkProjectSurface`) |
| **Learning** | `#F3EFFD` (`learningSurface`) | `#E2D8FA` | `#6B4FD6` (`learningAccent`) | `#1B1A2D` (`darkLearningSurface`) |
| **Goals** | `#FFF8E6` (`goalSurface`) | `#F7E4B4` | `#B7791F` (`goalAccent`) | `#241E14` (`darkGoalSurface`) |
| **Habits** | `#EEF9F2` (`habitSurface`) | `#CDEBD7` | `#2E8555` (`habitAccent`) | `#14231C` (`darkHabitSurface`) |
| **Focus** | `#EBF8FC` (`focusSurface`) | `#CCEBF5` | `#1D7FA8` (`focusAccent`) | `#13222A` (`darkFocusSurface`) |
| **Notes / Journal** | `#F9F7F3` (`noteSurface`) | `#EAE3D7` | `#727786` / `#7167E8` | `#1B1A18` (`darkNoteSurface`) |

## 5. Priority & Project Status Tokens

- **Priorities:** Low `#64748B`, Medium `#3B82F6`, High `#D97706`, Urgent `#DC2626`.
- **Project Statuses:** Active `#2E8555`, Planning `#5D52D6`, On Hold `#B7791F`, Completed `#2B7FB8`, Archived `#64748B`.

