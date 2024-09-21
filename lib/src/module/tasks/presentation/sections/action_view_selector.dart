import 'dart:async';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resource/colors.dart';
import '../action_view.dart';
import '../modals/add_action_modal.dart';
import '../state/action_view_list_controller.dart';
import '../state/selected_action_view_controller.dart';

class ActionViewSelector extends ConsumerStatefulWidget {
  const ActionViewSelector({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActionViewSelectorState();
}

class _ActionViewSelectorState extends ConsumerState<ActionViewSelector> with ActionViewModal {
  late final _scrollController = ScrollController();
  final _selectorItemKeys = <GlobalKey>[];

  @override
  void initState() {
    super.initState();

    _initializeItemKeys();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(selectedActionViewIndexController, (oldIndex, index) async {
        _scrollToSelectedItem();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedItem() {
    final selectedIndex = ref.read(selectedActionViewIndexController);

    if (selectedIndex < 0 || selectedIndex >= _selectorItemKeys.length) return;

    final _itemContext = _selectorItemKeys[selectedIndex].currentContext;
    if (_itemContext == null) return;

    unawaited(Scrollable.ensureVisible(
      _itemContext,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.7,
    ));
  }

  void _initializeItemKeys() {
    final actionViews = ref.read(actionViewList);
    _selectorItemKeys
      ..clear()
      ..addAll(List.generate(actionViews.length, (_) => GlobalKey()));
  }

  @override
  Widget build(BuildContext context) {
    final actionViews = ref.watch(actionViewList);

    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: surface0,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 12,
                  cornerSmoothing: 1,
                ),
                side: const BorderSide(color: surface0, width: 2),
              ),
            ),
            child: ClipSmoothRect(
              radius: SmoothBorderRadius(cornerRadius: 12, cornerSmoothing: 1),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Row(
                  children: List.generate(
                    actionViews.length,
                    (index) {
                      final actionView = actionViews[index];
                      return _ActionSelectorItem(
                        actionView: actionView,
                        index: index,
                        key: _selectorItemKeys[index],
                      );
                    },
                  ),
                ),
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

class _ActionSelectorItem extends ConsumerWidget {
  const _ActionSelectorItem({
    required this.actionView,
    required this.index,
    super.key,
  });

  final TaskView actionView;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedActionViewIndexController);
    final isSelected = selectedIndex == index;

    final color = isSelected ? backgroundColor.withOpacity(.7) : surface0;

    return GestureDetector(
      onTap: () => ref.read(selectedActionViewIndexController.notifier).update((value) => index),
      child: Container(
        height: 60,
        width: 60,
        decoration: ShapeDecoration(
          color: color,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 12,
              cornerSmoothing: 1,
            ),
          ),
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
