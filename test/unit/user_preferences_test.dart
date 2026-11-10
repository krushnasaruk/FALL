import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_os/data/repositories/user_preferences_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('UserPreferencesNotifier Tests', () {
    test('Initial state provides default display name and enabled sections', () {
      final notifier = UserPreferencesNotifier();
      expect(notifier.state.displayName, 'Developer');
      expect(notifier.state.dashboardSections.length, 6);
      expect(notifier.state.isSectionVisible('hero_projects'), isTrue);
      expect(notifier.state.isSectionVisible('quick_actions'), isTrue);
      expect(notifier.state.isTipDismissed('first_project'), isFalse);
    });

    test('dismissTip and markOnboardingCompleted persist state cleanly', () async {
      final notifier = UserPreferencesNotifier();
      await notifier.dismissTip('first_project');
      expect(notifier.state.isTipDismissed('first_project'), isTrue);

      await notifier.markOnboardingCompleted();
      expect(notifier.state.onboardingCompleted, isTrue);

      await notifier.resetAllTips();
      expect(notifier.state.isTipDismissed('first_project'), isFalse);
    });

    test('updateDisplayName changes state and persists', () async {
      final notifier = UserPreferencesNotifier();
      await notifier.updateDisplayName('Ada Lovelace');
      expect(notifier.state.displayName, 'Ada Lovelace');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_display_name'), 'Ada Lovelace');
    });

    test('toggleSectionVisibility hides and restores sections', () async {
      final notifier = UserPreferencesNotifier();
      await notifier.toggleSectionVisibility('quick_actions', false);
      expect(notifier.state.isSectionVisible('quick_actions'), isFalse);
      expect(notifier.state.isSectionVisible('hero_projects'), isTrue);

      await notifier.toggleSectionVisibility('quick_actions', true);
      expect(notifier.state.isSectionVisible('quick_actions'), isTrue);
    });

    test('resetDashboardSections restores all sections to visible', () async {
      final notifier = UserPreferencesNotifier();
      await notifier.toggleSectionVisibility('ongoing_projects', false);
      expect(notifier.state.isSectionVisible('ongoing_projects'), isFalse);

      await notifier.resetDashboardSections();
      expect(notifier.state.isSectionVisible('ongoing_projects'), isTrue);
    });
  });
}
