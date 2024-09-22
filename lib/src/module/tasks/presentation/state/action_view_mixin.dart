import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'selected_action_view_provider.dart';
import 'tasks_provider.dart';

mixin ActionViewMixin {
  Future<void> refreshCurrentSelectedView(WidgetRef ref) async {
    final selectedActionView = ref.watch(selectedActionViewController);
    return ref.refresh(tasksController(selectedActionView).future);
  }

  TasksController getTaskController({
    required WidgetRef ref,
  }) {
    final selectedActionView = ref.watch(selectedActionViewController);
    return ref.read(tasksController(selectedActionView).notifier);
  }
}
