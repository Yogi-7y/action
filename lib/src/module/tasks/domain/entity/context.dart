import 'package:flutter/foundation.dart';

@immutable
class Context {
  const Context({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  String toString() => 'Context(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Context && other.id == id && other.name == name);

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
