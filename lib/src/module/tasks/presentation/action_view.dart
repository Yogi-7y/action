import 'package:flutter/material.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

@immutable
abstract class ActionView {
  const ActionView({
    required this.title,
    required this.selectorText,
    this.filter,
    this.icon,
  });

  final String title;
  final String selectorText;
  final Filter? filter;
  final IconData? icon;

  @override
  String toString() =>
      'ActionView(title: $title, selectorText: $selectorText, filter: $filter, icon: $icon)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActionView &&
          other.title == title &&
          other.selectorText == selectorText &&
          other.filter == filter &&
          other.icon == icon);

  @override
  int get hashCode => title.hashCode ^ selectorText.hashCode ^ filter.hashCode ^ icon.hashCode;
}

@immutable
class TaskView extends ActionView {
  const TaskView({
    required super.title,
    required super.selectorText,
    super.filter,
    super.icon,
  });
}
