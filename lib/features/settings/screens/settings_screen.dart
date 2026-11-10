import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/fall_logo.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/database/database_provider.dart';
import '../../../data/repositories/backup_restore_service.dart';
import '../../../data/repositories/user_preferences_repository.dart';
import '../../../services/feedback_service.dart';
import '../../../services/github_service.dart';
import '../../../services/notification_preferences.dart';
import '../../../services/notification_service.dart';
import '../../../services/widget_sync_service.dart';
import '../../dashboard/widgets/dashboard_customization_sheet.dart';

/// Settings Screen organized by calm, clear groups:
/// Appearance, Notifications, Sounds & Vibrations, Dashboard Layout, Widgets, Backups, GitHub, About.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _gitHubTokenController = TextEditingController();
  final _jsonImportController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isExporting = false;
  bool _isResetting = false;
  bool _isSavingGitHub = false;
  bool _dailyAgendaEnabled = true;
  bool _dailySummaryEnabled = true;
  bool _notificationsPermitted = true;
  bool _exactAlarmsPermitted = true;
  bool _hasInitializedName = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationState();
  }

  Future<void> _loadNotificationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifService = ref.read(notificationServiceProvider);
      final enabled = await notifService.areNotificationsEnabled();
      final exact = await notifService.canScheduleExactAlarms();
      if (!mounted) return;
      setState(() {
        _dailyAgendaEnabled = prefs.getBool('notif_daily_agenda_enabled') ?? true;
        _dailySummaryEnabled = prefs.getBool('notif_daily_summary_enabled') ?? true;
        _notificationsPermitted = enabled;
        _exactAlarmsPermitted = exact;
      });
    } catch (_) {
      // Safe fallback under tests / restricted storage
    }
  }

  @override
  void dispose() {
    _gitHubTokenController.dispose();
    _jsonImportController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _exportBackup() async {
    ref.read(feedbackServiceProvider).buttonTap();
    setState(() => _isExporting = true);
    try {
      final service = ref.read(backupRestoreServiceProvider);
      await service.exportAndShare();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup exported successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _resetAllData() async {
    ref.read(feedbackServiceProvider).buttonTap();
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Reset All Data to Zero?',
      message:
          'This permanently deletes all tasks, projects, milestones, skills, goals, habits, notes, focus sessions, and stats so you can start completely fresh.',
      confirmLabel: 'Reset All to Zero',
      isDestructive: true,
    );
    if (!confirmed || !mounted) return;

    setState(() => _isResetting = true);
    try {
      await ref.read(notificationServiceProvider).cancelAllReminders();
      await ref.read(databaseProvider).clearAllData();
      await ref.read(widgetSyncServiceProvider).syncAllWidgets();
      if (mounted) {
        ref.read(feedbackServiceProvider).taskCompleted();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All tasks and stats reset to zero.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reset failed: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isResetting = false);
    }
  }

  void _showImportDialog() {
    ref.read(feedbackServiceProvider).buttonTap();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Backup JSON'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paste your exported FALL JSON backup below. Existing records are safely upserted.',
              style: TextStyle(fontSize: 12.5),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jsonImportController,
              maxLines: 6,
              style: const TextStyle(fontSize: 11.5, fontFamily: 'monospace'),
              decoration: const InputDecoration(
                hintText: '{"version": 1, "tasks": [...], ...}',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: 'Import',
            size: AppButtonSize.small,
            onPressed: () async {
              final json = _jsonImportController.text.trim();
              if (json.isNotEmpty) {
                final service = ref.read(backupRestoreServiceProvider);
                final success = await service.importFromJson(json);
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Database restored successfully!'
                            : 'Failed to import backup JSON.',
                      ),
                      backgroundColor: success ? AppColors.success : AppColors.error,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentThemeMode = ref.watch(themeModeProvider);
    final notifService = ref.watch(notificationServiceProvider);
    final widgetSync = ref.watch(widgetSyncServiceProvider);
    final gitHubProfileAsync = ref.watch(gitHubProfileProvider);
    final userPrefs = ref.watch(userPreferencesProvider);
    final feedbackSettings = ref.watch(feedbackSettingsProvider);
    final notifPrefs = ref.watch(notificationPreferencesProvider);
    final feedback = ref.read(feedbackServiceProvider);

    if (!_hasInitializedName) {
      _nameController.text = userPrefs.displayName;
      _hasInitializedName = true;
    }

    return AppScaffold(
      body: ListView(
        padding: const EdgeInsets.only(bottom: 56.0),
        children: [
          PageTitle(
            title: 'Settings',
            subtitle: 'Appearance, reminders, sounds & local backups',
            showBackButton: Navigator.of(context).canPop(),
          ),

          // 1. Appearance & Profile
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(
              title: 'Appearance & Profile',
              subtitle: 'Light mode primary canvas or independent dark slate theme',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme Mode',
                    style: AppTypography.cardTitle.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _ThemeOptionButton(
                          label: 'Light',
                          icon: Icons.light_mode_outlined,
                          selected: currentThemeMode == ThemeMode.light,
                          onTap: () {
                            feedback.selectionClick();
                            ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _ThemeOptionButton(
                          label: 'Dark',
                          icon: Icons.dark_mode_outlined,
                          selected: currentThemeMode == ThemeMode.dark,
                          onTap: () {
                            feedback.selectionClick();
                            ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _ThemeOptionButton(
                          label: 'System',
                          icon: Icons.brightness_auto_outlined,
                          selected: currentThemeMode == ThemeMode.system,
                          onTap: () {
                            feedback.selectionClick();
                            ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Display Name',
                          hintText: 'How FALL greets you on Home',
                          controller: _nameController,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      AppButton(
                        label: 'Save',
                        size: AppButtonSize.small,
                        onPressed: () {
                          final name = _nameController.text.trim();
                          if (name.isNotEmpty) {
                            feedback.buttonTap();
                            ref.read(userPreferencesProvider.notifier).updateDisplayName(name);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Display name updated')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 2. Dashboard Personalization
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(
              title: 'Home Dashboard Layout',
              subtitle: 'Reorder sections or hide modules you do not need',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              onTap: () {
                feedback.buttonTap();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const DashboardCustomizationSheet(),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.primaryDark : AppColors.primary).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(11.0),
                    ),
                    child: Icon(
                      AppIcons.filter,
                      color: isDark ? AppColors.primaryDark : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customize Home Sections',
                          style: AppTypography.cardTitle.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Drag-to-reorder & toggle dashboard cards',
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

          // 3. Notifications & Exact Alarms
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(
              title: 'Notifications & Reminders',
              subtitle: '7 dedicated Android channels, snooze & mark-done actions',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          AppBadge(
                            label: _notificationsPermitted ? 'Alerts Permitted' : 'Permission Needed',
                            color: _notificationsPermitted ? AppColors.success : AppColors.warning,
                          ),
                          AppBadge(
                            label: _exactAlarmsPermitted ? 'Exact Alarms Ready' : 'Inexact Fallback',
                            color: _exactAlarmsPermitted ? AppColors.taskAccent : AppColors.warning,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SwitchListTile.adaptive(
                    title: const Text('Morning Daily Agenda'),
                    subtitle: const Text('8:30 AM briefing of tasks & priorities'),
                    value: _dailyAgendaEnabled,
                    onChanged: (val) async {
                      feedback.selectionClick();
                      setState(() => _dailyAgendaEnabled = val);
                      await ref
                          .read(notificationPreferencesProvider.notifier)
                          .setCategory('daily_agenda', val);
                      if (val) {
                        await notifService.scheduleDailyMorningAgenda();
                      } else {
                        await notifService.cancelDailyMorningAgenda();
                      }
                    },
                  ),
                  const Divider(height: 1.0),
                  SwitchListTile.adaptive(
                    title: const Text('Evening Daily Review'),
                    subtitle: const Text('9:00 PM wrap-up & check-in reminder'),
                    value: _dailySummaryEnabled,
                    onChanged: (val) async {
                      feedback.selectionClick();
                      setState(() => _dailySummaryEnabled = val);
                      await ref
                          .read(notificationPreferencesProvider.notifier)
                          .setCategory('daily_summary', val);
                      if (val) {
                        await notifService.scheduleDailyEveningSummary();
                      } else {
                        await notifService.cancelDailyEveningSummary();
                      }
                    },
                  ),
                  const Divider(height: 1.0),
                  SwitchListTile.adaptive(
                    title: const Text('Task Reminders'),
                    subtitle: const Text('Direct alerts for scheduled task times'),
                    value: notifPrefs.tasksEnabled,
                    onChanged: (val) {
                      feedback.selectionClick();
                      ref.read(notificationPreferencesProvider.notifier).setCategory('tasks', val);
                    },
                  ),
                  const Divider(height: 1.0),
                  SwitchListTile.adaptive(
                    title: const Text('Habit Check-ins'),
                    subtitle: const Text('Gentle daily prompts for active habits'),
                    value: notifPrefs.habitsEnabled,
                    onChanged: (val) {
                      feedback.selectionClick();
                      ref.read(notificationPreferencesProvider.notifier).setCategory('habits', val);
                    },
                  ),
                  const Divider(height: 1.0),
                  SwitchListTile.adaptive(
                    title: const Text('Learning, Goals & Milestones'),
                    subtitle: const Text('Study nudges and milestone checkpoints'),
                    value: notifPrefs.learningEnabled && notifPrefs.goalsEnabled && notifPrefs.milestonesEnabled,
                    onChanged: (val) {
                      feedback.selectionClick();
                      final n = ref.read(notificationPreferencesProvider.notifier);
                      n.setCategory('learning', val);
                      n.setCategory('goals', val);
                      n.setCategory('milestones', val);
                    },
                  ),
                  const Divider(height: 1.0),
                  SwitchListTile.adaptive(
                    title: const Text('Focus Completion Alerts'),
                    subtitle: const Text('Notify softly when timed sessions end'),
                    value: notifPrefs.focusEnabled,
                    onChanged: (val) {
                      feedback.selectionClick();
                      ref.read(notificationPreferencesProvider.notifier).setCategory('focus', val);
                    },
                  ),
                  const Divider(height: 1.0),
                  SwitchListTile.adaptive(
                    title: const Text('Quiet Hours'),
                    subtitle: Text(
                      notifPrefs.quietHoursEnabled
                          ? 'Silenced ${notifPrefs.quietStart.format(context)} – ${notifPrefs.quietEnd.format(context)}'
                          : 'Off — alerts deliver at scheduled times',
                    ),
                    value: notifPrefs.quietHoursEnabled,
                    onChanged: (val) {
                      feedback.selectionClick();
                      ref.read(notificationPreferencesProvider.notifier).setQuietHoursEnabled(val);
                    },
                  ),
                  if (notifPrefs.quietHoursEnabled) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          AppButton(
                            label: 'Start: ${notifPrefs.quietStart.format(context)}',
                            variant: AppButtonVariant.outline,
                            size: AppButtonSize.small,
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: notifPrefs.quietStart,
                              );
                              if (picked != null) {
                                await ref
                                    .read(notificationPreferencesProvider.notifier)
                                    .setQuietWindow(picked, notifPrefs.quietEnd);
                              }
                            },
                          ),
                          AppButton(
                            label: 'End: ${notifPrefs.quietEnd.format(context)}',
                            variant: AppButtonVariant.outline,
                            size: AppButtonSize.small,
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: notifPrefs.quietEnd,
                              );
                              if (picked != null) {
                                await ref
                                    .read(notificationPreferencesProvider.notifier)
                                    .setQuietWindow(notifPrefs.quietStart, picked);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Divider(height: 1.0),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        if (!_notificationsPermitted)
                          AppButton(
                            label: 'Grant Alert Permission',
                            size: AppButtonSize.small,
                            onPressed: () async {
                              final granted = await notifService.requestPermissionsWithExplanation(context);
                              if (!mounted) return;
                              setState(() => _notificationsPermitted = granted);
                            },
                          ),
                        if (!_exactAlarmsPermitted)
                          AppButton(
                            label: 'Allow Exact Alarms',
                            variant: AppButtonVariant.secondary,
                            size: AppButtonSize.small,
                            onPressed: () async {
                              final ok = await notifService.requestExactAlarmPermission();
                              if (!mounted) return;
                              setState(() => _exactAlarmsPermitted = ok);
                            },
                          ),
                        AppButton(
                          label: 'Send Test Alert',
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.small,
                          icon: AppIcons.notifications,
                          onPressed: () async {
                            feedback.buttonTap();
                            final allowed = await notifService.requestPermissionsWithExplanation(context);
                            if (!allowed) return;
                            await notifService.showImmediateNotification(
                              title: 'FALL — Reminder Check',
                              body: 'Local notifications and snooze/done actions are ready.',
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Test notification dispatched')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 4. Sounds & Haptic Feedback (Phase 6)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(
              title: 'Sounds & Vibrations',
              subtitle: 'Subtle offline audio chimes (respects silent mode) & calm haptics',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    title: const Text('Haptic Feedback'),
                    subtitle: const Text('Tactile response for task completion, tabs & reorder'),
                    value: feedbackSettings.hapticsEnabled,
                    onChanged: (val) {
                      ref.read(feedbackSettingsProvider.notifier).setHapticsEnabled(val);
                      if (val) feedback.selectionClick();
                    },
                  ),
                  const Divider(height: 1.0),
                  SwitchListTile.adaptive(
                    title: const Text('In-App UI Chimes'),
                    subtitle: const Text('Gentle synthesized tones for tasks, goals & focus timer'),
                    value: feedbackSettings.soundEffectsEnabled,
                    onChanged: (val) async {
                      await ref.read(feedbackSettingsProvider.notifier).setSoundEffectsEnabled(val);
                      if (val) feedback.playPreviewAlert();
                    },
                  ),
                  const Divider(height: 1.0),
                  SwitchListTile.adaptive(
                    title: const Text('Notification Alert Sound'),
                    subtitle: const Text('Play sound when local scheduled reminders arrive'),
                    value: feedbackSettings.notificationSoundsEnabled,
                    onChanged: (val) {
                      ref.read(feedbackSettingsProvider.notifier).setNotificationSoundsEnabled(val);
                      feedback.selectionClick();
                    },
                  ),
                  const Divider(height: 1.0),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        AppButton(
                          label: 'Preview Alert Chime',
                          icon: Icons.volume_up_outlined,
                          variant: AppButtonVariant.secondary,
                          size: AppButtonSize.small,
                          onPressed: () {
                            feedback.playPreviewAlert();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Played gentle reminder chime.')),
                            );
                          },
                        ),
                        AppButton(
                          label: 'Preview Achievement',
                          icon: Icons.auto_awesome_outlined,
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.small,
                          onPressed: () {
                            feedback.achievementUnlocked();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Played achievement chime.')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 5. Android Native Home-Screen Widgets
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(
              title: 'Android Home-Screen Widgets',
              subtitle: 'Daily Progress, Today Tasks, Streak, Active Project, Focus & Quick Add',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Widgets stay updated automatically on task, habit, and timer changes.',
                      style: AppTypography.secondary.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  AppButton(
                    label: 'Sync Now',
                    icon: Icons.sync_rounded,
                    variant: AppButtonVariant.secondary,
                    size: AppButtonSize.small,
                    onPressed: () async {
                      feedback.buttonTap();
                      await widgetSync.syncAllWidgets();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('All 6 Android widgets synced!')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 6. Data Management & Offline JSON Backup
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(
              title: 'Data Management & JSON Backup',
              subtitle: '100% local SQLite storage with portable JSON export & import',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Export Backup',
                          icon: Icons.download_rounded,
                          isLoading: _isExporting,
                          variant: AppButtonVariant.secondary,
                          onPressed: _exportBackup,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppButton(
                          label: 'Import Backup',
                          icon: Icons.upload_rounded,
                          variant: AppButtonVariant.outline,
                          onPressed: _showImportDialog,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Reset All Data to Zero',
                    icon: Icons.delete_sweep_rounded,
                    isLoading: _isResetting,
                    variant: AppButtonVariant.danger,
                    onPressed: _resetAllData,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 7. GitHub Integration (Optional)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(
              title: 'GitHub Integration (Optional)',
              subtitle: 'Connect a personal access token to surface repo & profile metadata',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              child: gitHubProfileAsync.when(
                data: (profile) {
                  if (profile != null) {
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(profile.avatarUrl),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile.name, style: AppTypography.cardTitle),
                              Text(
                                '@${profile.login} • ${profile.publicRepos} repositories',
                                style: AppTypography.metadata,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.link_off_rounded, color: AppColors.error),
                          tooltip: 'Disconnect GitHub',
                          onPressed: () async {
                            final confirm = await ConfirmationDialog.show(
                              context,
                              title: 'Disconnect GitHub',
                              message: 'Remove your saved GitHub Personal Access Token from this device?',
                              confirmLabel: 'Disconnect',
                            );
                            if (confirm) {
                              await ref.read(gitHubServiceProvider).clearToken();
                              ref.invalidate(gitHubProfileProvider);
                            }
                          },
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        label: 'GitHub Personal Access Token',
                        hintText: 'ghp_xxxxxxxxxxxxxxxxxxxx',
                        controller: _gitHubTokenController,
                        obscureText: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: 'Connect Account',
                        size: AppButtonSize.small,
                        isLoading: _isSavingGitHub,
                        onPressed: () async {
                          final token = _gitHubTokenController.text.trim();
                          if (token.isNotEmpty) {
                            feedback.buttonTap();
                            setState(() => _isSavingGitHub = true);
                            try {
                              await ref.read(gitHubServiceProvider).saveToken(token);
                              ref.invalidate(gitHubProfileProvider);
                              _gitHubTokenController.clear();
                            } finally {
                              if (mounted) setState(() => _isSavingGitHub = false);
                            }
                          }
                        },
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error loading GitHub: $err'),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 8. Feature Guide & Discovery Tips
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(
              title: 'Feature Guide & Tips',
              subtitle: 'Quick reference & helpful workspace reminders',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Tasks: Tap circular checkboxes for immediate completion with Undo.\n'
                    '• Projects & Learning: Break big projects into Milestones or Skills into Modules.\n'
                    '• Focus Timer: Wall-clock timing stays accurate when switching apps or pausing.\n'
                    '• Habits & Streaks: Rest days are welcomed kindly — never punished.',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      AppButton(
                        label: 'Reset Helpful Tips',
                        icon: Icons.tips_and_updates_outlined,
                        variant: AppButtonVariant.secondary,
                        size: AppButtonSize.small,
                        onPressed: () async {
                          feedback.selectionClick();
                          await ref.read(userPreferencesProvider.notifier).resetAllTips();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contextual tips restored.')),
                            );
                          }
                        },
                      ),
                      AppButton(
                        label: 'Open Welcome Tour',
                        icon: Icons.explore_outlined,
                        variant: AppButtonVariant.outline,
                        size: AppButtonSize.small,
                        onPressed: () {
                          feedback.buttonTap();
                          context.go('/onboarding');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 9. About FALL
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: SectionHeader(title: 'About FALL'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: AppCard(
              child: Row(
                children: [
                  const FallLogo(size: 40.0, isCircle: false),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FALL',
                          style: AppTypography.cardTitle.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'Version 4.0.0 • FALL Productivity & Radar Intelligence',
                          style: AppTypography.metadata.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
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
    );
  }
}

class _ThemeOptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOptionButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryCol = isDark ? AppColors.primaryDark : AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: selected
              ? primaryCol.withOpacity(0.14)
              : (isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: selected
                ? primaryCol
                : (isDark ? AppColors.darkBorder : AppColors.border),
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18.0,
              color: selected
                  ? primaryCol
                  : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: AppTypography.metadata.copyWith(
                color: selected
                    ? primaryCol
                    : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
