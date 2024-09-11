import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_textfield/smart_textfield.dart';

import '../../../../core/resource/colors.dart';
import '../../../../widgets/buttons/async_button.dart';
import '../../../projects/domain/entity/project.dart';
import '../../../projects/domain/repository/project_repository.dart';
import '../../domain/entity/task.dart';
import '../../domain/use_case/task_use_case.dart';
import '../state/projects_controller.dart';

mixin ActionViewModal {
  Future<void> addNewAction({
    required BuildContext context,
  }) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: surface0,
      isScrollControlled: true,
      shape: SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius(
          cornerRadius: 24,
          cornerSmoothing: 1,
        ),
      ),
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        return Padding(
          padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
          child: const _ActionViewModalWidget(),
        );
      },
    );
  }
}

@immutable
class _ActionViewModalWidget extends ConsumerWidget {
  const _ActionViewModalWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(projectsController).when(
          data: (projects) => _ActionViewModalDataState(projects: projects),
          loading: _ActionViewModalLoadingState.new,
          error: (error, _) => const _ActionViewModalErrorState(),
        );
  }
}

class _ActionViewModalDataState extends ConsumerStatefulWidget {
  const _ActionViewModalDataState({
    required this.projects,
  });

  final Projects projects;

  @override
  ConsumerState<_ActionViewModalDataState> createState() => _ActionViewModalDataStateState();
}

class _ActionViewModalDataStateState extends ConsumerState<_ActionViewModalDataState> {
  late final _smartTextFieldController =
      SmartTextFieldController(tokenizers: [ProjectTokenizer(values: widget.projects)]);

  Project? project;
  TokenableDateTime? dateTime;

  @override
  void initState() {
    super.initState();
    _smartTextFieldController.addListener(_onHighlightedTokensChanged);
  }

  void _onHighlightedTokensChanged() {
    final _dateTime = _smartTextFieldController.highlightedDateTime;

    if (_dateTime != null) {
      dateTime = TokenableDateTime.fromDateTime(_dateTime);
    } else {
      dateTime = null;
    }

    final highlightedTokens = _smartTextFieldController.highlightedTokens;

    final projectToken = highlightedTokens[ProjectTokenizer.projectPrefix];

    if (projectToken != null && projectToken.value is Project) {
      project = projectToken.value as Project?;
    } else {
      project = null;
    }

    Future.delayed(Duration.zero, () {
      setState(() {});
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _smartTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Add Action',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          SmartTextField(
            controller: _smartTextFieldController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Action',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            children: [
              project,
              dateTime,
            ]
                .where((element) => element != null)
                .map((e) => ExtractedTokenChip(token: e!))
                .toList(),
          ),
          const SizedBox(height: 20),
          AsyncButton(
            onClick: _addTask,
            text: 'Add Action',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _addTask() async {
    print('Add task called');
    final task = Task(
      name: _smartTextFieldController.text,
      project: project,
    );

    final taskUseCase = ref.read(taskUseCaseProvider);

    final result = await taskUseCase.createTask(task: task);

    print(result);
  }
}

class _ActionViewModalLoadingState extends StatelessWidget {
  const _ActionViewModalLoadingState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 100,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ActionViewModalErrorState extends StatelessWidget {
  const _ActionViewModalErrorState();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProjectTokenizer extends Tokenizer {
  ProjectTokenizer({
    required super.values,
    super.prefix = projectPrefix,
  });
  static const projectPrefix = '@';
}

@immutable
class ExtractedTokenChip extends StatelessWidget {
  const ExtractedTokenChip({required this.token, super.key});

  final Tokenable token;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          side: BorderSide(
            color: maroon.withOpacity(0.7),
          ),
          borderRadius: SmoothBorderRadius(
            cornerRadius: 8,
            cornerSmoothing: 1,
          ),
        ),
        // color: Color(0xff585b70),
        color: const Color(0xff313244),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: ShapeDecoration(
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 4,
                  cornerSmoothing: 1,
                ),
              ),
              color: maroon,
            ),
            child: Text(
              token.prefix,
              style: const TextStyle(
                color: Color(0xff181825),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Text(
              token.stringValue,
              style: const TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TokenableDateTime extends DateTime implements Tokenable {
  TokenableDateTime(super.year, super.month, super.day, super.hour, super.minute);

  @override
  String get prefix => 'D';

  @override
  String get stringValue => 'Tomorrow';

  // ignore: sort_constructors_first
  factory TokenableDateTime.fromDateTime(DateTime dateTime) {
    return TokenableDateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );
  }
}
