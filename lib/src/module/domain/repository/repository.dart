import 'package:core_y/core_y.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../../data/notion/repository/repository.dart';
import '../entity/task.dart';

typedef AsyncTasks = AsyncResult<List<Task>, AppException>;
typedef TaskDatabaseId = String;

@immutable
abstract class TaskRepository {
  const TaskRepository();

  AsyncTasks fetchTasks({
    required TaskDatabaseId id,
  });
}

final taskRepository = Provider(
  (ref) {
    const options = NotionOptions(
      secret: String.fromEnvironment('notion_secret'),
      version: '2021-05-13',
    );
    final _client = NotionClient(options: options);

    return NotionRepository(
      client: _client,
    );
  },
);
