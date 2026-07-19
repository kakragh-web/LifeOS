import 'package:lifeos_ai/features/tasks/domain/task.dart';

abstract class ITaskRepository {
  Stream<List<Task>> watchTasks();
  Future<List<Task>> getTasks();
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String id);
}
