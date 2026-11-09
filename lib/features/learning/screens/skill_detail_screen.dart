import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_progress_bar.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/learning_repository.dart';
import '../widgets/log_session_dialog.dart';
import '../widgets/skill_form_sheet.dart';

class SkillDetailScreen extends ConsumerStatefulWidget {
  final String skillId;

  const SkillDetailScreen({super.key, required this.skillId});

  @override
  ConsumerState<SkillDetailScreen> createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends ConsumerState<SkillDetailScreen> {
  final _newModuleController = TextEditingController();
  final _newTopicController = TextEditingController();

  @override
  void dispose() {
    _newModuleController.dispose();
    _newTopicController.dispose();
    super.dispose();
  }

  Future<void> _addModule() async {
    final title = _newModuleController.text.trim();
    if (title.isEmpty) return;

    final repo = ref.read(learningRepositoryProvider);
    await repo.addModule(skillId: widget.skillId, title: title);
    _newModuleController.clear();
  }

  Future<void> _addTopic(String moduleId) async {
    final title = _newTopicController.text.trim();
    if (title.isEmpty) return;

    final repo = ref.read(learningRepositoryProvider);
    await repo.addTopic(moduleId: moduleId, title: title);
    _newTopicController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skillsAsync = ref.watch(allSkillsStreamProvider);
    final repo = ref.watch(learningRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Roadmap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_toggle_off_rounded, color: AppColors.primary),
            tooltip: 'Log Learning Time',
            onPressed: () {
              final skillData = skillsAsync.value?.firstWhere(
                (s) => s.skill.id == widget.skillId,
                orElse: () => throw Exception('Skill not found'),
              );
              if (skillData != null) {
                LogSessionDialog.show(
                  context,
                  skillId: skillData.skill.id,
                  skillName: skillData.skill.name,
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              final skillData = skillsAsync.value?.firstWhere(
                (s) => s.skill.id == widget.skillId,
              );
              if (skillData != null) {
                SkillFormSheet.show(context, skillToEdit: skillData);
              }
            },
          ),
        ],
      ),
      body: skillsAsync.when(
        data: (skills) {
          final skillWithRoadmap = skills.firstWhere(
            (s) => s.skill.id == widget.skillId,
            orElse: () => throw Exception('Skill not found'),
          );

          final skill = skillWithRoadmap.skill;
          final modules = skillWithRoadmap.modules;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Skill Overview Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          skill.name,
                          style: AppTypography.displayMedium.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: AppRadii.roundedXs,
                          ),
                          child: Text(
                            skill.category.toUpperCase(),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      children: [
                        const Icon(Icons.trending_up_rounded, size: 16.0, color: AppColors.success),
                        const SizedBox(width: 4.0),
                        Text(
                          '${skill.currentLevel.toUpperCase()} → ${skill.targetLevel.toUpperCase()}',
                          style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          '${DateFormatters.formatMinutes(skill.learningMinutes)} Total Invested',
                          style: AppTypography.caption.copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                    if (skill.notes != null && skill.notes!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        skill.notes!,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    AppProgressBar(
                      progress: skillWithRoadmap.progressPercentage,
                      label: '${skillWithRoadmap.completedTopics} of ${skillWithRoadmap.totalTopics} topics completed',
                      showPercentage: true,
                      height: 10.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Modules & Roadmaps Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Learning Modules & Milestones',
                    style: AppTypography.titleMedium.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    '${modules.length} modules',
                    style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Modules List
              if (modules.isEmpty) ...[
                EmptyStateView(
                  icon: Icons.alt_route_rounded,
                  title: 'No modules defined yet',
                  description: 'Break this technology into structured modules (e.g. Fundamentals, Architecture, Projects).',
                ),
              ] else ...[
                ...modules.map((mWithT) {
                  final module = mWithT.module;
                  final topics = mWithT.topics;

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: AppRadii.roundedMd,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 1.0,
                      ),
                    ),
                    child: ExpansionTile(
                      shape: const RoundedRectangleBorder(side: BorderSide.none),
                      collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
                      title: Text(
                        module.title,
                        style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${mWithT.completedCount}/${mWithT.totalCount} topics mastered',
                        style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                      ),
                      leading: CircularProgressIndicator(
                        value: mWithT.totalCount > 0 ? (mWithT.completedCount / mWithT.totalCount) : 0,
                        strokeWidth: 3.0,
                        backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        onPressed: () => repo.deleteModule(module.id),
                      ),
                      children: [
                        ...topics.map((t) {
                          final isCompleted = t.status == 'completed';
                          final isInProgress = t.status == 'in_progress';

                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorderSubtle,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    String nextStatus;
                                    if (t.status == 'planned') {
                                      nextStatus = 'in_progress';
                                    } else if (t.status == 'in_progress') {
                                      nextStatus = 'completed';
                                    } else {
                                      nextStatus = 'planned';
                                    }
                                    repo.updateTopicStatus(t.id, nextStatus);
                                  },
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCompleted
                                          ? AppColors.success
                                          : (isInProgress ? AppColors.warning : Colors.transparent),
                                      border: Border.all(
                                        color: isCompleted
                                            ? AppColors.success
                                            : (isInProgress ? AppColors.warning : AppColors.darkTextMuted),
                                        width: 1.8,
                                      ),
                                    ),
                                    child: isCompleted
                                        ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
                                        : (isInProgress
                                            ? const Icon(Icons.play_arrow_rounded, size: 12, color: Colors.white)
                                            : null),
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        t.title,
                                        style: AppTypography.bodySmall.copyWith(
                                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (t.resources.isNotEmpty)
                                        Text(
                                          t.resources,
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.primary,
                                            fontSize: 10.5,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? AppColors.successSoft
                                        : (isInProgress ? AppColors.warningSoft : AppColors.darkSurfaceElevated),
                                    borderRadius: AppRadii.roundedXs,
                                  ),
                                  child: Text(
                                    t.status.toUpperCase(),
                                    style: AppTypography.caption.copyWith(
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.w700,
                                      color: isCompleted
                                          ? AppColors.success
                                          : (isInProgress ? AppColors.warning : AppColors.darkTextMuted),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 16),
                                  onPressed: () => repo.deleteTopic(t.id),
                                ),
                              ],
                            ),
                          );
                        }),

                        // Add topic inline row
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _newTopicController,
                                  style: AppTypography.bodySmall,
                                  decoration: const InputDecoration(
                                    hintText: 'Add new topic / subtopic...',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                  onSubmitted: (_) => _addTopic(module.id),
                                ),
                              ),
                              const SizedBox(width: 8),
                              AppButton(
                                label: 'Add Topic',
                                onPressed: () => _addTopic(module.id),
                                size: AppButtonSize.small,
                                variant: AppButtonVariant.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],

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
                          hintText: 'New Module Title (e.g. Concurrency & Async)',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onSubmitted: (_) => _addModule(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppButton(
                      label: 'Create Module',
                      onPressed: _addModule,
                      size: AppButtonSize.small,
                      icon: Icons.add_rounded,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Recent Learning Sessions
              Text(
                'Recent Learning Sessions',
                style: AppTypography.titleMedium.copyWith(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              if (skillWithRoadmap.sessions.isEmpty)
                Text(
                  'No sessions recorded yet. Tap the timer icon above to log study hours!',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextMuted),
                )
              else
                ...skillWithRoadmap.sessions.take(5).map((sess) => Container(
                      margin: const EdgeInsets.only(bottom: 6.0),
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                        borderRadius: AppRadii.roundedSm,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${sess.durationMinutes} mins',
                                style: AppTypography.monoMedium.copyWith(color: AppColors.primary),
                              ),
                              if (sess.notes != null)
                                Text(
                                  sess.notes!,
                                  style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                                ),
                            ],
                          ),
                          Text(
                            DateFormatters.dateTimeShort(sess.createdAt),
                            style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                          ),
                        ],
                      ),
                    )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorStateView(message: err.toString()),
      ),
    );
  }
}
