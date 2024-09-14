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
}
