import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_motion.dart';
import '../features/calendar/screens/agenda_calendar_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/focus/screens/focus_screen.dart';
import '../features/habits/screens/goals_screen.dart';
import '../features/habits/screens/habits_screen.dart';
import '../features/insights/screens/insights_screen.dart';
import '../features/learning/screens/learning_screen.dart';
import '../features/more/screens/more_hub_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/radar/screens/radar_home_screen.dart';
import '../features/radar/screens/radar_briefing_screen.dart';
import '../features/radar/screens/radar_preferences_screen.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/tasks/screens/tasks_screen.dart';
import '../features/vault/screens/vault_screen.dart';
import 'scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorDashboard = GlobalKey<NavigatorState>(debugLabel: 'shellDashboard');
final _shellNavigatorTasks = GlobalKey<NavigatorState>(debugLabel: 'shellTasks');
final _shellNavigatorProjects = GlobalKey<NavigatorState>(debugLabel: 'shellProjects');
final _shellNavigatorLearning = GlobalKey<NavigatorState>(debugLabel: 'shellLearning');
final _shellNavigatorMore = GlobalKey<NavigatorState>(debugLabel: 'shellMore');

/// Overridden in `main.dart` on real cold launch if onboarding hasn't been completed yet.
/// Defaults to `/dashboard` so automated shell tests remain stable cleanly.
final initialRouteProvider = Provider<String>((ref) => '/dashboard');

final routerProvider = Provider<GoRouter>((ref) {
  final initialLocation = ref.watch(initialRouteProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDashboard,
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTasks,
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TasksScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProjects,
            routes: [
              GoRoute(
                path: '/projects',
                builder: (context, state) => const ProjectsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorLearning,
            routes: [
              GoRoute(
                path: '/learning',
                builder: (context, state) => const LearningScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorMore,
            routes: [
              GoRoute(
                path: '/more',
                builder: (context, state) => const MoreHubScreen(),
              ),
            ],
          ),
        ],
      ),

      // Direct routes accessible anywhere using smooth, reduced-motion-safe transitions
      GoRoute(
        path: '/insights',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const InsightsScreen(),
        ),
      ),
      GoRoute(
        path: '/focus',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const FocusScreen(),
        ),
      ),
      GoRoute(
        path: '/goals',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const GoalsScreen(),
        ),
      ),
      GoRoute(
        path: '/habits',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const HabitsScreen(),
        ),
      ),
      GoRoute(
        path: '/vault',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const VaultScreen(),
        ),
      ),
      GoRoute(
        path: '/journal',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const VaultScreen(initialJournalMode: true),
        ),
      ),
      GoRoute(
        path: '/calendar',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const AgendaCalendarScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/radar',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const RadarHomeScreen(),
        ),
      ),
      GoRoute(
        path: '/radar/briefings',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const RadarBriefingScreen(),
        ),
      ),
      GoRoute(
        path: '/radar/settings',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => AppMotion.buildDetailPage(
          state: state,
          child: const RadarPreferencesScreen(),
        ),
      ),
    ],
  );
});
