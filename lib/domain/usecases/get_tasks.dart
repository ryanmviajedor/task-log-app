// lib/domain/usecases/get_tasks.dart

import '../repositories/task_repository.dart';
import '../entities/task.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<Task>> call() async {
    return await repository.getTasks();
  }
}
