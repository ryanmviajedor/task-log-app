import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../domain/entities/task.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions
    await _requestPermissions();
    _isInitialized = true;
  }

  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.notification.request();
      
      // For Android 13+ (API level 33+)
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    debugPrint('Notification tapped: ${response.payload}');
  }

  Future<void> scheduleTaskReminder(Task task) async {
    if (!_isInitialized) await initialize();

    // Schedule notification for tasks due today
    if (task.isDueToday && !task.isCompleted) {
      await _scheduleNotification(
        id: task.id.hashCode,
        title: 'Task Due Today!',
        body: '${task.title} is due today. Don\'t forget to complete it!',
        scheduledDate: _getNotificationTime(task),
        payload: task.id,
      );
    }

    // Schedule notification for overdue tasks
    if (task.isOverdue) {
      await _scheduleNotification(
        id: task.id.hashCode + 1000,
        title: 'Overdue Task!',
        body: '${task.title} is overdue. Please complete it as soon as possible.',
        scheduledDate: DateTime.now().add(const Duration(minutes: 1)),
        payload: task.id,
      );
    }
  }

  DateTime _getNotificationTime(Task task) {
    final now = DateTime.now();
    final endDate = task.endDate;
    
    // If task ends today, notify 2 hours before end time
    if (task.isDueToday) {
      final notificationTime = endDate.subtract(const Duration(hours: 2));
      if (notificationTime.isAfter(now)) {
        return notificationTime;
      }
    }
    
    // Default: notify in 1 hour
    return now.add(const Duration(hours: 1));
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'task_reminders',
      'Task Reminders',
      channelDescription: 'Notifications for task reminders and due dates',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelTaskNotification(String taskId) async {
    await _notifications.cancel(taskId.hashCode);
    await _notifications.cancel(taskId.hashCode + 1000);
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'instant_notifications',
      'Instant Notifications',
      channelDescription: 'Instant notifications for task updates',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleDailyTaskReminder() async {
    if (!_isInitialized) await initialize();

    // Schedule daily reminder at 9 AM
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, 9, 0);
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _scheduleNotification(
      id: 999999,
      title: 'Daily Task Reminder',
      body: 'Don\'t forget to check your tasks for today!',
      scheduledDate: scheduledDate,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
