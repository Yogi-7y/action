import 'package:core_y/core_y.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../entity/task.dart';
import '../repository/task_repository.dart';

@immutable
class TaskUseCase {
  const TaskUseCase({required this.repository});

  final TaskRepository repository;

  AsyncTasks fetchTasks({
    Filter? filter,
  }) =>
      repository.fetchTasks(
        filter: filter,
      );

  AsyncResult<void, AppException> createTask({
    required Task task,
  }) =>
      repository.createTask(task: task);

  AsyncResult<void, AppException> markTaskAsTodo(String taskId) => repository.updateTask(
        taskId: taskId,
        properties: [const Status(name: 'Status', valueDetails: Value(value: 'To-do'))],
      );

  AsyncResult<void, AppException> markTaskAsInProgress(String taskId) => repository.updateTask(
        taskId: taskId,
        properties: [const Status(name: 'Status', valueDetails: Value(value: 'In Progress'))],
      );

  AsyncResult<void, AppException> markTaskAsComplete(String taskId) => repository.updateTask(
        taskId: taskId,
        properties: [const Status(name: 'Status', valueDetails: Value(value: 'Done'))],
      );
}

final taskUseCaseProvider = Provider(
  (ref) => TaskUseCase(repository: ref.read(taskRepository)),
);
