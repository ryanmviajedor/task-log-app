import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';
import '../../core/theme/app_colors.dart';
import '../providers/task_provider.dart';
import '../widgets/gradient_container.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  TaskPriority _priority = TaskPriority.normal;
  TaskStatus _status = TaskStatus.todo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _startDate = widget.task!.startDate;
      _endDate = widget.task!.endDate;
      _priority = widget.task!.priority;
      _status = widget.task!.status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    // Additional validation for dates
    if (_endDate.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date cannot be before start date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final provider = context.read<TaskProvider>();

      if (widget.task == null) {
        // Create new task
        final newTask = Task(
          id: const Uuid().v4(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          createdAt: DateTime.now(),
          startDate: _startDate,
          endDate: _endDate,
          priority: _priority,
          status: _status,
        );

        // Task created successfully
        await provider.addTask(newTask);
      } else {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          startDate: _startDate,
          endDate: _endDate,
          priority: _priority,
          status: _status,
        );

        // Task updated successfully
        await provider.editTask(updatedTask);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Log error for debugging (in production, use proper logging)
      debugPrint('Error saving task: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving task: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // Ensure end date is not before start date (allow same date)
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: GradientAppBar(
        title: isEditing ? 'Edit Task' : 'Add Task',
        gradient: AppColors.primaryGradient,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          else
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: GradientButton(
                text: 'SAVE',
                onPressed: _saveTask,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.1),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  if (value.trim().length < 3) {
                    return 'Title must be at least 3 characters long';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Start Date Field
              InkWell(
                onTap: _isLoading ? null : () => _selectStartDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(_startDate),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // End Date Field
              InkWell(
                onTap: _isLoading ? null : () => _selectEndDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.event),
                  ),
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(_endDate),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Priority Field
              DropdownButtonFormField<TaskPriority>(
                value: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: TaskPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Row(
                      children: [
                        Icon(priority.icon, color: priority.color, size: 20),
                        const SizedBox(width: 8),
                        Text(priority.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: _isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
              ),
              const SizedBox(height: 16),

              // Status Field (only show when editing)
              if (widget.task != null) ...[
                DropdownButtonFormField<TaskStatus>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.assignment),
                  ),
                  items: TaskStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Row(
                        children: [
                          Icon(status.icon, color: status.color, size: 20),
                          const SizedBox(width: 8),
                          Text(status.displayName),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _status = value!;
                          });
                        },
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: isEditing ? 'Update Task' : 'Create Task',
                  onPressed: _saveTask,
                  isLoading: _isLoading,
                  gradient: AppColors.primaryGradient,
                  icon: _isLoading
                      ? null
                      : Icon(
                          isEditing ? Icons.save : Icons.add,
                          color: Colors.white,
                        ),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
