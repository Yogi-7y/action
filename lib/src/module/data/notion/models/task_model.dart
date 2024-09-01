import 'package:flutter/foundation.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

import '../../../domain/entity/task.dart';

@immutable
class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.name,
    required super.status,
    required super.createdAt,
  });

  factory TaskModel.fromPropertyMap(Map<String, Property> map) {
    final name = (map['Name'] as TextProperty?)?.value ?? '';
    final status = (map['Status'] as Status?)?.value ?? '';
    final createdAt = (map['Created At'] as CreatedTime?)?.value;

    return TaskModel(
      id: 'random-id',
      name: name,
      status: status,
      createdAt: createdAt!,
    );
  }
}
