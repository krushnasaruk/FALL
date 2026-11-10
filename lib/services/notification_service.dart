import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../core/widgets/app_overlays.dart';
import '../data/database/app_database.dart';
import '../data/database/database_provider.dart';
import 'notification_preferences.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AppDatabase _db;
  bool _isInitialized = false;

  NotificationService(this._db);

  // Android Notification Channels
  static const String channelTasksId = 'channel_tasks';
  static const String channelDeadlinesId = 'channel_deadlines';
  static const String channelDailyAgendaId = 'channel_daily_agenda';
  static const String channelDailySummaryId = 'channel_daily_summary';
  static const String channelHabitsId = 'channel_habits';
  static const String channelFocusId = 'channel_focus';
  static const String channelMilestonesId = 'channel_milestones';

  static const _prefDailyAgenda = 'notif_daily_agenda_enabled';
  static const _prefDailySummary = 'notif_daily_summary_enabled';
  static const _prefSoundEnabled = 'feedback_notification_sounds_enabled';

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createNotificationChannels();
    await rescheduleStoredReminders();
    _isInitialized = true;
  }

  Future<bool> _isNotificationSoundEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_prefSoundEnabled) ?? true;
    } catch (_) {
      return true;
    }
  }

  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin == null) return;

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          channelTasksId,
          'Task Reminders',
          description: 'Direct alerts for upcoming tasks and reminders',
          importance: Importance.max,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          channelDeadlinesId,
          'Upcoming Deadlines',
          description: 'Warnings for approaching task and goal deadlines',
          importance: Importance.high,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          channelMilestonesId,
          'Project Milestones',
          description: 'Reminders for upcoming project milestone targets',
          importance: Importance.high,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          channelFocusId,
          'Focus Timer Alerts',
          description: 'Completion alerts for finished Pomodoro & deep work sessions',
          importance: Importance.high,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          channelDailyAgendaId,
          'Morning Daily Agenda',
          description: 'Morning briefing of today priorities and tasks',
          importance: Importance.defaultImportance,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          channelDailySummaryId,
          'Evening Daily Review',
          description: 'Evening summary of completed work and streaks',
          importance: Importance.defaultImportance,
        ),
      );

      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          channelHabitsId,
          'Habits & Learning Reminders',
          description: 'Prompts for daily technical habits and learning goals',
          importance: Importance.defaultImportance,
        ),
      );
    }
  }

  /// Checks if OS notification permission is granted without prompting.
  Future<bool> areNotificationsEnabled() async {
    if (!Platform.isAndroid) return true;
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await androidPlugin?.areNotificationsEnabled() ?? false;
  }

  /// Checks whether Android 12+ exact alarm scheduling is permitted.
  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await androidPlugin?.canScheduleExactNotifications() ?? false;
  }

  /// Presents a transparent rationale dialog BEFORE requesting Android 13+ notification permission.
  Future<bool> requestPermissionsWithExplanation(BuildContext context) async {
    final alreadyEnabled = await areNotificationsEnabled();
    if (alreadyEnabled) return true;
    if (!context.mounted) return false;

    final shouldAsk = await ConfirmationDialog.show(
      context,
      title: 'Enable Reminders & Alerts',
      message:
          'FALL sends local reminders only for scheduled tasks, deadlines, habits, and completed focus timers. Your data remains 100% offline.',
      confirmLabel: 'Continue',
      cancelLabel: 'Not Now',
      isDestructive: false,
    );
    if (!shouldAsk) return false;
    return requestPermissions();
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidPlugin?.requestNotificationsPermission() ?? false;
      return granted;
    } else if (Platform.isIOS) {
      final iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      return await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }
    return true;
  }

  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    return await androidPlugin?.requestExactAlarmsPermission() ?? false;
  }

  void _onNotificationTapped(NotificationResponse response) async {
    final payload = response.payload;
    final actionId = response.actionId;
    if (payload == null) return;

    if (actionId == 'ACTION_DONE') {
      await (_db.update(_db.tasks)..where((t) => t.id.equals(payload))).write(
        TasksCompanion(
          isCompleted: const Value(true),
          completedAt: Value(DateTime.now()),
        ),
      );
      await cancelTaskReminder(payload);
    } else if (actionId == 'ACTION_SNOOZE_15') {
      final task = await (_db.select(_db.tasks)..where((t) => t.id.equals(payload)))
          .getSingleOrNull();
      if (task != null && !task.isCompleted) {
        await scheduleTaskReminder(
          taskId: task.id,
          title: task.title,
          scheduledDate: DateTime.now().add(const Duration(minutes: 15)),
          body: 'Snoozed reminder (15m)',
        );
      }
    }
  }

  int _generateNotificationId(String key) {
    return (key.hashCode.abs() % 90000) + 1000;
  }

  Future<NotificationPreferences> _loadPreferences() async {
    try {
      final p = await SharedPreferences.getInstance();
      return NotificationPreferences(
        tasksEnabled: p.getBool('notif_cat_tasks') ?? true,
        habitsEnabled: p.getBool('notif_cat_habits') ?? true,
        learningEnabled: p.getBool('notif_cat_learning') ?? true,
        goalsEnabled: p.getBool('notif_cat_goals') ?? true,
        milestonesEnabled: p.getBool('notif_cat_milestones') ?? true,
        focusEnabled: p.getBool('notif_cat_focus') ?? true,
        dailyAgendaEnabled: p.getBool(_prefDailyAgenda) ?? true,
        dailySummaryEnabled: p.getBool(_prefDailySummary) ?? true,
        quietHoursEnabled: p.getBool('notif_quiet_hours_enabled') ?? true,
        quietStartMinutes: p.getInt('notif_quiet_start_mins') ?? (22 * 60),
        quietEndMinutes: p.getInt('notif_quiet_end_mins') ?? (7 * 60 + 30),
      );
    } catch (_) {
      return const NotificationPreferences();
    }
  }

  /// Schedules or replaces a task reminder, persisting record in ScheduledNotifications
  /// so reboot/startup rescheduling remains consistent and deduplicated.
  /// Respects task notification toggle and configured Quiet Hours.
  Future<void> scheduleTaskReminder({
    required String taskId,
    required String title,
    required DateTime scheduledDate,
    String? body,
  }) async {
    if (scheduledDate.isBefore(DateTime.now())) return;
    final prefs = await _loadPreferences();
    if (!prefs.tasksEnabled) return;

    final effectiveDate = prefs.adjustForQuietHours(scheduledDate);

    final id = _generateNotificationId('task_$taskId');
    await _safeCancel(id);

    // Replace existing DB record for deduplication
    await (_db.delete(_db.scheduledNotifications)
          ..where((n) => n.taskId.equals(taskId) & n.type.equals('task_reminder')))
        .go();

    await _db.into(_db.scheduledNotifications).insert(
          ScheduledNotificationsCompanion(
            taskId: Value(taskId),
            type: const Value('task_reminder'),
            scheduledTime: Value(effectiveDate),
            payload: Value(title),
          ),
        );

    final playSound = await _isNotificationSoundEnabled();
    final exactAllowed = await canScheduleExactAlarms();
    final tzScheduledDate = tz.TZDateTime.from(effectiveDate, tz.local);

    final androidDetails = AndroidNotificationDetails(
      channelTasksId,
      'Task Reminders',
      channelDescription: 'Direct alerts for upcoming tasks',
      importance: Importance.max,
      priority: Priority.high,
      playSound: playSound,
      actions: const <AndroidNotificationAction>[
        AndroidNotificationAction('ACTION_DONE', 'Mark Done'),
        AndroidNotificationAction('ACTION_SNOOZE_15', 'Snooze 15m'),
      ],
    );

    final details = NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        'Time for your $title task',
        body ?? 'Your planned task is ready when you are.',
        tzScheduledDate,
        details,
        androidScheduleMode: exactAllowed
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: taskId,
      );
    } catch (e) {
      debugPrint('Could not schedule task reminder ($exactAllowed): $e');
    }
  }

  Future<void> _safeCancel(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      debugPrint('Notification cancel skipped ($id): $e');
    }
  }

  /// Cancels any scheduled reminder for a task and clears its persistence record.
  Future<void> cancelTaskReminder(String taskId) async {
    final id = _generateNotificationId('task_$taskId');
    await _safeCancel(id);
    await (_db.delete(_db.scheduledNotifications)
          ..where((n) => n.taskId.equals(taskId) & n.type.equals('task_reminder')))
        .go();
  }

  /// Re-schedules future reminders from Drift SQLite table after app launch or reboot.
  Future<void> rescheduleStoredReminders() async {
    try {
      final now = DateTime.now();
      final pending = await (_db.select(_db.scheduledNotifications)).get();
      for (final item in pending) {
        if (item.scheduledTime.isBefore(now)) {
          await (_db.delete(_db.scheduledNotifications)..where((n) => n.id.equals(item.id))).go();
          continue;
        }
        if (item.taskId != null && item.type == 'task_reminder') {
          final id = _generateNotificationId('task_${item.taskId!}');
          final playSound = await _isNotificationSoundEnabled();
          final exactAllowed = await canScheduleExactAlarms();
          final details = NotificationDetails(
            android: AndroidNotificationDetails(
              channelTasksId,
              'Task Reminders',
              importance: Importance.max,
              priority: Priority.high,
              playSound: playSound,
              actions: const <AndroidNotificationAction>[
                AndroidNotificationAction('ACTION_DONE', 'Mark Done'),
                AndroidNotificationAction('ACTION_SNOOZE_15', 'Snooze 15m'),
              ],
            ),
          );
          await _notificationsPlugin.zonedSchedule(
            id,
            'Task Reminder: ${item.payload}',
            'Scheduled in FALL',
            tz.TZDateTime.from(item.scheduledTime, tz.local),
            details,
            androidScheduleMode: exactAllowed
                ? AndroidScheduleMode.exactAllowWhileIdle
                : AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: item.taskId,
          );
        }
      }
    } catch (e) {
      debugPrint('Error rescheduling reminders: $e');
    }
  }

  /// Daily Habit or Goal reminder at custom HH:mm time.
  Future<void> scheduleHabitReminder({
    required String habitId,
    required String title,
    required int hour,
    required int minute,
  }) async {
    final prefs = await _loadPreferences();
    if (!prefs.habitsEnabled) return;

    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, hour, minute);
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));
    target = prefs.adjustForQuietHours(target);

    final id = _generateNotificationId('habit_$habitId');
    final playSound = await _isNotificationSoundEnabled();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelHabitsId,
        'Habits & Learning Reminders',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: playSound,
      ),
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        'A small check-in?',
        'Your scheduled $title habit is ready.',
        tz.TZDateTime.from(target, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: habitId,
      );
    } catch (e) {
      debugPrint('Error scheduling habit reminder: $e');
    }
  }

  Future<void> cancelHabitReminder(String habitId) async {
    await _safeCancel(_generateNotificationId('habit_$habitId'));
  }

  /// Daily morning agenda briefing
  Future<void> scheduleDailyMorningAgenda({int hour = 8, int minute = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefDailyAgenda, true);

    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    const id = 99901;
    final playSound = await _isNotificationSoundEnabled();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelDailyAgendaId,
        'Morning Daily Agenda',
        channelDescription: 'Daily morning agenda briefing',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: playSound,
      ),
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        'Daily Agenda — FALL',
        'Review today priorities, milestones, and focus targets.',
        tz.TZDateTime.from(scheduledTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('Error scheduling daily agenda: $e');
    }
  }

  Future<void> cancelDailyMorningAgenda() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefDailyAgenda, false);
    await _safeCancel(99901);
  }

  /// Daily evening wrap-up review
  Future<void> scheduleDailyEveningSummary({int hour = 21, int minute = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefDailySummary, true);

    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    const id = 99902;
    final playSound = await _isNotificationSoundEnabled();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelDailySummaryId,
        'Evening Daily Review',
        channelDescription: 'Daily evening recap and progress summary',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: playSound,
      ),
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        'Evening Review — FALL',
        'Check off remaining tasks and record today progress.',
        tz.TZDateTime.from(scheduledTime, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('Error scheduling daily summary: $e');
    }
  }

  Future<void> cancelDailyEveningSummary() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefDailySummary, false);
    await _safeCancel(99902);
  }

  /// Cancels all scheduled reminders and wipes stored notification schedules.
  Future<void> cancelAllReminders() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('Error cancelling local notifications: $e');
    }
    try {
      await _db.delete(_db.scheduledNotifications).go();
    } catch (e) {
      debugPrint('Error clearing scheduledNotifications table: $e');
    }
  }

  /// Focus timer completion notification
  Future<void> showFocusCompletedNotification({required int durationMinutes}) async {
    final prefs = await _loadPreferences();
    if (!prefs.focusEnabled || prefs.isWithinQuietHours(DateTime.now())) return;
    await showImmediateNotification(
      title: 'Focus session complete',
      body: 'Your $durationMinutes-minute session has finished.',
      channelId: channelFocusId,
      channelName: 'Focus Timer Alerts',
    );
  }

  /// Immediate notification (test trigger or focus finish alert)
  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String channelId = channelTasksId,
    String channelName = 'Task Reminders',
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch % 100000;
    final playSound = await _isNotificationSoundEnabled();
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Direct alerts and schedule triggers',
      importance: Importance.max,
      priority: Priority.high,
      playSound: playSound,
    );
    final details = NotificationDetails(android: androidDetails);
    try {
      await _notificationsPlugin.show(id, title, body, details);
    } catch (e) {
      debugPrint('Error showing immediate notification: $e');
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final db = ref.watch(databaseProvider);
  return NotificationService(db);
});
