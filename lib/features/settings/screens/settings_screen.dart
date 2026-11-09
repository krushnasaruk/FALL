import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/repositories/backup_restore_service.dart';
import '../../../services/github_service.dart';
import '../../../services/notification_service.dart';
import '../../../services/widget_sync_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _gitHubTokenController = TextEditingController();
  final _jsonImportController = TextEditingController();
  bool _isExporting = false;
  bool _isSavingGitHub = false;
  bool _dailyAgendaEnabled = true;
  bool _dailySummaryEnabled = true;

  @override
  void dispose() {
    _gitHubTokenController.dispose();
    _jsonImportController.dispose();
    super.dispose();
  }

  Future<void> _exportBackup() async {
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

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Backup JSON'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paste your exported ProgressOS JSON backup below. Existing records will be safely updated without data loss.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jsonImportController,
              maxLines: 6,
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
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
                      content: Text(success ? 'Database restored successfully!' : 'Failed to import backup JSON.'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Settings
          SectionHeader(title: 'Appearance & Theme'),
          AppCard(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Theme Mode', style: AppTypography.titleSmall),
                        Text(
                          currentThemeMode == ThemeMode.dark
                              ? 'Developer Dark (Command Center)'
                              : (currentThemeMode == ThemeMode.light ? 'Light Workspace' : 'System Default'),
                          style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                        ),
                      ],
                    ),
                  ],
                ),
                DropdownButton<ThemeMode>(
                  value: currentThemeMode,
                  items: const [
                    DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                    DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                    DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                  ],
                  onChanged: (mode) {
                    if (mode != null) {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Automated Local Notifications
          SectionHeader(
            title: 'Automated Notification Engine',
            subtitle: 'Direct alarms for tasks, morning briefings, and daily reviews',
          ),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                  title: Text('Request Permissions', style: AppTypography.titleSmall),
                  subtitle: Text(
                    'Ensure notifications and exact alarms are permitted',
                    style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                  ),
                  trailing: AppButton(
                    label: 'Allow',
                    size: AppButtonSize.small,
                    variant: AppButtonVariant.secondary,
                    onPressed: () async {
                      final granted = await notifService.requestPermissions();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(granted ? 'Permissions enabled!' : 'Permission denied or restricted')),
                        );
                      }
                    },
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Morning Daily Agenda (08:00 AM)', style: AppTypography.titleSmall),
                  subtitle: Text('Receive a daily briefing of tasks and milestones due today', style: AppTypography.caption),
                  value: _dailyAgendaEnabled,
                  activeColor: AppColors.primary,
                  onChanged: (val) async {
                    setState(() => _dailyAgendaEnabled = val);
                    if (val) {
                      await notifService.scheduleDailyMorningAgenda(hour: 8, minute: 0);
                    }
                  },
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Evening Daily Review (09:00 PM)', style: AppTypography.titleSmall),
                  subtitle: Text('Wrap up your day and keep your learning streak alive', style: AppTypography.caption),
                  value: _dailySummaryEnabled,
                  activeColor: AppColors.primary,
                  onChanged: (val) async {
                    setState(() => _dailySummaryEnabled = val);
                    if (val) {
                      await notifService.scheduleDailyEveningSummary(hour: 21, minute: 0);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Android Home Screen Widgets
          SectionHeader(
            title: 'Android Native Widgets',
            subtitle: 'Sync real-time progress, streak, and focus timer to home screen',
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '6 native widgets available: Daily Progress, Today\'s Tasks, Learning Streak, Active Project, Focus Timer, Quick Add.',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Force Sync All Widgets',
                  icon: Icons.sync_rounded,
                  variant: AppButtonVariant.secondary,
                  onPressed: () async {
                    await widgetSync.syncAllWidgets();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Native Android widgets synchronized!')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Data Management & Offline JSON Backup/Restore
          SectionHeader(
            title: 'Data Management & JSON Backup',
            subtitle: '100% Local-First. Export and import complete JSON snapshots anytime.',
          ),
          AppCard(
            child: Row(
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
                const SizedBox(width: 12),
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
          ),
          const SizedBox(height: AppSpacing.xl),

          // GitHub Integration
          SectionHeader(
            title: 'GitHub Integration (Optional)',
            subtitle: 'Connect your personal access token to track repositories and commit activity',
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gitHubProfileAsync.when(
                  data: (profile) {
                    if (profile != null) {
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(profile.avatarUrl),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile.name, style: AppTypography.titleSmall),
                                Text('@${profile.login} • ${profile.publicRepos} Repositories', style: AppTypography.caption),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.link_off_rounded, color: AppColors.error),
                            tooltip: 'Disconnect GitHub',
                            onPressed: () async {
                              await ref.read(gitHubServiceProvider).clearToken();
                              ref.invalidate(gitHubProfileProvider);
                            },
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: 'GitHub Personal Access Token (classic / fine-grained)',
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
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // About Section
          SectionHeader(title: 'About ProgressOS'),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: const Icon(Icons.terminal_rounded, size: 18.0, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ProgressOS', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                        Text('Version 1.0.0 (Production Build)', style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'A unified personal operating system for technology learning, project management, and daily productivity execution.',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
