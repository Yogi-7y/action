import 'package:action/src/module/projects/domain/entity/project.dart';
import 'package:action/src/module/tasks/data/notion/models/task_model.dart';
import 'package:action/src/module/tasks/domain/entity/context.dart';
import 'package:action/src/module/tasks/domain/entity/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

void main() {
  group('TaskModel', () {
    test('fromPage creates a TaskModel instance from a Notion Page', () {
      final page = Page(
        id: '1',
        properties: {
          'Name': const TextProperty(name: 'Name', valueDetails: Value(value: 'Test Task')),
          'Status': const Status(name: 'Status', valueDetails: Value(value: 'In Progress')),
          'Created At': CreatedTime(name: 'Created At', valueDetails: Value(value: DateTime(2024))),
          'Due Date': Date(name: 'Due Date', valueDetails: Value(value: DateTime(2024, 1, 2))),
          'Project': RelationProperty(
            name: 'Project',
            valueDetails: Value(value: [
              Page(
                id: 'p1',
                properties: {
                  'Name': const TextProperty(name: 'Name', valueDetails: Value(value: 'Project 1'))
                },
              ),
            ]),
          ),
          'Context': RelationProperty(
            name: 'Context',
            valueDetails: Value(value: [
              Page(
                id: 'c1',
                properties: {
                  'Name': const TextProperty(name: 'Name', valueDetails: Value(value: 'Context 1'))
                },
              ),
            ]),
          ),
        },
      );

      final taskModel = TaskModel.fromPage(page);

      expect(taskModel.id, '1');
      expect(taskModel.name, 'Test Task');
      expect(taskModel.state, TaskState.inProgress);
      expect(taskModel.createdAt, DateTime(2024));
      expect(taskModel.dueDate, DateTime(2024, 1, 2));
      expect(taskModel.project, const Project(id: 'p1', name: 'Project 1'));
      expect(taskModel.context, const Context(id: 'c1', name: 'Context 1'));
    });

    test('fromTask creates a TaskModel instance from a Task entity', () {
      final task = Task(
        id: '1',
        name: 'Test Task',
        state: TaskState.inProgress,
        project: const Project(id: 'p1', name: 'Project 1'),
        context: const Context(id: 'c1', name: 'Context 1'),
        createdAt: DateTime(2024),
        dueDate: DateTime(2024, 1, 2),
      );

      final taskModel = TaskModel.fromTask(task);

      expect(taskModel.id, '1');
      expect(taskModel.name, 'Test Task');
      expect(taskModel.state, TaskState.inProgress);
      expect(taskModel.project, const Project(id: 'p1', name: 'Project 1'));
      expect(taskModel.context, const Context(id: 'c1', name: 'Context 1'));
      expect(taskModel.createdAt, DateTime(2024));
      expect(taskModel.dueDate, DateTime(2024, 1, 2));
    });

    test('toProperties creates correct Notion properties', () {
      final taskModel = TaskModel(
        id: '1',
        name: 'Test Task',
        state: TaskState.inProgress,
        project: const Project(id: 'p1', name: 'Project 1'),
        context: const Context(id: 'c1', name: 'Context 1'),
        createdAt: DateTime(2024),
        dueDate: DateTime(2024, 1, 2),
      );

      final properties = taskModel.toProperties();

      expect(properties.length, 5);
      expect(properties[0], isA<TextProperty>());
      expect(properties[1], isA<Status>());
      expect(properties[2], isA<RelationProperty>());
      expect(properties[3], isA<RelationProperty>());
      expect(properties[4], isA<Date>());

      final nameProperty = properties[0] as TextProperty;
      expect(nameProperty.name, 'Name');
      expect(nameProperty.valueDetails?.value, 'Test Task');
      expect(nameProperty.isTitle, true);

      final statusProperty = properties[1] as Status;
      expect(statusProperty.name, 'Status');
      expect(statusProperty.valueDetails?.value, 'In Progress');

      final projectProperty = properties[2] as RelationProperty;
      expect(projectProperty.name, 'Project');
      expect(projectProperty.value?.first.id, 'p1');

      final contextProperty = properties[3] as RelationProperty;
      expect(contextProperty.name, 'Context');
      expect(contextProperty.value?.first.id, 'c1');

      final dueDateProperty = properties[4] as Date;
      expect(dueDateProperty.name, 'Due Date');
      expect(dueDateProperty.valueDetails?.value, DateTime(2024, 1, 2));
    });

    test('toProperties omits properties with empty values', () {
      const taskModel = TaskModel(
        id: '1',
        name: 'Test Task',
      );

      final properties = taskModel.toProperties();

      expect(properties.length, 1);
      expect(properties[0], isA<TextProperty>());

      final nameProperty = properties[0] as TextProperty;
      expect(nameProperty.name, 'Name');
      expect(nameProperty.valueDetails?.value, 'Test Task');
      expect(nameProperty.isTitle, true);
    });
  });
}
