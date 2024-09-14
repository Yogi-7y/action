import 'package:flutter/material.dart';
import 'package:core_y/src/extensions/time_ago.dart';

import '../../../../core/resource/colors.dart';
import '../../domain/entity/task.dart';
import 'checkbox.dart';

@immutable
class TodoTile extends StatelessWidget {
  const TodoTile({
    required this.task,
    super.key,
  });

  final Task task;

  @override
  Widget build(BuildContext context) {
    final project = task.project;
    final context = task.context;

    return Padding(
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
                Text(
                  task.name,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
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
                    if (context != null)
                      _TodoTileChip(
                        icon: Icons.label_outline_rounded,
                        value: context.name,
                      ),
                    const Spacer(),
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
              ],
            ),
          ),
        ],
      ),
    );
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
