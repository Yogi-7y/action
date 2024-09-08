import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../action_view.dart';
import 'action_view_list_controller.dart';

final selectedActionViewIndex = StateProvider<int>((ref) => 0);

final selectedActionView = Provider<ActionView>((ref) {
  final actionViews = ref.watch(actionViewList);

  final index = ref.watch(selectedActionViewIndex);
  return actionViews[index];
});
