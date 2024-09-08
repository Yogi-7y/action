import 'package:flutter/foundation.dart';

import '../../presentation/widgets/checkbox.dart';
import 'context.dart';
import '../../../projects/domain/entity/project.dart';

@immutable
class Task {
  const Task({
    required this.id,
    required this.name,
    required this.status,
    required this.project,
    required this.context,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String status;
  final Project project;
  final Context context;
  final DateTime createdAt;

  CheckboxState get checkboxState => CheckboxState.fromValue(status);

  @override
  String toString() =>
      'Task(id: $id, name: $name, status: $status, project: $project, context: $context, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == id &&
          other.name == name &&
          other.status == status &&
          other.project == project &&
          other.context == context &&
          other.createdAt == createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      status.hashCode ^
      project.hashCode ^
      context.hashCode ^
      createdAt.hashCode;
}
