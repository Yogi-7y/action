import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../projects/domain/repository/project_repository.dart';
import '../../../projects/domain/use_case/project_use_case.dart';

final projectsController = AsyncNotifierProvider<ProjectsController, Projects>(
  ProjectsController.new,
);

class ProjectsController extends AsyncNotifier<Projects> {
  late final usecase = ref.read(projectUseCase);

  @override
  FutureOr<Projects> build() async {
    final result = await usecase.fetchAllProjects();

    return result.valueOrNull ?? [];
  }
}
