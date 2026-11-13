import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../../services/focus_timer_controller.dart';
import '../../features/focus/widgets/focus_completion_sheet.dart';

/// Omnipresent Floating Global Mini-Player for the active Focus Timer.
/// Renders at the bottom of the AppScaffold whenever a timer is running, paused, or on break.
class GlobalTimerBanner extends ConsumerWidget {
  const GlobalTimerBanner({super.key});

  static String _fmt(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(focusTimerProvider);
    if (!timerState.isActive) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifier = ref.read(focusTimerProvider.notifier);

    Color accentColor;
    String statusLabel;
    IconData statusIcon;

    if (timerState.isOnBreak) {
      accentColor = AppColors.warning;
      statusLabel = 'Break • ${_fmt(timerState.effectiveBreakSeconds())}';
      statusIcon = Icons.coffee_rounded;
    } else if (timerState.isRunning) {
      accentColor = AppColors.focusAccent;
      statusLabel = '${timerState.mode.label} • Active';
      statusIcon = Icons.timer_rounded;
    } else {
      accentColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
      statusLabel = '${timerState.mode.label} • Paused';
      statusIcon = Icons.pause_circle_outline_rounded;
    }

    final timeDisplay = _fmt(timerState.remainingSeconds);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        child: Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadii.xl),
            onTap: () => context.push('/focus'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.xl),
                border: Border.all(
                  color: accentColor.withOpacity(0.35),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(statusIcon, color: accentColor, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              timeDisplay,
                              style: AppTypography.titleMedium.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              statusLabel,
                              style: AppTypography.caption.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (timerState.linkedProjectId != null ||
                            timerState.linkedSkillId != null ||
                            timerState.linkedTaskId != null)
                          Text(
                            'Session attached to active context',
                            style: AppTypography.caption.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),

                  // Break Toggle
                  if (timerState.isRunning)
                    IconButton(
                      icon: const Icon(Icons.coffee_outlined, size: 20),
                      tooltip: 'Take a break',
                      color: AppColors.warning,
                      onPressed: () => notifier.takeBreak(),
                    )
                  else if (timerState.isOnBreak)
                    IconButton(
                      icon: const Icon(Icons.play_arrow_rounded, size: 22),
                      tooltip: 'Resume focus',
                      color: AppColors.focusAccent,
                      onPressed: () => notifier.resumeFromBreak(),
                    ),

                  // Play / Pause
                  IconButton(
                    icon: Icon(
                      timerState.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 24,
                    ),
                    tooltip: timerState.isRunning ? 'Pause' : 'Resume',
                    color: accentColor,
                    onPressed: () => notifier.togglePlayPause(),
                  ),

                  // End & Summary
                  IconButton(
                    icon: const Icon(AppIcons.completion, size: 20),
                    tooltip: 'Finish session',
                    color: AppColors.success,
                    onPressed: () async {
                      final activeSeconds = timerState.effectiveFocusedSeconds();
                      final breakSeconds = timerState.effectiveBreakSeconds();
                      final focusedMins = (activeSeconds / 60).round().clamp(1, 1440);
                      final breakMins = (breakSeconds / 60).floor().clamp(0, 720);

                      await FocusCompletionSheet.show(
                        context,
                        focusedMinutes: focusedMins,
                        breakMinutes: breakMins,
                        initialProjectId: timerState.linkedProjectId,
                        initialSkillId: timerState.linkedSkillId,
                        initialTaskId: timerState.linkedTaskId,
                        initialNotes: timerState.sessionNotes,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
