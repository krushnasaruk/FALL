import 'package:flutter/material.dart';
import '../../../data/repositories/task_repository.dart';
import 'task_card.dart';

export 'task_card.dart';

class TaskTile extends StatelessWidget {
  final TaskWithSubtasks taskWithSubtasks;
  final ValueChanged<bool>? onToggleComplete;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Gradient? gradient;
  final bool compact;

  const TaskTile({
    super.key,
    required this.taskWithSubtasks,
    this.onToggleComplete,
    this.onTap,
    this.onDelete,
    this.gradient,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TaskCard(
        taskWithSubtasks: taskWithSubtasks,
        onToggleComplete: onToggleComplete,
        onTap: onTap,
        onDelete: onDelete,
        gradient: gradient,
        compact: compact,
      ),
    );
  }
}
