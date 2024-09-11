import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../../../domain/entity/project.dart';

class ProjectModel extends Project {
  const ProjectModel({required super.id, required super.name});

  factory ProjectModel.fromPage(Page page) {
    final id = page.id;
    final name = (page.properties['Name'] as TextProperty?)?.value ?? '';

    return ProjectModel(id: id, name: name);
  }
}
