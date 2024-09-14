import 'package:flutter/foundation.dart';

import '../../../projects/domain/entity/project.dart';
import '../../presentation/widgets/checkbox.dart';
import 'context.dart';

@immutable
class Task {
  const Task({
    required this.name,
    this.id,
    this.state,
    this.project,
    this.context,
    this.dueDate,
    this.createdAt,
  });

  final String name;
  final String? id;
  final TaskState? state;
  final Project? project;
  final Context? context;
  final DateTime? createdAt;
  final DateTime? dueDate;

  CheckboxState get checkboxState =>
      state == null ? CheckboxState.todo : CheckboxState.fromTaskState(state!);

  @override
  String toString() =>
      'Task(id: $id, name: $name, state: $state, project: $project, context: $context, createdAt: $createdAt, dueDate: $dueDate)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == id &&
          other.name == name &&
          other.state == state &&
          other.project == project &&
          other.context == context &&
          other.createdAt == createdAt &&
          other.dueDate == dueDate);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      state.hashCode ^
      project.hashCode ^
      context.hashCode ^
      createdAt.hashCode ^
      dueDate.hashCode;
}

enum TaskState {
  todo('To-do'),
  awaiting('Awaiting'),
  stalled('Stalled'),
  doNext('Do Next'),
  inProgress('In Progress'),
  done('Done'),
  discard('Discard');

  const TaskState(this.value);

  final String value;

  static TaskState fromString(String value) {
    return TaskState.values.firstWhere(
      (state) => state.value == value,
      orElse: () => TaskState.todo,
    );
  }
}
