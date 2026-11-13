import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repositories/focus_repository.dart';
import 'feedback_service.dart';
import 'notification_preferences.dart';
import 'notification_service.dart';
import 'widget_sync_service.dart';

enum FocusTimerMode {
  pomodoro(25, 'Pomodoro', 'Focus Session'),
  deepWork(45, 'Deep Work', 'Extended Focus'),
  quickSprint(15, '15m Sprint', 'Quick Focus'),
  shortBreak(5, 'Short Break', 'Recovery'),
  longBreak(15, 'Long Break', 'Deep Rest');

  final int defaultMinutes;
  final String label;
  final String category;
  const FocusTimerMode(this.defaultMinutes, this.label, this.category);
}

enum FocusTimerStatus {
  idle,
  running,
  paused,
  onBreak,
  completed,
}

class FocusCompletionSummary {
  final int recordedMinutes;
  final int breakMinutes;
  final String modeLabel;
  final String? linkedTaskId;
  final String? linkedProjectId;
  final String? linkedSkillId;
  final String? notes;
  final DateTime completedAt;

  const FocusCompletionSummary({
    required this.recordedMinutes,
    this.breakMinutes = 0,
    required this.modeLabel,
    this.linkedTaskId,
    this.linkedProjectId,
    this.linkedSkillId,
    this.notes,
    required this.completedAt,
  });
}

class FocusTimerState {
  final FocusTimerMode mode;
  final FocusTimerStatus status;
  final int targetMinutes;
  final int remainingSeconds;
  final int accumulatedFocusedSeconds;
  final int accumulatedBreakSeconds;
  final int? segmentStartEpochMs;
  final int? breakStartEpochMs;
  final int? sessionStartEpochMs;
  final String? linkedTaskId;
  final String? linkedProjectId;
  final String? linkedSkillId;
  final String? sessionNotes;
  final FocusCompletionSummary? lastSummary;

  const FocusTimerState({
    this.mode = FocusTimerMode.pomodoro,
    FocusTimerStatus? status,
    this.targetMinutes = 25,
    this.remainingSeconds = 25 * 60,
    this.accumulatedFocusedSeconds = 0,
    this.accumulatedBreakSeconds = 0,
    this.segmentStartEpochMs,
    this.breakStartEpochMs,
    this.sessionStartEpochMs,
    this.linkedTaskId,
    this.linkedProjectId,
    this.linkedSkillId,
    this.sessionNotes,
    this.lastSummary,
    bool isRunning = false,
  }) : status = status ?? (isRunning ? FocusTimerStatus.running : FocusTimerStatus.idle);

  int get totalTargetSeconds => targetMinutes * 60;

  bool get isRunning => status == FocusTimerStatus.running;
  bool get isPaused => status == FocusTimerStatus.paused;
  bool get isOnBreak => status == FocusTimerStatus.onBreak;
  bool get isIdle => status == FocusTimerStatus.idle;
  bool get isActive => status == FocusTimerStatus.running ||
      status == FocusTimerStatus.paused ||
      status == FocusTimerStatus.onBreak;

  double get progress {
    if (totalTargetSeconds <= 0) return 0.0;
    return (1.0 - (remainingSeconds / totalTargetSeconds)).clamp(0.0, 1.0);
  }

  /// Active focused seconds including the current running slice (never includes paused time or break time).
  int effectiveFocusedSeconds({DateTime? now}) {
    if (status != FocusTimerStatus.running || segmentStartEpochMs == null) {
      return accumulatedFocusedSeconds;
    }
    final currentMs = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final slice = ((currentMs - segmentStartEpochMs!) / 1000).floor().clamp(0, totalTargetSeconds);
    return (accumulatedFocusedSeconds + slice).clamp(0, totalTargetSeconds);
  }

  /// Active break seconds including current break slice.
  int effectiveBreakSeconds({DateTime? now}) {
    if (status != FocusTimerStatus.onBreak || breakStartEpochMs == null) {
      return accumulatedBreakSeconds;
    }
    final currentMs = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final slice = ((currentMs - breakStartEpochMs!) / 1000).floor().clamp(0, 86400);
    return accumulatedBreakSeconds + slice;
  }

