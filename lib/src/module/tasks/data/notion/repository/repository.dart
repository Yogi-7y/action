import 'package:core_y/src/exceptions/app_exception.dart';
import 'package:core_y/src/types/result.dart';
import 'package:flutter/foundation.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../../../domain/entity/task.dart';
import '../../../domain/repository/task_repository.dart';
import '../models/task_model.dart';

@immutable
class NotionRepository extends TaskRepository {
  const NotionRepository({required this.client});

  final NotionClient client;

  // ignore: avoid_field_initializers_in_const_classes, do_not_use_environment
  final _taskDatabaseId = const String.fromEnvironment('task_database_id');

  @override
  AsyncTasks fetchTasks({
    Filter? filter,
  }) async {
    try {
      final _result = await client.query(
        _taskDatabaseId,
        filter: filter,
        forceFetchRelationPages: true,
        cacheRelationPages: true,
      );

      return _result.map<List<Task>>((value) {
        final tasks = value.map((e) {
          return TaskModel.fromPage(e);
        }).toList();

        return tasks;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  AsyncResult<void, AppException> createTask({required Task task}) {
    throw UnimplementedError();
  }
}
