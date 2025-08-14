import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/gradient_container.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/task_status.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback? onNavigateToCalendar;
  final VoidCallback? onNavigateToTasks;

  const DashboardScreen({
    super.key,
    this.onNavigateToCalendar,
    this.onNavigateToTasks,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkBackgroundGradient
              : AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.dashboard,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary1,
                            ),
                          ),
                          Text(
                            DateFormat(
                              'EEEE, MMMM d, y',
                            ).format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Main Statistics Cards
                Consumer<TaskProvider>(
                  builder: (context, taskProvider, child) {
                    return Column(
                      children: [
                        // Primary Stats Row
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 500) {
                              // Stack vertically on small screens
                              return Column(
                                children: [
                                  DashboardCard(
                                    title: 'Tasks Today',
                                    value: taskProvider.tasksToday.toString(),
                                    icon: Icons.today,
                                    gradient: AppColors.primaryGradient,
                                    onTap: () => _navigateToTasks(context),
                                  ),
                                  const SizedBox(height: 12),
                                  DashboardCard(
                                    title: 'Ongoing Tasks',
                                    value: taskProvider.ongoingTasks.toString(),
                                    icon: Icons.play_circle_filled,
                                    gradient: AppColors.secondaryGradient,
                                    onTap: () => _navigateToTasks(context),
                                  ),
                                ],
                              );
                            } else {
                              // Side by side on larger screens
                              return Row(
                                children: [
                                  Expanded(
                                    child: DashboardCard(
                                      title: 'Tasks Today',
                                      value: taskProvider.tasksToday.toString(),
                                      icon: Icons.today,
                                      gradient: AppColors.primaryGradient,
                                      onTap: () => _navigateToTasks(context),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: DashboardCard(
                                      title: 'Ongoing Tasks',
                                      value: taskProvider.ongoingTasks
                                          .toString(),
                                      icon: Icons.play_circle_filled,
                                      gradient: AppColors.secondaryGradient,
                                      onTap: () => _navigateToTasks(context),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Secondary Stats Grid
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Determine grid layout based on screen width
                            int crossAxisCount = 3;
                            double childAspectRatio = 1.0;

                            if (constraints.maxWidth < 400) {
                              crossAxisCount = 2;
                              childAspectRatio = 1.2;
                            } else if (constraints.maxWidth > 600) {
                              crossAxisCount = 4;
                              childAspectRatio = 0.9;
                            }

                            return GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: childAspectRatio,
                              children: [
                                DashboardStatCard(
                                  title: 'Total Tasks',
                                  value: taskProvider.totalTasks,
                                  icon: Icons.assignment,
                                  color: AppColors.primary1,
                                  onTap: onNavigateToTasks,
                                ),
                                DashboardStatCard(
                                  title: 'Tasks Due',
                                  value: taskProvider.tasksDue,
                                  icon: Icons.schedule,
                                  color: Colors.orange,
                                  onTap: onNavigateToTasks,
                                ),
                                DashboardStatCard(
                                  title: 'Completed',
                                  value: taskProvider.completedTasks,
                                  icon: Icons.check_circle,
                                  color: Colors.green,
                                  onTap: () => _showTasksFilter(
                                    context,
                                    TaskStatus.completed,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Quick Actions
                        _buildQuickActions(context),
                        const SizedBox(height: 24),

                        // Recent Tasks
                        _buildRecentTasks(context, taskProvider),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary1.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary1,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 400) {
                // Stack vertically on small screens
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        text: 'Add Task',
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                        gradient: AppColors.primaryGradient,
                        onPressed: () => Navigator.pushNamed(context, '/add'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        text: 'View Calendar',
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 18,
                        ),
                        gradient: AppColors.accentGradient,
                        onPressed: onNavigateToCalendar,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // Side by side on larger screens
                return Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        text: 'Add Task',
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                        gradient: AppColors.primaryGradient,
                        onPressed: () => Navigator.pushNamed(context, '/add'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GradientButton(
                        text: 'Calendar',
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 18,
                        ),
                        gradient: AppColors.accentGradient,
                        onPressed: onNavigateToCalendar,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTasks(BuildContext context, TaskProvider taskProvider) {
    final recentTasks = taskProvider.tasks
        .where((task) => !task.isCompleted)
        .take(3)
        .toList();

    if (recentTasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary1.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No pending tasks',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary1.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Tasks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary1,
            ),
          ),
          const SizedBox(height: 16),
          ...recentTasks.map((task) => _buildTaskItem(context, task)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: task.status.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: task.status.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (task.isTimerRunning)
                  Text(
                    'Running: ${task.formattedDuration}',
                    style: TextStyle(
                      color: AppColors.primary2,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          Icon(task.status.icon, color: task.status.color, size: 16),
        ],
      ),
    );
  }

  void _navigateToTasks(BuildContext context) {
    // Navigate to tasks screen (tab index 2)
    DefaultTabController.of(context).animateTo(2);
  }

  void _showTasksFilter(BuildContext context, TaskStatus status) {
    // Navigate to tasks screen with filter
    DefaultTabController.of(context).animateTo(2);
  }
}