  FocusTimerState copyWith({
    FocusTimerMode? mode,
    FocusTimerStatus? status,
    int? targetMinutes,
    int? remainingSeconds,
    int? accumulatedFocusedSeconds,
    int? accumulatedBreakSeconds,
    int? Function()? segmentStartEpochMs,
    int? Function()? breakStartEpochMs,
    int? Function()? sessionStartEpochMs,
    String? Function()? linkedTaskId,
    String? Function()? linkedProjectId,
    String? Function()? linkedSkillId,
    String? Function()? sessionNotes,
    FocusCompletionSummary? Function()? lastSummary,
    bool? isRunning, // backward-compat helper
  }) {
    final newStatus = status ??
        (isRunning != null
            ? (isRunning ? FocusTimerStatus.running : FocusTimerStatus.paused)
            : this.status);

    return FocusTimerState(
      mode: mode ?? this.mode,
      status: newStatus,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      accumulatedFocusedSeconds: accumulatedFocusedSeconds ?? this.accumulatedFocusedSeconds,
      accumulatedBreakSeconds: accumulatedBreakSeconds ?? this.accumulatedBreakSeconds,
      segmentStartEpochMs: segmentStartEpochMs != null ? segmentStartEpochMs() : this.segmentStartEpochMs,
      breakStartEpochMs: breakStartEpochMs != null ? breakStartEpochMs() : this.breakStartEpochMs,
      sessionStartEpochMs: sessionStartEpochMs != null ? sessionStartEpochMs() : this.sessionStartEpochMs,
      linkedTaskId: linkedTaskId != null ? linkedTaskId() : this.linkedTaskId,
      linkedProjectId: linkedProjectId != null ? linkedProjectId() : this.linkedProjectId,
      linkedSkillId: linkedSkillId != null ? linkedSkillId() : this.linkedSkillId,
      sessionNotes: sessionNotes != null ? sessionNotes() : this.sessionNotes,
      lastSummary: lastSummary != null ? lastSummary() : this.lastSummary,
    );
  }
}

/// Persistent wall-clock Focus Timer state manager.
/// Maintains accurate elapsed focus duration across route exits and Android backgrounding,
/// strictly excluding paused intervals and break times from focused time calculations.
class FocusTimerNotifier extends StateNotifier<FocusTimerState> {
  static const _kStatus = 'focus_timer_status_v2';
  static const _kMode = 'focus_timer_mode_v2';
  static const _kTargetMins = 'focus_timer_target_mins_v2';
  static const _kAccFocused = 'focus_timer_acc_focused_v2';
  static const _kAccBreak = 'focus_timer_acc_break_v2';
  static const _kSegStart = 'focus_timer_seg_start_v2';
  static const _kBreakStart = 'focus_timer_break_start_v2';
  static const _kSessionStart = 'focus_timer_session_start_v2';
  static const _kTaskId = 'focus_timer_task_id_v2';
  static const _kProjId = 'focus_timer_proj_id_v2';
  static const _kSkillId = 'focus_timer_skill_id_v2';
  static const _kNotes = 'focus_timer_notes_v2';

  final Ref _ref;
  Timer? _ticker;
  bool _completing = false;

  FocusTimerNotifier(this._ref) : super(const FocusTimerState()) {
    _restoreFromStorage();
  }

