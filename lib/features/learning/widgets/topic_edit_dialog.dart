import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/learning_repository.dart';

class TopicEditDialog extends ConsumerStatefulWidget {
  final String moduleId;
  final LearningTopicEntry? topicToEdit;

  const TopicEditDialog({
    super.key,
    required this.moduleId,
    this.topicToEdit,
  });

  static Future<void> show(
    BuildContext context, {
    required String moduleId,
    LearningTopicEntry? topicToEdit,
  }) {
    return showDialog(
      context: context,
      builder: (context) => TopicEditDialog(
        moduleId: moduleId,
        topicToEdit: topicToEdit,
      ),
    );
  }

  @override
  ConsumerState<TopicEditDialog> createState() => _TopicEditDialogState();
}

class _TopicEditDialogState extends ConsumerState<TopicEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _resourcesController;
  late TextEditingController _notesController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.topicToEdit?.title ?? '');
    _resourcesController = TextEditingController(text: widget.topicToEdit?.resources ?? '');
    _notesController = TextEditingController(text: widget.topicToEdit?.notes ?? '');
    _status = widget.topicToEdit?.status ?? 'planned';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _resourcesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final repo = ref.read(learningRepositoryProvider);
    if (widget.topicToEdit == null) {
      await repo.addTopic(
        moduleId: widget.moduleId,
        title: title,
        resources: _resourcesController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
    } else {
      await repo.updateTopic(
        id: widget.topicToEdit!.id,
        title: title,
        resources: _resourcesController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        status: _status,
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.card)),
      title: Text(
        widget.topicToEdit == null ? 'Add Learning Topic' : 'Topic Details',
        style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Topic Title',
              hintText: 'e.g. Zero-Cost Abstractions, Shaders, Async Streams',
              controller: _titleController,
              autofocus: widget.topicToEdit == null,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Resource URL or Reference',
              hintText: 'e.g. https://docs.rs/... or Book Chapter 4',
              controller: _resourcesController,
              prefixIcon: const Icon(Icons.link_rounded, size: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Study Notes & Core Insights',
              hintText: 'Key syntax, pitfalls, memory models, or mental frameworks...',
              controller: _notesController,
              maxLines: 3,
            ),
            if (widget.topicToEdit != null) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Progress Status', style: AppTypography.titleSmall),
                  DropdownButton<String>(
                    value: _status,
                    items: const [
                      DropdownMenuItem(value: 'planned', child: Text('Planned')),
                      DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                      DropdownMenuItem(value: 'completed', child: Text('Completed')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _status = val);
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: widget.topicToEdit == null ? 'Add Topic' : 'Save',
          size: AppButtonSize.small,
          onPressed: _save,
        ),
      ],
    );
  }
}
