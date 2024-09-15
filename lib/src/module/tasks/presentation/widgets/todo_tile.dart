import 'dart:async';

import 'package:flutter/material.dart';
import 'package:core_y/src/extensions/time_ago.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resource/colors.dart';
import '../../domain/entity/task.dart';
import '../state/selected_action_view_controller.dart';
import '../state/tasks_controller.dart';
import 'checkbox.dart';

@immutable
class TodoTile extends ConsumerWidget {
  const TodoTile({
    required this.task,
    super.key,
  });

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = task.project;
    final _context = task.context;

    return GestureDetector(
      onTap: () async => _updateTaskStatus(ref: ref, isTap: true),
      onDoubleTap: () async => _updateTaskStatus(ref: ref, isDoubleTap: true),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCheckbox(state: task.checkboxState),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.name,
                          maxLines: 2,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        task.createdAt?.timeAgo ?? '',
                        style: const TextStyle(
                          color: subText0Color,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (project != null)
                        _TodoTileChip(
                          icon: Icons.hardware_outlined,
                          value: project.name,
                        ),
                      const SizedBox(width: 8),
                      if (_context != null)
                        _TodoTileChip(
                          icon: Icons.label_outline_rounded,
                          value: _context.name,
                        ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTaskStatus({
    required WidgetRef ref,
    bool isTap = false,
    bool isDoubleTap = false,
  }) {
    final selectedActionView = ref.read(selectedActionViewController);
    final taskController = ref.read(tasksController(selectedActionView).notifier);
    unawaited(taskController.updateTaskStatus(
      task,
      isTap: isTap,
      isDoubleTap: isDoubleTap,
    ));
  }
}

class _TodoTileChip extends StatelessWidget {
  const _TodoTileChip({
    required this.icon,
    required this.value,
  });

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: rosewater,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: subText1Color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
