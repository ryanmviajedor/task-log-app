import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum TaskStatus {
  todo,
  inProgress,
  completed;

  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'To-do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.todo:
        return const Color(0xFF9E9E9E);
      case TaskStatus.inProgress:
        return const Color(0xFFFF9800);
      case TaskStatus.completed:
        return const Color(0xFF4CAF50);
    }
  }

  LinearGradient get gradient {
    switch (this) {
      case TaskStatus.todo:
        return AppColors.todoGradient;
      case TaskStatus.inProgress:
        return AppColors.inProgressGradient;
      case TaskStatus.completed:
        return AppColors.completedGradient;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.access_time;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }
}
