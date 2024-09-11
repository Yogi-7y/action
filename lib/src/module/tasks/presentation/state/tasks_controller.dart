import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';
import '../action_view.dart';

final tasksController = FutureProvider.family<List<Task>, ActionView>(
  (ref, actionView) async {
    final _useCase = ref.read(taskUseCaseProvider);

    final result = await _useCase.fetchTasks(
      filter: actionView.filter,
    );

    return result.valueOrNull ?? [];
  },
);
