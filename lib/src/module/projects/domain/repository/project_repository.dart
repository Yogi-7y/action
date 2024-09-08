import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../../data/notion/repository/project_repository.dart';
import '../entity/project.dart';

typedef Projects = List<Project>;
typedef AsyncProjects = AsyncResult<Projects, AppException>;
typedef ProjectDatabaseId = String;

abstract class ProjectRepository {
  const ProjectRepository();

  AsyncProjects fetchAllProjects({
    Filter? filter,
  });
}

final projectRepository = Provider(
  (ref) {
    const options = NotionOptions(
      // ignore: do_not_use_environment
      secret: String.fromEnvironment('notion_secret'),
      version: '2021-05-13',
    );

    final _client = NotionClient(options: options);

    return NotionProjectRepository(
      client: _client,
    );
  },
);
