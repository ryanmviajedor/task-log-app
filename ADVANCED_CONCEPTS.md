# 🚀 HiveFlow - Advanced Concepts & Best Practices

## 📋 Advanced Topics

1. [Performance Optimization](#-performance-optimization)
2. [Error Handling Strategies](#-error-handling-strategies)
3. [Security Best Practices](#-security-best-practices)
4. [Accessibility Implementation](#-accessibility-implementation)
5. [Internationalization](#-internationalization)
6. [Advanced State Management](#-advanced-state-management)
7. [Custom Animations](#-custom-animations)
8. [Memory Management](#-memory-management)

---

## ⚡ Performance Optimization

### 1. Widget Optimization

#### Use Const Constructors
```dart
// ✅ Good - Const constructor prevents unnecessary rebuilds
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
  });
  
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Text('Static content'),
    );
  }
}

// ❌ Bad - Non-const constructor causes rebuilds
class TaskCard extends StatelessWidget {
  TaskCard({required this.task});
}
```

#### Optimize ListView Performance
```dart
// ✅ Good - ListView.builder for large lists
ListView.builder(
  itemCount: tasks.length,
  itemBuilder: (context, index) {
    final task = tasks[index];
    return TaskCard(
      key: ValueKey(task.id), // Stable keys for performance
      task: task,
    );
  },
)

// ✅ Better - Add cacheExtent for smooth scrolling
ListView.builder(
  cacheExtent: 500, // Pre-render items for smooth scrolling
  itemCount: tasks.length,
  itemBuilder: (context, index) => TaskCard(task: tasks[index]),
)
```

#### Selective Rebuilds with Consumer
```dart
// ✅ Good - Only rebuild specific parts
class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Static header - won't rebuild
        const AppBar(title: Text('Tasks')),
        
        // Only this part rebuilds when tasks change
        Expanded(
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              return ListView.builder(
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(task: taskProvider.tasks[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
```

### 2. Memory Optimization

#### Dispose Resources Properly
```dart
class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _startTimer();
    _listenToTasks();
  }
  
  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer
    _subscription?.cancel(); // Cancel stream subscription
    super.dispose();
  }
  
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Update UI
    });
  }
  
  void _listenToTasks() {
    _subscription = taskStream.listen((tasks) {
      // Handle task updates
    });
  }
}
```

### 3. Image Optimization

```dart
// ✅ Good - Cached network images with proper sizing
CachedNetworkImage(
  imageUrl: task.imageUrl,
  width: 100,
  height: 100,
  fit: BoxFit.cover,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  memCacheWidth: 200, // Resize in memory
  memCacheHeight: 200,
)
```

---

## 🛡️ Error Handling Strategies

### 1. Centralized Error Handling

```dart
// lib/core/error/failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}
```

### 2. Result Pattern Implementation

```dart
// lib/core/utils/result.dart
abstract class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}

// Usage in use cases
class GetTasks {
  final TaskRepository repository;
  
  GetTasks(this.repository);
  
  Future<Result<List<Task>>> call() async {
    try {
      final tasks = await repository.getAllTasks();
      return Success(tasks);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Error(CacheFailure(e.message));
    } catch (e) {
      return Error(ServerFailure('Unexpected error occurred'));
    }
  }
}
```

### 3. Global Error Handler

```dart
// lib/core/error/error_handler.dart
class GlobalErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    // Log error
    debugPrint('Error: $error');
    debugPrint('Stack trace: $stackTrace');
    
    // Report to crash analytics (Firebase Crashlytics, Sentry, etc.)
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
    
    // Show user-friendly message
    if (error is ValidationFailure) {
      _showSnackBar(error.message);
    } else {
      _showSnackBar('Something went wrong. Please try again.');
    }
  }
  
  static void _showSnackBar(String message) {
    // Implementation depends on your navigation setup
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// In main.dart
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    GlobalErrorHandler.handleError(details.exception, details.stack!);
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    GlobalErrorHandler.handleError(error, stack);
    return true;
  };
  
  runApp(MyApp());
}
```

---

## 🔒 Security Best Practices

### 1. Secure Local Storage

```dart
// lib/core/security/secure_storage.dart
class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );
  
  static Future<void> storeSecurely(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  static Future<String?> getSecurely(String key) async {
    return await _storage.read(key: key);
  }
  
  static Future<void> deleteSecurely(String key) async {
    await _storage.delete(key: key);
  }
}
```

### 2. Input Validation

```dart
// lib/core/validation/validators.dart
class Validators {
  static String? validateTaskTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Task title is required';
    }
    
    if (value.trim().length < 3) {
      return 'Task title must be at least 3 characters';
    }
    
    if (value.trim().length > 100) {
      return 'Task title must be less than 100 characters';
    }
    
    // Check for malicious content
    if (_containsMaliciousContent(value)) {
      return 'Invalid characters detected';
    }
    
    return null;
  }
  
  static String? validateDate(DateTime? date) {
    if (date == null) {
      return 'Date is required';
    }
    
    final now = DateTime.now();
    final maxDate = now.add(Duration(days: 365 * 5)); // 5 years from now
    
    if (date.isBefore(now.subtract(Duration(days: 365)))) {
      return 'Date cannot be more than 1 year in the past';
    }
    
    if (date.isAfter(maxDate)) {
      return 'Date cannot be more than 5 years in the future';
    }
    
    return null;
  }
  
  static bool _containsMaliciousContent(String input) {
    final maliciousPatterns = [
      RegExp(r'<script.*?>.*?</script>', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
    ];
    
    return maliciousPatterns.any((pattern) => pattern.hasMatch(input));
  }
}
```

### 3. Network Security

```dart
// lib/core/network/secure_http_client.dart
class SecureHttpClient {
  static Dio createSecureClient() {
    final dio = Dio();
    
    // Add certificate pinning
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        // Implement certificate pinning logic
        return _isValidCertificate(cert, host);
      };
      return client;
    };
    
    // Add request/response interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add security headers
          options.headers['X-Requested-With'] = 'XMLHttpRequest';
          options.headers['X-App-Version'] = '1.0.0';
          handler.next(options);
        },
        onError: (error, handler) {
          // Log security-related errors
          if (error.response?.statusCode == 401) {
            // Handle unauthorized access
            _handleUnauthorized();
          }
          handler.next(error);
        },
      ),
    );
    
    return dio;
  }
  
  static bool _isValidCertificate(X509Certificate cert, String host) {
    // Implement certificate validation logic
    return true; // Simplified for example
  }
  
  static void _handleUnauthorized() {
    // Clear stored credentials and redirect to login
  }
}
```

---

## ♿ Accessibility Implementation

### 1. Semantic Widgets

```dart
// lib/presentation/widgets/accessible_task_card.dart
class AccessibleTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  
  const AccessibleTaskCard({
    super.key,
    required this.task,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Task: ${task.title}',
      hint: 'Double tap to edit task',
      value: 'Priority: ${task.priority.name}, Status: ${task.status.name}',
      button: true,
      enabled: onTap != null,
      child: Card(
        child: ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: Semantics(
            label: 'Task priority indicator',
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: task.priority.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
```

### 2. Screen Reader Support

```dart
// lib/presentation/widgets/accessible_button.dart
class AccessibleButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final String? semanticHint;
  
  const AccessibleButton({
    super.key,
    required this.text,
    this.onPressed,
    this.semanticLabel,
    this.semanticHint,
  });
  
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? text,
      hint: semanticHint,
      button: true,
      enabled: onPressed != null,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
```

### 3. Focus Management

```dart
// lib/presentation/screens/accessible_form_screen.dart
class AccessibleFormScreen extends StatefulWidget {
  @override
  _AccessibleFormScreenState createState() => _AccessibleFormScreenState();
}

class _AccessibleFormScreenState extends State<AccessibleFormScreen> {
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  
  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        actions: [
          Semantics(
            label: 'Save task',
            hint: 'Saves the current task',
            child: IconButton(
              icon: Icon(Icons.save),
              onPressed: _saveTask,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Semantics(
                label: 'Task title input field',
                hint: 'Enter the title for your task',
                child: TextFormField(
                  focusNode: _titleFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter task title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: Validators.validateTaskTitle,
                ),
              ),
              SizedBox(height: 16),
              Semantics(
                label: 'Task description input field',
                hint: 'Enter a detailed description for your task',
                child: TextFormField(
                  focusNode: _descriptionFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter task description',
                  ),
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      // Save task logic
      
      // Announce success to screen readers
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Semantics(
            liveRegion: true,
            child: Text('Task saved successfully'),
          ),
        ),
      );
    }
  }
}
```

---

## 🌍 Internationalization

### 1. Setup Localization

```yaml
# pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1

dev_dependencies:
  intl_utils: ^2.8.5
```

### 2. Create ARB Files

```json
// lib/l10n/app_en.arb
{
  "appTitle": "HiveFlow",
  "taskTitle": "Task Title",
  "taskDescription": "Task Description",
  "addTask": "Add Task",
  "editTask": "Edit Task",
  "deleteTask": "Delete Task",
  "taskCreated": "Task created successfully",
  "taskUpdated": "Task updated successfully",
  "taskDeleted": "Task deleted successfully",
  "confirmDelete": "Are you sure you want to delete this task?",
  "cancel": "Cancel",
  "delete": "Delete",
  "save": "Save",
  "tasksToday": "{count, plural, =0{No tasks today} =1{1 task today} other{{count} tasks today}}",
  "@tasksToday": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

```json
// lib/l10n/app_es.arb
{
  "appTitle": "HiveFlow",
  "taskTitle": "Título de la Tarea",
  "taskDescription": "Descripción de la Tarea",
  "addTask": "Agregar Tarea",
  "editTask": "Editar Tarea",
  "deleteTask": "Eliminar Tarea",
  "taskCreated": "Tarea creada exitosamente",
  "taskUpdated": "Tarea actualizada exitosamente",
  "taskDeleted": "Tarea eliminada exitosamente",
  "confirmDelete": "¿Estás seguro de que quieres eliminar esta tarea?",
  "cancel": "Cancelar",
  "delete": "Eliminar",
  "save": "Guardar",
  "tasksToday": "{count, plural, =0{No hay tareas hoy} =1{1 tarea hoy} other{{count} tareas hoy}}"
}
```

### 3. Configure App for Localization

```dart
// lib/main.dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HiveFlow',
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: TasksScreen(),
    );
  }
}
```

### 4. Use Localized Strings

```dart
// lib/presentation/screens/localized_screen.dart
class LocalizedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: Column(
        children: [
          Text(l10n.taskTitle),
          Text(l10n.tasksToday(5)), // Pluralization
          ElevatedButton(
            onPressed: () {},
            child: Text(l10n.addTask),
          ),
        ],
      ),
    );
  }
}
```

This comprehensive documentation covers the advanced concepts and best practices used in HiveFlow, providing developers with the knowledge to build production-ready Flutter applications with proper architecture, security, accessibility, and internationalization support.
