import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
              indicatorColor: AppColors.primarySoft,
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: const Icon(
                        Icons.terminal_rounded,
                        size: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'ProgressOS',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.check_circle_outline_rounded),
                  selectedIcon: Icon(Icons.check_circle_rounded, color: AppColors.primary),
                  label: Text('Tasks'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.school_outlined),
                  selectedIcon: Icon(Icons.school_rounded, color: AppColors.primary),
                  label: Text('Learning'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.rocket_launch_outlined),
                  selectedIcon: Icon(Icons.rocket_launch_rounded, color: AppColors.primary),
                  label: Text('Projects'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.insights_rounded),
                  selectedIcon: Icon(Icons.insights_rounded, color: AppColors.primary),
                  label: Text('Insights'),
                ),
              ],
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    // Mobile Layout: Floating White Capsule Dock (matching reference image)
    final activeIndex = navigationShell.currentIndex;

    const navItems = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, tooltip: 'Home'),
      _NavItem(icon: Icons.check_circle_outline_rounded, activeIcon: Icons.check_circle_rounded, tooltip: 'Tasks'),
      _NavItem(icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome_rounded, tooltip: 'Learning'),
      _NavItem(icon: Icons.folder_open_rounded, activeIcon: Icons.folder_rounded, tooltip: 'Projects'),
      _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, tooltip: 'Insights'),
    ];

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 64.0,
          margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 14.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(32.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                blurRadius: 20.0,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isSelected = activeIndex == index;

              return GestureDetector(
                onTap: () => _onTap(index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 52.0,
                  height: 64.0,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      width: isSelected ? 44.0 : 36.0,
                      height: isSelected ? 44.0 : 36.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? (isDark ? Colors.white : const Color(0xFF19213D))
                            : Colors.transparent,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 8.0,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isSelected ? item.activeIcon : item.icon,
                        size: 21.0,
                        color: isSelected
                            ? (isDark ? const Color(0xFF19213D) : Colors.white)
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String tooltip;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.tooltip,
  });
}
