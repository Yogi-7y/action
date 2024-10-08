import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_y/src/pagination/pagination_params.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../../data/notion/repository/repository.dart';
import '../entity/task.dart';

typedef Tasks = List<Task>;
typedef AsyncTasks = AsyncResult<PaginatedResponse<Task>, AppException>;
typedef TaskDatabaseId = String;

abstract class TaskRepository {
  const TaskRepository();

  AsyncTasks fetchTasks({
    Filter? filter,
    PaginationStrategyParams? paginationParams,
  });

  AsyncTasks fetchMoreTasks();

  AsyncResult<void, AppException> createTask({
    required Task task,
  });

  AsyncResult<void, AppException> updateTask({
    required String taskId,
    required List<Property> properties,
  });
}

final taskRepository = Provider(
  (ref) {
    const options = NotionOptions(
      // ignore: do_not_use_environment
      secret: String.fromEnvironment('notion_secret'),
      version: '2022-06-28',
    );
    final _client = NotionClient(options: options);

    return NotionRepository(client: _client);
  },
);
