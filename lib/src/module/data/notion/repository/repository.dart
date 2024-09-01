import 'package:flutter/foundation.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../../../domain/entity/task.dart';
import '../../../domain/repository/repository.dart';

@immutable
class NotionRepository extends TaskRepository {
  const NotionRepository({required this.client});

  final NotionClient client;

  @override
  AsyncTasks fetchTasks({
    required TaskDatabaseId id,
  }) async {
    try {
      final _result = await client.getProperties(id);

      return _result.map<List<Task>>((value) {
        return <Task>[];
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
