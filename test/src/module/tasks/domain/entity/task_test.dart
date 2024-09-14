import 'package:action/src/module/tasks/presentation/widgets/checkbox.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:action/src/module/tasks/domain/entity/task.dart';
import 'package:action/src/module/projects/domain/entity/project.dart';
import 'package:action/src/module/tasks/domain/entity/context.dart';

void main() {
  group('Task', () {
    test('creates a Task instance with all properties', () {
      final now = DateTime.now();
      final dueDate = now.add(const Duration(days: 1));
      final task = Task(
        id: '1',
        name: 'Test Task',
        status: 'In Progress',
        project: const Project(id: 'p1', name: 'Project 1'),
        context: const Context(id: 'c1', name: 'Context 1'),
        createdAt: now,
        dueDate: dueDate,
      );

      expect(task.id, '1');
      expect(task.name, 'Test Task');
      expect(task.status, 'In Progress');
      expect(task.project, const Project(id: 'p1', name: 'Project 1'));
      expect(task.context, const Context(id: 'c1', name: 'Context 1'));
      expect(task.createdAt, now);
      expect(task.dueDate, dueDate);
    });

    test('creates a Task instance with minimal properties', () {
      const task = Task(name: 'Minimal Task');

      expect(task.name, 'Minimal Task');
      expect(task.id, isNull);
      expect(task.status, isNull);
      expect(task.project, isNull);
      expect(task.context, isNull);
      expect(task.createdAt, isNull);
      expect(task.dueDate, isNull);
    });

    test('checkboxState returns correct state based on status', () {
      const todoTask = Task(name: 'Todo Task', status: 'todo');
      const inProgressTask = Task(name: 'In Progress Task', status: 'In Progress');
      const completedTask = Task(name: 'Completed Task', status: 'Completed');

      expect(todoTask.checkboxState, CheckboxState.todo);
      expect(inProgressTask.checkboxState, CheckboxState.inProgress);
      expect(completedTask.checkboxState, CheckboxState.completed);
    });

    test('toString returns correct string representation', () {
      final task = Task(
        id: '1',
        name: 'Test Task',
        status: 'In Progress',
        project: const Project(id: 'p1', name: 'Project 1'),
        context: const Context(id: 'c1', name: 'Context 1'),
        createdAt: DateTime(2023, 1, 1),
        dueDate: DateTime(2023, 1, 2),
      );

      expect(task.toString(),
          'Task(id: 1, name: Test Task, status: In Progress, project: Project(id: p1, name: Project 1), context: Context(id: c1, name: Context 1), createdAt: 2023-01-01 00:00:00.000, dueDate: 2023-01-02 00:00:00.000)');
    });

    test('equality and hashCode', () {
      final task1 = Task(
        id: '1',
        name: 'Test Task',
        status: 'In Progress',
        project: const Project(id: 'p1', name: 'Project 1'),
        context: const Context(id: 'c1', name: 'Context 1'),
        createdAt: DateTime(2023, 1, 1),
        dueDate: DateTime(2023, 1, 2),
      );

      final task2 = Task(
        id: '1',
        name: 'Test Task',
        status: 'In Progress',
        project: const Project(id: 'p1', name: 'Project 1'),
        context: const Context(id: 'c1', name: 'Context 1'),
        createdAt: DateTime(2023, 1, 1),
        dueDate: DateTime(2023, 1, 2),
      );

      final task3 = Task(
        id: '2',
        name: 'Different Task',
        status: 'Todo',
        project: const Project(id: 'p2', name: 'Project 2'),
        context: const Context(id: 'c2', name: 'Context 2'),
        createdAt: DateTime(2023, 1, 3),
        dueDate: DateTime(2023, 1, 4),
      );

      expect(task1, equals(task2));
      expect(task1.hashCode, equals(task2.hashCode));
      expect(task1, isNot(equals(task3)));
      expect(task1.hashCode, isNot(equals(task3.hashCode)));
    });
  });
}
