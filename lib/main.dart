import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_colors.dart';
import 'core/services/notification_service.dart';
import 'data/datasources/task_local_data_source.dart';
import 'data/models/task_model.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/entities/task.dart';
import 'domain/repositories/task_repository.dart';
import 'domain/usecases/create_task.dart';
import 'domain/usecases/delete_task.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/update_task.dart';
import 'presentation/providers/task_provider.dart';
import 'presentation/screens/add_edit_task_screen.dart';
import 'presentation/screens/tasks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasks');

  // Initialize notifications
  await NotificationService().initialize();

  final taskBox = Hive.box<TaskModel>('tasks');
  final taskLocalDataSource = TaskLocalDataSourceImpl(taskBox: taskBox);
  final taskRepository = TaskRepositoryImpl(
    localDataSource: taskLocalDataSource,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(
            getTasks: GetTasks(taskRepository),
            createTask: CreateTask(taskRepository),
            updateTask: UpdateTask(taskRepository),
            deleteTask: DeleteTask(taskRepository),
          )..fetchTasks(), // Load tasks on startup
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Log',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary1,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primary1.withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primary1.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary1, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: const TasksScreen(),
      ),
      routes: {'/add': (_) => const AddEditTaskScreen()},
    );
  }
}
