import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/entity/task.dart';
import '../state/tasks_controller.dart';
import '../widgets/checkbox.dart';

const backgroundColor = Color(0xff1e1e2e);
const blue = Color(0xff89b4fa);
const maroon = Color(0xffeba0ac);
const mauve = Color(0xffcba6f7);
const rosewater = Color(0xfff5e0dc);
const surface0 = Color(0xff313244);
const textColor = Color(0xffcdd6f4);
const subText0Color = Color(0xffa6adc8);
const subText1Color = Color(0xffbac2de);
const yellow = Color(0xfff9e2af);

@immutable
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: mediaQuery.padding.top),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  'Inbox',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Expanded(
                child: TasksList(),
              ),
              Row(
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
                          5,
                          (index) => Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: surface0,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'A',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                      ),
                    ),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        // color: _mauve,
                        // color: _yellow,
                        // color: _blue,
                        color: maroon,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TasksList extends ConsumerWidget {
  const TasksList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tasksController).when(
          data: (tasks) {
            return _TasksList(tasks: tasks);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Center(
            child: Text('Error: $error'),
          ),
        );
  }
}

class _TasksList extends StatelessWidget {
  const _TasksList({required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tasks.length,
      padding: const EdgeInsets.only(top: 12),
      separatorBuilder: (context, index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (context, index) {
        return TodoTile(
          checkboxState: CheckboxState.todo,
          task: tasks[index],
        );
      },
    );
  }
}

@immutable
class TodoTile extends StatelessWidget {
  const TodoTile({
    required this.checkboxState,
    required this.task,
    super.key,
  });

  final CheckboxState checkboxState;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCheckbox(state: checkboxState),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.hardware_outlined,
                          color: rosewater,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Project Name',
                          style: TextStyle(
                            color: subText1Color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.label_outline_rounded,
                          color: rosewater,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Context',
                          style: TextStyle(
                            color: subText1Color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '2d Ago',
                      style: TextStyle(
                        color: subText1Color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
