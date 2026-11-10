import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_badges.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_interaction.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/user_preferences_repository.dart';
import '../../../services/feedback_service.dart';
import '../widgets/project_card.dart';
import '../widgets/project_form_sheet.dart';
import 'project_detail_screen.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  String _activeStatus = 'all';
  String _searchQuery = '';
  final _searchController = TextEditingController();
  bool _isSearchExpanded = false;

  final _statuses = const [
    {'value': 'all', 'label': 'All'},
    {'value': 'active', 'label': 'Active'},
    {'value': 'planning', 'label': 'Planning'},
    {'value': 'on_hold', 'label': 'On Hold'},
    {'value': 'completed', 'label': 'Completed'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projectsAsync = ref.watch(allProjectsStreamProvider);
    final feedback = ref.read(feedbackServiceProvider);

    return AppScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          feedback.buttonTap();
          ProjectFormSheet.show(context);
        },
        backgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
        foregroundColor: Colors.white,
        tooltip: 'New Project',
        child: const Icon(AppIcons.add, size: 26.0),
      ),
      body: Column(
        children: [
          PageTitle(
            title: 'Projects',
            actions: [
              AppIconButton(
                icon: _isSearchExpanded ? AppIcons.close : AppIcons.search,
                tooltip: 'Search projects',
                onPressed: () {
                  feedback.buttonTap();
                  setState(() {
                    if (_isSearchExpanded) {
                      _searchController.clear();
                      _searchQuery = '';
                    }
                    _isSearchExpanded = !_isSearchExpanded;
                  });
                },
              ),
            ],
          ),

          if (_isSearchExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                0,
                AppSpacing.pageHorizontal,
                AppSpacing.md,
              ),
              child: SearchField(
                controller: _searchController,
                hintText: 'Search by project name or stack...',
                autofocus: true,
                onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
              ),
            ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: Row(
              children: _statuses.map((s) {
                final val = s['value']!;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: AppFilterChip(
                    label: s['label']!,
                    selected: _activeStatus == val,
                    onSelected: () {
                      feedback.selectionClick();
                      setState(() => _activeStatus = val);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Expanded(
            child: projectsAsync.when(
              loading: () => const ProjectsSkeleton(),
              error: (err, _) => ErrorStateView(
                message: 'Error loading projects: $err',
                onRetry: () => ref.invalidate(allProjectsStreamProvider),
              ),
              data: (projects) {
                final prefsState = ref.watch(userPreferencesProvider);
                var visible = projects;
                if (_activeStatus != 'all') {
                  visible = visible.where((p) => p.project.status == _activeStatus).toList();
                }
                if (_searchQuery.isNotEmpty) {
                  visible = visible.where((p) {
                    final name = p.project.name.toLowerCase();
                    final desc = (p.project.description ?? '').toLowerCase();
                    final tech = p.project.techStack.toLowerCase();
                    return name.contains(_searchQuery) ||
                        desc.contains(_searchQuery) ||
                        tech.contains(_searchQuery);
                  }).toList();
                }

                if (visible.isEmpty) {
                  return EmptyStateView(
                    icon: AppIcons.projects,
                    illustrationAsset: _searchQuery.isNotEmpty
                        ? 'assets/images/empty/empty_search.png'
                        : 'assets/images/empty/empty_projects.png',
                    title: _searchQuery.isNotEmpty
                        ? 'No matching projects.'
                        : 'Your next big thing starts here.',
                    description: _searchQuery.isNotEmpty
                        ? 'Try adjusting your search filters.'
                        : 'Create a project and break it into manageable steps.',
                    actionLabel: 'Create project',
                    onAction: () => ProjectFormSheet.show(context),
                  );
                }

                final showProjectTip = !prefsState.isTipDismissed('first_project');

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pageHorizontal,
                    AppSpacing.xs,
                    AppSpacing.pageHorizontal,
                    96.0,
                  ),
                  itemCount: visible.length + (showProjectTip ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    if (showProjectTip && index == 0) {
                      return DismissibleTipBanner(
                        icon: AppIcons.projects,
                        title: 'Connect tasks & milestones',
                        message:
                            'Open any project to track milestones, link deliverables from Tasks, and view a live activity timeline.',
                        accentColor: AppColors.projectAccent,
                        onDismiss: () {
                          feedback.selectionClick();
                          ref.read(userPreferencesProvider.notifier).dismissTip('first_project');
                        },
                      );
                    }
                    final item = visible[showProjectTip ? index - 1 : index];
                    return ProjectCard(
                      projectWithDetails: item,
                      colorIndex: index,
                      variant: index == (showProjectTip ? 1 : 0)
                          ? ProjectCardVariant.folderGrid
                          : ProjectCardVariant.standard,
                      onTap: () {
                        feedback.buttonTap();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProjectDetailScreen(projectId: item.project.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
