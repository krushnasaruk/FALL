import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/focus/screens/focus_screen.dart';
import '../features/habits/screens/habits_screen.dart';
import '../features/insights/screens/insights_screen.dart';
import '../features/learning/screens/learning_screen.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/tasks/screens/tasks_screen.dart';
import '../features/vault/screens/vault_screen.dart';
import 'scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorDashboard = GlobalKey<NavigatorState>(debugLabel: 'shellDashboard');
final _shellNavigatorTasks = GlobalKey<NavigatorState>(debugLabel: 'shellTasks');
final _shellNavigatorLearning = GlobalKey<NavigatorState>(debugLabel: 'shellLearning');
final _shellNavigatorProjects = GlobalKey<NavigatorState>(debugLabel: 'shellProjects');
final _shellNavigatorInsights = GlobalKey<NavigatorState>(debugLabel: 'shellInsights');

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // 1. Dashboard Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDashboard,
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // 2. Tasks Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTasks,
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (context, state) => const TasksScreen(),
              ),
            ],
          ),

          // 3. Learning Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorLearning,
            routes: [
              GoRoute(
                path: '/learning',
                builder: (context, state) => const LearningScreen(),
              ),
            ],
          ),

          // 4. Projects Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProjects,
            routes: [
              GoRoute(
                path: '/projects',
                builder: (context, state) => const ProjectsScreen(),
              ),
            ],
          ),

          // 5. Insights Branch
          StatefulShellBranch(
            navigatorKey: _shellNavigatorInsights,
            routes: [
              GoRoute(
                path: '/insights',
                builder: (context, state) => const InsightsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Direct routes
      GoRoute(
        path: '/focus',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FocusScreen(),
      ),
      GoRoute(
        path: '/habits',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HabitsScreen(),
      ),
      GoRoute(
        path: '/vault',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VaultScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

