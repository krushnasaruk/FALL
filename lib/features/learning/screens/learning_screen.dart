import 'package:fl_chart/fl_chart.dart';
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
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/user_preferences_repository.dart';
import '../../../services/feedback_service.dart';
import '../widgets/log_session_dialog.dart';
import '../widgets/skill_card.dart';
import '../widgets/skill_form_sheet.dart';
import 'skill_detail_screen.dart';

class LearningScreen extends ConsumerStatefulWidget {
  const LearningScreen({super.key});

  @override
  ConsumerState<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends ConsumerState<LearningScreen> {
  String? _selectedSkillId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skillsAsync = ref.watch(allSkillsStreamProvider);
    final feedback = ref.read(feedbackServiceProvider);

    return AppScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          feedback.buttonTap();
          SkillFormSheet.show(context);
        },
        backgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
        foregroundColor: Colors.white,
        tooltip: 'Add Skill',
        child: const Icon(AppIcons.add, size: 26.0),
      ),
      body: Column(
        children: [
          PageTitle(
            title: 'Learning',
            actions: [
              AppIconButton(
                icon: AppIcons.analytics,
                tooltip: 'Learning analytics',
                onPressed: () {
                  feedback.buttonTap();
                  context.push('/insights');
                },
              ),
            ],
          ),
          Expanded(
            child: skillsAsync.when(
              loading: () => const ProjectsSkeleton(),
              error: (err, _) => ErrorStateView(
                message: 'Error loading learning roadmaps: $err',
                onRetry: () => ref.invalidate(allSkillsStreamProvider),
              ),
              data: (skills) {
                final prefsState = ref.watch(userPreferencesProvider);
                if (skills.isEmpty) {
                  return EmptyStateView(
                    icon: AppIcons.learning,
                    illustrationAsset: 'assets/images/empty/empty_learning.png',
                    title: 'Your learning journey starts here.',
                    description: 'Add a skill and build your own roadmap.',
                    actionLabel: 'Add a skill',
                    onAction: () => SkillFormSheet.show(context),
                  );
                }

                final heroSkill = skills.firstWhere(
                  (s) => s.skill.id == _selectedSkillId,
                  orElse: () => skills.first,
                );

                final totalMinutes = skills.fold<int>(
                  0,
                  (sum, s) => sum + s.skill.learningMinutes,
                );
                final allSessions = skills.expand((s) => s.sessions).toList();

                // Real 7-day learning minutes trend
                final now = DateTime.now();
                final todayStart = DateTime(now.year, now.month, now.day);
                final dailyMins = List<double>.generate(7, (idx) {
                  final day = todayStart.subtract(Duration(days: 6 - idx));
                  final next = day.add(const Duration(days: 1));
                  final sum = allSessions.where((sess) {
                    return !sess.createdAt.isBefore(day) && sess.createdAt.isBefore(next);
                  }).fold<int>(0, (acc, s) => acc + s.durationMinutes);
                  return sum.toDouble();
                });
                final hasRecentStudyData = dailyMins.any((v) => v > 0);

                // Find next uncompleted topic across heroSkill
                String? nextTopicTitle;
                for (final m in heroSkill.modules) {
                  for (final t in m.topics) {
                    if (t.status != 'completed') {
                      nextTopicTitle = t.title;
                      break;
                    }
                  }
                  if (nextTopicTitle != null) break;
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    AppSpacing.xs,
                    AppSpacing.pageHorizontal,
                    96.0,
                  ),
                  children: [
                    if (!prefsState.isTipDismissed('first_learning'))
                      DismissibleTipBanner(
                        icon: AppIcons.learning,
                        title: 'Structure your roadmap',
                        message:
                            'Break skills into Modules and Topics, then log focused study sessions to build momentum.',
                        accentColor: AppColors.learningAccent,
                        onDismiss: () {
                          feedback.selectionClick();
                          ref.read(userPreferencesProvider.notifier).dismissTip('first_learning');
                        },
                      ),
                    // 1. Total Learning Summary Card + Real Sparkline
                    Container(
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkLearningSurface
                            : AppColors.learningSurface,
                        borderRadius: AppRadii.roundedCardLg,
                        border: Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.learningBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Learning Time',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.secondary.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      DateFormatters.formatMinutes(totalMinutes),
                                      style: AppTypography.statNumerical.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurface : AppColors.surface,
                                    borderRadius: AppRadii.roundedFull,
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkBorder
                                          : AppColors.learningBorder,
                                    ),
                                  ),
                                  child: Text(
                                    '${skills.length} skills • ${allSessions.length} sessions',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.metadata.copyWith(
                                      color: AppColors.learningAccent,
                                      fontFeatures: AppTypography.tabularFigures,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (hasRecentStudyData)
                            SizedBox(
                              height: 64.0,
                              child: LineChart(
                                LineChartData(
                                  gridData: const FlGridData(show: false),
                                  titlesData: const FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  minY: 0,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: List.generate(
                                        7,
                                        (i) => FlSpot(i.toDouble(), dailyMins[i]),
                                      ),
                                      isCurved: true,
                                      color: AppColors.learningAccent,
                                      barWidth: 2.5,
                                      dotData: const FlDotData(show: true),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: AppColors.learningAccent.withOpacity(0.14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Text(
                              'Log sessions in the last 7 days to view your study trend.',
                              style: AppTypography.metadata.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // 2. Continue Learning Quick Action (Real Skill & Topic Data)
                    SectionHeader(
                      title: 'Continue Learning',
                      actionLabel: 'Roadmap',
                      onAction: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SkillDetailScreen(skillId: heroSkill.skill.id),
                        ),
                      ),
                    ),
                    AppCard(
                      onTap: () => LogSessionDialog.show(
                        context,
                        skillId: heroSkill.skill.id,
                        skillName: heroSkill.skill.name,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44.0,
                            height: 44.0,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkLearningSurface
                                  : AppColors.learningSurface,
                              borderRadius: AppRadii.roundedMd,
                            ),
                            child: const Icon(
                              AppIcons.learningActive,
                              color: AppColors.learningAccent,
                              size: 22.0,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nextTopicTitle ?? heroSkill.skill.name,
                                  style: AppTypography.cardTitle.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  '${heroSkill.skill.name} • ${DateFormatters.formatMinutes(heroSkill.skill.learningMinutes)} logged',
                                  style: AppTypography.metadata.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                    fontFeatures: AppTypography.tabularFigures,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            width: 38.0,
                            height: 38.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? AppColors.primaryDark : AppColors.primary,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // 3. Skill Filter Switcher
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: skills.map((s) {
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.sm),
                            child: AppFilterChip(
                              label: s.skill.name,
                              selected: s.skill.id == heroSkill.skill.id,
                              onSelected: () {
                                feedback.selectionClick();
                                setState(() => _selectedSkillId = s.skill.id);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // 4. All Skills List
                    const SectionHeader(title: 'Your Skills'),
                    ...skills.map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: SkillCard(
                          skillWithRoadmap: s,
                          onTap: () {
                            feedback.buttonTap();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SkillDetailScreen(skillId: s.skill.id),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
