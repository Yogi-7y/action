import 'package:network_y/src/pagination/pagination_params.dart';
import 'package:core_y/src/exceptions/app_exception.dart';
import 'package:core_y/src/types/result.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

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
      final cursorPaginationParams = paginationParams as CursorPaginationStrategyParams?;

      final notionPaginationParams = cursorPaginationParams != null
          ? CursorPaginationStrategyParams(
              cursor: cursorPaginationParams.cursor,
              limit: cursorPaginationParams.limit,
            )
          : null;

      final result = await client.query(
        _taskDatabaseId,
        filter: filter,
        forceFetchRelationPages: true,
        cacheRelationPages: true,
        paginationParams: notionPaginationParams,
      );

      return result.map((paginatedResult) {
        final pages = paginatedResult.results;

        final tasks = pages.map(TaskModel.fromPage).toList();

        return PaginatedResponse(
          results: tasks,
          paginationParams: paginatedResult.paginationParams,
          hasMore: paginatedResult.hasMore,
        );
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
