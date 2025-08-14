import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_status.dart';
import '../providers/task_provider.dart';
import 'add_edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          Consumer<TaskProvider>(
            builder: (context, provider, child) {
              Task? task;
              try {
                task = provider.tasks.firstWhere((t) => t.id == taskId);
              } catch (e) {
                task = null;
              }

              if (task == null) return const SizedBox.shrink();

              return PopupMenuButton<String>(
                onSelected: (value) async {
                  switch (value) {
                    case 'edit':
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddEditTaskScreen(task: task),
                        ),
                      );
                      break;
                    case 'delete':
                      if (task != null) {
                        _showDeleteConfirmation(context, provider, task);
                      }
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          Task? task;
          try {
            task = provider.tasks.firstWhere((t) => t.id == taskId);
          } catch (e) {
            task = null;
          }

          if (task == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Task not found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          task.status.icon,
                          color: task.status.color,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.status.displayName,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: task.status.color,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Tap to change status',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Task Title
                Text(
                  'Title',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.title, color: Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            task.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Task Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.description, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            task.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Priority
                Text(
                  'Priority',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(task.priority.icon, color: task.priority.color),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            task.priority.displayName,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: task.priority.color,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Start Date
                Text(
                  'Start Date',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat(
                                  'EEEE, MMMM d, y',
                                ).format(task.startDate),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                DateFormat('h:mm a').format(task.startDate),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // End Date
                Text(
                  'End Date',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.stop, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat(
                                  'EEEE, MMMM d, y',
                                ).format(task.endDate),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                DateFormat('h:mm a').format(task.endDate),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Created Date
                Text(
                  'Created',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.purple),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat(
                                  'EEEE, MMMM d, y',
                                ).format(task.createdAt),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text(
                                DateFormat('h:mm a').format(task.createdAt),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => provider.toggleTaskCompletion(task!.id),
                    icon: Icon(_getNextStatusIcon(task.status)),
                    label: Text(_getNextStatusText(task.status)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: _getNextStatusColor(task.status),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getNextStatusIcon(TaskStatus currentStatus) {
    switch (currentStatus) {
      case TaskStatus.todo:
        return Icons.play_arrow;
      case TaskStatus.inProgress:
        return Icons.check;
      case TaskStatus.completed:
        return Icons.refresh;
    }
  }

  String _getNextStatusText(TaskStatus currentStatus) {
    switch (currentStatus) {
      case TaskStatus.todo:
        return 'Start Task';
      case TaskStatus.inProgress:
        return 'Complete Task';
      case TaskStatus.completed:
        return 'Reset to To-do';
    }
  }

  Color _getNextStatusColor(TaskStatus currentStatus) {
    switch (currentStatus) {
      case TaskStatus.todo:
        return Colors.blue;
      case TaskStatus.inProgress:
        return Colors.green;
      case TaskStatus.completed:
        return Colors.orange;
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    TaskProvider provider,
    Task task,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              await provider.removeTask(task.id);
              if (context.mounted) {
                Navigator.of(context).pop(); // Go back to tasks list
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
