import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/services/notification_service.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_status.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';

class TaskProvider with ChangeNotifier {
  final GetTasks getTasks;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final NotificationService _notificationService = NotificationService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  Timer? _timer;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // Dashboard statistics
  int get tasksToday => _tasks.where((task) => task.isDueToday).length;
  int get ongoingTasks => _tasks.where((task) => task.isInProgress).length;
  int get totalTasks => _tasks.length;
  int get tasksDue =>
      _tasks.where((task) => task.isDueToday && !task.isCompleted).length;
  int get completedTasks => _tasks.where((task) => task.isCompleted).length;

  TaskProvider({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
  }) {
    _initializeNotifications();
    _startPeriodicUpdates();
  }

  void _initializeNotifications() async {
    await _notificationService.initialize();
    await _notificationService.scheduleDailyTaskReminder();
  }

  void _startPeriodicUpdates() {
    // Update UI every second for running timers
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_tasks.any((task) => task.isTimerRunning)) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    final result = await getTasks();
    _tasks = result;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await createTask(task);
    await fetchTasks();

    // Schedule notifications for the new task
    await _notificationService.scheduleTaskReminder(task);
  }

  Future<void> editTask(Task task) async {
    await updateTask(task);
    await fetchTasks();
  }

  Future<void> removeTask(String id) async {
    await deleteTask(id);
    await fetchTasks();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      final task = _tasks[taskIndex];
      TaskStatus newStatus;
      DateTime? newTimerStartTime;
      Duration newTotalDuration = task.totalDuration;

      switch (task.status) {
        case TaskStatus.todo:
          newStatus = TaskStatus.inProgress;
          newTimerStartTime = DateTime.now();
          break;
        case TaskStatus.inProgress:
          newStatus = TaskStatus.completed;
          newTimerStartTime = null;
          // Add current session duration to total
          if (task.timerStartTime != null) {
            newTotalDuration =
                task.totalDuration +
                DateTime.now().difference(task.timerStartTime!);
          }
          break;
        case TaskStatus.completed:
          newStatus = TaskStatus.todo;
          newTimerStartTime = null;
          break;
      }

      final updatedTask = task.copyWith(
        status: newStatus,
        timerStartTime: newTimerStartTime,
        totalDuration: newTotalDuration,
      );

      await updateTask(updatedTask);
      await fetchTasks();

      // Handle notifications
      if (newStatus == TaskStatus.completed) {
        await _notificationService.showInstantNotification(
          title: 'Task Completed! 🎉',
          body:
              '${task.title} has been completed in ${updatedTask.formattedDuration}',
        );
        await _notificationService.cancelTaskNotification(task.id);
      } else if (newStatus == TaskStatus.inProgress) {
        await _notificationService.scheduleTaskReminder(updatedTask);
      }
    }
  }

  Future<void> updateTaskStatus(String id, TaskStatus status) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      final task = _tasks[taskIndex];
      final updatedTask = task.copyWith(status: status);
      await updateTask(updatedTask);
      await fetchTasks();
    }
  }
}
