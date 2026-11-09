import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_stat_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/project_repository.dart';
import '../widgets/project_card.dart';
import '../widgets/project_form_sheet.dart';
import 'project_detail_screen.dart';

class ProjectsScreen extends ConsumerStatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ConsumerState<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<ProjectsScreen> {
  String _activeStatus = 'all'; // all, active, planning, completed, on_hold, archived
  String _searchQuery = '';
  final _searchController = TextEditingController();
  bool _isSearchExpanded = false;

  final _statuses = [
    {'value': 'all', 'label': 'All'},
    {'value': 'active', 'label': 'Active'},
    {'value': 'planning', 'label': 'Planning'},
    {'value': 'completed', 'label': 'Completed'},
    {'value': 'on_hold', 'label': 'On Hold'},
    {'value': 'archived', 'label': 'Archived'},
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

    return Scaffold(
      appBar: AppBar(
        title: _isSearchExpanded
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search projects by name, category, or tech...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                        _isSearchExpanded = false;
                      });
                    },
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
              )
            : Text(
                'Projects',
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
              ),
        actions: [
          if (!_isSearchExpanded)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => setState(() => _isSearchExpanded = true),
            ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
            onPressed: () => ProjectFormSheet.show(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ProjectFormSheet.show(context),
        backgroundColor: AppColors.primary,
        foregroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Project', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: projectsAsync.when(
        data: (projects) {
          // Filter projects
          var visible = projects;
          if (_activeStatus != 'all') {
            visible = visible.where((p) => p.project.status == _activeStatus).toList();
          }
          if (_searchQuery.isNotEmpty) {
            visible = visible.where((p) {
              final name = p.project.name.toLowerCase();
              final desc = (p.project.description ?? '').toLowerCase();
              final tech = p.project.techStack.toLowerCase();
              return name.contains(_searchQuery) || desc.contains(_searchQuery) || tech.contains(_searchQuery);
            }).toList();
          }

          // Compute stats
          int totalTimeSpent = 0;
          int activeCount = 0;
          for (final p in projects) {
            totalTimeSpent += p.project.timeSpentMinutes;
            if (p.project.status == 'active') activeCount++;
          }

          return Column(
            children: [
              // Project Stat Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: AppStatCard(
                        title: 'Active Builds',
                        value: activeCount.toString(),
                        subtitle: '${projects.length} total projects',
                        icon: Icons.rocket_launch_rounded,
                        accentColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStatCard(
                        title: 'Total Time Invested',
                        value: DateFormatters.formatMinutes(totalTimeSpent),
                        subtitle: 'Across all repositories',
                        icon: Icons.access_time_filled_rounded,
                        accentColor: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Filter Bar
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: _statuses.map((s) {
                    final isSelected = _activeStatus == s['value'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(s['label']!),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _activeStatus = s['value']!),
                        labelStyle: AppTypography.caption.copyWith(
                          color: isSelected
                              ? const Color(0xFF0F172A)
                              : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        selectedColor: AppColors.primary,
                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.roundedMd,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Projects List
              Expanded(
                child: visible.isEmpty
                    ? EmptyStateView(
                        icon: Icons.rocket_launch_outlined,
                        title: _searchQuery.isNotEmpty ? 'No projects match your query' : 'No projects here yet',
                        description: _searchQuery.isNotEmpty
                            ? 'Try searching with different terms or reset your filter.'
                            : 'Create startup builds, web apps, mobile tools, or hardware experiments.',
                        actionLabel: 'Create Project',
                        onAction: () => ProjectFormSheet.show(context),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 80.0),
                        itemCount: visible.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final item = visible[index];
                          return ProjectCard(
                            projectWithDetails: item,
                            colorIndex: index,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProjectDetailScreen(projectId: item.project.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorStateView(
          message: err.toString(),
          onRetry: () => ref.refresh(allProjectsStreamProvider),
        ),
      ),
    );
  }
}

