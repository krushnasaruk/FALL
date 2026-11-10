import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/repositories/learning_repository.dart';
import '../../../services/widget_sync_service.dart';

class LogSessionDialog extends ConsumerStatefulWidget {
  final String skillId;
  final String skillName;
  final String? preselectedTopicId;

  const LogSessionDialog({
    super.key,
    required this.skillId,
    required this.skillName,
    this.preselectedTopicId,
  });

  static Future<void> show(
    BuildContext context, {
    required String skillId,
    required String skillName,
    String? preselectedTopicId,
  }) {
    return showDialog(
      context: context,
      builder: (context) => LogSessionDialog(
        skillId: skillId,
        skillName: skillName,
        preselectedTopicId: preselectedTopicId,
      ),
    );
  }

  @override
  ConsumerState<LogSessionDialog> createState() => _LogSessionDialogState();
}

class _LogSessionDialogState extends ConsumerState<LogSessionDialog> {
  final _durationController = TextEditingController(text: '45');
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final mins = int.tryParse(_durationController.text.trim());
    if (mins == null || mins <= 0) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(learningRepositoryProvider);
      await repo.logLearningSession(
        skillId: widget.skillId,
        topicId: widget.preselectedTopicId,
        durationMinutes: mins,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      await ref.read(widgetSyncServiceProvider).syncAllWidgets();

      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.roundedLg),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: const BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: AppRadii.roundedSm,
            ),
            child: const Icon(Icons.history_toggle_off_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Log Learning Time', style: AppTypography.titleMedium),
                Text(widget.skillName, style: AppTypography.caption.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Duration (Minutes)',
              hintText: '45',
              controller: _durationController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.sm),
            // Quick preset pills
            Row(
              children: [15, 30, 45, 60, 90].map((m) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ActionChip(
                    label: Text('${m}m'),
                    labelStyle: AppTypography.caption,
                    padding: EdgeInsets.zero,
                    onPressed: () => setState(() => _durationController.text = m.toString()),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Notes & What You Built/Read',
              hintText: 'Implemented riverpod state notifier, studied documentation...',
              controller: _notesController,
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Log Session',
          onPressed: _submit,
          isLoading: _isLoading,
          size: AppButtonSize.small,
        ),
      ],
    );
  }
}

