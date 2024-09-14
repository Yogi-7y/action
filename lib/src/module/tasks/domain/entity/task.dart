import 'package:flutter/foundation.dart';

import '../../../projects/domain/entity/project.dart';
import '../../presentation/widgets/checkbox.dart';
import 'context.dart';

@immutable
class Task {
  const Task({
    required this.name,
    this.id,
    this.status,
    this.project,
    this.context,
    this.dueDate,
    this.createdAt,
  });

  final String name;
  final String? id;
  final String? status;
  final Project? project;
  final Context? context;
  final DateTime? createdAt;
  final DateTime? dueDate;

  CheckboxState get checkboxState =>
      status == null ? CheckboxState.todo : CheckboxState.fromValue(status!);

  @override
  String toString() =>
      'Task(id: $id, name: $name, status: $status, project: $project, context: $context, createdAt: $createdAt, dueDate: $dueDate)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == id &&
          other.name == name &&
          other.status == status &&
          other.project == project &&
          other.context == context &&
          other.createdAt == createdAt &&
          other.dueDate == dueDate);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      status.hashCode ^
      project.hashCode ^
      context.hashCode ^
      createdAt.hashCode ^
      dueDate.hashCode;
}
