import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resource/colors.dart';
import '../state/selected_action_view_controller.dart';

@immutable
class ActionViewAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ActionViewAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionView = ref.watch(selectedActionViewController);
    return AppBar(
      backgroundColor: backgroundColor,
      title: Text(
        actionView.title,
        style: const TextStyle(
          color: textColor,
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
