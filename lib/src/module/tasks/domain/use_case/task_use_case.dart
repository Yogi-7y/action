import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

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
}

final taskUseCase = Provider(
  (ref) => TaskUseCase(repository: ref.read(taskRepository)),
);
