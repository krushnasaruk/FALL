import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/app_radii.dart';
import '../core/theme/app_typography.dart';
import '../core/widgets/fall_logo.dart';
import '../features/tasks/widgets/task_form_sheet.dart';
import '../services/feedback_service.dart';

class ScaffoldWithNavBar extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  ConsumerState<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends ConsumerState<ScaffoldWithNavBar>
    with WidgetsBindingObserver {
  static const _channel = MethodChannel('com.progressos.progress_os/feedback');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumePendingWidgetAction());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _consumePendingWidgetAction();
    }
  }

  Future<void> _consumePendingWidgetAction() async {
    try {
      final action = await _channel.invokeMethod<String>('consumeLaunchAction');
      if (!mounted || action == null || action.isEmpty) return;

      switch (action) {
        case 'new_task':
          widget.navigationShell.goBranch(1);
          await TaskFormSheet.show(context);
          break;
        case 'open_tasks':
          widget.navigationShell.goBranch(1);
          break;
        case 'open_projects':
          widget.navigationShell.goBranch(2);
          break;
        case 'open_learning':
          widget.navigationShell.goBranch(3);
          break;
        case 'open_habits':
          if (mounted) context.push('/habits');
          break;
        case 'open_focus':
          if (mounted) context.push('/focus');
          break;
        case 'new_note':
          if (mounted) context.push('/vault');
          break;
        case 'open_goals':
          if (mounted) context.push('/goals');
          break;
        case 'open_radar':
          if (mounted) context.push('/radar');
          break;
        default:
          break;
      }
    } catch (_) {
      // Safe no-op on non-Android platforms & tests
    }
  }

  void _onTap(int index) {
    ref.read(feedbackServiceProvider).selectionClick();
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
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
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
              indicatorColor: isDark ? AppColors.darkProjectSurface : AppColors.primarySoft,
              labelType: NavigationRailLabelType.all,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: FallLogo(size: 28.0, showText: true),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(AppIcons.home),
                  selectedIcon: Icon(AppIcons.homeActive, color: AppColors.primary),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(AppIcons.tasks),
                  selectedIcon: Icon(AppIcons.tasksActive, color: AppColors.primary),
                  label: Text('Tasks'),
                ),
                NavigationRailDestination(
                  icon: Icon(AppIcons.projects),
                  selectedIcon: Icon(AppIcons.projectsActive, color: AppColors.primary),
                  label: Text('Projects'),
                ),
                NavigationRailDestination(
                  icon: Icon(AppIcons.learning),
                  selectedIcon: Icon(AppIcons.learningActive, color: AppColors.primary),
                  label: Text('Learning'),
                ),
                NavigationRailDestination(
                  icon: Icon(AppIcons.more),
                  selectedIcon: Icon(AppIcons.moreActive, color: AppColors.primary),
                  label: Text('More'),
                ),
              ],
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: widget.navigationShell),
          ],
        ),
      );
    }

    final activeIndex = widget.navigationShell.currentIndex;

    const navItems = [
      _NavItem(
        icon: AppIcons.home,
        activeIcon: AppIcons.homeActive,
        label: 'Home',
      ),
      _NavItem(
        icon: AppIcons.tasks,
        activeIcon: AppIcons.tasksActive,
        label: 'Tasks',
      ),
      _NavItem(
        icon: AppIcons.projects,
        activeIcon: AppIcons.projectsActive,
        label: 'Projects',
      ),
      _NavItem(
        icon: AppIcons.learning,
        activeIcon: AppIcons.learningActive,
        label: 'Learning',
      ),
      _NavItem(
        icon: AppIcons.more,
        activeIcon: AppIcons.moreActive,
        label: 'More',
      ),
    ];

    final navSurface = isDark ? AppColors.darkSurface : AppColors.surface;
    final topBorder = isDark ? AppColors.darkBorder : AppColors.divider;
    final activeAccent = isDark ? AppColors.primaryDark : AppColors.primary;
    final activePill = isDark
        ? AppColors.primaryDark.withOpacity(0.16)
        : AppColors.primarySoft;
    final inactiveColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: navSurface,
          border: Border(top: BorderSide(color: topBorder, width: 1.0)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isSelected = activeIndex == index;

                return Expanded(
                  child: Semantics(
                    selected: isSelected,
                    button: true,
                    label: '${item.label} tab',
                    child: InkWell(
                      onTap: () => _onTap(index),
                      borderRadius: AppRadii.roundedMd,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? activePill : Colors.transparent,
                                borderRadius: AppRadii.roundedFull,
                              ),
                              child: Icon(
                                isSelected ? item.activeIcon : item.icon,
                                size: 22.0,
                                color: isSelected ? activeAccent : inactiveColor,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              item.label,
                              style: AppTypography.metadata.copyWith(
                                fontSize: 11.0,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? activeAccent : inactiveColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
