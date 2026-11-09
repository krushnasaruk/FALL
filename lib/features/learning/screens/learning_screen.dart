import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_formatters.dart';
import '../../../core/widgets/app_stat_card.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/repositories/learning_repository.dart';
import '../widgets/skill_card.dart';
import '../widgets/skill_form_sheet.dart';
import 'skill_detail_screen.dart';

class LearningScreen extends ConsumerStatefulWidget {
  const LearningScreen({super.key});

  @override
  ConsumerState<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends ConsumerState<LearningScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();
  bool _isSearchExpanded = false;

  final _categories = ['All', 'Language', 'Framework', 'AI & ML', 'Systems & IoT', 'Database', 'Cloud & DevOps'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skillsAsync = ref.watch(allSkillsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearchExpanded
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: AppTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search skills or roadmaps...',
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
                'Learning Roadmaps',
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
            onPressed: () => SkillFormSheet.show(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => SkillFormSheet.show(context),
        backgroundColor: AppColors.primary,
        foregroundColor: const Color(0xFF0F172A),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Skill', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: skillsAsync.when(
        data: (skills) {
          // Filter skills
          var visible = skills;
          if (_selectedCategory != 'All') {
            visible = visible
                .where((s) => s.skill.category.toLowerCase().contains(_selectedCategory.toLowerCase()))
                .toList();
          }
          if (_searchQuery.isNotEmpty) {
            visible = visible
                .where((s) =>
                    s.skill.name.toLowerCase().contains(_searchQuery) ||
                    s.skill.category.toLowerCase().contains(_searchQuery))
                .toList();
          }

          // Compute stats
          int totalMinutes = 0;
          int totalTopicsMastered = 0;
          for (final s in skills) {
            totalMinutes += s.skill.learningMinutes;
            totalTopicsMastered += s.completedTopics;
          }

          return Column(
            children: [
              // High-level Learning Metrics Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: AppStatCard(
                        title: 'Total Study Time',
                        value: DateFormatters.formatMinutes(totalMinutes),
                        subtitle: 'Across all skills',
                        icon: Icons.timer_outlined,
                        accentColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStatCard(
                        title: 'Mastered Topics',
                        value: totalTopicsMastered.toString(),
                        subtitle: '${skills.length} tracked skills',
                        icon: Icons.verified_rounded,
                        accentColor: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),

              // Category Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: _categories.map((c) {
                    final isSelected = _selectedCategory == c;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(c),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedCategory = c),
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

              // Skills List
              Expanded(
                child: visible.isEmpty
                    ? EmptyStateView(
                        icon: Icons.school_outlined,
                        title: _searchQuery.isNotEmpty ? 'No skills matched' : 'No technical skills tracked',
                        description: _searchQuery.isNotEmpty
                            ? 'Try searching with a different keyword.'
                            : 'Add programming languages, frameworks, AI concepts, or systems you are mastering.',
                        actionLabel: 'Track a Skill',
                        onAction: () => SkillFormSheet.show(context),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 80.0),
                        itemCount: visible.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final item = visible[index];
                          return SkillCard(
                            skillWithRoadmap: item,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SkillDetailScreen(skillId: item.skill.id),
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
          onRetry: () => ref.refresh(allSkillsStreamProvider),
        ),
      ),
    );
  }
}