  Future<void> _restoreFromStorage() async {
    try {
      final p = await SharedPreferences.getInstance();
      final statusName = p.getString(_kStatus);
      final status = FocusTimerStatus.values.firstWhere(
        (s) => s.name == statusName,
        orElse: () => FocusTimerStatus.idle,
      );

      final modeName = p.getString(_kMode);
      final mode = FocusTimerMode.values.firstWhere(
        (m) => m.name == modeName,
        orElse: () => FocusTimerMode.pomodoro,
      );
      final targetMins = p.getInt(_kTargetMins) ?? mode.defaultMinutes;
      final accFocused = p.getInt(_kAccFocused) ?? 0;
      final accBreak = p.getInt(_kAccBreak) ?? 0;
      final segStart = p.getInt(_kSegStart);
      final breakStart = p.getInt(_kBreakStart);
      final sessionStart = p.getInt(_kSessionStart);
      final taskId = p.getString(_kTaskId);
      final projId = p.getString(_kProjId);
      final skillId = p.getString(_kSkillId);
      final notes = p.getString(_kNotes);

      final totalSecs = targetMins * 60;
      int remaining = (totalSecs - accFocused).clamp(0, totalSecs);

      if (status == FocusTimerStatus.running && segStart != null) {
        final elapsedSlice = ((DateTime.now().millisecondsSinceEpoch - segStart) / 1000).floor();
        final effectiveFocused = (accFocused + elapsedSlice).clamp(0, totalSecs);
        remaining = (totalSecs - effectiveFocused).clamp(0, totalSecs);
      }

      state = FocusTimerState(
        mode: mode,
        status: (status == FocusTimerStatus.running && remaining <= 0)
            ? FocusTimerStatus.completed
            : status,
        targetMinutes: targetMins,
        remainingSeconds: remaining,
        accumulatedFocusedSeconds: accFocused,
        accumulatedBreakSeconds: accBreak,
        segmentStartEpochMs: status == FocusTimerStatus.running ? segStart : null,
        breakStartEpochMs: status == FocusTimerStatus.onBreak ? breakStart : null,
        sessionStartEpochMs: sessionStart,
        linkedTaskId: taskId,
        linkedProjectId: projId,
        linkedSkillId: skillId,
        sessionNotes: notes,
      );

      if (status == FocusTimerStatus.running && remaining <= 0) {
        await completeSession(autoCompleted: true);
      } else if (state.isRunning || state.isOnBreak) {
        _startTicker();
      }
    } catch (_) {
      // Safe default in tests
    }
  }

