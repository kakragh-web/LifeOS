import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos_ai/features/tasks/domain/task.dart';
import 'package:lifeos_ai/features/tasks/data/task_repository_impl.dart';

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
}
