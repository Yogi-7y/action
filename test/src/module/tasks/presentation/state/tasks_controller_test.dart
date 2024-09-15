import 'package:action/src/module/tasks/domain/entity/task.dart';
import 'package:action/src/module/tasks/domain/repository/task_repository.dart';
import 'package:action/src/module/tasks/domain/use_case/task_use_case.dart';
import 'package:action/src/module/tasks/presentation/action_view.dart';
import 'package:action/src/module/tasks/presentation/state/tasks_controller.dart';
import 'package:core_y/core_y.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

class MockTaskUseCase extends Mock implements TaskUseCase {}

class MockActionView extends Mock implements ActionView {}

class FakeTask extends Fake implements Task {}

class FakeFilter extends Fake implements Filter {}

void main() {
  late ProviderContainer container;
  late MockTaskUseCase mockTaskUseCase;
  late MockActionView mockActionView;

  setUp(() {
    mockTaskUseCase = MockTaskUseCase();
    mockActionView = MockActionView();

    container = ProviderContainer(
      overrides: [
        taskUseCaseProvider.overrideWithValue(mockTaskUseCase),
      ],
    );

    registerFallbackValue(FakeTask());
    registerFallbackValue(FakeFilter());
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is loading', () {
    expect(container.read(tasksController(mockActionView)), isA<AsyncLoading<Tasks>>());
  });

  test('fetchTasks returns list of tasks', () async {
    const tasks = <Task>[Task(name: 'Test Task')];

    when(() => mockTaskUseCase.fetchTasks(filter: any(named: 'filter')))
        .thenAnswer((_) async => const Success(tasks));

    final tasksControllerProvider = tasksController(mockActionView);

    // Wait for the build method to complete
    await container.read(tasksControllerProvider.future);

    expect(container.read(tasksControllerProvider).value, [isA<Task>()]);
    expect(container.read(tasksControllerProvider).value, tasks);
  });

  test('addTask updates state optimistically and refreshes', () async {
    const initialTasks = [Task(name: 'Initial Task')];
    const newTask = Task(name: 'New Task');
    const updatedTasks = [newTask, ...initialTasks];

    // Use a closure to maintain state between calls
    var fetchTasksCallCount = 0;
    when(() => mockTaskUseCase.fetchTasks(filter: any(named: 'filter'))).thenAnswer((_) async {
      fetchTasksCallCount++;

      if (fetchTasksCallCount == 1) {
        return const Success(initialTasks);
      } else {
        return const Success(updatedTasks);
      }
    });

    when(() => mockTaskUseCase.createTask(task: any(named: 'task')))
        .thenAnswer((_) async => const Success(null));

    final tasksControllerProvider = tasksController(mockActionView);
    final controller = container.read(tasksControllerProvider.notifier);

    await container.read(tasksControllerProvider.future);

    // Verify initial state
    expect(container.read(tasksControllerProvider).value, initialTasks);

    // Start addTask but don't await it
    final addTaskFuture = controller.addTask(newTask);

    // Immediately check the optimistic update
    expect(container.read(tasksControllerProvider).value, updatedTasks);

    // Now await the addTask operation to complete
    await addTaskFuture;

    // Verify final state after refresh
    expect(container.read(tasksControllerProvider).value, updatedTasks);

    // Verify fetchTasks was called twice (initial + refresh)
    verify(() => mockTaskUseCase.fetchTasks(filter: any(named: 'filter'))).called(2);
  });

  test('addTask updates UI optimistically, then rolls back on backend failure', () async {
    const initialTasks = [Task(name: 'Initial Task')];
    const newTask = Task(name: 'New Task');
    const updatedTasks = [newTask, ...initialTasks];

    when(() => mockTaskUseCase.fetchTasks(filter: any(named: 'filter')))
        .thenAnswer((_) async => const Success(initialTasks));

    when(() => mockTaskUseCase.createTask(task: any(named: 'task'))).thenAnswer((_) async =>
        const Failure(AppException(exception: 'Failed to add task', stackTrace: StackTrace.empty)));

    final tasksControllerProvider = tasksController(mockActionView);
    final controller = container.read(tasksControllerProvider.notifier);

    // 1. Verify initial state
    await container.read(tasksControllerProvider.future);
    expect(container.read(tasksControllerProvider).value, initialTasks);

    // 2. Call addTask
    final addTaskFuture = controller.addTask(newTask);

    // 3. Immediately check for optimistic update
    expect(container.read(tasksControllerProvider).value, updatedTasks);

    // 4. Wait for the addTask operation to complete (which will fail)
    await addTaskFuture;

    // 5. Verify that the UI has rolled back to the initial state
    expect(container.read(tasksControllerProvider).value, initialTasks);

    // Verify that fetchTasks was called twice (initial + after failure)
    verify(() => mockTaskUseCase.fetchTasks(filter: any(named: 'filter'))).called(1);

    // Verify that createTask was called once
    verify(() => mockTaskUseCase.createTask(task: any(named: 'task'))).called(1);
  });

  group('updaeTaskStatus', () {
    test('updates task state and refreshes on success', () async {
      const task = Task(id: '1', name: 'Test Task', state: TaskState.todo);
      when(() => mockTaskUseCase.markTaskAsComplete(any()))
          .thenAnswer((_) async => const Success(null));
      when(() => mockTaskUseCase.fetchTasks(filter: any(named: 'filter')))
          .thenAnswer((_) async => Success([task.copyWith(state: TaskState.done)]));

      final controller = container.read(tasksController(mockActionView).notifier);
      await controller.updateTaskStatus(task);

      expect(container.read(tasksController(mockActionView)).value?.first.state, TaskState.done);
      verify(() => mockTaskUseCase.markTaskAsComplete(any())).called(1);

      /// Called first during the build method and next after update
      verify(() => mockTaskUseCase.fetchTasks(filter: any(named: 'filter'))).called(2);
    });

    test('updateTaskStatus rolls back on failure', () async {
      const task = Task(id: '1', name: 'Test Task', state: TaskState.todo);

      when(() => mockTaskUseCase.fetchTasks(filter: any(named: 'filter')))
          .thenAnswer((_) async => const Success([task]));
      when(() => mockTaskUseCase.markTaskAsComplete(any())).thenAnswer((_) async =>
          const Failure(AppException(exception: 'Error', stackTrace: StackTrace.empty)));

      final controller = container.read(tasksController(mockActionView).notifier);
      final state = await container.read(tasksController(mockActionView).future);
      expect(state.first.state, TaskState.todo);

      final updateTaskFuture = controller.updateTaskStatus(task);
      expect(container.read(tasksController(mockActionView)).value?.first.state, TaskState.done);

      await updateTaskFuture;

      expect(container.read(tasksController(mockActionView)).value?.first.state, TaskState.todo);

      verify(() => mockTaskUseCase.markTaskAsComplete(any())).called(1);
    });
  });

  group('getNextTodoState', () {
    test('returns correct state for tap', () {
      final controller = container.read(tasksController(mockActionView).notifier);

      expect(controller.getNextTodoState(TaskState.todo), TaskState.done);
      expect(controller.getNextTodoState(TaskState.done), TaskState.todo);
      expect(controller.getNextTodoState(TaskState.inProgress), TaskState.done);
    });

    test('getNextTodoState returns correct state for double tap', () {
      final controller = container.read(tasksController(mockActionView).notifier);

      expect(
        controller.getNextTodoState(
          TaskState.todo,
          isDoubleTap: true,
          isTap: false,
        ),
        TaskState.inProgress,
      );
      expect(
        controller.getNextTodoState(
          TaskState.inProgress,
          isDoubleTap: true,
          isTap: false,
        ),
        TaskState.todo,
      );
      expect(
        controller.getNextTodoState(
          TaskState.done,
          isDoubleTap: true,
          isTap: false,
        ),
        TaskState.todo,
      );
    });
  });

  group('updateTaskInList', () {
    test('correctly updates task in list in memory', () async {
      const tasks = [
        Task(id: '1', name: 'Task 1'),
        Task(id: '2', name: 'Task 2'),
        Task(id: '3', name: 'Task 3'),
      ];

      when(() => mockTaskUseCase.fetchTasks(filter: any(named: 'filter')))
          .thenAnswer((_) async => const Success(tasks));

      final controller = container.read(tasksController(mockActionView).notifier);
      final state = await container.read(tasksController(mockActionView).future);

      expect(state, tasks);

      const updatedTask = Task(id: '2', name: 'Updated Task 2');
      final result = controller.updateTaskInList('2', updatedTask);

      expect(result.length, 3);
      expect(result[1], updatedTask);
      expect(result[0].id, '1');
      expect(result[2].id, '3');
    });
  });
}
