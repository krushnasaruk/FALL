class RecurrenceUtil {
  RecurrenceUtil._();

  /// Calculates the next due date for a recurring task based on current due date and recurrence pattern.
  static DateTime? getNextDueDate(DateTime currentDueDate, String recurrence) {
    final lower = recurrence.toLowerCase().trim();
    if (lower == 'none' || lower.isEmpty) return null;

    final now = DateTime.now();
    var next = currentDueDate;

    switch (lower) {
      case 'daily':
        next = next.add(const Duration(days: 1));
        // If it was overdue by more than 1 day, advance to the future
        while (next.isBefore(now)) {
          next = next.add(const Duration(days: 1));
        }
        return next;

      case 'weekly':
        next = next.add(const Duration(days: 7));
        while (next.isBefore(now)) {
          next = next.add(const Duration(days: 7));
        }
        return next;

      case 'monthly':
        int nextMonth = next.month + 1;
        int nextYear = next.year;
        if (nextMonth > 12) {
          nextMonth = 1;
          nextYear += 1;
        }
        // Ensure day fits in the month (e.g. handle Feb 28/29, 30-day months)
        final daysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        final day = next.day > daysInNextMonth ? daysInNextMonth : next.day;
        next = DateTime(nextYear, nextMonth, day, next.hour, next.minute, next.second);
        while (next.isBefore(now)) {
          nextMonth = next.month + 1;
          nextYear = next.year;
          if (nextMonth > 12) {
            nextMonth = 1;
            nextYear += 1;
          }
          final dim = DateTime(nextYear, nextMonth + 1, 0).day;
          final d = next.day > dim ? dim : next.day;
          next = DateTime(nextYear, nextMonth, d, next.hour, next.minute, next.second);
        }
        return next;

      case 'weekdays':
        // Monday (1) to Friday (5)
        next = next.add(const Duration(days: 1));
        while (next.weekday == DateTime.saturday || next.weekday == DateTime.sunday || next.isBefore(now)) {
          next = next.add(const Duration(days: 1));
        }
        return next;

      default:
        return null;
    }
  }
}

