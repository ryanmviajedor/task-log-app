import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum TaskPriority {
  low,
  normal,
  high;

  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.normal:
        return 'Normal';
      case TaskPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return const Color(0xFFFFC107);
      case TaskPriority.normal:
        return AppColors.primary2;
      case TaskPriority.high:
        return const Color(0xFFFF5722);
    }
  }

  LinearGradient get gradient {
    switch (this) {
      case TaskPriority.low:
        return AppColors.lowPriorityGradient;
      case TaskPriority.normal:
        return AppColors.normalPriorityGradient;
      case TaskPriority.high:
        return AppColors.highPriorityGradient;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.low:
        return Icons.keyboard_arrow_down;
      case TaskPriority.normal:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.keyboard_arrow_up;
    }
  }
}
