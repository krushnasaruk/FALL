import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted granular Notification Category toggles and Quiet Hours window.
class NotificationPreferences {
  final bool tasksEnabled;
  final bool habitsEnabled;
  final bool learningEnabled;
  final bool goalsEnabled;
  final bool milestonesEnabled;
  final bool focusEnabled;
  final bool dailyAgendaEnabled;
  final bool dailySummaryEnabled;
  final bool quietHoursEnabled;
  final int quietStartMinutes; // Minutes since midnight, e.g. 22*60 = 1320
  final int quietEndMinutes;   // Minutes since midnight, e.g. 7*60+30 = 450

  const NotificationPreferences({
    this.tasksEnabled = true,
    this.habitsEnabled = true,
    this.learningEnabled = true,
    this.goalsEnabled = true,
    this.milestonesEnabled = true,
    this.focusEnabled = true,
    this.dailyAgendaEnabled = true,
    this.dailySummaryEnabled = true,
    this.quietHoursEnabled = true,
    this.quietStartMinutes = 22 * 60,
    this.quietEndMinutes = 7 * 60 + 30,
  });

  TimeOfDay get quietStart => TimeOfDay(
        hour: quietStartMinutes ~/ 60,
        minute: quietStartMinutes % 60,
      );

  TimeOfDay get quietEnd => TimeOfDay(
        hour: quietEndMinutes ~/ 60,
        minute: quietEndMinutes % 60,
      );

  bool isCategoryEnabled(String category) {
    switch (category) {
      case 'tasks':
        return tasksEnabled;
      case 'habits':
        return habitsEnabled;
      case 'learning':
        return learningEnabled;
      case 'goals':
        return goalsEnabled;
      case 'milestones':
        return milestonesEnabled;
      case 'focus':
        return focusEnabled;
      case 'daily_agenda':
        return dailyAgendaEnabled;
      case 'daily_summary':
        return dailySummaryEnabled;
      default:
        return true;
    }
  }

  /// Checks whether [dateTime] falls inside configured Quiet Hours (supports overnight wrap).
  bool isWithinQuietHours(DateTime dateTime) {
    if (!quietHoursEnabled) return false;
    final mins = dateTime.hour * 60 + dateTime.minute;
    if (quietStartMinutes == quietEndMinutes) return false;
    if (quietStartMinutes < quietEndMinutes) {
      return mins >= quietStartMinutes && mins < quietEndMinutes;
    }
    // Wrap overnight (e.g. 22:00 -> 07:30)
    return mins >= quietStartMinutes || mins < quietEndMinutes;
  }

  /// If [scheduled] falls within quiet hours, shifts cleanly to end of quiet hours so
  /// important reminders remain helpful without waking the user at night.
  DateTime adjustForQuietHours(DateTime scheduled) {
    if (!isWithinQuietHours(scheduled)) return scheduled;
    final endHour = quietEndMinutes ~/ 60;
    final endMinute = quietEndMinutes % 60;
    var candidate = DateTime(
      scheduled.year,
      scheduled.month,
      scheduled.day,
      endHour,
      endMinute,
    );
    if (!candidate.isAfter(scheduled)) {
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate;
  }

  NotificationPreferences copyWith({
    bool? tasksEnabled,
    bool? habitsEnabled,
    bool? learningEnabled,
    bool? goalsEnabled,
    bool? milestonesEnabled,
    bool? focusEnabled,
    bool? dailyAgendaEnabled,
    bool? dailySummaryEnabled,
    bool? quietHoursEnabled,
    int? quietStartMinutes,
    int? quietEndMinutes,
  }) {
    return NotificationPreferences(
      tasksEnabled: tasksEnabled ?? this.tasksEnabled,
      habitsEnabled: habitsEnabled ?? this.habitsEnabled,
      learningEnabled: learningEnabled ?? this.learningEnabled,
      goalsEnabled: goalsEnabled ?? this.goalsEnabled,
      milestonesEnabled: milestonesEnabled ?? this.milestonesEnabled,
      focusEnabled: focusEnabled ?? this.focusEnabled,
      dailyAgendaEnabled: dailyAgendaEnabled ?? this.dailyAgendaEnabled,
      dailySummaryEnabled: dailySummaryEnabled ?? this.dailySummaryEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietStartMinutes: quietStartMinutes ?? this.quietStartMinutes,
      quietEndMinutes: quietEndMinutes ?? this.quietEndMinutes,
    );
  }
}

class NotificationPreferencesNotifier extends StateNotifier<NotificationPreferences> {
  static const _kTasks = 'notif_cat_tasks';
  static const _kHabits = 'notif_cat_habits';
  static const _kLearning = 'notif_cat_learning';
  static const _kGoals = 'notif_cat_goals';
  static const _kMilestones = 'notif_cat_milestones';
  static const _kFocus = 'notif_cat_focus';
  static const _kAgenda = 'notif_daily_agenda_enabled';
  static const _kSummary = 'notif_daily_summary_enabled';
  static const _kQuietEnabled = 'notif_quiet_hours_enabled';
  static const _kQuietStart = 'notif_quiet_start_mins';
  static const _kQuietEnd = 'notif_quiet_end_mins';

