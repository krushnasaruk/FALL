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

class FocusCompletionSummary {
  final int recordedMinutes;
  final String modeLabel;
  final String? linkedTaskId;
  final String? linkedProjectId;
  final DateTime completedAt;

  const FocusCompletionSummary({
    required this.recordedMinutes,
    required this.modeLabel,
    this.linkedTaskId,
    this.linkedProjectId,
    required this.completedAt,
  });
}

class FocusTimerState {
  final FocusTimerMode mode;
  final int targetMinutes;
  final int remainingSeconds;
  final int accumulatedFocusedSeconds;
  final int? segmentStartEpochMs;
  final bool isRunning;
  final String? linkedTaskId;
  final String? linkedProjectId;
  final FocusCompletionSummary? lastSummary;

  const FocusTimerState({
    this.mode = FocusTimerMode.pomodoro,
    this.targetMinutes = 25,
    this.remainingSeconds = 25 * 60,
    this.accumulatedFocusedSeconds = 0,
    this.segmentStartEpochMs,
    this.isRunning = false,
    this.linkedTaskId,
    this.linkedProjectId,
    this.lastSummary,
  });

  int get totalTargetSeconds => targetMinutes * 60;

  double get progress {
    if (totalTargetSeconds <= 0) return 0.0;
    return (1.0 - (remainingSeconds / totalTargetSeconds)).clamp(0.0, 1.0);
  }

  /// Active focused seconds including the current running slice (never includes paused time).
  int effectiveFocusedSeconds({DateTime? now}) {
    if (!isRunning || segmentStartEpochMs == null) return accumulatedFocusedSeconds;
    final currentMs = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final slice = ((currentMs - segmentStartEpochMs!) / 1000).floor().clamp(0, totalTargetSeconds);
    return (accumulatedFocusedSeconds + slice).clamp(0, totalTargetSeconds);
  }

  FocusTimerState copyWith({
    FocusTimerMode? mode,
    int? targetMinutes,
    int? remainingSeconds,
    int? accumulatedFocusedSeconds,
    int? Function()? segmentStartEpochMs,
    bool? isRunning,
    String? Function()? linkedTaskId,
    String? Function()? linkedProjectId,
    FocusCompletionSummary? Function()? lastSummary,
  }) {
    return FocusTimerState(
      mode: mode ?? this.mode,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      accumulatedFocusedSeconds: accumulatedFocusedSeconds ?? this.accumulatedFocusedSeconds,
      segmentStartEpochMs: segmentStartEpochMs != null ? segmentStartEpochMs() : this.segmentStartEpochMs,
      isRunning: isRunning ?? this.isRunning,
      linkedTaskId: linkedTaskId != null ? linkedTaskId() : this.linkedTaskId,
      linkedProjectId: linkedProjectId != null ? linkedProjectId() : this.linkedProjectId,
      lastSummary: lastSummary != null ? lastSummary() : this.lastSummary,
    );
  }
}

/// Persistent wall-clock Focus Timer state manager.
/// Maintains accurate elapsed focus duration across route exits and Android backgrounding,
/// strictly excluding paused intervals from focused time calculations.
class FocusTimerNotifier extends StateNotifier<FocusTimerState> {
  static const _kMode = 'focus_timer_mode_v1';
  static const _kTargetMins = 'focus_timer_target_mins_v1';
  static const _kAccFocused = 'focus_timer_acc_focused_v1';
  static const _kSegStart = 'focus_timer_seg_start_v1';
  static const _kRunning = 'focus_timer_running_v1';
  static const _kTaskId = 'focus_timer_task_id_v1';
  static const _kProjId = 'focus_timer_proj_id_v1';

  final Ref _ref;
  Timer? _ticker;
  bool _completing = false;

  FocusTimerNotifier(this._ref) : super(const FocusTimerState()) {
    _restoreFromStorage();
  }

  Future<void> _restoreFromStorage() async {
    try {
      final p = await SharedPreferences.getInstance();
      final modeName = p.getString(_kMode);
      final mode = FocusTimerMode.values.firstWhere(
        (m) => m.name == modeName,
        orElse: () => FocusTimerMode.pomodoro,
      );
      final targetMins = p.getInt(_kTargetMins) ?? mode.defaultMinutes;
      final accFocused = p.getInt(_kAccFocused) ?? 0;
      final segStart = p.getInt(_kSegStart);
      final isRunning = p.getBool(_kRunning) ?? false;
      final taskId = p.getString(_kTaskId);
      final projId = p.getString(_kProjId);

      final totalSecs = targetMins * 60;
      int remaining = (totalSecs - accFocused).clamp(0, totalSecs);
      if (isRunning && segStart != null) {
        final elapsedSlice = ((DateTime.now().millisecondsSinceEpoch - segStart) / 1000).floor();
        final effectiveFocused = (accFocused + elapsedSlice).clamp(0, totalSecs);
        remaining = (totalSecs - effectiveFocused).clamp(0, totalSecs);
      }

      state = FocusTimerState(
        mode: mode,
        targetMinutes: targetMins,
        remainingSeconds: remaining,
        accumulatedFocusedSeconds: accFocused,
        segmentStartEpochMs: isRunning ? segStart : null,
        isRunning: isRunning && remaining > 0,
        linkedTaskId: taskId,
        linkedProjectId: projId,
      );

      if (isRunning && remaining <= 0) {
        await completeSession(autoCompleted: true);
      } else if (state.isRunning) {
        _startTicker();
      }
    } catch (_) {
      // Safe default in isolated tests
    }
  }

