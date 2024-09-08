import 'package:notion_db_sdk/notion_db_sdk.dart';
import 'package:notion_db_sdk/src/module/domain/entity/filter.dart';

import '../../../domain/repository/project_repository.dart';
import '../models/project_model.dart';

class NotionProjectRepository implements ProjectRepository {
  const NotionProjectRepository({required this.client});

  final NotionClient client;

  @override
  AsyncProjects fetchAllProjects({
    Filter? filter,
  }) async {
    // ignore: do_not_use_environment
    const projectDatabaseId = String.fromEnvironment('project_database_id');

    final response = await client.fetchAll(projectDatabaseId);

    return response.map<Projects>(
      (value) => value.map(ProjectModel.fromPropertyMap).toList(),
    );
  }
}
