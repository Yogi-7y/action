import 'package:flutter/material.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

@immutable
abstract class ActionView {
  const ActionView({
    required this.title,
    required this.selectorText,
    this.filter,
  });

  final String title;
  final String selectorText;
  final Filter? filter;
}

@immutable
class TaskView extends ActionView {
  const TaskView({
    required super.title,
    required super.selectorText,
    super.filter,
  });
}
