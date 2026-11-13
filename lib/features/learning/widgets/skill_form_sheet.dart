import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_interaction.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/repositories/learning_repository.dart';

class SkillFormSheet extends ConsumerStatefulWidget {
  final SkillWithRoadmap? skillToEdit;

  const SkillFormSheet({super.key, this.skillToEdit});

  static Future<void> show(BuildContext context, {SkillWithRoadmap? skillToEdit}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SkillFormSheet(skillToEdit: skillToEdit),
    );
  }

  @override
  ConsumerState<SkillFormSheet> createState() => _SkillFormSheetState();
}

class _SkillFormSheetState extends ConsumerState<SkillFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _notesController;
  late TextEditingController _targetHoursController;

  String _category = 'Framework';
  String _currentLevel = 'beginner';
  String _targetLevel = 'advanced';
  String _progressMethod = 'topics'; // topics, time, manual
  double _manualProgress = 0.0;
  bool _isLoading = false;

  bool _hasUnsavedChanges() {
    final s = widget.skillToEdit?.skill;
    if (s == null) {
      return _nameController.text.trim().isNotEmpty ||
          _notesController.text.trim().isNotEmpty ||
          _targetHoursController.text.trim().isNotEmpty;
    }
    return _nameController.text.trim() != s.name ||
        _notesController.text.trim() != (s.notes ?? '') ||
        _category != s.category ||
        _currentLevel != s.currentLevel ||
        _targetLevel != s.targetLevel ||
        _progressMethod != s.progressMethod;
  }

  Future<void> _handleAttemptClose() async {
    if (_isLoading || !_hasUnsavedChanges()) {
      Navigator.of(context).pop();
      return;
    }
    final choice = await confirmDiscardChanges(context, allowSaveOption: true);
    if (!mounted) return;
    if (choice == UnsavedChoice.discard) {
      Navigator.of(context).pop();
    } else if (choice == UnsavedChoice.save) {
      await _saveSkill();
    }
  }

  final _categories = ['Language', 'Framework', 'AI & ML', 'Systems & IoT', 'Database', 'Cloud & DevOps', 'General'];
  final _levels = ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'];

  @override
  void initState() {
    super.initState();
    final s = widget.skillToEdit?.skill;
    _nameController = TextEditingController(text: s?.name ?? '');
    _notesController = TextEditingController(text: s?.notes ?? '');
    final targetMins = s?.targetMinutes ?? 0;
    _targetHoursController = TextEditingController(
      text: targetMins > 0 ? (targetMins / 60).toStringAsFixed(1) : '',
    );

    if (s != null) {
      _category = s.category;
      _currentLevel = s.currentLevel;
      _targetLevel = s.targetLevel;
      _progressMethod = s.progressMethod;
      _manualProgress = s.manualProgressPercentage;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _targetHoursController.dispose();
    super.dispose();
  }

  Future<void> _saveSkill() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(learningRepositoryProvider);
      final targetHours = double.tryParse(_targetHoursController.text.trim()) ?? 0.0;
      final targetMinutes = (targetHours * 60).round();

      if (widget.skillToEdit == null) {
        await repo.createSkill(
          name: _nameController.text.trim(),
          category: _category,
          currentLevel: _currentLevel,
          targetLevel: _targetLevel,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          progressMethod: _progressMethod,
          targetMinutes: targetMinutes,
          manualProgressPercentage: _manualProgress,
        );
      } else {
        await repo.updateSkill(
          id: widget.skillToEdit!.skill.id,
          name: _nameController.text.trim(),
          category: _category,
          currentLevel: _currentLevel,
          targetLevel: _targetLevel,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          progressMethod: _progressMethod,
          targetMinutes: targetMinutes,
          manualProgressPercentage: _manualProgress,
        );
      }

      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleAttemptClose();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1.0,
          ),
        ),
        padding: EdgeInsets.only(
          top: 20.0,
          left: 20.0,
          right: 20.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.skillToEdit == null ? 'Track New Skill' : 'Edit Skill',
                      style: AppTypography.titleLarge.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: _handleAttemptClose,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Skill Name
                AppTextField(
                  label: 'Skill Name',
                  hintText: 'e.g. Flutter, Rust, PyTorch, Kubernetes',
                  controller: _nameController,
                  autofocus: widget.skillToEdit == null,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Skill name is required';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Primary Progress Method Selector
                const Text('Primary Progress Method', style: AppTypography.titleSmall),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _progressMethod,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.show_chart_rounded, size: 20),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'topics',
                      child: Text('Curriculum Topics (% of lessons completed)'),
                    ),
                    DropdownMenuItem(
                      value: 'time',
                      child: Text('Time Target (Focused study hours goal)'),
                    ),
                    DropdownMenuItem(
                      value: 'manual',
                      child: Text('Manual Progress (% self-reported)'),
                    ),
                  ],
                  onChanged: (val) => setState(() => _progressMethod = val ?? 'topics'),
                ),
                const SizedBox(height: AppSpacing.md),

                // Target Hours (Optional or for time method)
                AppTextField(
                  label: _progressMethod == 'time'
                      ? 'Target Study Hours (e.g., 30 hours)'
                      : 'Target Study Hours (Optional)',
                  hintText: 'e.g. 30',
                  controller: _targetHoursController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: AppSpacing.md),

                // Manual Progress Slider (if manual)
                if (_progressMethod == 'manual') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Current Mastery Progress', style: AppTypography.titleSmall),
                      Text('${(_manualProgress * 100).toStringAsFixed(0)}%',
                          style: AppTypography.titleMedium.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  Slider(
                    value: _manualProgress,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    label: '${(_manualProgress * 100).toStringAsFixed(0)}%',
                    onChanged: (val) => setState(() => _manualProgress = val),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Category dropdown
                DropdownButtonFormField<String>(
                  value: _categories.contains(_category) ? _category : 'General',
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => _category = val ?? 'General'),
                ),
                const SizedBox(height: AppSpacing.md),

                // Level Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _currentLevel,
                        decoration: const InputDecoration(labelText: 'Current Level'),
                        items: _levels
                            .map((l) => DropdownMenuItem(value: l, child: Text(l.toUpperCase())))
                            .toList(),
                        onChanged: (val) => setState(() => _currentLevel = val ?? 'beginner'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _targetLevel,
                        decoration: const InputDecoration(labelText: 'Target Level'),
                        items: _levels
                            .map((l) => DropdownMenuItem(value: l, child: Text(l.toUpperCase())))
                            .toList(),
                        onChanged: (val) => setState(() => _targetLevel = val ?? 'advanced'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Notes
                AppTextField(
                  label: 'Notes & Learning Objectives',
                  hintText: 'Why are you learning this? What projects will you build?',
                  controller: _notesController,
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Save button
                AppButton(
                  label: widget.skillToEdit == null ? 'Add Skill' : 'Save Changes',
                  onPressed: _saveSkill,
                  isLoading: _isLoading,
                  isFullWidth: true,
                  size: AppButtonSize.large,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
