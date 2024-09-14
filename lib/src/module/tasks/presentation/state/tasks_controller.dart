import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';
import '../action_view.dart';

final tasksController =
    AsyncNotifierProvider.family<TasksController, List<Task>, ActionView>(TasksController.new);

class TasksController extends FamilyAsyncNotifier<List<Task>, ActionView> {
  late final _useCase = ref.read(taskUseCaseProvider);

  @override
  FutureOr<List<Task>> build(ActionView arg) async {
    final result = await _fetchTasks(actionView: arg);

    return result;
  }

  Future<List<Task>> _fetchTasks({required ActionView actionView}) async {
    final result = await _useCase.fetchTasks(
      filter: actionView.filter,
    );

    return result.valueOrNull ?? [];
  }

  Future<void> addTask(Task task) async {
    // Optimistically update the UI
    state = AsyncValue.data([task, ...state.value ?? []]);

    final result = await _useCase.createTask(task: task);

    await result.fold(
      onSuccess: (_) async {
        state = await AsyncValue.guard(() => _fetchTasks(actionView: arg));
      },
      onFailure: (error) {
        state = AsyncValue.data(state.value?.where((t) => t != task).toList() ?? []);
      },
    );
  }
}