  Future<void> _persist() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_kMode, state.mode.name);
      await p.setInt(_kTargetMins, state.targetMinutes);
      await p.setInt(_kAccFocused, state.accumulatedFocusedSeconds);
      if (state.segmentStartEpochMs != null) {
        await p.setInt(_kSegStart, state.segmentStartEpochMs!);
      } else {
        await p.remove(_kSegStart);
      }
      await p.setBool(_kRunning, state.isRunning);
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
    } catch (_) {}
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => syncWithClock());
  }

  /// Synchronizes remaining & active focus time against wall-clock time.
  /// Call when app resumes from background so timer never drifts.
  void syncWithClock() {
    if (!state.isRunning || state.segmentStartEpochMs == null) return;
    final total = state.totalTargetSeconds;
    final effectiveFocused = state.effectiveFocusedSeconds();
    final rem = (total - effectiveFocused).clamp(0, total);
    if (rem != state.remainingSeconds) {
      state = state.copyWith(remainingSeconds: rem);
    }
    if (rem <= 0 && !_completing) {
      completeSession(autoCompleted: true);
    }
  }

  Future<void> switchMode(FocusTimerMode mode, {int? customMinutes}) async {
    _ticker?.cancel();
    final mins = customMinutes ?? mode.defaultMinutes;
    _ref.read(feedbackServiceProvider).selectionClick();
    state = state.copyWith(
      mode: mode,
      targetMinutes: mins,
      remainingSeconds: mins * 60,
      accumulatedFocusedSeconds: 0,
      segmentStartEpochMs: () => null,
      isRunning: false,
    );
    await _persist();
    await _ref.read(widgetSyncServiceProvider).syncFocusStatus('${_fmt(state.remainingSeconds)} ready');
  }

  Future<void> setLinkedTargets({String? taskId, String? projectId}) async {
    state = state.copyWith(
      linkedTaskId: () => taskId,
      linkedProjectId: () => projectId,
    );
    await _persist();
  }

  Future<void> togglePlayPause() async {
    final feedback = _ref.read(feedbackServiceProvider);
    if (state.isRunning) {
      _ticker?.cancel();
      // Commit active segment elapsed seconds before pausing; paused interval won't accumulate!
      final totalFocused = state.effectiveFocusedSeconds();
      final rem = (state.totalTargetSeconds - totalFocused).clamp(0, state.totalTargetSeconds);
      feedback.buttonTap();
      state = state.copyWith(
        accumulatedFocusedSeconds: totalFocused,
        remainingSeconds: rem,
        segmentStartEpochMs: () => null,
        isRunning: false,
      );
      await _persist();
      await _ref.read(widgetSyncServiceProvider).syncFocusStatus('${_fmt(rem)} paused');
    } else {
      feedback.timerStart();
      state = state.copyWith(
        segmentStartEpochMs: () => DateTime.now().millisecondsSinceEpoch,
        isRunning: true,
        lastSummary: () => null,
      );
      _startTicker();
      await _persist();
      await _ref.read(widgetSyncServiceProvider).syncFocusStatus('${_fmt(state.remainingSeconds)} running');
    }
  }

  Future<void> reset() async {
    _ticker?.cancel();
    _ref.read(feedbackServiceProvider).buttonTap();
    state = state.copyWith(
      remainingSeconds: state.targetMinutes * 60,
      accumulatedFocusedSeconds: 0,
      segmentStartEpochMs: () => null,
      isRunning: false,
    );
    await _persist();
    await _ref.read(widgetSyncServiceProvider).syncFocusStatus(_fmt(state.remainingSeconds));
  }

  void clearLastSummary() {
    if (state.lastSummary != null) {
      state = state.copyWith(lastSummary: () => null);
    }
  }

  /// Stops and records focused minutes strictly from accumulated active seconds (excluding pause).
  Future<FocusCompletionSummary?> completeSession({bool autoCompleted = false}) async {
    if (_completing) return null;
    _completing = true;
    try {
      _ticker?.cancel();
      final activeSeconds = state.effectiveFocusedSeconds();
      final recordedMinutes = autoCompleted
          ? state.targetMinutes
          : (activeSeconds / 60).floor().clamp(1, state.targetMinutes);

      final repo = _ref.read(focusRepositoryProvider);
      await repo.recordFocusSession(
        taskId: state.linkedTaskId,
        projectId: state.linkedProjectId,
        durationMinutes: recordedMinutes,
        sessionType: state.mode.name,
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
        modeLabel: state.mode.label,
        linkedTaskId: state.linkedTaskId,
        linkedProjectId: state.linkedProjectId,
        completedAt: DateTime.now(),
      );

      state = state.copyWith(
        remainingSeconds: state.targetMinutes * 60,
        accumulatedFocusedSeconds: 0,
        segmentStartEpochMs: () => null,
        isRunning: false,
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

