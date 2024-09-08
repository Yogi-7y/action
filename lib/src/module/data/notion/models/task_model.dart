import 'package:notion_db_sdk/notion_db_sdk.dart';
import '../../../domain/entity/context.dart';
import '../../../projects/domain/entity/project.dart';
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

  factory TaskModel.fromPropertyMap(Map<String, Property> map) {
    final id = map['id']?.id ?? '';
    final name = (map['Name'] as TextProperty?)?.value ?? '';
    final status = (map['Status'] as Status?)?.value ?? '';

    final createdAt = (map['Created At'] as CreatedTime?)?.value ?? DateTime.now();

    final projectPage = (map['Project'] as RelationProperty).value?.first;
    final projectProperties = projectPage?.properties ?? const <String, Property>{};
    final projectName = (projectProperties['Name'] as TextProperty?)?.value ?? '';

    final contextName = 'Some context name here';

    final project = Project(id: 'project-$projectName', name: projectName);
    final context = Context(id: 'context-$contextName', name: contextName);

    return TaskModel(
      id: id,
      name: name,
      status: status,
      project: project,
      context: context,
      createdAt: createdAt,
    );
  }
}
