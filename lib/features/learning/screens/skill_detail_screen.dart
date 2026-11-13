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
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/reward_celebration_sheet.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/rewards_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/focus_timer_controller.dart';
import '../../../services/widget_sync_service.dart';
import '../widgets/log_session_dialog.dart';
import '../widgets/skill_form_sheet.dart';
import '../widgets/topic_edit_dialog.dart';

class SkillDetailScreen extends ConsumerStatefulWidget {
  final String skillId;

  const SkillDetailScreen({super.key, required this.skillId});

  @override
  ConsumerState<SkillDetailScreen> createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends ConsumerState<SkillDetailScreen> {
  final _newModuleController = TextEditingController();

  @override
  void dispose() {
    _newModuleController.dispose();
    super.dispose();
  }

  Future<void> _addModule() async {
    final title = _newModuleController.text.trim();
    if (title.isEmpty) return;

    final repo = ref.read(learningRepositoryProvider);
    await repo.addModule(skillId: widget.skillId, title: title);
    _newModuleController.clear();
    await ref.read(feedbackServiceProvider).buttonTap();
  }

  Future<void> _startStudyTimer() async {
    final timerCtrl = ref.read(focusTimerProvider.notifier);
    await timerCtrl.startSession(skillId: widget.skillId);
    if (mounted) {
      context.push('/focus');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skillsAsync = ref.watch(allSkillsStreamProvider);
    final repo = ref.watch(learningRepositoryProvider);
    final feedback = ref.read(feedbackServiceProvider);
    final widgetSync = ref.read(widgetSyncServiceProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Skill Roadmap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer_outlined, color: AppColors.primary),
            tooltip: 'Start study timer',
            onPressed: _startStudyTimer,
          ),
          IconButton(
            icon: const Icon(AppIcons.edit),
            tooltip: 'Edit skill',
            onPressed: () {
              final s = skillsAsync.value?.where((x) => x.skill.id == widget.skillId).firstOrNull;
              if (s != null) SkillFormSheet.show(context, skillToEdit: s);
            },
          ),
          IconButton(
            icon: const Icon(AppIcons.delete, color: AppColors.error),
            tooltip: 'Delete skill',
            onPressed: () async {
              final s = skillsAsync.value?.where((x) => x.skill.id == widget.skillId).firstOrNull;
              final confirmed = await ConfirmationDialog.show(
                context,
                title: 'Delete skill?',
                message:
                    'Delete "${s?.skill.name ?? 'this skill'}" and all its learning modules/sessions?',
              );
              if (!confirmed) return;
              await feedback.destructiveAction();
              await repo.deleteSkill(widget.skillId);
              await widgetSync.syncAllWidgets();
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: skillsAsync.when(
        loading: () => const LoadingSkeleton(itemCount: 3, itemHeight: 110.0),
        error: (err, _) => ErrorStateView(message: err.toString()),
        data: (skills) {
          final skillWithRoadmap = skills.where((s) => s.skill.id == widget.skillId).firstOrNull;
          if (skillWithRoadmap == null) {
            return const EmptyStateView(
              icon: AppIcons.learning,
              title: 'Skill not found',
              description: 'This skill may have been removed.',
            );
          }

          final skill = skillWithRoadmap.skill;
          final modules = skillWithRoadmap.modules;

          // Unified Session History combining manual and timer records
          final allSessions = [
            ...skillWithRoadmap.sessions.map((s) => _UnifiedSession(
                  durationMinutes: s.durationMinutes,
                  notes: s.notes,
                  date: s.createdAt,
                  isTimer: false,
                )),
            ...skillWithRoadmap.focusSessions.map((f) => _UnifiedSession(
                  durationMinutes: f.durationMinutes,
                  notes: f.notes,
                  date: f.completedAt,
                  isTimer: true,
                )),
          ]..sort((a, b) => b.date.compareTo(a.date));

          // Determine progress presentation
          final method = skill.progressMethod;
          final double displayProgress;
          final String progressLabel;
          final bool isOverachieved = skillWithRoadmap.isTimeTargetExceeded;

          if (method == 'time') {
            if (skillWithRoadmap.hasTimeTarget) {
              final pct = skillWithRoadmap.timeProgressPercentage!;
              displayProgress = pct.clamp(0.0, 1.0);
              if (isOverachieved) {
                progressLabel =
                    '${(skill.learningMinutes / 60).toStringAsFixed(1)}h / ${(skill.targetMinutes / 60).toStringAsFixed(0)}h • Target Exceeded! 🌟 (${(pct * 100).toStringAsFixed(0)}%)';
              } else {
                progressLabel =
                    '${(skill.learningMinutes / 60).toStringAsFixed(1)}h of ${(skill.targetMinutes / 60).toStringAsFixed(0)}h target (${(pct * 100).toStringAsFixed(0)}%)';
              }
            } else {
              displayProgress = 0.0;
              progressLabel = 'No time target set • Tap Edit to define a target';
            }
          } else if (method == 'manual') {
            displayProgress = skill.manualProgressPercentage;
            progressLabel =
                'User-reported mastery: ${(skill.manualProgressPercentage * 100).toStringAsFixed(0)}%';
          } else {
            // 'topics'
            displayProgress = skillWithRoadmap.curriculumProgress;
            progressLabel = skillWithRoadmap.totalTopics > 0
                ? '${skillWithRoadmap.completedTopics} of ${skillWithRoadmap.totalTopics} topics completed'
                : 'No curriculum topics added yet';
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              AppSpacing.md,
              AppSpacing.pageHorizontal,
              48.0,
            ),
            children: [
              // Overview Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            skill.name,
                            style: AppTypography.displayMedium.copyWith(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        AppBadge(label: skill.category, color: AppColors.learningAccent),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Text(
                          '${skill.currentLevel.toUpperCase()} → ${skill.targetLevel.toUpperCase()}',
                          style: AppTypography.metadata.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${DateFormatters.formatMinutes(skill.learningMinutes)} invested',
                          style: AppTypography.metadata.copyWith(
                            color: AppColors.learningAccent,
                            fontWeight: FontWeight.w700,
                            fontFeatures: AppTypography.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                    if (skill.notes != null && skill.notes!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        skill.notes!,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    AppProgressBar(
                      progress: displayProgress,
                      progressColor: isOverachieved ? AppColors.warning : AppColors.learningAccent,
                      label: progressLabel,
                      showPercentage: method != 'time' || skillWithRoadmap.hasTimeTarget,
                      height: 8.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Contextual Action Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _startStudyTimer,
                      icon: const Icon(Icons.timer_outlined, size: 18),
                      label: const Text('Start Study Timer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.learningAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => LogSessionDialog.show(
                        context,
                        skillId: skill.id,
                        skillName: skill.name,
                      ),
                      icon: const Icon(Icons.history_edu_rounded, size: 18),
                      label: const Text('Log Past Time'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Modules Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Curriculum & Roadmap',
                    style: AppTypography.sectionTitle.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${modules.length} modules',
                    style: AppTypography.metadata.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              if (modules.isEmpty)
                const EmptyStateView(
                  icon: AppIcons.learning,
                  title: 'No modules yet',
                  description: 'Add a module below to break this skill into learning topics.',
                )
              else
                ...modules.map((mWithT) {
                  final module = mWithT.module;
                  final topics = mWithT.topics;

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.surface,
                      borderRadius: AppRadii.roundedCard,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      shape: const RoundedRectangleBorder(side: BorderSide.none),
                      collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
                      title: Text(
                        module.title,
                        style: AppTypography.cardTitle.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '${mWithT.completedCount}/${mWithT.totalCount} topics completed',
                        style: AppTypography.metadata.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          fontFeatures: AppTypography.tabularFigures,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(AppIcons.delete, size: 18.0),
                        tooltip: 'Delete module',
                        onPressed: () async {
                          final ok = await ConfirmationDialog.show(
                            context,
                            title: 'Delete module?',
                            message: 'Remove "${module.title}" and its topics?',
                          );
                          if (ok) await repo.deleteModule(module.id);
                        },
                      ),
                      children: [
                        ...topics.map((t) {
                          final isCompleted = t.status == 'completed';
                          final isInProgress = t.status == 'in_progress';

                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: isDark ? AppColors.darkBorderSubtle : AppColors.borderSubtle,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    String nextStatus;
                                    if (t.status == 'planned') {
                                      nextStatus = 'in_progress';
                                    } else if (t.status == 'in_progress') {
                                      nextStatus = 'completed';
                                    } else {
                                      nextStatus = 'planned';
                                    }
                                    if (nextStatus == 'completed') {
                                      await feedback.taskCompleted();
                                    } else {
                                      await feedback.selectionClick();
                                    }
                                    await repo.updateTopicStatus(t.id, nextStatus);
                                    if (nextStatus == 'completed' && context.mounted) {
                                      final reward = await ref
                                          .read(rewardsRepositoryProvider)
                                          .recordActivityAndEvaluate(
                                            sourceKey: 'topic:${t.id}',
                                            sourceType: 'learning',
                                            amount: RewardsRepository.xpTopicCompleted,
                                            summary: 'Completed topic: ${t.title}',
                                          );
                                      if (!context.mounted) return;
                                      final xpNote =
                                          reward.xpAdded > 0 ? ' (+${reward.xpAdded} XP)' : '';
                                      AppToast.show(
                                        context,
                                        'Topic completed.$xpNote',
                                        isSuccess: true,
                                      );
                                      if (reward.newlyUnlocked.isNotEmpty) {
                                        await feedback.achievementUnlocked();
                                        if (context.mounted) {
                                          await RewardCelebrationDialog.show(
                                            context,
                                            achievement: reward.newlyUnlocked.first,
                                            xpEarned: reward.xpAdded,
                                          );
                                        }
                                      }
                                    }
                                  },
                                  borderRadius: AppRadii.roundedFull,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      width: 22.0,
                                      height: 22.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isCompleted
                                            ? AppColors.success
                                            : (isInProgress ? AppColors.warning : Colors.transparent),
                                        border: Border.all(
                                          color: isCompleted
                                              ? AppColors.success
                                              : (isInProgress
                                                  ? AppColors.warning
                                                  : (isDark
                                                      ? AppColors.darkBorder
                                                      : const Color(0xFFCBD5E1))),
                                          width: 1.8,
                                        ),
                                      ),
                                      child: isCompleted
                                          ? const Icon(AppIcons.completion, size: 13.0, color: Colors.white)
                                          : (isInProgress
                                              ? const Icon(Icons.play_arrow_rounded, size: 13.0, color: Colors.white)
                                              : null),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => TopicEditDialog.show(
                                      context,
                                      moduleId: module.id,
                                      topicToEdit: t,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          t.title,
                                          style: AppTypography.bodySmall.copyWith(
                                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                                            fontWeight: FontWeight.w500,
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                                          ),
                                        ),
                                        if (t.resources.isNotEmpty)
                                          Text(
                                            t.resources,
                                            style: AppTypography.metadata.copyWith(
                                              color: AppColors.primary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                AppBadge(
                                  label: t.status.replaceAll('_', ' '),
                                  color: isCompleted
                                      ? AppColors.success
                                      : (isInProgress ? AppColors.warning : AppColors.textSecondary),
                                ),
                                IconButton(
                                  icon: const Icon(AppIcons.close, size: 16.0),
                                  onPressed: () => repo.deleteTopic(t.id),
                                ),
                              ],
                            ),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SecondaryButton(
                              label: 'Add Topic',
                              icon: AppIcons.add,
                              size: AppButtonSize.small,
                              onPressed: () => TopicEditDialog.show(context, moduleId: module.id),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              // Add Module Input
              AppCard(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newModuleController,
                        style: AppTypography.bodySmall,
                        decoration: const InputDecoration(
                          hintText: 'New module title...',
                          isDense: true,
                        ),
                        onSubmitted: (_) => _addModule(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    PrimaryButton(
                      label: 'Add',
                      onPressed: _addModule,
                      size: AppButtonSize.small,
                      icon: AppIcons.add,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              Text(
                'Study & Focus History',
                style: AppTypography.sectionTitle.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              if (allSessions.isEmpty)
                AppCard(
                  child: Text(
                    'No study sessions logged yet. Tap "Start Study Timer" above to begin.',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                )
              else
                ...allSessions.take(10).map(
                      (sess) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AppCard(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: (sess.isTimer ? AppColors.focusAccent : AppColors.learningAccent)
                                      .withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  sess.isTimer ? Icons.timer_rounded : Icons.edit_note_rounded,
                                  size: 16,
                                  color: sess.isTimer ? AppColors.focusAccent : AppColors.learningAccent,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormatters.formatMinutes(sess.durationMinutes),
                                      style: AppTypography.statMedium.copyWith(
                                        fontSize: 16.0,
                                        color: AppColors.learningAccent,
                                      ),
                                    ),
                                    if (sess.notes != null && sess.notes!.isNotEmpty)
                                      Text(
                                        sess.notes!,
                                        style: AppTypography.secondary.copyWith(
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                DateFormatters.dateTimeShort(sess.date),
                                style: AppTypography.metadata.copyWith(
                                  color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}

class _UnifiedSession {
  final int durationMinutes;
  final String? notes;
  final DateTime date;
  final bool isTimer;

  const _UnifiedSession({
    required this.durationMinutes,
    this.notes,
    required this.date,
    required this.isTimer,
  });
}
