import 'dart:async';

import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';
import '../action_view.dart';
import 'selected_action_view_controller.dart';

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
        final actionView = ref.read(selectedActionViewController);

        return ref.refresh(tasksController(actionView).future);
      },
      onFailure: (error) {
        state = AsyncValue.data(state.value?.where((t) => t != task).toList() ?? []);
      },
    );
  }

  Future<void> markTaskAsTodo(String taskId) async {
    await _updateTaskStatus(taskId, _useCase.markTaskAsTodo);
  }

  Future<void> markTaskAsInProgress(String taskId) async {
    await _updateTaskStatus(taskId, _useCase.markTaskAsInProgress);
  }

  Future<void> markTaskAsComplete(String taskId) async {
    await _updateTaskStatus(taskId, _useCase.markTaskAsComplete);
  }

  Future<void> _updateTaskStatus(
    String taskId,
    AsyncResult<void, AppException> Function(String) updateFunction,
  ) async {
    final result = await updateFunction(taskId);

    await result.fold(
      onSuccess: (_) async {
        final actionView = ref.read(selectedActionViewController);
        return ref.refresh(tasksController(actionView).future);
      },
      onFailure: (error) {},
    );
  }
}
