import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeos_ai/features/tasks/domain/i_task_repository.dart';
import 'package:lifeos_ai/features/tasks/data/task_repository_impl.dart';
import 'package:lifeos_ai/features/tasks/domain/task.dart';

final taskRepositoryProvider = Provider<ITaskRepository>((ref) {
  return InMemoryTaskRepository();
});

final tasksProvider = StreamProvider<List<Task>>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.watchTasks();
});

final taskCategoriesProvider = Provider<List<String>>((ref) {
  final tasks = ref.watch(tasksProvider).value ?? const <Task>[];
  final cats = <String>{};
  for (final t in tasks) {
    if (t.category != null && t.category!.isNotEmpty) {
      cats.add(t.category!);
    }
  }
  return cats.toList()..sort();
});
