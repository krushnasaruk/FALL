import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/companion_avatar.dart';
import '../../../data/repositories/user_preferences_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/notification_preferences.dart';
import '../../../services/notification_service.dart';

/// Welcoming, Calm Onboarding Experience for FALL.
/// Lets the user set their name, preferred theme, and optional daily summaries
/// without demanding permissions upfront.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  late final TextEditingController _nameController;
  bool _agendaOptIn = false;
  bool _summaryOptIn = false;

  static const int _pageCount = 3;

  @override
  void initState() {
    super.initState();
    final initialName = ref.read(userPreferencesProvider).displayName;
    _nameController = TextEditingController(
      text: initialName == 'Developer' ? '' : initialName,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    ref.read(feedbackServiceProvider).buttonTap();
    final name = _nameController.text.trim();
    final prefsNotifier = ref.read(userPreferencesProvider.notifier);
    if (name.isNotEmpty) {
      await prefsNotifier.updateDisplayName(name);
    }
    await prefsNotifier.markOnboardingCompleted();

    try {
      final notifPrefs = ref.read(notificationPreferencesProvider.notifier);
      final notifService = ref.read(notificationServiceProvider);
      await notifPrefs.setCategory('daily_agenda', _agendaOptIn);
      await notifPrefs.setCategory('daily_summary', _summaryOptIn);
      if (_agendaOptIn) {
        await notifService.scheduleDailyMorningAgenda();
      } else {
        await notifService.cancelDailyMorningAgenda();
      }
      if (_summaryOptIn) {
        await notifService.scheduleDailyEveningSummary();
      } else {
        await notifService.cancelDailyEveningSummary();
      }
    } catch (e) {
      debugPrint('Onboarding notification preference setup skipped: $e');
    }

    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTheme = ref.watch(themeModeProvider);
    final primaryCol = isDark ? AppColors.primaryDark : AppColors.primary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with subtle Skip action
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(
                      'Skip',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Swipe Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                children: [
                  // Page 1: Welcome & Clear Purpose
                  _OnboardingStepContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CompanionAvatar(
                          expression: CompanionExpression.welcome,
                          size: 140.0,
                          animate: true,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppBadge(
                          label: 'Personal Command Center',
                          color: primaryCol,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'FALL',
                          style: AppTypography.display.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            letterSpacing: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Plan. Build. Learn. Grow.',
                          style: AppTypography.cardTitle.copyWith(color: primaryCol),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'A calm, offline-first workspace for tasks, projects, learning roadmaps, habits, and deep focus.',
                          style: AppTypography.body.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Page 2: Personalize Name & Theme
                  _OnboardingStepContainer(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CompanionAvatar(
                            expression: CompanionExpression.thinking,
                            size: 112.0,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppBadge(label: 'Make It Yours', color: primaryCol),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Personalize FALL',
                            style: AppTypography.titleLarge.copyWith(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Optional preferences — you can change these anytime in Settings.',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextField(
                                  label: 'Your First Name (Optional)',
                                  hintText: 'e.g. Alex or Developer',
                                  controller: _nameController,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Preferred Theme',
                                  style: AppTypography.secondary.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: [
                                    AppFilterChip(
                                      label: 'Light',
                                      selected: currentTheme == ThemeMode.light,
                                      onSelected: () => ref
                                          .read(themeModeProvider.notifier)
                                          .setThemeMode(ThemeMode.light),
                                    ),
                                    AppFilterChip(
                                      label: 'Dark',
                                      selected: currentTheme == ThemeMode.dark,
                                      onSelected: () => ref
                                          .read(themeModeProvider.notifier)
                                          .setThemeMode(ThemeMode.dark),
                                    ),
                                    AppFilterChip(
                                      label: 'System',
                                      selected: currentTheme == ThemeMode.system,
                                      onSelected: () => ref
                                          .read(themeModeProvider.notifier)
                                          .setThemeMode(ThemeMode.system),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Page 3: Gentle Reminders (Optional, No Startup Permission Nag)
                  _OnboardingStepContainer(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CompanionAvatar(
                            expression: CompanionExpression.celebrating,
                            size: 112.0,
                            animate: true,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const AppBadge(label: 'Ready When You Are', color: AppColors.success),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Quiet Reminders',
                            style: AppTypography.titleLarge.copyWith(
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Optional daily check-ins. Rest days and breaks are always welcomed kindly.',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                SwitchListTile.adaptive(
                                  title: const Text('Morning Agenda (8:30 AM)'),
                                  subtitle: const Text('Gentle plan of today priorities'),
                                  value: _agendaOptIn,
                                  onChanged: (v) async {
                                    if (v) {
                                      await ref
                                          .read(notificationServiceProvider)
                                          .requestPermissionsWithExplanation(context);
                                    }
                                    setState(() => _agendaOptIn = v);
                                  },
                                ),
                                const Divider(height: 1.0),
                                SwitchListTile.adaptive(
                                  title: const Text('Evening Review (9:00 PM)'),
                                  subtitle: const Text('Optional wrap-up check-in'),
                                  value: _summaryOptIn,
                                  onChanged: (v) async {
                                    if (v) {
                                      await ref
                                          .read(notificationServiceProvider)
                                          .requestPermissionsWithExplanation(context);
                                    }
                                    setState(() => _summaryOptIn = v);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Minimal Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pageCount, (index) {
                final isActive = _currentPage == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: isActive ? 22.0 : 7.0,
                  height: 7.0,
                  decoration: BoxDecoration(
                    color: isActive
                        ? primaryCol
                        : (isDark ? AppColors.darkBorder : AppColors.border),
                    borderRadius: AppRadii.roundedFull,
                  ),
                );
              }),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Primary CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                0,
                AppSpacing.xxl,
                AppSpacing.xxl,
              ),
              child: AppButton(
                label: _currentPage == _pageCount - 1 ? 'Get Started' : 'Continue',
                icon: Icons.arrow_forward_rounded,
                size: AppButtonSize.large,
                isFullWidth: true,
                onPressed: () {
                  if (_currentPage < _pageCount - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                    );
                  } else {
                    _finishOnboarding();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStepContainer extends StatelessWidget {
  final Widget child;
  const _OnboardingStepContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Center(child: child),
    );
  }
}
