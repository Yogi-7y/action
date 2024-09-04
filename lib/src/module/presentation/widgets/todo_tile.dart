import 'package:flutter/material.dart';

import '../../../core/resource/colors.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCheckbox(state: task.checkboxState),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.hardware_outlined,
                          color: rosewater,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.project.name,
                          style: const TextStyle(
                            color: subText1Color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.label_outline_rounded,
                          color: rosewater,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task.context.name,
                          style: const TextStyle(
                            color: subText1Color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Text(
                      '2d Ago',
                      style: TextStyle(
                        color: subText1Color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
