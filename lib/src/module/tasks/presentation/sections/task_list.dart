import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/resource/colors.dart';
import '../../domain/repository/task_repository.dart';
import '../state/action_view_list_provider.dart';
import '../state/action_view_mixin.dart';
import '../state/selected_action_view_provider.dart';
import '../state/tasks_provider.dart';
import '../widgets/todo_tile.dart';

class TasksList extends ConsumerStatefulWidget {
  const TasksList({
    super.key,
  });

  @override
  ConsumerState<TasksList> createState() => _TasksListState();
}

class _TasksListState extends ConsumerState<TasksList> {
  late final pageController = PageController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncPageController();
    });
  }

  void _onPageChanged(int index) {
    ref.read(selectedActionViewIndexController.notifier).update((_) => index);
  }

  void _syncPageController() => ref.listenManual(
        selectedActionViewIndexController,
        (oldIndex, index) async {
          final currentPage = pageController.page?.round();

          if (currentPage == index) return;

          pageController.jumpToPage(index);
        },
      );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionViews = ref.watch(actionViewListProvider);

    return PageView.builder(
      controller: pageController,
      itemCount: actionViews.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final actionView = actionViews[index];
        return ref.watch(tasksController(actionView)).when(
              data: (tasks) => _TasksListData(tasks: tasks),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            );
      },
    );
  }
}

class _TasksListData extends ConsumerStatefulWidget {
  const _TasksListData({
    required this.tasks,
  });

  final Tasks tasks;

  @override
  ConsumerState<_TasksListData> createState() => _TasksListDataState();
}

class _TasksListDataState extends ConsumerState<_TasksListData> with ActionViewMixin {
  late final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(_handlePagination);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _handlePagination() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (!mounted) return;

      final controller = getTaskController(ref: ref);
      unawaited(controller.loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = getTaskController(ref: ref);
    final hasMore = controller.hasMore;

    return Stack(
      children: [
        const _TaskLinearLoadingIndicator(),
        RefreshIndicator(
          onRefresh: () async => refreshCurrentSelectedView(ref),
          child: ListView.separated(
            controller: scrollController,
            itemCount: widget.tasks.length + 1,
            padding: const EdgeInsets.symmetric(vertical: 12),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
            itemBuilder: (context, index) {
              if (index == widget.tasks.length) return _LoadMoreWidget(isLoading: hasMore);

              return TodoTile(
                task: widget.tasks[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

@immutable
class _LoadMoreWidget extends StatelessWidget {
  const _LoadMoreWidget({
    this.isLoading = true,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final text = isLoading ? 'Loading more...' : 'All caught up!';

    return SizedBox(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: subText0Color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskLinearLoadingIndicator extends ConsumerWidget {
  const _TaskLinearLoadingIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionView = ref.watch(selectedActionViewController);
    final isLoading = ref.watch(tasksController(actionView)).isRefreshing;

    if (!isLoading) return const SizedBox.shrink();

    return LinearProgressIndicator(
      value: isLoading ? null : 0,
    );
  }
}