  NotificationPreferencesNotifier() : super(const NotificationPreferences()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await SharedPreferences.getInstance();
      state = NotificationPreferences(
        tasksEnabled: p.getBool(_kTasks) ?? true,
        habitsEnabled: p.getBool(_kHabits) ?? true,
        learningEnabled: p.getBool(_kLearning) ?? true,
        goalsEnabled: p.getBool(_kGoals) ?? true,
        milestonesEnabled: p.getBool(_kMilestones) ?? true,
        focusEnabled: p.getBool(_kFocus) ?? true,
        dailyAgendaEnabled: p.getBool(_kAgenda) ?? true,
        dailySummaryEnabled: p.getBool(_kSummary) ?? true,
        quietHoursEnabled: p.getBool(_kQuietEnabled) ?? true,
        quietStartMinutes: p.getInt(_kQuietStart) ?? (22 * 60),
        quietEndMinutes: p.getInt(_kQuietEnd) ?? (7 * 60 + 30),
      );
    } catch (_) {}
  }

  Future<void> setCategory(String category, bool enabled) async {
    final p = await SharedPreferences.getInstance();
    switch (category) {
      case 'tasks':
        state = state.copyWith(tasksEnabled: enabled);
        await p.setBool(_kTasks, enabled);
        break;
      case 'habits':
        state = state.copyWith(habitsEnabled: enabled);
        await p.setBool(_kHabits, enabled);
        break;
      case 'learning':
        state = state.copyWith(learningEnabled: enabled);
        await p.setBool(_kLearning, enabled);
        break;
      case 'goals':
        state = state.copyWith(goalsEnabled: enabled);
        await p.setBool(_kGoals, enabled);
        break;
      case 'milestones':
        state = state.copyWith(milestonesEnabled: enabled);
        await p.setBool(_kMilestones, enabled);
        break;
      case 'focus':
        state = state.copyWith(focusEnabled: enabled);
        await p.setBool(_kFocus, enabled);
        break;
      case 'daily_agenda':
        state = state.copyWith(dailyAgendaEnabled: enabled);
        await p.setBool(_kAgenda, enabled);
        break;
      case 'daily_summary':
        state = state.copyWith(dailySummaryEnabled: enabled);
        await p.setBool(_kSummary, enabled);
        break;
    }
  }

  Future<void> setQuietHoursEnabled(bool enabled) async {
    state = state.copyWith(quietHoursEnabled: enabled);
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kQuietEnabled, enabled);
  }

  Future<void> setQuietWindow(TimeOfDay start, TimeOfDay end) async {
    final s = start.hour * 60 + start.minute;
    final e = end.hour * 60 + end.minute;
    state = state.copyWith(quietStartMinutes: s, quietEndMinutes: e);
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kQuietStart, s);
    await p.setInt(_kQuietEnd, e);
  }
}

final notificationPreferencesProvider =
    StateNotifierProvider<NotificationPreferencesNotifier, NotificationPreferences>((ref) {
  return NotificationPreferencesNotifier();
});

