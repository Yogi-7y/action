import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../action_view.dart';
import 'action_view_list_provider.dart';

final selectedActionViewIndexController = StateProvider<int>((ref) => 0);

final selectedActionViewController = Provider<ActionView>((ref) {
  final actionViews = ref.watch(actionViewListProvider);

  final index = ref.watch(selectedActionViewIndexController);
  return actionViews[index];
});
