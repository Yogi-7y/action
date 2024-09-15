import 'package:flutter/foundation.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../tasks/presentation/modals/add_action_modal.dart';

@immutable
class Project implements Tokenable {
  const Project({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  String get prefix => ProjectTokenizer.projectPrefix;

  @override
  String get stringValue => name;

  @override
  String toString() => 'Project(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Project && other.id == id && other.name == name);

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
