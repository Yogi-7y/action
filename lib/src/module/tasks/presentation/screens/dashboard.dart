import 'package:flutter/material.dart';

import '../../../../core/resource/colors.dart';
import '../sections/action_view_app_bar.dart';
import '../sections/action_view_selector.dart';
import '../sections/task_list.dart';

@immutable
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      appBar: ActionViewAppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TasksList(),
            ),
            ActionViewSelector(),
          ],
        ),
      ),
    );
  }
}
