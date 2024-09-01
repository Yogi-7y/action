import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';

final tasksController = FutureProvider<List<Task>>(
  (ref) async {
    final _useCase = ref.read(taskUseCase);
    const _taskDatabaseId = '3013396e180246fbb30b51b75e87c27c';

    final result = await _useCase.fetchTasks(id: _taskDatabaseId);

    return result.valueOrNull ?? [];
  },
);
