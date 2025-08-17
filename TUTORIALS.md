# 🎓 HiveFlow - Step-by-Step Tutorials

## 📚 Tutorial Index

1. [Setting Up Clean Architecture](#-tutorial-1-setting-up-clean-architecture)
2. [Implementing State Management](#-tutorial-2-implementing-state-management)
3. [Creating Custom Widgets](#-tutorial-3-creating-custom-widgets)
4. [Setting Up Local Storage](#-tutorial-4-setting-up-local-storage)
5. [Implementing Theme System](#-tutorial-5-implementing-theme-system)
6. [Adding Notifications](#-tutorial-6-adding-notifications)
7. [Writing Tests](#-tutorial-7-writing-tests)
8. [Building for Production](#-tutorial-8-building-for-production)

---

## 🏗️ Tutorial 1: Setting Up Clean Architecture

### Step 1: Create Directory Structure

```bash
mkdir -p lib/{core/{services,theme},data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{providers,screens,widgets}}
```

### Step 2: Define Domain Entity

```dart
// lib/domain/entities/task.dart
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
  final int totalDuration; // in seconds

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.status,
    this.timerStartTime,
    this.totalDuration = 0,
  });

  // Business logic methods
  bool get isCompleted => status == TaskStatus.completed;
  bool get isInProgress => status == TaskStatus.inProgress;
  bool get isDueToday {
    final now = DateTime.now();
    return endDate.year == now.year &&
           endDate.month == now.month &&
           endDate.day == now.day;
  }

  String get formattedDuration {
    final hours = totalDuration ~/ 3600;
    final minutes = (totalDuration % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  // Copy with method for immutability
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
    int? totalDuration,
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
}

enum TaskPriority { low, normal, high }
enum TaskStatus { todo, inProgress, completed }
```

### Step 3: Define Repository Interface

```dart
// lib/domain/repositories/task_repository.dart
abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Future<void> createTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String id);
}
```

### Step 4: Create Use Cases

```dart
// lib/domain/usecases/get_tasks.dart
class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<Task>> call() async {
    return await repository.getAllTasks();
  }
}

// lib/domain/usecases/create_task.dart
class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<void> call(Task task) async {
    // Add business logic validation here
    if (task.title.trim().isEmpty) {
      throw Exception('Task title cannot be empty');
    }
    
    if (task.endDate.isBefore(task.startDate)) {
      throw Exception('End date cannot be before start date');
    }

    await repository.createTask(task);
  }
}
```

### Key Learning Points:
- **Entities** contain business logic and are framework-independent
- **Repository interfaces** define contracts without implementation details
- **Use cases** encapsulate business operations and validation
- **Immutability** is maintained with `copyWith` methods

---

## 🔄 Tutorial 2: Implementing State Management

### Step 1: Add Provider Dependency

```yaml
# pubspec.yaml
dependencies:
  provider: ^6.1.1
```

### Step 2: Create Provider Class

```dart
// lib/presentation/providers/task_provider.dart
import 'package:flutter/foundation.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';

class TaskProvider with ChangeNotifier {
  final GetTasks getTasks;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskProvider({
    required this.getTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
  });

  // Private state
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  // Public getters
  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Computed properties
  List<Task> get todayTasks {
    return _tasks.where((task) => task.isDueToday).toList();
  }

  List<Task> get inProgressTasks {
    return _tasks.where((task) => task.isInProgress).toList();
  }

  List<Task> get completedTasks {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  int get totalTasks => _tasks.length;

  // Actions
  Future<void> fetchTasks() async {
    _setLoading(true);
    _setError(null);

    try {
      _tasks = await getTasks();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await createTask(task);
      await fetchTasks(); // Refresh the list
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> editTask(Task task) async {
    try {
      await updateTask(task);
      await fetchTasks(); // Refresh the list
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> removeTask(String id) async {
    try {
      await deleteTask(id);
      await fetchTasks(); // Refresh the list
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}
```

### Step 3: Provide at App Level

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  final taskRepository = TaskRepositoryImpl(/* dependencies */);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(
            getTasks: GetTasks(taskRepository),
            createTask: CreateTask(taskRepository),
            updateTask: UpdateTask(taskRepository),
            deleteTask: DeleteTask(taskRepository),
          )..fetchTasks(), // Load initial data
        ),
      ],
      child: const MyApp(),
    ),
  );
}
```

### Step 4: Consume in Widgets

```dart
// lib/presentation/screens/task_list_screen.dart
class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (taskProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${taskProvider.error}'),
                  ElevatedButton(
                    onPressed: () => taskProvider.fetchTasks(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return TaskCard(
                task: task,
                onTap: () => _editTask(context, task),
                onDelete: () => taskProvider.removeTask(task.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(),
      ),
    );
  }

  void _editTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: task),
      ),
    );
  }
}
```

### Key Learning Points:
- **ChangeNotifier** provides reactive state management
- **Consumer** rebuilds only when state changes
- **Separation of concerns** between UI and business logic
- **Error handling** is centralized in the provider
- **Loading states** provide better user experience

---

## 🎨 Tutorial 3: Creating Custom Widgets

### Step 1: Create Reusable Gradient Container

```dart
// lib/presentation/widgets/gradient_container.dart
import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final LinearGradient gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  const GradientContainer({
    super.key,
    required this.child,
    required this.gradient,
    this.padding,
    this.margin,
    this.borderRadius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
```

### Step 2: Create Gradient Button

```dart
// lib/presentation/widgets/gradient_button.dart
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final LinearGradient gradient;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.gradient,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.borderRadius,
    this.textStyle,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          gradient: onPressed != null ? gradient : _disabledGradient,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          boxShadow: onPressed != null ? [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 8),
            ] else if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: textStyle ?? const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient get _disabledGradient => LinearGradient(
    colors: [Colors.grey.shade400, Colors.grey.shade500],
  );
}
```

### Step 3: Create Task Card Widget

```dart
// lib/presentation/widgets/task_card.dart
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onDelete,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isDark ? _darkGradient : _lightGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: task.priority.color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isDark),
                const SizedBox(height: 8),
                _buildDescription(context, isDark),
                const SizedBox(height: 12),
                _buildFooter(context, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        // Priority indicator
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            gradient: task.priority.gradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        // Title
        Expanded(
          child: Text(
            task.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
              decoration: task.isCompleted 
                  ? TextDecoration.lineThrough 
                  : null,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Status chip
        _buildStatusChip(),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, bool isDark) {
    return Text(
      task.description,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: isDark ? Colors.grey[300] : Colors.grey[600],
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Row(
      children: [
        // Due date
        Icon(
          Icons.calendar_today,
          size: 16,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          _formatDate(task.endDate),
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const Spacer(),
        // Timer info
        if (task.isInProgress && task.timerStartTime != null) ...[
          Icon(
            Icons.timer,
            size: 16,
            color: Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            'Running',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ] else if (task.totalDuration > 0) ...[
          Icon(
            Icons.access_time,
            size: 16,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            task.formattedDuration,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: task.status.gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        task.status.displayName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference < 0) return '${-difference} days ago';
    return 'In $difference days';
  }

  LinearGradient get _lightGradient => LinearGradient(
    colors: [
      Colors.white,
      Colors.grey.shade50,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  LinearGradient get _darkGradient => LinearGradient(
    colors: [
      const Color(0xFF2A2A2A),
      const Color(0xFF1E1E1E),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
```

### Key Learning Points:
- **Composition over inheritance** for flexible widget design
- **Theme awareness** for light/dark mode support
- **Responsive design** with proper overflow handling
- **Accessibility** with semantic widgets and proper contrast
- **Performance** with const constructors and efficient rebuilds

This tutorial system provides hands-on learning for each major concept in the HiveFlow app. Each tutorial builds upon the previous ones, creating a comprehensive learning path for Flutter development with clean architecture.
