import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_interaction.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_progress_ring.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/companion_avatar.dart';
import '../../../core/widgets/reward_celebration_sheet.dart';
import '../../../data/repositories/focus_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/repositories/user_preferences_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/focus_timer_controller.dart';

/// Distraction-Free Focus Timer backed by wall-clock persistent `FocusTimerNotifier`.
/// Resists background suspension and excludes paused durations from focused totals.
class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(focusTimerProvider.notifier).syncWithClock();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      ref.read(focusTimerProvider.notifier).syncWithClock();
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _finishSessionAndPresentSummary() async {
    final timerState = ref.read(focusTimerProvider);
    final activeSeconds = timerState.effectiveFocusedSeconds();
    if (activeSeconds < 5 && !timerState.isRunning) {
      AppToast.show(context, 'Start the timer for a moment before finishing.');
      return;
    }

    final summary = await ref.read(focusTimerProvider.notifier).completeSession();
    if (!mounted || summary == null) return;

    final rewardsRepo = ref.read(rewardsRepositoryProvider);
    final xpAmount = summary.recordedMinutes >= 15 ? RewardsRepository.xpFocusCompleted : 10;
    final reward = await rewardsRepo.recordActivityAndEvaluate(
      sourceKey: 'focus:${summary.completedAt.millisecondsSinceEpoch}',
      sourceType: 'focus',
      amount: xpAmount,
      summary: 'Focused ${summary.recordedMinutes}m (${summary.modeLabel})',
    );

    if (!mounted) return;
    await _showSummaryModal(summary, reward.xpAdded);

    if (reward.newlyUnlocked.isNotEmpty && mounted) {
      await ref.read(feedbackServiceProvider).achievementUnlocked();
      if (mounted) {
        await RewardCelebrationDialog.show(
          context,
          achievement: reward.newlyUnlocked.first,
          xpEarned: reward.xpAdded,
        );
      }
    }
  }

  Future<void> _showSummaryModal(FocusCompletionSummary summary, int xpAdded) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.roundedXl),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CompanionAvatar(
              expression: CompanionExpression.celebrating,
              size: 96.0,
              animate: true,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'All done. Nice work.',
              style: AppTypography.titleLarge.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Recorded ${summary.recordedMinutes} min of ${summary.modeLabel} (paused intervals excluded).',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (xpAdded > 0) ...[
              const SizedBox(height: AppSpacing.md),
              AppBadge(
                label: '+$xpAdded XP earned',
                color: AppColors.success,
                icon: Icons.bolt_rounded,
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Done',
              isFullWidth: true,
              onPressed: () {
                ref.read(focusTimerProvider.notifier).clearLastSummary();
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timerState = ref.watch(focusTimerProvider);
    final timerNotifier = ref.read(focusTimerProvider.notifier);
    final tasksAsync = ref.watch(allTasksStreamProvider);
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final recentSessionsAsync = ref.watch(recentFocusSessionsProvider);
    final feedbackSettings = ref.watch(feedbackSettingsProvider);
    final prefsState = ref.watch(userPreferencesProvider);
    final feedback = ref.read(feedbackServiceProvider);

    final primaryCol = isDark ? AppColors.primaryDark : AppColors.primary;

    return AppScaffold(
      body: Column(
        children: [
          PageTitle(
            title: 'Focus Time',
            showBackButton: true,
            actions: [
              AppIconButton(
                icon: feedbackSettings.soundEffectsEnabled
                    ? Icons.volume_up_outlined
                    : Icons.volume_off_outlined,
                tooltip: 'Toggle focus sound',
                onPressed: () {
                  ref
                      .read(feedbackSettingsProvider.notifier)
                      .setSoundEffectsEnabled(!feedbackSettings.soundEffectsEnabled);
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              AppIconButton(
                icon: AppIcons.settings,
                tooltip: 'Focus & feedback settings',
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                AppSpacing.sm,
                AppSpacing.pageHorizontal,
                40.0,
              ),
              children: [
                if (!prefsState.isTipDismissed('first_focus'))
                  DismissibleTipBanner(
                    icon: AppIcons.focus,
                    title: 'Accurate deep work tracking',
                    message:
                        'Your countdown stays accurate even if you leave this screen or lock your device, and paused time is never billed as focus.',
                    accentColor: AppColors.focusAccent,
                    onDismiss: () {
                      feedback.selectionClick();
                      ref.read(userPreferencesProvider.notifier).dismissTip('first_focus');
                    },
                  ),

                // Mode Pills (dimmed cleanly during active run)
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: FocusTimerMode.values.map((mode) {
                      return AppFilterChip(
                        label: '${mode.label} (${mode.defaultMinutes}m)',
                        selected: timerState.mode == mode,
                        accentColor: AppColors.focusAccent,
                        onSelected: () {
                          if (timerState.isRunning) {
                            AppToast.show(context, 'Pause timer before switching focus mode.');
                            return;
                          }
                          timerNotifier.switchMode(mode);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Focal Element: Tabular Timer Ring with calm Pip Focus Companion indicator
                Center(
                  child: AppProgressRing(
                    progress: timerState.progress,
                    size: 248.0,
                    strokeWidth: 14.0,
                    progressGradient: LinearGradient(
                      colors: [AppColors.secondary, primaryCol],
                    ),
                    centerChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CompanionAvatar(
                          expression: timerState.isRunning
                              ? CompanionExpression.focused
                              : CompanionExpression.idle,
                          size: 46.0,
                          animate: false,
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          _formatTime(timerState.remainingSeconds),
                          style: AppTypography.timerDisplay.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          timerState.isRunning
                              ? '${timerState.mode.category} • Active'
                              : (timerState.accumulatedFocusedSeconds > 0
                                  ? '${timerState.mode.category} • Paused'
                                  : timerState.mode.category),
                          style: AppTypography.secondary.copyWith(
                            color: timerState.isRunning
                                ? AppColors.focusAccent
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Comfortable 1-Handed Controls (Reset, Play/Pause, Complete/Stop)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIconButton(
                      icon: Icons.refresh_rounded,
                      tooltip: 'Reset timer',
                      onPressed: timerNotifier.reset,
                      size: 48.0,
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    Semantics(
                      button: true,
                      label: timerState.isRunning ? 'Pause timer' : 'Start timer',
                      child: AppPressable(
                        triggerHaptic: false,
                        onTap: timerNotifier.togglePlayPause,
                        child: Container(
                          width: 72.0,
                          height: 72.0,
                          decoration: BoxDecoration(
                            color: primaryCol,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            timerState.isRunning
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 36.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    AppIconButton(
                      icon: AppIcons.completion,
                      tooltip: 'Finish and log session',
                      iconColor: AppColors.success,
                      onPressed: _finishSessionAndPresentSummary,
                      size: 48.0,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Target Task & Project Link (quietly dimmed while running to minimize visual distraction)
                AnimatedOpacity(
                  opacity: timerState.isRunning ? 0.55 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Session Focus Target',
                          style: AppTypography.titleSmall.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        tasksAsync.when(
                          data: (tasks) {
                            final openTasks = tasks.where((t) => !t.task.isCompleted).toList();
                            final currentId = openTasks.any((t) => t.task.id == timerState.linkedTaskId)
                                ? timerState.linkedTaskId
                                : null;
                            return DropdownButtonFormField<String?>(
                              value: currentId,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Linked task',
                                prefixIcon: Icon(AppIcons.tasks, size: 18.0),
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('General deep work'),
                                ),
                                ...openTasks.map(
                                  (t) => DropdownMenuItem(
                                    value: t.task.id,
                                    child: Text(t.task.title, overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ],
                              onChanged: (val) => timerNotifier.setLinkedTargets(
                                taskId: val,
                                projectId: timerState.linkedProjectId,
                              ),
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        projectsAsync.when(
                          data: (projects) {
                            final currentProjId = projects.any((p) => p.project.id == timerState.linkedProjectId)
                                ? timerState.linkedProjectId
                                : null;
                            return DropdownButtonFormField<String?>(
                              value: currentProjId,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Linked project',
                                prefixIcon: Icon(AppIcons.projects, size: 18.0),
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('No project linked'),
                                ),
                                ...projects.map(
                                  (p) => DropdownMenuItem(
                                    value: p.project.id,
                                    child: Text(p.project.name, overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ],
                              onChanged: (val) => timerNotifier.setLinkedTargets(
                                taskId: timerState.linkedTaskId,
                                projectId: val,
                              ),
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Real Recent Sessions History (if any)
                recentSessionsAsync.when(
                  data: (sessions) {
                    if (sessions.isEmpty) return const SizedBox.shrink();
                    final totalTodayMins = sessions.where((s) {
                      final now = DateTime.now();
                      return s.session.completedAt.year == now.year &&
                          s.session.completedAt.month == now.month &&
                          s.session.completedAt.day == now.day;
                    }).fold<int>(0, (sum, s) => sum + s.session.durationMinutes);

                    return AppCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's Focus Total",
                                style: AppTypography.secondary.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                DateFormatters.formatMinutes(totalTodayMins),
                                style: AppTypography.statMedium.copyWith(
                                  color: AppColors.focusAccent,
                                ),
                              ),
                            ],
                          ),
                          AppBadge(
                            label: '${sessions.length} total logs',
                            color: AppColors.focusAccent,
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
