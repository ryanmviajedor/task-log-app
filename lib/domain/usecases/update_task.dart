// lib/domain/usecases/update_task.dart

import '../repositories/task_repository.dart';
import '../entities/task.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<void> call(Task task) async {
    return await repository.updateTask(task);
  }
}
