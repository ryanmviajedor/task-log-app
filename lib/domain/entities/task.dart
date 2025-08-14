import 'task_priority.dart';
import 'task_status.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? timerStartTime;
  final Duration totalDuration;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    this.priority = TaskPriority.normal,
    this.status = TaskStatus.todo,
    this.timerStartTime,
    this.totalDuration = Duration.zero,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? startDate,
    DateTime? endDate,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? timerStartTime,
    Duration? totalDuration,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      timerStartTime: timerStartTime ?? this.timerStartTime,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }

  // Helper getters for backward compatibility
  bool get isCompleted => status == TaskStatus.completed;
  bool get isInProgress => status == TaskStatus.inProgress;
  bool get isTodo => status == TaskStatus.todo;

  // Timer helper methods
  bool get isTimerRunning => timerStartTime != null && isInProgress;

  Duration get currentDuration {
    if (timerStartTime != null && isInProgress) {
      return totalDuration + DateTime.now().difference(timerStartTime!);
    }
    return totalDuration;
  }

  String get formattedDuration {
    final duration = currentDuration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  // Check if task is due today
  bool get isDueToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endDay = DateTime(endDate.year, endDate.month, endDate.day);
    return today.isAtSameMomentAs(endDay);
  }

  // Check if task is overdue
  bool get isOverdue {
    final now = DateTime.now();
    return endDate.isBefore(now) && !isCompleted;
  }
}
