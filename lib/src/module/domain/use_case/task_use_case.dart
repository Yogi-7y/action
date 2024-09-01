import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/repository.dart';

@immutable
class TaskUseCase {
  const TaskUseCase({required this.repository});

  final TaskRepository repository;

  AsyncTasks fetchTasks({
    required TaskDatabaseId id,
  }) =>
      repository.fetchTasks(id: id);
}

final taskUseCase = Provider(
  (ref) => TaskUseCase(repository: ref.read(taskRepository)),
);
