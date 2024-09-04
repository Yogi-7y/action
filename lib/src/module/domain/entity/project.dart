import 'package:flutter/foundation.dart';

@immutable
class Project {
  const Project({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  String toString() => 'Project(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Project && other.id == id && other.name == name);

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