  Future<void> _persist() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_kStatus, state.status.name);
      await p.setString(_kMode, state.mode.name);
      await p.setInt(_kTargetMins, state.targetMinutes);
      await p.setInt(_kAccFocused, state.accumulatedFocusedSeconds);
      await p.setInt(_kAccBreak, state.accumulatedBreakSeconds);

      if (state.segmentStartEpochMs != null) {
        await p.setInt(_kSegStart, state.segmentStartEpochMs!);
      } else {
        await p.remove(_kSegStart);
      }

      if (state.breakStartEpochMs != null) {
        await p.setInt(_kBreakStart, state.breakStartEpochMs!);
      } else {
        await p.remove(_kBreakStart);
      }

      if (state.sessionStartEpochMs != null) {
        await p.setInt(_kSessionStart, state.sessionStartEpochMs!);
      } else {
        await p.remove(_kSessionStart);
      }

      if (state.linkedTaskId != null) {
        await p.setString(_kTaskId, state.linkedTaskId!);
      } else {
        await p.remove(_kTaskId);
      }

      if (state.linkedProjectId != null) {
        await p.setString(_kProjId, state.linkedProjectId!);
      } else {
        await p.remove(_kProjId);
      }

      if (state.linkedSkillId != null) {
        await p.setString(_kSkillId, state.linkedSkillId!);
      } else {
        await p.remove(_kSkillId);
      }

      if (state.sessionNotes != null) {
        await p.setString(_kNotes, state.sessionNotes!);
      } else {
        await p.remove(_kNotes);
      }
    } catch (_) {}
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => syncWithClock());
  }

  /// Synchronizes remaining & active focus time against wall-clock time.
  void syncWithClock() {
    if (state.status == FocusTimerStatus.running) {
      if (state.segmentStartEpochMs == null) return;
      final total = state.totalTargetSeconds;
      final effectiveFocused = state.effectiveFocusedSeconds();
      final rem = (total - effectiveFocused).clamp(0, total);
      if (rem != state.remainingSeconds) {
        state = state.copyWith(remainingSeconds: rem);
      }
      if (rem <= 0 && !_completing) {
        completeSession(autoCompleted: true);
      }
    } else if (state.status == FocusTimerStatus.onBreak) {
      // Refresh break counter
      final bSecs = state.effectiveBreakSeconds();
      if (bSecs != state.accumulatedBreakSeconds) {
        // Ticking break state
      }
    }
  }

  Future<void> switchMode(FocusTimerMode mode, {int? customMinutes}) async {
    _ticker?.cancel();
    final mins = customMinutes ?? mode.defaultMinutes;
    _ref.read(feedbackServiceProvider).selectionClick();
    state = state.copyWith(
      mode: mode,
      status: FocusTimerStatus.idle,
      targetMinutes: mins,
      remainingSeconds: mins * 60,
      accumulatedFocusedSeconds: 0,
      accumulatedBreakSeconds: 0,
      segmentStartEpochMs: () => null,
      breakStartEpochMs: () => null,
      sessionStartEpochMs: () => null,
    );
    await _persist();
    await _ref.read(widgetSyncServiceProvider).syncFocusStatus('${_fmt(state.remainingSeconds)} ready');
  }

  Future<void> setLinkedTargets({
    String? taskId,
    String? projectId,
    String? skillId,
    String? notes,
  }) async {
    state = state.copyWith(
      linkedTaskId: () => taskId,
      linkedProjectId: () => projectId,
      linkedSkillId: () => skillId,
      sessionNotes: () => notes,
    );
    await _persist();
  }

  /// Start a focus session pre-configured with contextual targets
  Future<void> startSession({
    FocusTimerMode? mode,
    int? customMinutes,
    String? taskId,
    String? projectId,
    String? skillId,
    String? notes,
  }) async {
    _ticker?.cancel();
    final selectedMode = mode ?? state.mode;
    final mins = customMinutes ?? selectedMode.defaultMinutes;
    final now = DateTime.now().millisecondsSinceEpoch;

    _ref.read(feedbackServiceProvider).timerStart();
    state = FocusTimerState(
      mode: selectedMode,
      status: FocusTimerStatus.running,
      targetMinutes: mins,
      remainingSeconds: mins * 60,
      accumulatedFocusedSeconds: 0,
      accumulatedBreakSeconds: 0,
      segmentStartEpochMs: now,
      breakStartEpochMs: null,
      sessionStartEpochMs: now,
      linkedTaskId: taskId,
      linkedProjectId: projectId,
      linkedSkillId: skillId,
      sessionNotes: notes,
      lastSummary: null,
    );
    _startTicker();
    await _persist();
    await _ref.read(widgetSyncServiceProvider).syncFocusStatus('${_fmt(state.remainingSeconds)} running');
  }

  Future<void> pauseTimer() async {
    if (state.status != FocusTimerStatus.running) return;
    _ticker?.cancel();
    final feedback = _ref.read(feedbackServiceProvider);
    feedback.buttonTap();

    final totalFocused = state.effectiveFocusedSeconds();
    final rem = (state.totalTargetSeconds - totalFocused).clamp(0, state.totalTargetSeconds);

    state = state.copyWith(
      status: FocusTimerStatus.paused,
      accumulatedFocusedSeconds: totalFocused,
      remainingSeconds: rem,
      segmentStartEpochMs: () => null,
    );
    await _persist();
    await _ref.read(widgetSyncServiceProvider).syncFocusStatus('${_fmt(rem)} paused');
  }

  Future<void> resumeTimer() async {
    if (state.status != FocusTimerStatus.paused && state.status != FocusTimerStatus.idle) return;
    final feedback = _ref.read(feedbackServiceProvider);
    feedback.timerStart();

    state = state.copyWith(
      status: FocusTimerStatus.running,
      segmentStartEpochMs: () => DateTime.now().millisecondsSinceEpoch,
      sessionStartEpochMs: () => state.sessionStartEpochMs ?? DateTime.now().millisecondsSinceEpoch,
    );
    _startTicker();
    await _persist();
    await _ref.read(widgetSyncServiceProvider).syncFocusStatus('${_fmt(state.remainingSeconds)} running');
  }

  Future<void> takeBreak() async {
    if (state.status != FocusTimerStatus.running && state.status != FocusTimerStatus.paused) return;
    _ticker?.cancel();
    final feedback = _ref.read(feedbackServiceProvider);
    feedback.selectionClick();

    // Commit any active running segment before entering break
    final totalFocused = state.effectiveFocusedSeconds();
    final rem = (state.totalTargetSeconds - totalFocused).clamp(0, state.totalTargetSeconds);
    final now = DateTime.now().millisecondsSinceEpoch;

    state = state.copyWith(
      status: FocusTimerStatus.onBreak,
      accumulatedFocusedSeconds: totalFocused,
      remainingSeconds: rem,
      segmentStartEpochMs: () => null,
      breakStartEpochMs: () => now,
    );
    _startTicker();
    await _persist();
    await _ref.read(widgetSyncServiceProvider).syncFocusStatus('On break');
  }

  Future<void> resumeFromBreak() async {
    if (state.status != FocusTimerStatus.onBreak) return;
    _ticker?.cancel();
    final feedback = _ref.read(feedbackServiceProvider);
    feedback.timerStart();

    // Commit accumulated break seconds
    final totalBreak = state.effectiveBreakSeconds();
    final now = DateTime.now().millisecondsSinceEpoch;

    state = state.copyWith(
      status: FocusTimerStatus.running,
      accumulatedBreakSeconds: totalBreak,
      breakStartEpochMs: () => null,
      segmentStartEpochMs: () => now,
    );
    _startTicker();
    await _persist();
    await _ref.read(widgetSyncServiceProvider).syncFocusStatus('${_fmt(state.remainingSeconds)} running');
  }

  Future<void> togglePlayPause() async {
    if (state.status == FocusTimerStatus.running) {
      await pauseTimer();
    } else if (state.status == FocusTimerStatus.paused || state.status == FocusTimerStatus.idle) {
      await resumeTimer();
    } else if (state.status == FocusTimerStatus.onBreak) {
      await resumeFromBreak();
    }
  }

  Future<void> reset() async {
    _ticker?.cancel();
    _ref.read(feedbackServiceProvider).buttonTap();
    state = state.copyWith(
      status: FocusTimerStatus.idle,
      remainingSeconds: state.targetMinutes * 60,
      accumulatedFocusedSeconds: 0,
      accumulatedBreakSeconds: 0,
      segmentStartEpochMs: () => null,
      breakStartEpochMs: () => null,
      sessionStartEpochMs: () => null,
    );
    await _persist();
    await _ref.read(widgetSyncServiceProvider).syncFocusStatus(_fmt(state.remainingSeconds));
  }

  void clearLastSummary() {
    if (state.lastSummary != null) {
      state = state.copyWith(lastSummary: () => null);
    }
  }

  /// Completes session, records focused minutes, break minutes, and optional notes.
  Future<FocusCompletionSummary?> completeSession({
    bool autoCompleted = false,
    String? notes,
    String? taskId,
    String? projectId,
    String? skillId,
  }) async {
    if (_completing) return null;
    _completing = true;
    try {
      _ticker?.cancel();
      final activeSeconds = state.effectiveFocusedSeconds();
      final breakSeconds = state.effectiveBreakSeconds();

      final recordedMinutes = autoCompleted
          ? state.targetMinutes
          : (activeSeconds / 60).round().clamp(1, 1440);

      final breakMinutes = (breakSeconds / 60).floor().clamp(0, 720);

      final finalTaskId = taskId ?? state.linkedTaskId;
      final finalProjectId = projectId ?? state.linkedProjectId;
      final finalSkillId = skillId ?? state.linkedSkillId;
      final finalNotes = notes ?? state.sessionNotes;

      final repo = _ref.read(focusRepositoryProvider);
      await repo.recordFocusSession(
        taskId: finalTaskId,
        projectId: finalProjectId,
        skillId: finalSkillId,
        durationMinutes: recordedMinutes,
        breakMinutes: breakMinutes,
        sessionType: state.mode.name,
        notes: finalNotes,
      );

      await _ref.read(feedbackServiceProvider).timerComplete();
      if (autoCompleted) {
        final notifPrefs = _ref.read(notificationPreferencesProvider);
        if (notifPrefs.isCategoryEnabled('focus')) {
          await _ref
              .read(notificationServiceProvider)
              .showFocusCompletedNotification(durationMinutes: recordedMinutes);
        }
      }

      final summary = FocusCompletionSummary(
        recordedMinutes: recordedMinutes,
        breakMinutes: breakMinutes,
        modeLabel: state.mode.label,
        linkedTaskId: finalTaskId,
        linkedProjectId: finalProjectId,
        linkedSkillId: finalSkillId,
        notes: finalNotes,
        completedAt: DateTime.now(),
      );

      state = state.copyWith(
        status: FocusTimerStatus.idle,
        remainingSeconds: state.targetMinutes * 60,
        accumulatedFocusedSeconds: 0,
        accumulatedBreakSeconds: 0,
        segmentStartEpochMs: () => null,
        breakStartEpochMs: () => null,
        sessionStartEpochMs: () => null,
        lastSummary: () => summary,
      );
      await _persist();
      await _ref.read(widgetSyncServiceProvider).syncAllWidgets();
      return summary;
    } finally {
      _completing = false;
    }
  }

  static String _fmt(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final focusTimerProvider = StateNotifierProvider<FocusTimerNotifier, FocusTimerState>((ref) {
  return FocusTimerNotifier(ref);
});
