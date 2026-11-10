# FALL Accessibility & Usability Audit

## 1. Contrast & Visual Legibility Fixes

- **Light Mode Contrast Upgrades:** Upgraded primary ink `#171923` on `#FFFFFF`/`#F8F9FC` (>15:1 contrast), secondary ink `#727786` (~4.5:1), and module foreground accents (`AppColors.taskAccent #2B7FB8`, `projectAccent #5D52D6`, `learningAccent #6B4FD6`, `goalAccent #B7791F`, `habitAccent #2E8555`, `focusAccent #1D7FA8`) instead of light pastel-on-pastel text.
- **CTA Contrast Fix:** Replaced dark ink on indigo/blue primary buttons and fixed `VaultScreen` FAB foreground (`Colors.white` on `#7167E8`) plus `SkillDetailScreen` completion status pill (`Colors.white` text on `#2E8555` / `#6B4FD6`).
- **Independent Dark Palette:** Uses `#0D1117` background, `#161B22` surface, `#30363D` border, and `#F0F6FC` text primary for comfortable dark-room readability.

## 2. Never Color Alone

- **`AppPriorityBadge`** pairs semantic colors with explicit icons (`priority_high_rounded`, `flag_rounded`, `flag_outlined`, `low_priority_rounded`) and readable labels (`Urgent`, `High`, `Medium`, `Low`).
- **`AppStatusBadge`** pairs status colors with distinct icons and labels (`Active`, `Planning`, `On Hold`, `Completed`, `Archived`).
- **Habit 7-Day Trackers:** Completed days show filled pill markers + numerical count (`X/7 days`), never unlabelled colored dots alone.

## 3. Touch Targets & One-Handed Reachability

- Primary interactive controls (`SelectionField` >= `48dp`, `AppButton` `medium >= 44dp` / `large >= 52dp`, `PageTitle` back button `44x44dp`, `SectionHeader` action button `48x44dp` minimum hit area, docked bottom nav comfortable tap items).
- Bottom sheets (`AppBottomSheet`, `TaskFormSheet`, `_NoteEditorSheet`, `DashboardCustomizationSheet`) place primary confirmation buttons cleanly above system keyboard insets.

## 4. Semantic Labels & Screen Reader Support

- `TodayProgressCard`, `QuickStatMiniCard`, `PageTitle` back action, `AppFilterChip`, and `SelectionField` expose explicit `Semantics(button:, selected:, label:)` metadata for TalkBack.
- `TaskCard` / `HabitCard` / `VaultScreen` destructive delete actions always confirm via `ConfirmationDialog.show(...)` with haptic alert (`FeedbackService.destructiveAction()`).

## 5. Typography Scaling & Narrow-Device Wrapping (`320x640`)

- Titles on cards allow up to 2 lines with `TextOverflow.ellipsis` instead of hard single-line clipping.
- Calendar header, Skill Detail chips, and Settings `ListTile.trailing` buttons use `MainAxisSize.min` and `Expanded` rows to prevent RenderFlex overflow down to `320dp` logical viewport width (verified under `phase8_ui_workflow_test.dart`).

