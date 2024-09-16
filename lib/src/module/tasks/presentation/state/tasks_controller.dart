import 'dart:async';

import 'package:core_y/core_y.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_y/src/pagination/pagination_params.dart';

import '../../domain/entity/task.dart';
import '../../domain/repository/task_repository.dart';
import '../../domain/use_case/task_use_case.dart';
import '../action_view.dart';
import '../widgets/checkbox.dart';
import 'selected_action_view_controller.dart';

final tasksController =
    AsyncNotifierProvider.family<TasksController, List<Task>, ActionView>(TasksController.new);

class TasksController extends FamilyAsyncNotifier<List<Task>, ActionView> {
  late final _useCase = ref.read(taskUseCaseProvider);

  bool hasMore = true;
  PaginationStrategyParams? paginationParams;

  @override
  FutureOr<Tasks> build(ActionView arg) async {
    final result = await _loadInitial(actionView: arg);

    return result;
  }

  Future<Tasks> _loadInitial({required ActionView actionView}) async {
    final result = await _useCase.fetchTasks(
      filter: actionView.filter,
      paginationParams: const CursorPaginationStrategyParams(limit: 50),
    );

    return result.fold(
      onSuccess: (paginatedResponse) {
        paginationParams = paginatedResponse.paginationParams;
        hasMore = paginatedResponse.hasMore;

        return paginatedResponse.results;
      },
      onFailure: (error) => throw error,
    );
  }

  Future<void> loadMore() async {
    if (!hasMore || paginationParams == null) return;

    final result = await _useCase.fetchTasks(
      filter: ref.read(selectedActionViewController).filter,
      paginationParams: paginationParams,
    );

    result.fold(
      onSuccess: (paginatedResponse) {
        final newTasks = paginatedResponse.results;

        state = AsyncValue.data([...state.value ?? [], ...newTasks]);

        paginationParams = paginatedResponse.paginationParams;
        hasMore = paginatedResponse.hasMore;
      },
      onFailure: (error) => throw error,
    );
  }

  Future<void> addTask(Task task) async {
    // Optimistically update the UI
    state = AsyncValue.data([task, ...state.value ?? []]);

    final result = await _useCase.createTask(task: task);

    await result.fold(
      onSuccess: (_) async => refresh(),
      onFailure: (error) {
        state = AsyncValue.data(state.value?.where((t) => t != task).toList() ?? []);
      },
    );
  }

  @visibleForTesting
  TaskState getNextTodoState(
    TaskState currentState, {
    bool isTap = true,
    bool isDoubleTap = false,
  }) {
    assert(isTap != isDoubleTap, 'Either tap or double tap must be true, but not both');

    final checkboxState = CheckboxState.fromTaskState(currentState);

    if (isTap) {
      if (checkboxState == CheckboxState.todo) return TaskState.done;
      if (checkboxState == CheckboxState.completed) return TaskState.todo;
      if (checkboxState == CheckboxState.inProgress) return TaskState.done;

      return TaskState.todo;
    }

    if (isDoubleTap) {
      if (checkboxState == CheckboxState.todo) return TaskState.inProgress;
      if (checkboxState == CheckboxState.inProgress) return TaskState.todo;

      return TaskState.todo;
    }

    return TaskState.todo;
  }

  Future<void> updateTaskStatus(
    Task task, {
    bool isTap = true,
    bool isDoubleTap = false,
  }) async {
    final taskId = task.id ?? '';

    if (taskId.isEmpty) return;

    // Store the old state for potential rollback
    final previousState = AsyncValue.data(state.value ?? []);

    final newTodoState =
        getNextTodoState(task.state ?? TaskState.todo, isTap: isTap, isDoubleTap: isDoubleTap);

    final updatedTask = task.copyWith(state: newTodoState);

    // Optimistically update the UI
    state = AsyncValue.data(updateTaskInList(task.id ?? '', updatedTask));

    Result<void, AppException> result;

    switch (newTodoState) {
      case TaskState.todo:
        result = await _useCase.markTaskAsTodo(taskId);
      case TaskState.inProgress:
        result = await _useCase.markTaskAsInProgress(taskId);
      case TaskState.done:
        result = await _useCase.markTaskAsComplete(taskId);
      // ignore: no_default_cases
      default:
        result = Failure(
          AppException(exception: 'Invalid state: ${newTodoState}', stackTrace: StackTrace.empty),
        );
    }

    await result.fold(
      onSuccess: (_) async => refresh(),
      onFailure: (error) {
        state = previousState;
      },
    );
  }

  @visibleForTesting
  List<Task> updateTaskInList(
    String taskId,
    Task updatedTask,
  ) =>
      state.value?.map((task) => task.id == taskId ? updatedTask : task).toList() ?? [];

  @visibleForTesting
  Future<void> refresh() async {
    final actionView = ref.read(selectedActionViewController);

    return ref.refresh(tasksController(actionView).future);
  }
}
