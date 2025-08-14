import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/gradient_container.dart';
import 'add_edit_task_screen.dart';
import 'dashboard_screen.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_status.dart';
import '../../core/theme/app_colors.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TaskStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load tasks when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTasks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Task> _getTasksForDay(List<Task> tasks, DateTime day) {
    return tasks.where((task) {
      return isSameDay(task.startDate, day) ||
          isSameDay(task.endDate, day) ||
          (task.startDate.isBefore(day) && task.endDate.isAfter(day));
    }).toList();
  }

  List<Task> _getFilteredTasks(List<Task> tasks) {
    if (_statusFilter == null) return tasks;
    return tasks.where((task) => task.status == _statusFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.darkBackgroundGradient
            : AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GradientAppBar(
          title: 'HiveFlow',
          gradient: AppColors.primaryGradient,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
              Tab(icon: Icon(Icons.calendar_today), text: 'Calendar'),
              Tab(icon: Icon(Icons.list), text: 'Tasks'),
            ],
          ),
          actions: [
            // Filter button for tasks tab
            if (_tabController.index == 2)
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PopupMenuButton<TaskStatus?>(
                  icon: Icon(
                    Icons.filter_list,
                    color: _statusFilter != null
                        ? Colors.white
                        : Colors.white70,
                  ),
                  onSelected: (status) {
                    setState(() {
                      _statusFilter = status;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Row(
                        children: [
                          Icon(Icons.clear_all),
                          SizedBox(width: 8),
                          Text('All Tasks'),
                        ],
                      ),
                    ),
                    ...TaskStatus.values.map(
                      (status) => PopupMenuItem(
                        value: status,
                        child: Row(
                          children: [
                            Icon(status.icon, color: status.color, size: 20),
                            const SizedBox(width: 8),
                            Text(status.displayName),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            DashboardScreen(
              onNavigateToCalendar: () => _tabController.animateTo(1),
              onNavigateToTasks: () => _tabController.animateTo(2),
            ),
            _buildCalendarView(),
            _buildTaskListView(),
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary1.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView() {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasksForSelectedDay = _getTasksForDay(
          provider.tasks,
          _selectedDay,
        );

        return Column(
          children: [
            // Calendar
            TableCalendar<Task>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: (day) => _getTasksForDay(provider.tasks, day),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: TextStyle(color: Colors.red),
                holidayTextStyle: TextStyle(color: Colors.red),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            const SizedBox(height: 8),

            // Selected day tasks
            Expanded(
              child: tasksForSelectedDay.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_available,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks for ${DateFormat('MMM dd, yyyy').format(_selectedDay)}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasksForSelectedDay.length,
                      itemBuilder: (context, index) {
                        final task = tasksForSelectedDay[index];
                        return TaskCard(
                          task: task,
                          onStatusToggle: () =>
                              provider.toggleTaskCompletion(task.id),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskListView() {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No tasks yet. Add one!',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddEditTaskScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Task'),
                ),
              ],
            ),
          );
        }

        final filteredTasks = _getFilteredTasks(provider.tasks);

        if (filteredTasks.isEmpty && _statusFilter != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_statusFilter!.icon, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No ${_statusFilter!.displayName.toLowerCase()} tasks',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return TaskCard(
              task: task,
              onStatusToggle: () => provider.toggleTaskCompletion(task.id),
            );
          },
        );
      },
    );
  }
}
