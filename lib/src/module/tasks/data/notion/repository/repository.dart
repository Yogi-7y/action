import 'package:core_y/src/exceptions/app_exception.dart';
import 'package:core_y/src/types/result.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../../../../../core/api/pagination_params.dart';
import '../../../domain/entity/task.dart';
import '../../../domain/repository/task_repository.dart';
import '../models/task_model.dart';

class NotionRepository extends TaskRepository {
  NotionRepository({required this.client});

  final NotionClient client;
  // ignore: do_not_use_environment
  final _taskDatabaseId = const String.fromEnvironment('task_database_id');

  @override
  AsyncTasks fetchTasks({
    Filter? filter,
    PaginationStrategyParams? paginationParams,
  }) async {
    try {
      final cursorPaginationParams = paginationParams as CursorBasedStrategyParams?;

      final notionPaginationParams = cursorPaginationParams != null
          ? PaginationParams(
              startCursor: cursorPaginationParams.cursor,
              pageSize: cursorPaginationParams.limit,
            )
          : null;

      final _result = await client.query(
        _taskDatabaseId,
        filter: filter,
        forceFetchRelationPages: true,
        cacheRelationPages: true,
        paginationParams: notionPaginationParams,
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
  AsyncResult<void, AppException> createTask({
    required Task task,
  }) async {
    final properties = TaskModel.fromTask(task).toProperties();

    return client.createPage(
      databaseId: _taskDatabaseId,
      properties: properties,
    );
  }

  @override
  AsyncResult<void, AppException> updateTask({
    required String taskId,
    required List<Property<Object>> properties,
  }) async {
    final result = await client.updatePage(
      pageId: taskId,
      properties: properties,
    );

    return result;
  }

  @override
  AsyncTasks fetchMoreTasks() {
    throw UnimplementedError();
  }
}
