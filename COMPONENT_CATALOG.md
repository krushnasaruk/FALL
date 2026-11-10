# FALL Reusable Component Catalog

All core design primitives live under `lib/core/widgets/` and enforce consistent radii (`14–20dp`), 1dp borders, accessibility semantics, and adaptive Light/Dark surface behavior.

## 1. Layout & Chrome

- **`AppScaffold`** ([app_scaffold.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/app_scaffold.dart)): SafeArea-aware scaffold applying `AppColors.background` (light) / `AppColors.darkBackground` (dark).
- **`PageTitle`**: Consistent top header with `AppTypography.pageTitle`, optional 44x44dp rounded back button (`showBackButton`), optional subtitle, and trailing actions.
- **`SectionHeader`** ([section_header.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/section_header.dart)): Paired `AppTypography.sectionTitle` + subtitle + accessible `48x44dp` minimum `actionLabel` button (`See all`, etc.).
- **`ScaffoldWithNavBar`** ([scaffold_with_nav_bar.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/routing/scaffold_with_nav_bar.dart)): Docked 5-tab mobile bottom bar (`Home`, `Tasks`, `Projects`, `Learning`, `More`) using outline/filled icons from `AppIcons` plus desktop `NavigationRail` at `>= 800dp`.

## 2. Buttons & Inputs

- **`AppButton` / `PrimaryButton` / `SecondaryButton`** ([app_button.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/app_button.dart)): Uses `MainAxisSize.min` (preventing unbounded `ListTile.trailing` assertions) with `small` (`36dp`), `medium` (`44dp`), and `large` (`52dp`) heights across `primary`, `secondary`, `outline`, `ghost`, and `danger` variants.
- **`AppIconButton`**: Rounded icon button enforcing accessible minimum target sizing and required `tooltip`.
- **`AppTextField`** ([app_text_field.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/app_text_field.dart)): Labeled form field with theme-integrated `14dp` border radius and clear contrast.
- **`SearchField`**: Pill-shaped search input (`AppRadii.roundedFull`) with leading search icon and conditional clear button.
- **`SelectionField`**: `48dp` minimum-height picker control for dates, times, and optional reminders with clear action.

## 3. Cards & Telemetry Displays

- **`AppCard`** ([app_card.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/app_card.dart)): Neutral `18dp` rounded card (`#FFFFFF` light / `#161B22` dark) with `1dp` border.
- **`PastelCard`** ([pastel_card.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/pastel_card.dart)): Subtle tinted container for intentional module surfaces (no decorative blobs).
- **`TodayProgressCard`** ([today_progress_card.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/features/dashboard/widgets/today_progress_card.dart)): Hero card rendering real completion percentage, honest count (`'X of Y tasks'` or `'No tasks scheduled today'`), and real 7-day throughput bars.
- **`QuickStatMiniCard`** ([quick_stat_mini_card.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/quick_stat_mini_card.dart)): Compact module metric cards (`tasks`, `projects`, `learning`, `focus`, `goals`) with semantic `Semantics` label.
- **`ProgressCard`** ([progress_card.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/progress_card.dart)): Project summary tile displaying factual milestone/task progress bar.
- **`FocusCard`** ([focus_card.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/focus_card.dart)): Focus summary / timer launcher card.
- **`AppProgressRing`** ([app_progress_ring.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/app_progress_ring.dart)): CustomPainter ring supporting gradient stroke & centered tabular statistic widget.

## 4. Badges, Overlays & States

- **`AppBadge`, `AppFilterChip`, `AppPriorityBadge`, `AppStatusBadge`** ([app_badges.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/app_badges.dart)): Icon + label indicators (never color-only) with `>= 36dp` filter pill targets.
- **`ConfirmationDialog`, `AppBottomSheet`, `AppToast`** ([app_overlays.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/app_overlays.dart)): Standardized modals and floating status alerts.
- **`EmptyStateView`, `ErrorStateView`, `LoadingSkeleton`** ([state_views.dart](file:///c:/Users/Krushna/OneDrive/Documents/personal%20projects/tracker/lib/core/widgets/state_views.dart)): Clear empty explanations, retryable error recovery, and card skeleton placeholders.

