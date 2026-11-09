import 'package:intl/intl.dart';

class DateFormatters {
  DateFormatters._();

  static final DateFormat _dayOfWeekMonthDay = DateFormat('EEEE, MMM d');
  static final DateFormat _monthDayYear = DateFormat('MMM d, y');
  static final DateFormat _monthDay = DateFormat('MMM d');
  static final DateFormat _timeOnly = DateFormat('h:mm a');
  static final DateFormat _dateTimeShort = DateFormat('MMM d, h:mm a');
  static final DateFormat _isoDateOnly = DateFormat('yyyy-MM-dd');

  static String dayOfWeekMonthDay(DateTime dt) => _dayOfWeekMonthDay.format(dt);
  static String monthDayYear(DateTime dt) => _monthDayYear.format(dt);
  static String monthDay(DateTime dt) => _monthDay.format(dt);
  static String timeOnly(DateTime dt) => _timeOnly.format(dt);
  static String dateTimeShort(DateTime dt) => _dateTimeShort.format(dt);
  static String isoDateOnly(DateTime dt) => _isoDateOnly.format(dt);

  /// Returns a clean human-readable relative label: "Today", "Tomorrow", "Yesterday", or "Oct 24"
  static String relativeDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dt.year, dt.month, dt.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff > 1 && diff < 7) {
      return DateFormat('EEEE').format(dt); // e.g. "Thursday"
    }
    return _monthDay.format(dt);
  }

  /// Format minutes into "2h 45m" or "35m"
  static String formatMinutes(int totalMinutes) {
    if (totalMinutes <= 0) return '0m';
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (hours > 0 && mins > 0) {
      return '${hours}h ${mins}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${mins}m';
    }
  }

  /// Get time of day greeting
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
}

