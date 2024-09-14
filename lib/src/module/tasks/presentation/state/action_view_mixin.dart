import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'selected_action_view_controller.dart';
import 'tasks_controller.dart';

mixin ActionViewMixin {
  Future<void> refreshCurrentSelectedView(WidgetRef ref) async {
    final selectedActionView = ref.watch(selectedActionViewController);
    return ref.refresh(tasksController(selectedActionView).future);
  }
}
