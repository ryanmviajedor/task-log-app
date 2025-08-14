import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime endDate;

  @HiveField(6)
  final int priorityIndex;

  @HiveField(7)
  final int statusIndex;

  @HiveField(8)
  final DateTime? timerStartTime;

  @HiveField(9)
  final int totalDurationInSeconds;

  TaskModel({
    String? id,
    required this.title,
    required this.description,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
    this.priorityIndex = 1, // TaskPriority.normal
    this.statusIndex = 0, // TaskStatus.todo
    this.timerStartTime,
    this.totalDurationInSeconds = 0,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       startDate = startDate ?? DateTime.now(),
       endDate = endDate ?? DateTime.now().add(const Duration(days: 1));

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      createdAt: task.createdAt,
      startDate: task.startDate,
      endDate: task.endDate,
      priorityIndex: task.priority.index,
      statusIndex: task.status.index,
      timerStartTime: task.timerStartTime,
      totalDurationInSeconds: task.totalDuration.inSeconds,
    );
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      startDate: startDate,
      endDate: endDate,
      priority: TaskPriority.values[priorityIndex],
      status: TaskStatus.values[statusIndex],
      timerStartTime: timerStartTime,
      totalDuration: Duration(seconds: totalDurationInSeconds),
    );
  }
}
