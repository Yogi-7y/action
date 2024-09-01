import 'package:flutter/foundation.dart';

import '../../../domain/entity/task.dart';

@immutable
class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.name,
    required super.status,
    required super.createdAt,
  });
}
