import 'package:action/src/module/projects/domain/entity/project.dart';
import 'package:action/src/module/tasks/data/notion/models/task_model.dart';
import 'package:action/src/module/tasks/domain/entity/context.dart';
import 'package:action/src/module/tasks/domain/entity/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

void main() {
  group('Task toProperties method', () {
    test('returns correct properties for a fully populated task', () {
      final task = Task(
        id: '123',
        name: 'Test Task',
        status: 'In Progress',
        project: const Project(id: 'proj1', name: 'Test Project'),
        context: const Context(id: 'ctx1', name: 'Test Context'),
        createdAt: DateTime(2023),
      );

      final properties = TaskModel.fromTask(task).toProperties();

      expect(properties.length, 4);
      expect(properties[0], isA<TextProperty>());
      expect(properties[1], isA<Status>());
      expect(properties[2], isA<RelationProperty>());
      expect(properties[3], isA<RelationProperty>());

      final nameProperty = properties[0] as TextProperty;
      expect(nameProperty.name, 'Name');
      expect(nameProperty.valueDetails?.value, 'Test Task');
      expect(nameProperty.isTitle, true);
    });

    test('omits properties with empty values', () {
      final task = Task(
        id: '123',
        name: '',
        status: '',
        project: const Project(id: '', name: ''),
        context: const Context(id: '', name: ''),
        createdAt: DateTime(2023),
      );

      final properties = TaskModel.fromTask(task).toProperties();

      expect(properties.length, 0);
    });

    test('includes only non-empty properties', () {
      final task = Task(
        name: 'Test Task',
        status: '',
        project: const Project(id: 'proj1', name: 'Test Project'),
        context: const Context(id: '', name: ''),
        createdAt: DateTime(2023),
      );

      final properties = TaskModel.fromTask(task).toProperties();

      expect(properties.length, 2);
      expect(properties[0], isA<TextProperty>());
      expect(properties[1], isA<RelationProperty>());

      final nameProperty = properties[0] as TextProperty;
      expect(nameProperty.name, 'Name');
      expect(nameProperty.valueDetails?.value, 'Test Task');

      final projectProperty = properties[1] as RelationProperty;
      expect(projectProperty.name, 'Project');
      expect(projectProperty.value?.first.id, 'proj1');
    });

    test('does not include createdAt property', () {
      final task = Task(
        id: '123',
        name: 'Test Task',
        status: 'In Progress',
        project: const Project(id: 'proj1', name: 'Test Project'),
        context: const Context(id: 'ctx1', name: 'Test Context'),
        createdAt: DateTime(2023),
      );

      final properties = TaskModel.fromTask(task).toProperties();
      expect(properties.any((p) => p is CreatedTime), false);
    });
  });
}
