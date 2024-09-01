import 'package:flutter/foundation.dart';

@immutable
class Task {
  const Task({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String status;
  final DateTime createdAt;

  @override
  String toString() => 'Task(id: $id, name: $name, status: $status, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == id &&
          other.name == name &&
          other.status == status &&
          other.createdAt == createdAt);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ status.hashCode ^ createdAt.hashCode;
}
