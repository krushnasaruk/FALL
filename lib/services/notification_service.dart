import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../data/database/app_database.dart';
import '../data/database/database_provider.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AppDatabase _db;
  bool _isInitialized = false;

  NotificationService(this._db);

  // Channels
  static const String channelTasksId = 'channel_tasks';
  static const String channelDeadlinesId = 'channel_deadlines';
  static const String channelDailyAgendaId = 'channel_daily_agenda';
  static const String channelDailySummaryId = 'channel_daily_summary';
  static const String channelHabitsId = 'channel_habits';

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
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
    _isInitialized = true;
  }

  Future<void> _createNotificationChannels() async {
    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            channelTasksId,
            'Task Reminders',
            description: 'Direct alerts for upcoming tasks and schedule triggers',
            importance: Importance.max,
          ),
        );

        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            channelDeadlinesId,
            'Upcoming Deadlines',
            description: 'Warnings for approaching task and project milestones',
            importance: Importance.high,
          ),
        );

        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            channelDailyAgendaId,
            'Morning Daily Agenda',
            description: 'Morning briefing of today’s priorities and tasks',
            importance: Importance.defaultImportance,
          ),
        );

        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            channelDailySummaryId,
            'Evening Daily Review',
            description: 'Evening summary of completed goals and streaks',
            importance: Importance.defaultImportance,
          ),
        );

        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            channelHabitsId,
            'Habits & Learning Reminders',
            description: 'Prompts for daily technical habits and skill development',
            importance: Importance.defaultImportance,
          ),
        );
      }
    }
  }

  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;

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

  void _onNotificationTapped(NotificationResponse response) async {
    final payload = response.payload;
    final actionId = response.actionId;
    if (actionId == 'ACTION_DONE' && payload != null) {
      // Mark task complete directly
      await (_db.update(_db.tasks)..where((t) => t.id.equals(payload))).write(
        TasksCompanion(
          isCompleted: const Value(true),
          completedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  int _generateNotificationId(String key) {
    return key.hashCode.abs() % 100000;
  }

  /// Schedule a task reminder at a specific DateTime
  Future<void> scheduleTaskReminder({
    required String taskId,
    required String title,
    required DateTime scheduledDate,
    String? body,
  }) async {
    if (scheduledDate.isBefore(DateTime.now())) return;

    final id = _generateNotificationId('task_$taskId');
    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    const androidDetails = AndroidNotificationDetails(
      channelTasksId,
      'Task Reminders',
      channelDescription: 'Direct alerts for upcoming tasks',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('ACTION_DONE', 'Mark Done'),
      ],
    );

    const details = NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        'Task Reminder: $title',
        body ?? 'Scheduled task reminder',
        tzScheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: taskId,
      );
    } catch (e) {
      // Fallback if exact alarm is restricted by system
      debugPrint('Could not schedule exact alarm: $e');
    }
  }

  /// Cancel reminder for a specific task
  Future<void> cancelTaskReminder(String taskId) async {
    final id = _generateNotificationId('task_$taskId');
    await _notificationsPlugin.cancel(id);
  }

  /// Schedule daily morning agenda briefing
  Future<void> scheduleDailyMorningAgenda({int hour = 8, int minute = 0}) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    const id = 99901;
    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      channelDailyAgendaId,
      'Morning Daily Agenda',
      channelDescription: 'Daily morning agenda briefing',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const details = NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        'Daily Agenda — ProgressOS',
        'Check your daily targets and planned tech roadmap for today!',
        tzTime,
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

  /// Schedule daily evening summary review
  Future<void> scheduleDailyEveningSummary({int hour = 21, int minute = 0}) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    const id = 99902;
    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      channelDailySummaryId,
      'Evening Daily Review',
      channelDescription: 'Daily evening recap and progress summary',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const details = NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        'Evening Wrap-up — ProgressOS',
        'Reflect on today’s completed milestones and keep your learning streak alive.',
        tzTime,
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
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final db = ref.watch(databaseProvider);
  return NotificationService(db);
});
