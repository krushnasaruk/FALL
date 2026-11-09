import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/core/utils/recurrence_util.dart';

void main() {
  group('RecurrenceUtil Tests', () {
    test('daily recurrence advances to future', () {
      final base = DateTime.now().subtract(const Duration(days: 2));
      final next = RecurrenceUtil.getNextDueDate(base, 'daily');
      expect(next, isNotNull);
      expect(next!.isAfter(DateTime.now()), isTrue);
    });

    test('weekly recurrence advances by 7 days', () {
      final base = DateTime.now().subtract(const Duration(days: 10));
      final next = RecurrenceUtil.getNextDueDate(base, 'weekly');
      expect(next, isNotNull);
      expect(next!.isAfter(DateTime.now()), isTrue);
    });

    test('weekdays recurrence skips weekends', () {
      final base = DateTime(2026, 11, 13, 10, 0); // Friday
      final next = RecurrenceUtil.getNextDueDate(base, 'weekdays');
      expect(next, isNotNull);
      expect(next!.weekday, isNot(DateTime.saturday));
      expect(next.weekday, isNot(DateTime.sunday));
    });

    test('none recurrence returns null', () {
      final base = DateTime.now();
      final next = RecurrenceUtil.getNextDueDate(base, 'none');
      expect(next, isNull);
    });
  });
}

