import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repository/repository.dart';
import '../state/tasks_controller.dart';
import '../widgets/todo_tile.dart';

class TasksList extends ConsumerWidget {
  const TasksList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tasksController).when(
          data: (tasks) {
            return _TasksList(tasks: tasks);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Center(
            child: Text('Error: $error'),
          ),
        );
  }
}

class _TasksList extends StatelessWidget {
  const _TasksList({required this.tasks});

  final Tasks tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tasks.length,
      padding: const EdgeInsets.only(top: 12),
      separatorBuilder: (context, index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (context, index) {
        return TodoTile(
          task: tasks[index],
        );
      },
    );
  }
}
