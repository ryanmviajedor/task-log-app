import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<void> createTask(Task task) async {
    await localDataSource.createTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<List<Task>> getTasks() async {
    final tasks = await localDataSource.getTasks();
    return tasks.map((model) => model.toEntity()).toList().cast<Task>();
  }

  @override
  Future<void> updateTask(Task task) async {
    await localDataSource.updateTask(TaskModel.fromEntity(task));
  }
}
