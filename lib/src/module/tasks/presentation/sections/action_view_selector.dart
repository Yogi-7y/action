import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resource/colors.dart';
import '../modals/add_action_modal.dart';
import '../state/action_view_list_controller.dart';
import '../state/selected_action_view_controller.dart';

class ActionViewSelector extends ConsumerWidget with ActionViewModal {
  const ActionViewSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionViews = ref.watch(actionViewList);

    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: surface0,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: List.generate(
                actionViews.length,
                (index) {
                  final actionView = actionViews[index];
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => ref
                            .read(selectedActionViewIndexController.notifier)
                            .update((value) => index),
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: surface0,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: actionView.icon != null
                                ? Icon(
                                    actionView.icon,
                                    size: 28,
                                    color: textColor,
                                  )
                                : Text(
                                    actionView.title,
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        const AddActionWidget(),
        const SizedBox(width: 8),
      ],
    );
  }
}

@immutable
class AddActionWidget extends StatelessWidget with ActionViewModal {
  const AddActionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => addNewAction(context: context),
      child: Container(
        height: 60,
        width: 60,
        decoration: ShapeDecoration(
          color: maroon,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 12,
              cornerSmoothing: 1,
            ),
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
