import 'package:flutter_test/flutter_test.dart';
import 'package:progress_os/core/utils/date_formatters.dart';

void main() {
  group('DateFormatters Tests', () {
    test('formatMinutes displays hours and minutes correctly', () {
      expect(DateFormatters.formatMinutes(0), '0m');
      expect(DateFormatters.formatMinutes(45), '45m');
      expect(DateFormatters.formatMinutes(60), '1h');
      expect(DateFormatters.formatMinutes(125), '2h 5m');
    });

    test('relativeDate handles today and tomorrow', () {
      final now = DateTime.now();
      expect(DateFormatters.relativeDate(now), 'Today');
      expect(DateFormatters.relativeDate(now.add(const Duration(days: 1))), 'Tomorrow');
    });

    test('getGreeting returns valid string based on hour', () {
      final greeting = DateFormatters.getGreeting();
      expect(
        greeting == 'Good morning' || greeting == 'Good afternoon' || greeting == 'Good evening',
        isTrue,
      );
    });
  });
}

