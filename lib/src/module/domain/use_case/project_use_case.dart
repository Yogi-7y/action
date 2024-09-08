import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../repository/project_repository.dart';

@immutable
class ProjectUseCase {
  const ProjectUseCase({required this.repository});

  final ProjectRepository repository;

  AsyncProjects fetchAllProjects({
    Filter? filter,
  }) =>
      repository.fetchAllProjects(
        filter: filter,
      );
}

final projectUseCase = Provider(
  (ref) {
    final repository = ref.read(projectRepository);
    return ProjectUseCase(repository: repository);
  },
);
