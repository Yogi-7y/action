import 'package:flutter/foundation.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../../../domain/entity/task.dart';
import '../../../domain/repository/repository.dart';
import '../models/task_model.dart';

@immutable
class NotionRepository extends TaskRepository {
  const NotionRepository({required this.client});

  final NotionClient client;

  @override
  AsyncTasks fetchTasks({
    required TaskDatabaseId id,
  }) async {
    try {
      final filter = CheckboxFilter(
        'Inbox',
        equals: true,
      );

      final _result = await client.query(
        id,
        filter: filter,
        forceFetchRelationPages: true,
        cacheRelationPages: true,
      );

      return _result.map<List<Task>>((value) {
        final tasks = value.map((e) {
          return TaskModel.fromPropertyMap(e);
        }).toList();

        return tasks;
      });
    } catch (e) {
      rethrow;
    }
  }
}
