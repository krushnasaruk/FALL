import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardSectionConfig {
  final String id;
  final String label;
  final bool isVisible;

  const DashboardSectionConfig({
    required this.id,
    required this.label,
    required this.isVisible,
  });

  DashboardSectionConfig copyWith({bool? isVisible}) {
    return DashboardSectionConfig(
      id: id,
      label: label,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class UserPreferencesState {
  final String displayName;
  final List<DashboardSectionConfig> dashboardSections;
  final bool onboardingCompleted;
  final Set<String> dismissedTips;

  const UserPreferencesState({
    required this.displayName,
    required this.dashboardSections,
    this.onboardingCompleted = false,
    this.dismissedTips = const {},
  });

  bool isSectionVisible(String sectionId) {
    final s = dashboardSections.firstWhere(
      (element) => element.id == sectionId,
      orElse: () => DashboardSectionConfig(id: sectionId, label: '', isVisible: true),
    );
    return s.isVisible;
  }

  bool isTipDismissed(String tipId) => dismissedTips.contains(tipId);
}

class UserPreferencesNotifier extends StateNotifier<UserPreferencesState> {
  static const _keyDisplayName = 'user_display_name';
  static const _keyHiddenSections = 'dashboard_hidden_sections';
  static const _keySectionOrder = 'dashboard_section_order';
  static const _keyOnboardingCompleted = 'onboarding_completed_v1';
  static const _keyDismissedTips = 'dismissed_tips_v1';

  static const List<DashboardSectionConfig> defaultSections = [
    DashboardSectionConfig(id: 'hero_projects', label: "Today's Progress Summary", isVisible: true),
    DashboardSectionConfig(id: 'quick_actions', label: 'Quick Action Shortcuts', isVisible: true),
    DashboardSectionConfig(id: 'productivity_stats', label: 'Productivity Summary Grid', isVisible: true),
    DashboardSectionConfig(id: 'todays_priorities', label: 'Upcoming Tasks', isVisible: true),
    DashboardSectionConfig(id: 'ongoing_projects', label: 'Active Projects', isVisible: true),
    DashboardSectionConfig(id: 'learning_roadmaps', label: 'Learning & Focus Summary', isVisible: true),
  ];

  UserPreferencesNotifier()
      : super(const UserPreferencesState(
          displayName: 'Developer',
          dashboardSections: defaultSections,
        )) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_keyDisplayName) ?? 'Developer';
      final hiddenList = prefs.getStringList(_keyHiddenSections) ?? [];
      final savedOrder = prefs.getStringList(_keySectionOrder);
      final onboardingDone = prefs.getBool(_keyOnboardingCompleted) ?? false;
      final tips = (prefs.getStringList(_keyDismissedTips) ?? const []).toSet();

      List<DashboardSectionConfig> ordered = List.of(defaultSections);
      if (savedOrder != null && savedOrder.isNotEmpty) {
        final byId = {for (final s in defaultSections) s.id: s};
        final rebuilt = <DashboardSectionConfig>[];
        for (final id in savedOrder) {
          final found = byId.remove(id);
          if (found != null) rebuilt.add(found);
        }
        rebuilt.addAll(byId.values);
        ordered = rebuilt;
      }

      final updatedSections = ordered.map((s) {
        return s.copyWith(isVisible: !hiddenList.contains(s.id));
      }).toList();

      state = UserPreferencesState(
        displayName: name,
        dashboardSections: updatedSections,
        onboardingCompleted: onboardingDone,
        dismissedTips: tips,
      );
    } catch (_) {
      // Keep default state safely if prefs unavailable
    }
  }

  Future<void> updateDisplayName(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDisplayName, trimmed);
    state = UserPreferencesState(
      displayName: trimmed,
      dashboardSections: state.dashboardSections,
      onboardingCompleted: state.onboardingCompleted,
      dismissedTips: state.dismissedTips,
    );
  }

  Future<void> markOnboardingCompleted() async {
    state = UserPreferencesState(
      displayName: state.displayName,
      dashboardSections: state.dashboardSections,
      onboardingCompleted: true,
      dismissedTips: state.dismissedTips,
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyOnboardingCompleted, true);
    } catch (_) {}
  }

  Future<void> dismissTip(String tipId) async {
    final nextTips = {...state.dismissedTips, tipId};
    state = UserPreferencesState(
      displayName: state.displayName,
      dashboardSections: state.dashboardSections,
      onboardingCompleted: state.onboardingCompleted,
      dismissedTips: nextTips,
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_keyDismissedTips, nextTips.toList());
    } catch (_) {}
  }

  Future<void> resetAllTips() async {
    state = UserPreferencesState(
      displayName: state.displayName,
      dashboardSections: state.dashboardSections,
      onboardingCompleted: state.onboardingCompleted,
      dismissedTips: const {},
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyDismissedTips);
    } catch (_) {}
  }

  Future<void> toggleSectionVisibility(String sectionId, bool isVisible) async {
    final updated = state.dashboardSections.map((s) {
      if (s.id == sectionId) {
        return s.copyWith(isVisible: isVisible);
      }
      return s;
    }).toList();

    final hiddenList = updated.where((s) => !s.isVisible).map((s) => s.id).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyHiddenSections, hiddenList);

    state = UserPreferencesState(
      displayName: state.displayName,
      dashboardSections: updated,
      onboardingCompleted: state.onboardingCompleted,
      dismissedTips: state.dismissedTips,
    );
  }

  Future<void> reorderSections(int oldIndex, int newIndex) async {
    final current = List<DashboardSectionConfig>.of(state.dashboardSections);
    if (oldIndex < 0 || oldIndex >= current.length) return;
    if (newIndex > oldIndex) newIndex -= 1;
    if (newIndex < 0 || newIndex >= current.length) return;

    final moved = current.removeAt(oldIndex);
    current.insert(newIndex, moved);

    state = UserPreferencesState(
      displayName: state.displayName,
      dashboardSections: current,
      onboardingCompleted: state.onboardingCompleted,
      dismissedTips: state.dismissedTips,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _keySectionOrder,
      current.map((s) => s.id).toList(),
    );
  }

  Future<void> resetDashboardSections() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHiddenSections);
    await prefs.remove(_keySectionOrder);
    state = UserPreferencesState(
      displayName: state.displayName,
      dashboardSections: defaultSections,
      onboardingCompleted: state.onboardingCompleted,
      dismissedTips: state.dismissedTips,
    );
  }
}

final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferencesState>((ref) {
  return UserPreferencesNotifier();
});
