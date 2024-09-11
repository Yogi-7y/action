import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../../../../projects/domain/entity/project.dart';
import '../../../domain/entity/context.dart';
import '../../../domain/entity/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.name,
    required super.status,
    required super.project,
    required super.context,
    required super.createdAt,
  });

  factory TaskModel.fromPage(Page page) {
    final id = page.id;
    final properties = page.properties;
    final name = (properties['Name'] as TextProperty?)?.value ?? '';
    final status = (properties['Status'] as Status?)?.value ?? '';

    final createdAt = (properties['Created At'] as CreatedTime?)?.value ?? DateTime.now();

    final projectPage = (properties['Project'] as RelationProperty).value?.first;
    final projectProperties = projectPage?.properties ?? const <String, Property>{};
    final projectName = (projectProperties['Name'] as TextProperty?)?.value ?? '';

    const contextName = 'Some context name here';

    final project = Project(id: 'project-$projectName', name: projectName);
    const context = Context(id: 'context-$contextName', name: contextName);

    return TaskModel(
      id: id,
      name: name,
      status: status,
      project: project,
      context: context,
      createdAt: createdAt,
    );
  }

  factory TaskModel.fromTask(Task task) => TaskModel(
        id: task.id,
        name: task.name,
        status: task.status,
        project: task.project,
        context: task.context,
        createdAt: task.createdAt,
      );

  List<Property> toProperties() {
    final properties = <Property>[];

    if (name.isNotEmpty) {
      properties.add(TextProperty(
        name: 'Name',
        valueDetails: Value(value: name),
        isTitle: true,
      ));
    }

    if (status?.isNotEmpty ?? false) {
      properties.add(Status(
        name: 'Status',
        valueDetails: Value(value: status),
      ));
    }

    if (project != null && project!.id.isNotEmpty) {
      final projectPage = Page(id: project!.id);
      properties.add(RelationProperty(
        name: 'Project',
        valueDetails: Value(value: [projectPage]),
      ));
    }

    if (context != null && context!.id.isNotEmpty) {
      final contextPage = Page(id: context!.id);
      properties.add(RelationProperty(
        name: 'Context',
        valueDetails: Value(value: [contextPage]),
      ));
    }

    return properties;
  }
}
