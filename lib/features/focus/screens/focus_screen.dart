import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/focus_repository.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../services/widget_sync_service.dart';

enum FocusMode {
  pomodoro(25 * 60, 'Focus Session'),
  deepWork(50 * 60, 'Deep Work'),
  shortBreak(5 * 60, 'Short Break'),
  longBreak(15 * 60, 'Long Break');

  final int initialSeconds;
  final String label;
  const FocusMode(this.initialSeconds, this.label);
}

class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  FocusMode _currentMode = FocusMode.pomodoro;
  int _secondsRemaining = FocusMode.pomodoro.initialSeconds;
  bool _isRunning = false;
  Timer? _timer;

  String? _selectedTaskId;
  String? _selectedProjectId;
  String? _selectedSkillId;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _switchMode(FocusMode mode) {
    _timer?.cancel();
    setState(() {
      _currentMode = mode;
      _secondsRemaining = mode.initialSeconds;
      _isRunning = false;
    });
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timer?.cancel();
          setState(() => _isRunning = false);
          _completeSession();
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = _currentMode.initialSeconds;
      _isRunning = false;
    });
  }

  Future<void> _completeSession() async {
    final durationMinutes = _currentMode.initialSeconds ~/ 60;
    final repo = ref.read(focusRepositoryProvider);

    await repo.recordFocusSession(
      taskId: _selectedTaskId,
      projectId: _selectedProjectId,
      skillId: _selectedSkillId,
      durationMinutes: durationMinutes,
      sessionType: _currentMode.name,
    );

    await ref.read(widgetSyncServiceProvider).syncAllWidgets();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Completed ${durationMinutes}m focus session! Time logged.'),
          backgroundColor: AppColors.success,
        ),
      );
      _resetTimer();
    }
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recentSessionsAsync = ref.watch(recentFocusSessionsProvider);
    final tasksAsync = ref.watch(allTasksStreamProvider);
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final skillsAsync = ref.watch(allSkillsStreamProvider);

    final progress = 1.0 - (_secondsRemaining / _currentMode.initialSeconds);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Timer'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Mode Selector
          Row(
            children: [
              _buildModeButton(FocusMode.pomodoro, '25m Focus'),
              const SizedBox(width: 8),
              _buildModeButton(FocusMode.deepWork, '50m Deep'),
              const SizedBox(width: 8),
              _buildModeButton(FocusMode.shortBreak, '5m Break'),
              const SizedBox(width: 8),
              _buildModeButton(FocusMode.longBreak, '15m Rest'),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Central Timer Card
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 20.0),
            child: Column(
              children: [
                // Circular Timer Gauge
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220.0,
                      height: 220.0,
                      child: CircularProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        strokeWidth: 8.0,
                        backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                        valueColor: AlwaysStoppedAnimation(
                          _currentMode == FocusMode.shortBreak || _currentMode == FocusMode.longBreak
                              ? AppColors.success
                              : AppColors.primary,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(_secondsRemaining),
                          style: AppTypography.displayLarge.copyWith(
                            fontFamily: 'monospace',
                            fontSize: 48.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          _currentMode.label.toUpperCase(),
                          style: AppTypography.caption.copyWith(
                            letterSpacing: 1.0,
                            color: AppColors.darkTextMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),

                // Controls: Start/Pause, Reset, Complete Early
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      onPressed: _resetTimer,
                      icon: const Icon(Icons.refresh_rounded),
                      tooltip: 'Reset',
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 140,
                      child: AppButton(
                        label: _isRunning ? 'Pause' : 'Start Focus',
                        icon: _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        onPressed: _toggleTimer,
                        size: AppButtonSize.large,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton.filledTonal(
                      onPressed: _completeSession,
                      icon: const Icon(Icons.check_rounded),
                      tooltip: 'Log Finished',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Link Session to Work
          Text(
            'Link Session Target',
            style: AppTypography.titleSmall.copyWith(
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Time logged will automatically be added to the selected task, project, and skill.',
            style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Dropdowns for task / project / skill
          AppCard(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Task
                tasksAsync.when(
                  data: (tasks) {
                    final openTasks = tasks.where((t) => !t.task.isCompleted).toList();
                    return DropdownButtonFormField<String?>(
                      value: _selectedTaskId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Focus on Task'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('No Task Linked')),
                        ...openTasks.map((t) => DropdownMenuItem(
                              value: t.task.id,
                              child: Text(t.task.title, overflow: TextOverflow.ellipsis),
                            )),
                      ],
                      onChanged: (val) => setState(() => _selectedTaskId = val),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Project
                projectsAsync.when(
                  data: (projects) {
                    return DropdownButtonFormField<String?>(
                      value: _selectedProjectId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Focus on Project'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('No Project Linked')),
                        ...projects.map((p) => DropdownMenuItem(
                              value: p.project.id,
                              child: Text(p.project.name, overflow: TextOverflow.ellipsis),
                            )),
                      ],
                      onChanged: (val) => setState(() => _selectedProjectId = val),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Skill
                skillsAsync.when(
                  data: (skills) {
                    return DropdownButtonFormField<String?>(
                      value: _selectedSkillId,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Skill / Roadmap'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('No Skill Linked')),
                        ...skills.map((s) => DropdownMenuItem(
                              value: s.skill.id,
                              child: Text(s.skill.name, overflow: TextOverflow.ellipsis),
                            )),
                      ],
                      onChanged: (val) => setState(() => _selectedSkillId = val),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Recent Focus Sessions List
          SectionHeader(title: 'Recent Focus Sessions'),
          recentSessionsAsync.when(
            data: (sessions) {
              if (sessions.isEmpty) {
                return Text(
                  'No focus sessions completed yet. Start your first session above!',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextMuted),
                );
              }

              return Column(
                children: sessions.take(10).map((s) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: AppRadii.roundedSm,
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: AppRadii.roundedSm,
                              ),
                              child: const Icon(Icons.timer_outlined, size: 16, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${s.session.durationMinutes}m ${s.session.sessionType.toUpperCase()}',
                                  style: AppTypography.titleSmall,
                                ),
                                if (s.task != null)
                                  Text('Task: ${s.task!.title}', style: AppTypography.caption),
                                if (s.project != null)
                                  Text('Project: ${s.project!.name}', style: AppTypography.caption),
                                if (s.skill != null)
                                  Text('Skill: ${s.skill!.name}', style: AppTypography.caption),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          DateFormatters.dateTimeShort(s.session.completedAt),
                          style: AppTypography.caption.copyWith(color: AppColors.darkTextMuted),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => ErrorStateView(message: err.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(FocusMode mode, String label) {
    final isSelected = _currentMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchMode(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: AppRadii.roundedSm,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.darkBorder,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              color: isSelected ? const Color(0xFF0F172A) : AppColors.darkTextSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 10.5,
            ),
          ),
        ),
      ),
    );
  }
}
