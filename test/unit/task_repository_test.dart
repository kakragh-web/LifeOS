import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lifeos_ai/features/tasks/domain/task.dart';
import 'package:lifeos_ai/features/tasks/domain/i_task_repository.dart';
import 'package:lifeos_ai/features/tasks/data/task_repository_impl.dart';
import 'package:lifeos_ai/features/tasks/providers/task_providers.dart';

void main() {
  group('InMemoryTaskRepository', () {
    late InMemoryTaskRepository repo;

    setUp(() {
      repo = InMemoryTaskRepository();
    });

    tearDown(() {
      repo.dispose();
    });

    test('starts empty', () async {
      final tasks = await repo.getTasks();
      expect(tasks, isEmpty);
    });

    test('createTask adds a task', () async {
      final task = Task(
        id: '1',
        createdAt: DateTime.now(),
        title: 'Test task',
        priority: TaskPriority.high,
        status: TaskStatus.todo,
      );
      final result = await repo.createTask(task);
      expect(result.title, 'Test task');
      expect(await repo.getTasks(), [task]);
    });

    test('updateTask modifies a task', () async {
      final task = Task(
        id: '1',
        createdAt: DateTime.now(),
        title: 'Original',
        status: TaskStatus.todo,
      );
      await repo.createTask(task);
      final updated = task.copyWith(title: 'Updated', status: TaskStatus.done);
      await repo.updateTask(updated);
      final tasks = await repo.getTasks();
      expect(tasks.single.title, 'Updated');
      expect(tasks.single.status, TaskStatus.done);
    });

    test('deleteTask removes a task', () async {
      final task = Task(
        id: '1',
        createdAt: DateTime.now(),
        title: 'To delete',
      );
      await repo.createTask(task);
      await repo.deleteTask('1');
      expect(await repo.getTasks(), isEmpty);
    });

    test('watchTasks emits updates', () async {
      final task = Task(
        id: '1',
        createdAt: DateTime.now(),
        title: 'Watched',
      );
      final stream = repo.watchTasks();
      final values = <List<Task>>[];
      final sub = stream.listen(values.add);
      await repo.createTask(task);
      await Future.delayed(const Duration(milliseconds: 200));
      expect(values.last, [task]);
      await sub.cancel();
    });
  });

  group('TaskProviders', () {
    test('tasksProvider returns empty list initially', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final tasks = await container.read(tasksProvider.future);
      expect(tasks, isEmpty);
    });

    test('taskCategoriesProvider returns empty list initially', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final categories = container.read(taskCategoriesProvider);
      expect(categories, isEmpty);
    });
  });
}
