import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task.dart';
import '../../core/theme/app_colors.dart';
import '../screens/task_detail_screen.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onStatusToggle;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onStatusToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [
                  const Color(0xFF2A2A2A).withValues(alpha: 0.8),
                  const Color(0xFF1E1E1E).withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppColors.lightCardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.primary1.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : AppColors.primary2.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              onTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaskDetailScreen(taskId: task.id),
                  ),
                );
              },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and priority
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.primary1,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Priority indicator with gradient
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: task.priority.gradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: task.priority.color.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            task.priority.icon,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            task.priority.displayName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark ? Colors.grey[300] : AppColors.darkGrey,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Date range and timer info
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 350) {
                      // Stack vertically on very small screens
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date range
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary3.withValues(alpha: 0.1),
                                  AppColors.primary4.withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: AppColors.primary3,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    '${DateFormat('MMM dd').format(task.startDate)} - ${DateFormat('MMM dd').format(task.endDate)}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.primary2,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Timer info
                          if (task.isTimerRunning ||
                              task.totalDuration > Duration.zero) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: task.isTimerRunning
                                    ? AppColors.inProgressGradient
                                    : AppColors.completedGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    task.isTimerRunning
                                        ? Icons.timer
                                        : Icons.access_time,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    task.formattedDuration,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      );
                    } else {
                      // Side by side on larger screens
                      return Row(
                        children: [
                          // Date range
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary3.withValues(alpha: 0.1),
                                    AppColors.primary4.withValues(alpha: 0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: AppColors.primary3,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      '${DateFormat('MMM dd').format(task.startDate)} - ${DateFormat('MMM dd, yyyy').format(task.endDate)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.primary2,
                                            fontWeight: FontWeight.w500,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Timer info
                          if (task.isTimerRunning ||
                              task.totalDuration > Duration.zero) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: task.isTimerRunning
                                    ? AppColors.inProgressGradient
                                    : AppColors.completedGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    task.isTimerRunning
                                        ? Icons.timer
                                        : Icons.access_time,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    task.formattedDuration,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Status and action
                Row(
                  children: [
                    // Status chip with gradient
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: task.status.gradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: task.status.color.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(task.status.icon, size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            task.status.displayName,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Status toggle button with gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: task.isCompleted
                            ? AppColors.completedGradient
                            : AppColors.secondaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (task.isCompleted
                                        ? AppColors
                                              .completedGradient
                                              .colors
                                              .first
                                        : AppColors.primary2)
                                    .withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: onStatusToggle,
                        icon: Icon(
                          task.isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: Colors.white,
                        ),
                        tooltip: task.isCompleted
                            ? 'Mark as incomplete'
                            : 'Mark as complete',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
