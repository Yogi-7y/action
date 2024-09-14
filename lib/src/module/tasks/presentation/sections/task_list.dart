import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repository/task_repository.dart';
import '../state/action_view_list_controller.dart';
import '../state/action_view_mixin.dart';
import '../state/selected_action_view_controller.dart';
import '../state/tasks_controller.dart';
import '../widgets/todo_tile.dart';

class TasksList extends ConsumerStatefulWidget {
  const TasksList({
    super.key,
  });

  @override
  ConsumerState<TasksList> createState() => _TasksListState();
}

class _TasksListState extends ConsumerState<TasksList> {
  late final pageController = PageController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(
        selectedActionViewIndexController,
        (oldIndex, index) {
          final currentPage = pageController.page?.round();

          if (currentPage == index) return;

          unawaited(
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          );
        },
      );
    });
  }

  void _onPageChanged(int index) {
    ref.read(selectedActionViewIndexController.notifier).update((_) => index);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionViews = ref.watch(actionViewList);

    return PageView.builder(
      controller: pageController,
      itemCount: actionViews.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final actionView = actionViews[index];
        return ref.watch(tasksController(actionView)).when(
              data: (tasks) => _TasksList(tasks: tasks),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            );
      },
    );
  }
}

class _TasksList extends ConsumerWidget with ActionViewMixin {
  const _TasksList({required this.tasks});

  final Tasks tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => refreshCurrentSelectedView(ref),
      child: ListView.separated(
        itemCount: tasks.length,
        padding: const EdgeInsets.symmetric(vertical: 12),
        separatorBuilder: (context, index) {
          return const SizedBox(height: 20);
        },
        itemBuilder: (context, index) {
          return TodoTile(
            task: tasks[index],
          );
        },
      ),
    );
  }
}
