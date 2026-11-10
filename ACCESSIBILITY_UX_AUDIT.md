# FALL (`progress_os`) — Accessibility UX Audit & Verification

## 1. Motion & Sensory Accessibility
- **Reduced Motion Support:** Verified via widget test (`ux_motion_phase_test.dart`): when `MediaQuery.disableAnimations` is `true`, `AppMotion.isReducedMotion(context)` returns `true` and `AppMotion.resolveDuration` collapses durations to `Duration.zero`. `ShimmerBox` disables continuous opacity pulsing under reduced motion.
- **Audio & Haptics:** Independent toggles in Settings plus hardware ringer-mode check on Android (`MainActivity.kt`).
- **Notification Quiet Hours:** `NotificationPreferences` (`22:00–07:30` default, overnight-wrap safe) shifts reminders to the morning window instead of interrupting sleep.

## 2. Semantic Labels, Touch Targets & Narrow Screen Resilience
- Interactive checkboxes, filter chips, icon buttons, floating action buttons, dashboard KPI cards, and Radar action buttons expose explicit `Semantics(button: true, label: ...)` descriptions and standard `tooltip` attributes.
- **Narrow Viewport Verification (`320x640`):** Automated Flutter widget tests verify Light & Dark rendering across all 14 core FALL screens + 4 ProgressOS Radar screens (`RadarHomeScreen`, `RadarDetailScreen`, `RadarBriefingScreen`, `RadarPreferencesScreen`) with zero `RenderFlex` overflow exceptions. (Note: `DashboardSkeleton` quick-action row was caught overflowing by `8.0 px` at `320px` and refactored to responsive `Expanded` slots.)

