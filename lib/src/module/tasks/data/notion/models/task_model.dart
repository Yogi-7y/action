import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../../../../projects/domain/entity/project.dart';
import '../../../domain/entity/context.dart';
import '../../../domain/entity/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.name,
    super.state,
    super.project,
    super.context,
    super.dueDate,
    super.createdAt,
  });

  factory TaskModel.fromPage(Page page) {
    final id = page.id;
    final properties = page.properties;
    final name = (properties['Name'] as TextProperty?)?.value ?? '';

    final statusValue = (properties['Status'] as Status?)?.value ?? '';
    final state = TaskState.fromString(statusValue);

    final createdAt = (properties['Created At'] as CreatedTime?)?.value ?? DateTime.now();
    final dueDate = (properties['Due Date'] as Date?)?.value; // New field

    final projectRelation = (properties['Project'] as RelationProperty?)?.value ?? [];
    final projectPage = projectRelation.isNotEmpty ? projectRelation.first : null;
    final projectProperties = projectPage?.properties ?? const <String, Property>{};
    final projectName = (projectProperties['Name'] as TextProperty?)?.value ?? '';

    final contextRelation = (properties['Context'] as RelationProperty?)?.value ?? []; // New field
    final contextPage = contextRelation.isNotEmpty ? contextRelation.first : null;
    final contextProperties = contextPage?.properties ?? const <String, Property>{};
    final contextName = (contextProperties['Name'] as TextProperty?)?.value ?? '';

    final project = projectPage == null ? null : Project(id: projectPage.id, name: projectName);

    final context = contextPage == null ? null : Context(id: contextPage.id, name: contextName);

    return TaskModel(
      id: id,
      name: name,
      state: state,
      project: project,
      context: context,
      createdAt: createdAt,
      dueDate: dueDate,
    );
  }

  factory TaskModel.fromTask(Task task) => TaskModel(
        id: task.id,
        name: task.name,
        state: task.state,
        project: task.project,
        context: task.context,
        createdAt: task.createdAt,
        dueDate: task.dueDate,
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

    if (state != null) {
      properties.add(Status(
        name: 'Status',
        valueDetails: Value(value: state!.value),
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

    if (dueDate != null) {
      properties.add(Date(
        name: 'Due Date',
        valueDetails: Value(value: dueDate),
      ));
    }

    return properties;
  }
}
