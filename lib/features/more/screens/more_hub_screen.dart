import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/fall_logo.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/repositories/user_preferences_repository.dart';
import '../../../services/feedback_service.dart';

/// Screen 5 — Command Hub ("More" Tab): organized cleanly by workflow without random neon gradients.
class MoreHubScreen extends ConsumerWidget {
  const MoreHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prefs = ref.watch(userPreferencesProvider);
    final feedback = ref.read(feedbackServiceProvider);

    void go(String route) {
      feedback.buttonTap();
      context.push(route);
    }

    return AppScaffold(
      body: ListView(
        padding: const EdgeInsets.only(bottom: 112.0),
        children: [
          PageTitle(
            title: 'Command Hub',
            subtitle: 'Tools, reflection & workspace configuration',
            actions: [
              IconButton(
                onPressed: () {
                  feedback.selectionClick();
                  ref.read(themeModeProvider.notifier).setThemeMode(
                        isDark ? ThemeMode.light : ThemeMode.dark,
                      );
                },
                tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => go('/settings'),
                tooltip: 'Settings',
                icon: Icon(
                  AppIcons.settings,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),

          // FALL Workspace Identity Header Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              onTap: () => go('/settings'),
              child: Row(
                children: [
                  const FallLogo(size: 46.0, isCircle: false),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prefs.displayName,
                          style: AppTypography.cardTitle.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'FALL Personal Workspace • 100% Local-First',
                          style: AppTypography.metadata.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    AppIcons.forward,
                    color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Section 1: Discipline & Execution
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(
              title: 'Execution & Consistency',
              subtitle: 'Dedicated workspaces for long-term objectives & daily rhythm',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _HubTile(
                    icon: AppIcons.goals,
                    title: 'Goals',
                    subtitle: 'Quarterly & yearly milestone targets',
                    accentColor: isDark ? AppColors.goalYellow : AppColors.goalAccent,
                    onTap: () => go('/goals'),
                  ),
                  const _TileDivider(),
                  _HubTile(
                    icon: AppIcons.habits,
                    title: 'Habits',
                    subtitle: 'Daily engineering habits & streak tracking',
                    accentColor: isDark ? AppColors.habitGreen : AppColors.habitAccent,
                    onTap: () => go('/habits'),
                  ),
                  const _TileDivider(),
                  _HubTile(
                    icon: AppIcons.focus,
                    title: 'Focus Timer',
                    subtitle: 'Pomodoro & deep work session logger',
                    accentColor: isDark ? AppColors.analyticsCyan : AppColors.focusAccent,
                    onTap: () => go('/focus'),
                  ),
                  const _TileDivider(),
                  _HubTile(
                    icon: AppIcons.calendar,
                    title: 'Calendar & Agenda',
                    subtitle: 'Date-based schedule, due tasks & milestones',
                    accentColor: isDark ? AppColors.taskBlue : AppColors.taskAccent,
                    onTap: () => go('/calendar'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Section 2: Knowledge & Reflection
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(
              title: 'Knowledge & Insights',
              subtitle: 'Technical documentation, logs & productivity analytics',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _HubTile(
                    icon: Icons.radar_rounded,
                    title: 'ProgressOS Radar',
                    subtitle: 'AI, open source, research & trend intelligence',
                    accentColor: AppColors.taskAccent,
                    onTap: () => go('/radar'),
                  ),
                  const _TileDivider(),
                  _HubTile(
                    icon: AppIcons.notes,
                    title: 'Knowledge Vault',
                    subtitle: 'Architecture notes, resources & ideas',
                    accentColor: isDark ? AppColors.primaryDark : AppColors.primary,
                    onTap: () => go('/vault'),
                  ),
                  const _TileDivider(),
                  _HubTile(
                    icon: AppIcons.journal,
                    title: 'Developer Journal',
                    subtitle: 'Daily engineering log, bugs solved & next steps',
                    accentColor: isDark ? AppColors.learningPurple : AppColors.learningAccent,
                    onTap: () => go('/journal'),
                  ),
                  const _TileDivider(),
                  _HubTile(
                    icon: AppIcons.analytics,
                    title: 'Analytics & Insights',
                    subtitle: 'Real completion rates, heatmap & velocity',
                    accentColor: AppColors.success,
                    onTap: () => go('/insights'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Section 3: System & Preferences
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(title: 'Preferences & System'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _HubTile(
                    icon: AppIcons.settings,
                    title: 'Settings, Backups & Sounds',
                    subtitle: 'Theme, reminders, haptics, chimes, JSON & GitHub',
                    accentColor: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    onTap: () => go('/settings'),
                  ),
                  const _TileDivider(),
                  _HubTile(
                    icon: Icons.auto_awesome_outlined,
                    title: 'Welcome Tour',
                    subtitle: 'Review FALL workflow overview',
                    accentColor: isDark ? AppColors.primaryDark : AppColors.primary,
                    onTap: () {
                      feedback.buttonTap();
                      context.go('/onboarding');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HubTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _HubTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      minVerticalPadding: 10.0,
      leading: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: accentColor.withOpacity(isDark ? 0.16 : 0.11),
          borderRadius: BorderRadius.circular(11.0),
        ),
        child: Icon(icon, size: 20.0, color: accentColor),
      ),
      title: Text(
        title,
        style: AppTypography.cardTitle.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.metadata.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        AppIcons.forward,
        size: 18.0,
        color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
      ),
      onTap: onTap,
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1.0,
      thickness: 1.0,
      indent: 68.0,
      color: isDark ? AppColors.darkDivider : AppColors.divider,
    );
  }
}
