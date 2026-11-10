# FALL (`progress_os`) — Motion Design System

## 1. Timing Tokens (`lib/core/theme/app_motion.dart`)
| Token | Duration | Intended Usage |
|---|---|---|
| `AppMotion.fast` | `110 ms` | Press scale compression (`AppButton`, `AppIconButton`, `AppPressable`) |
| `AppMotion.normal` | `180 ms` | Chip selections, subtle reverse transitions, badge transitions |
| `AppMotion.moderate` | `240 ms` | Forward pushed route transitions (`AppMotion.buildDetailPage`), sheet reveals |
| `AppMotion.slow` | `340 ms` | Progress fills (`TodayProgressCard`, project rings), numeric rollups (`AnimatedNumericValue`) |
| `AppMotion.celebration` | `460 ms` | Unlocked achievement dialog appearance (`RewardCelebrationDialog`) |
| `AppMotion.shimmer` | `1400 ms` | Gentle loading skeleton pulse (`ShimmerBox`) |

## 2. Easing Curves & Transforms
- `AppMotion.easeOut` (`Curves.easeOutCubic`) — Decelerating entrance for pushed pages & content swaps.
- `AppMotion.standard` (`Curves.easeInOutCubic`) — Balanced state shifts.
- `AppMotion.crisp` (`Curves.easeOutQuart`) — Snappy press recovery.
- `AppMotion.gentleSettle` (`Curves.easeOutBack`) — Subtle celebratory badges only.
- `AppMotion.pressScale` (`0.97`) + `AppMotion.subtleSlideOffset` (`Offset(0.0, 0.035)`).

## 3. Reduced Motion Accessibility Contract
- `AppMotion.isReducedMotion(context)` inspects `MediaQuery.maybeDisableAnimationsOf(context)`.
- `AppMotion.resolveDuration(context, duration)` collapses non-essential transition durations to `Duration.zero` when OS animation suppression is enabled.
- `AppMotion.buildDetailPage` bypasses `FadeTransition`/`SlideTransition` cleanly under reduced motion, and `ShimmerBox` renders a static low-contrast placeholder card instead of pulsing opacity.

